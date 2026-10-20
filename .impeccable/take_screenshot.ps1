$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
$htmlPath = (Resolve-Path 'index.html').Path
$outPath = (Resolve-Path '.impeccable\review').Path + '\hero-repro.png'
$fileUri = 'file:///' + ($htmlPath -replace '\\', '/')

Write-Host "Capturing $fileUri to $outPath..."

$proc = Start-Process -FilePath $edge -ArgumentList @(
    '--headless=new',
    '--disable-gpu',
    '--window-size=1376,768',
    '--hide-scrollbars',
    "--screenshot=$outPath",
    $fileUri
) -PassThru -Wait

if (Test-Path $outPath) {
    $item = Get-Item $outPath
    Write-Host "Screenshot captured successfully: $($item.FullName) ($($item.Length) bytes)"
} else {
    Write-Host "Screenshot failed."
}
