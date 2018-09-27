onedrivePlist="$HOME/Library/Preferences/com.microsoft.OneDrive.plist"

/usr/libexec/PlistBuddy -c "Add :HideDockIcon bool False" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :DisablePersonalSync bool True" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :TeamSiteSyncPreview bool True" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants dict" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants:53049b77-3e8f-4792-977f-0a3e5f23891b dict" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants:53049b77-3e8f-4792-977f-0a3e5f23891b:DefaultFolder string 'file:///$HOME/OneDrive/'" $onedrivePlist

onedrivePlist="$HOME/Library/Containers/com.microsoft.OneDrive-mac/Data/Library/Preferences/com.microsoft.OneDrive-mac.plist"

/usr/libexec/PlistBuddy -c "Add :HideDockIcon bool False" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :DisablePersonalSync bool True" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :TeamSiteSyncPreview bool True" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants dict" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants:53049b77-3e8f-4792-977f-0a3e5f23891b dict" $onedrivePlist
/usr/libexec/PlistBuddy -c "Add :Tenants:53049b77-3e8f-4792-977f-0a3e5f23891b:DefaultFolder string 'file:///$HOME/OneDrive/'" $onedrivePlist