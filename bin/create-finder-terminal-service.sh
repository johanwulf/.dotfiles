#!/bin/bash

osascript <<'END'
tell application "Automator"
    set newWorkflow to make new workflow
    
    set runAppleScript to Automator action "Run AppleScript"
    tell newWorkflow to add runAppleScript to it
    
    set value of variable "script" of runAppleScript to "on run {input, parameters}
    tell application \"Finder\"
        set dir_path to quoted form of (POSIX path of (folder of the front window as alias))
    end tell
    
    tell application \"Terminal\"
        activate
        do script \"cd \" & dir_path
    end tell
end run"
    
    save newWorkflow as "Open Terminal Here" in ((path to home folder as text) & "Library:Services:")
end tell
END

echo "✅ 'Open Terminal Here' service created"
