#!/bin/bash
# A robust and secure script to restore GPG keys from an encrypted backup.

set -euo pipefail

# --- Script Configuration ---
readonly SCRIPT_NAME="$(basename "$0")"
readonly TARGET_DIR="$HOME/.gnupg"
readonly DEFAULT_BACKUP_FILENAME="$TARGET_DIR/gpg-backup.tar.gz.gpg"

# --- Helper Functions ---

# Print an error message and exit.
# @param message The error message to print.
error() {
    echo >&2 "ERROR: $1"
    exit 1
}

# Print a usage message and exit.
usage() {
    echo "Usage: $SCRIPT_NAME [ENCRYPTED_BACKUP_FILE]"
    echo "Restores a GPG key pair from an encrypted backup file created by gpg-backup.sh."
    echo
    echo "If ENCRYPTED_BACKUP_FILE is not provided, the script will look for a backup file at:"
    echo "$DEFAULT_BACKUP_FILENAME"
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

    local backup_file="${1:-$DEFAULT_BACKUP_FILENAME}"

    if [ ! -f "$backup_file" ]; then
        error "Backup file not found: $backup_file"
    fi

    # Create a temporary directory for the restored files.
    # The global trap will clean this up automatically on script exit.
    tmp_dir=$(mktemp -d)

    echo "Decrypting backup file: $backup_file"
    # Decrypt the backup and pipe the tarball directly to the tar command
    # to extract the contents into the temporary directory.
    gpg --pinentry-mode loopback --decrypt "$backup_file" | tar -xzf - -C "$tmp_dir"

    # Verify that the expected files were extracted.
    if [ ! -f "$tmp_dir/sec.asc" ] || [ ! -f "$tmp_dir/pub.asc" ]; then
        error "The backup archive is missing the required key files (sec.asc, pub.asc)."
    fi

    echo "Importing GPG keys..."
    # Import the secret key first, then the public key.
    gpg --import "$tmp_dir/sec.asc"
    gpg --import "$tmp_dir/pub.asc"

    echo
    echo "Key restoration complete!"
    echo "The public and secret keys have been imported into your GPG keychain."
    echo

    # Provide a strong warning and instructions about the revocation certificate.
    if [ -f "$tmp_dir/revoke.asc" ]; then
        echo "--- IMPORTANT: Revocation Certificate ---"
        echo "The backup includes a revocation certificate: 'revoke.asc'."
        echo "This certificate is used to permanently invalidate your GPG key if it is ever compromised."
        echo "DO NOT import it unless you are certain you want to revoke your key."
        echo "To revoke the key, you would run: gpg --import $tmp_dir/revoke.asc"
        echo "Keep this certificate safe in case you need it in the future."
        echo "----------------------------------------"
    fi
}

# Run the main function with all provided arguments.
main "$@"
