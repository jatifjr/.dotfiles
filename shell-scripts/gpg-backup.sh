#!/bin/bash
# A robust and secure script to back up GPG keys.

set -euo pipefail

# --- Script Configuration ---
readonly SCRIPT_NAME="$(basename "$0")"
readonly TARGET_DIR="$HOME/.gnupg"
readonly BACKUP_FILENAME="gpg-backup.tar.gz"
readonly ENCRYPTED_FILENAME="${BACKUP_FILENAME}.gpg"
readonly CIPHER_ALGO="AES256"

# --- Helper Functions ---

# Print an error message and exit.
# @param message The error message to print.
error() {
    echo >&2 "ERROR: $1"
    exit 1
}

# Print a usage message and exit.
usage() {
    echo "Usage: $SCRIPT_NAME [KEY_ID]"
    echo "Backs up a GPG key pair, including a revocation certificate, into a single encrypted file."
    echo "The backup will be saved in $TARGET_DIR."
    echo
    echo "If KEY_ID is not provided, the script will attempt to find a single available secret key."
    echo "The script will fail if multiple secret keys are found and no KEY_ID is specified."
    exit 1
}

# --- Global Variables & Cleanup ---
tmp_dir=""
trap '[[ -n "$tmp_dir" ]] && rm -rf -- "$tmp_dir"' EXIT

# --- Main Logic ---

main() {
    if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        usage
    fi

    local key_id="${1:-}"

    # If no KEY_ID is provided, try to automatically determine it.
    if [ -z "$key_id" ]; then
        echo "No KEY_ID provided. Attempting to find a unique secret key..."
        # Get a list of all secret key IDs
        local secret_key_ids
        secret_key_ids=$(gpg --list-secret-keys --keyid-format=long | awk '/^sec/{print $2}' | cut -d'/' -f2)

        local num_keys
        num_keys=$(echo "$secret_key_ids" | wc -w)

        if [ "$num_keys" -eq 0 ]; then
            error "No secret keys found in your GPG keychain."
        elif [ "$num_keys" -gt 1 ]; then
            error "Multiple secret keys found. Please specify the KEY_ID of the key to back up. Available keys:\n$secret_key_ids"
        fi
        key_id="$secret_key_ids"
        echo "Found unique key: $key_id"
    fi

    # Create the target directory if it doesn't exist.
    mkdir -p "$TARGET_DIR"

    # Create a temporary directory for the backup files.
    # The global trap will clean this up automatically on script exit.
    tmp_dir=$(mktemp -d)

    echo "Backing up GPG keys for KEY_ID: $key_id"

    # Export the public key.
    echo "Exporting public key..."
    gpg --export --armor "$key_id" > "$tmp_dir/pub.asc"

    # Export the secret key.
    echo "Exporting secret key..."
    gpg --export-secret-keys --armor "$key_id" > "$tmp_dir/sec.asc"

    # Generate a revocation certificate.
    # This step is interactive and will require your input.
    echo "Generating revocation certificate (this step is interactive)..."
    echo "Please choose a reason for revocation (e.g., '1' for 'Key has been compromised')."
    gpg --output "$tmp_dir/revoke.asc" --gen-revoke "$key_id"

    echo "Creating and encrypting tarball..."
    # Create a tarball of the keys and pipe it directly to gpg for encryption.
    # This avoids leaving an unencrypted tarball on the disk.
    tar -czf - -C "$tmp_dir" pub.asc sec.asc revoke.asc | gpg --pinentry-mode loopback --symmetric --cipher-algo "$CIPHER_ALGO" -o "$TARGET_DIR/$ENCRYPTED_FILENAME"

    echo
    echo "Backup complete!"
    echo "Your encrypted backup is saved as: $TARGET_DIR/$ENCRYPTED_FILENAME"
    echo "Store this file in a safe, separate location."
}

# Run the main function with all provided arguments.
main "$@"
