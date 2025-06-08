#!/bin/bash

echo "🚀 Setting up macOS Spaces with applications..."

check_app() {
    local app_name="$1"
    if [[ -d "/Applications/$app_name.app" ]]; then
        return 0
    else
        echo "⚠️  $app_name not found"
        return 1
    fi
}

grant_accessibility_permissions() {
    echo "Granting accessibility permissions..."
    
    osascript <<'END'
tell application "System Events"
    set UI elements enabled to true
end tell
END

    echo "Please grant accessibility permissions when prompted"
    
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    
    echo "Make sure Terminal is enabled in Accessibility permissions"
    gum confirm "Have you granted accessibility permissions to Terminal?" || return 1
}

create_spaces() {
    echo "Creating desktop spaces..."
    
    grant_accessibility_permissions
    
    osascript <<'END'
tell application "Mission Control"
    activate
end tell

delay 2

tell application "System Events"
    tell application "Mission Control" to activate
    delay 2
    
    repeat 6 times
        try
            key code 24 using {control down, option down}
            delay 0.5
        on error
            tell process "Dock"
                click (last UI element of group 1 whose role description is "add desktop button")
                delay 0.5
            end tell
        end try
    end repeat
    
    key code 53
end tell
END
}

open_all_apps() {
    echo "Opening all applications..."
    APPS=("Alacritty" "Google Chrome" "Claude" "Microsoft Teams" "Discord" "Todoist" "Slack" "DBeaver" "Spotify")
    
    for app in "${APPS[@]}"; do
        if check_app "$app"; then
            echo "  Opening $app..."
            open -a "$app" 2>/dev/null || true
            sleep 1
        fi
    done
    
    echo "Waiting for apps to fully launch..."
    sleep 5
}

setup_space_shortcuts() {
    echo "Setting up desktop shortcuts..."
    
    for i in {1..7}; do
        hotkey_id=$((117 + i))
        /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:$hotkey_id:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || true
    done
    
    defaults read com.apple.symbolichotkeys > /dev/null
}

assign_apps_simple() {
    echo "Assigning applications to spaces..."
    echo ""
    echo "Manual steps required:"
    echo "1. Use Ctrl+1 through Ctrl+7 to switch between spaces"
    echo "2. On each space, right-click the app in the Dock"
    echo "3. Go to Options > Assign To > This Desktop"
    echo ""
    echo "Space assignments:"
    echo "  Space 1: Alacritty"
    echo "  Space 2: Chrome"
    echo "  Space 3: Claude"
    echo "  Space 4: Teams/Discord/Todoist"
    echo "  Space 5: Slack"
    echo "  Space 6: DBeaver"
    echo "  Space 7: Spotify"
}

set_login_items() {
    echo "Setting applications to open at login..."
    
    osascript <<'END'
on run
    tell application "System Events"
        set login_items_names to name of every login item
        
        set apps_list to {"Alacritty", "Google Chrome", "Claude", "Microsoft Teams", "Discord", "Todoist", "Slack", "DBeaver", "Spotify"}
        
        repeat with app_name in apps_list
            if app_name is not in login_items_names then
                try
                    set app_path to "/Applications/" & app_name & ".app"
                    make new login item at end of login items with properties {name:app_name, path:app_path, hidden:false}
                on error errMsg
                end try
            end if
        end repeat
    end tell
    
    return true
end run
END
}

echo ""
gum confirm "This will set up desktop spaces. Continue?" || exit 0

open_all_apps

create_spaces
echo "✅ Attempted to create desktop spaces"

echo ""
setup_space_shortcuts
echo "✅ Desktop shortcuts configured"

echo ""
set_login_items
echo "✅ Login items configured"

echo ""
assign_apps_simple

echo ""
gum confirm "Have you manually assigned apps to their spaces?" || echo "Remember to do this later"

echo ""
echo "✅ Setup complete!"
echo ""
echo "Desktop shortcuts should now work:"
echo "  Ctrl+1 through Ctrl+7 - Switch to desktop 1-7"
