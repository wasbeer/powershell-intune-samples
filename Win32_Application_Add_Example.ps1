####################################################

Test-AuthToken

####################################################

$baseUrl = "https://graph.microsoft.com/beta/deviceAppManagement/"

$logRequestUris = $true;
$logHeaders = $false;
$logContent = $true;

$azureStorageUploadChunkSizeInMb = 6l;

$sleep = 30

####################################################
# Sample Win32 Application
####################################################

$SourceFile = "C:\packages\package.intunewin"

# Defining Intunewin32 detectionRules
$DetectionXML = Get-IntuneWinXML "$SourceFile" -fileName "detection.xml"

# Defining Intunewin32 detectionRules
$FileRule = New-DetectionRule -File -Path "C:\Program Files\Application" `
-FileOrFolderName "application.exe" -FileDetectionType exists -check32BitOn64System False

$RegistryRule = New-DetectionRule -Registry -RegistryKeyPath "HKEY_LOCAL_MACHINE\SOFTWARE\Program" `
-RegistryDetectionType exists -check32BitRegOn64System True

$MSIRule = New-DetectionRule -MSI -MSIproductCode $DetectionXML.ApplicationInfo.MsiInfo.MsiProductCode

# Creating Array for detection Rule
$DetectionRule = @($FileRule,$RegistryRule,$MSIRule)

$ReturnCodes = Get-DefaultReturnCodes

$ReturnCodes += New-ReturnCode -returnCode 302 -type softReboot
$ReturnCodes += New-ReturnCode -returnCode 145 -type hardReboot

# Win32 Application Upload
Upload-Win32Lob -SourceFile "$SourceFile" -publisher "Publisher" `
-description "Description" -detectionRules $DetectionRule -returnCodes $ReturnCodes `
-installCmdLine "powershell.exe .\install.ps1" `
-uninstallCmdLine "powershell.exe .\uninstall.ps1"

####################################################