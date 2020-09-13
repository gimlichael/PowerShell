$PROFILEHOME = get-childItem $PROFILE; $PROFILEHOME = $PROFILEHOME.DirectoryName
. "$PROFILEHOME\Shared.PowerShell_profile.ps1"