#!/usr/bin/env bash
set -e
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Path configuration
DOTFILES_DIR="$HOME/github/dotfiles-latest"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
CACHE_DIR="$HOME/.cache/backdrop-sync"
mkdir -p "$CACHE_DIR"

LAST_WALLPAPER_FILE="$CACHE_DIR/last-wallpaper"
EXTRACTED_FRAME="$CACHE_DIR/current_frame.png"
OUTPUT_COLORSCHEME="$DOTFILES_DIR/colorscheme/list/backdrop-sync.sh"

# 1. Detect wallpaper path
get_wallpaper_path() {
    # Check BackdropWallpaper process
    local pid
    pid=$(pgrep -x BackdropWallpaper | head -n 1)
    if [ -n "$pid" ]; then
        local path
        path=$(lsof -Fn -p "$pid" | sed -n 's/^n//p' | grep -i -E '\.(mov|mp4|heic|png|jpg|jpeg|webp)$' | head -n 1)
        if [ -n "$path" ] && [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    fi

    # Check Backdrop process
    pid=$(pgrep -x Backdrop | head -n 1)
    if [ -n "$pid" ]; then
        local path
        path=$(lsof -Fn -p "$pid" | sed -n 's/^n//p' | grep -i -E '\.(mov|mp4|heic|png|jpg|jpeg|webp)$' | head -n 1)
        if [ -n "$path" ] && [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    fi

    # Fallback: macOS Finder Wallpaper
    local finder_path
    finder_path=$(osascript -e 'tell app "Finder" to get posix path of (get desktop picture as alias)' 2>/dev/null)
    if [ -n "$finder_path" ] && [ -f "$finder_path" ]; then
        echo "$finder_path"
        return 0
    fi

    return 1
}

WALLPAPER_PATH=$(get_wallpaper_path)
if [ -z "$WALLPAPER_PATH" ]; then
    echo "No active wallpaper detected."
    exit 0
fi

# 2. Check if wallpaper has changed
LAST_WALLPAPER=""
if [ -f "$LAST_WALLPAPER_FILE" ]; then
    LAST_WALLPAPER=$(cat "$LAST_WALLPAPER_FILE")
fi

# Force run if --force argument is provided
FORCE_RUN=false
if [ "$1" = "--force" ]; then
    FORCE_RUN=true
fi

if [ "$WALLPAPER_PATH" = "$LAST_WALLPAPER" ] && [ "$FORCE_RUN" = false ]; then
    # No change, exit silently
    exit 0
fi

echo "New wallpaper detected: $WALLPAPER_PATH"

# 3. Determine if source is video or image
IS_VIDEO=false
if [[ "$WALLPAPER_PATH" =~ \.(mov|mp4)$ ]]; then
    IS_VIDEO=true
fi

# 4. Extract frame or copy image to temp file
if [ "$IS_VIDEO" = true ]; then
    echo "Extracting frame from video..."
    "$SCRIPTS_DIR/extract_frame" "$WALLPAPER_PATH" "$EXTRACTED_FRAME"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to extract frame from video."
        exit 1
    fi
    SOURCE_IMAGE="$EXTRACTED_FRAME"
else
    SOURCE_IMAGE="$WALLPAPER_PATH"
fi

# 5. Generate colorscheme script using Python
echo "Generating colorscheme..."
/opt/homebrew/bin/python3 "$SCRIPTS_DIR/backdrop-sync.py" "$SOURCE_IMAGE" "$WALLPAPER_PATH" "$OUTPUT_COLORSCHEME"
if [ $? -ne 0 ]; then
    echo "Error: Python colorscheme generation failed."
    exit 1
fi

# 6. Apply the generated colorscheme
echo "Applying colorscheme..."
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
"$DOTFILES_DIR/zshrc/colorscheme-set.sh" "backdrop-sync.sh"

# 7. Update cache
echo "$WALLPAPER_PATH" > "$LAST_WALLPAPER_FILE"
echo "Backdrop sync completed successfully."
