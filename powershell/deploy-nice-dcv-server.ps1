# Set TLS 1.2 for Invoke-RestMethod
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Set the download link to Nice DCV Server (64-bit installer)
$downloadUrl = "https://d1uj6qtbmh3dt5.cloudfront.net/nice-dcv-server-x64-Release.msi"
# Set the path for our download, which will be in the temp directory
$installerFile = "nice-dcv-server-x64-Release.msi"
$installerDownloadPath = (Join-Path $env:TEMP $installerFile)
# Set the default owner to the current user
$installerOwner = [Environment]::UserName
# Set Install Command Expression
$msiExpression = "msiexec.exe /i $installerDownloadPath AUTOMATIC_SESSION_OWNER=$installerOwner ADDLOCAL=ALL /quiet /norestart /l*v dcv_install_msi.log"
# Download the file
Invoke-Webrequest $downloadUrl -UseBasicParsing -OutFile $installerDownloadPath
# Install
Invoke-Expression $msiExpression