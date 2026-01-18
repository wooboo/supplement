#!/bin/bash

# Ensure prerequisites for secrets management
yay -S --noconfirm --needed gomplate-bin jq npm

# Function to backup a file if it exists and differs from a new version
# Usage: backup_if_changed <target_file> <new_file_source>
backup_if_changed() {
    local TARGET="$1"
    local NEW_SOURCE="$2"
    local TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    if [ ! -f "$TARGET" ]; then
        return 0
    fi

    if cmp -s "$TARGET" "$NEW_SOURCE"; then
        return 0
    fi

    local BACKUP="${TARGET}.${TIMESTAMP}.bak"
    echo "Changes detected in $TARGET. Backing up to $BACKUP"
    
    # Show diff
    if command -v colordiff >/dev/null 2>&1; then
        colordiff -u "$TARGET" "$NEW_SOURCE"
    else
        diff -u --color=always "$TARGET" "$NEW_SOURCE"
    fi

    cp "$TARGET" "$BACKUP"
}

# Function to process templates using secrets from Bitwarden
# Usage: process_bw_templates <bw_item_name> <templates_dir> [options]
# Options: --merge-json (deep merge existing JSON files instead of overwriting)
process_bw_templates() {
    local BW_ITEM="$1"
    local TEMPLATE_DIR="$2"
    local OPTIONS="$3"
    local SECRETS_FILE="/dev/shm/bw-secrets-${BW_ITEM}.json"

    if [ -z "$BW_ITEM" ] || [ -z "$TEMPLATE_DIR" ]; then
        echo "Usage: process_bw_templates <bw_item_name> <templates_dir>"
        return 1
    fi

    if [ ! -d "$TEMPLATE_DIR" ]; then
        echo "Template directory $TEMPLATE_DIR not found, skipping."
        return 0
    fi

    status_json=$(bw status 2>/dev/null)
    status=$(echo "$status_json" | jq -r '.status // "unauthenticated"')
    email=$(echo "$status_json" | jq -r '.userEmail // ""')

    case "$status" in
        unauthenticated)
            if [ -z "$email" ]; then
                read -r -p "Enter Bitwarden email: " email
            fi
            export BW_SESSION=$(bw login --raw "$email") || return 1
            ;;
        locked)
            export BW_SESSION=$(bw unlock --raw) || return 1
            ;;
        unlocked)
            if [ -z "$BW_SESSION" ]; then
                export BW_SESSION=$(bw unlock --raw) || return 1
            fi
            ;;
        *)
            echo "Bitwarden status unknown: $status"
            return 1
            ;;
    esac

    # Fetch secrets
    if ! bw get item "$BW_ITEM" >/dev/null 2>&1; then
        echo "Error: Bitwarden item '$BW_ITEM' not found."
        return 1
    fi

    echo "Processing templates for $BW_ITEM..."
    bw get item "$BW_ITEM" | jq -r '.notes' > "$SECRETS_FILE"
    chmod 600 "$SECRETS_FILE"

    # Process files
    find "$TEMPLATE_DIR" -type f | while read -r tmpl_path; do
        rel_path="${tmpl_path#$TEMPLATE_DIR/}"
        
        if [[ "$rel_path" == *.tmpl ]]; then
            target_path="$HOME/${rel_path%.tmpl}"
            mkdir -p "$(dirname "$target_path")"
            
            # Create temporary file for comparison
            temp_output=$(mktemp)
            if ! gomplate -d secrets="file://$SECRETS_FILE" -f "$tmpl_path" -o "$temp_output"; then
                echo "Error: gomplate failed for $tmpl_path"
                rm -f "$temp_output"
                continue
            fi
            
            # Deep merge if requested and target is JSON
            if [[ "$OPTIONS" == *"--merge-json"* ]] && [ -f "$target_path" ]; then
                if jq -e . "$target_path" >/dev/null 2>&1 && jq -e . "$temp_output" >/dev/null 2>&1; then
                    merged_output=$(mktemp)
                    echo "Merging JSON changes for $target_path..."
                    if jq -s '.[0] * .[1]' "$target_path" "$temp_output" > "$merged_output"; then
                        mv "$merged_output" "$temp_output"
                    else
                        echo "Warning: JSON merge failed for $target_path, falling back to overwrite."
                        rm -f "$merged_output"
                    fi
                else
                    echo "Notice: Target $target_path or template output is not valid JSON, skipping merge and overwriting."
                fi
            fi

            backup_if_changed "$target_path" "$temp_output"
            
            mv "$temp_output" "$target_path"
            chmod 600 "$target_path"
        else
            target_path="$HOME/$rel_path"
            mkdir -p "$(dirname "$target_path")"
            
            # Use temporary file to allow merging for non-template JSONs too
            temp_output=$(mktemp)
            cp "$tmpl_path" "$temp_output"

            if [[ "$OPTIONS" == *"--merge-json"* ]] && [ -f "$target_path" ]; then
                if jq -e . "$target_path" >/dev/null 2>&1 && jq -e . "$temp_output" >/dev/null 2>&1; then
                    merged_output=$(mktemp)
                    echo "Merging JSON changes for $target_path..."
                    if jq -s '.[0] * .[1]' "$target_path" "$temp_output" > "$merged_output"; then
                        mv "$merged_output" "$temp_output"
                    else
                        echo "Warning: JSON merge failed for $target_path, falling back to overwrite."
                        rm -f "$merged_output"
                    fi
                fi
            fi

            backup_if_changed "$target_path" "$temp_output"
            
            mv "$temp_output" "$target_path"
        fi
    done

    rm -f "$SECRETS_FILE"
    return 0
}
