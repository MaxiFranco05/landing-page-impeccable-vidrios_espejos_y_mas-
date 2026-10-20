$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
$htmlPath = (Resolve-Path 'index.html').Path
$reviewDir = (Resolve-Path '.impeccable\review').Path
$desktopOut = Join-Path $reviewDir 'desktop.png'
$mobileOut = Join-Path $reviewDir 'mobile.png'
$fileUri = 'file:///' + ($htmlPath -replace '\\', '/')

Write-Host "Capturing desktop.png (1440x3600)..."
$proc1 = Start-Process -FilePath $edge -ArgumentList @(
    '--headless=new',
    '--disable-gpu',
    '--window-size=1440,3600',
    '--hide-scrollbars',
    "--screenshot=$desktopOut",
    $fileUri
) -PassThru -Wait

Write-Host "Capturing mobile.png (390x4000)..."
$proc2 = Start-Process -FilePath $edge -ArgumentList @(
    '--headless=new',
    '--disable-gpu',
    '--window-size=390,4000',
    '--hide-scrollbars',
    "--screenshot=$mobileOut",
    $fileUri
) -PassThru -Wait

Get-Item $desktopOut, $mobileOut | Select-Object Name, Length, LastWriteTime
