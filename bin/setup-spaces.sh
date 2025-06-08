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

create_spaces() {
    echo "Creating desktop spaces..."
    
    osascript <<'END'
on run
    tell application "Mission Control" to launch
    delay 2
    
    tell application "System Events"
        tell process "Dock"
            repeat 6 times
                try
                    click button 1 of group "Spaces Bar" of group 1 of group "Mission Control"
                    delay 0.5
                on error
                    keystroke "+" using control down
                    delay 0.5
                end try
            end repeat
        end tell
        
        key code 53
    end tell
    
    return true
end run
END
}

assign_to_desktop() {
    local app_name="$1"
    local desktop_num="$2"
    
    echo "  Assigning $app_name to Desktop $desktop_num..."
    
    osascript <<END
on run
    tell application "System Events"
        key code $(($desktop_num + 17)) using control down
        delay 1
    end tell
    
    tell application "$app_name"
        activate
        delay 2
    end tell
    
    tell application "System Events"
        tell process "Dock"
            set frontmost to true
            try
                click UI element "$app_name" of list 1 with option down
                delay 0.5
                
                click menu item "Options" of menu 1 of UI element "$app_name" of list 1
                delay 0.5
                
                click menu item "This Desktop" of menu 1 of menu item "Options" of menu 1 of UI element "$app_name" of list 1
            on error
                keystroke "$app_name" using command down
                delay 0.5
            end try
        end tell
    end tell
    
    return true
end run
END
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

enable_shortcuts() {
    osascript <<'END'
tell application "System Events"
    set plist_file to property list file "~/Library/Preferences/com.apple.symbolichotkeys.plist"
    
    repeat with i from 118 to 124
        tell property list item i of property list item "AppleSymbolicHotKeys" of plist_file
            set value of property list item "enabled" to true
        end tell
    end repeat
end tell

do shell script "defaults read com.apple.symbolichotkeys > /dev/null"
END
}

echo ""
gum confirm "This will create 7 desktop spaces and assign your apps. Continue?" || exit 0

echo "Opening all applications..."
APPS=("Alacritty" "Google Chrome" "Claude" "Microsoft Teams" "Discord" "Todoist" "Slack" "DBeaver" "Spotify")

for app in "${APPS[@]}"; do
    if check_app "$app"; then
        echo "  Opening $app..."
        open -a "$app"
    fi
done

echo "Waiting for apps to launch..."
sleep 5

create_spaces
echo "✅ Desktop spaces created"

echo ""
echo "Assigning applications to spaces..."

if check_app "Alacritty"; then
    assign_to_desktop "Alacritty" 1
fi

if check_app "Google Chrome"; then
    assign_to_desktop "Google Chrome" 2
fi

if check_app "Claude"; then
    assign_to_desktop "Claude" 3
fi

for app in "Microsoft Teams" "Discord" "Todoist"; do
    if check_app "$app"; then
        assign_to_desktop "$app" 4
    fi
done

if check_app "Slack"; then
    assign_to_desktop "Slack" 5
fi

if check_app "DBeaver"; then
    assign_to_desktop "DBeaver" 6
fi

if check_app "Spotify"; then
    assign_to_desktop "Spotify" 7
fi

echo ""
echo "✅ Applications assigned to spaces"

echo ""
set_login_items
echo "✅ Login items configured"

echo ""
echo "🎹 Attempting to enable keyboard shortcuts..."
enable_shortcuts

echo ""
echo "Opening System Settings to verify shortcuts..."

osascript <<'END'
tell application "System Settings"
    activate
    delay 1
end tell

tell application "System Events"
    tell process "System Settings"
        keystroke "keyboard shortcuts mission control"
        delay 0.5
        key code 36
    end tell
end tell
END

echo "Please verify that shortcuts for 'Switch to Desktop 1-7' are enabled (Ctrl+1-7)"
echo ""

gum confirm "Are all desktop switching shortcuts enabled?" || echo "⚠️  Enable them manually"

echo ""
echo "✅ Space setup complete!"
echo ""
echo "Your spaces:"
echo "  Space 1: Alacritty"
echo "  Space 2: Chrome"
echo "  Space 3: Claude"
echo "  Space 4: Teams/Discord/Todoist"
echo "  Space 5: Slack"
echo "  Space 6: DBeaver"
echo "  Space 7: Spotify"
