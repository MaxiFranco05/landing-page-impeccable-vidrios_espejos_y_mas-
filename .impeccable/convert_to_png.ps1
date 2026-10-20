Add-Type -AssemblyName System.Drawing
$platesDir = (Resolve-Path 'assets/plates').Path
$plateFiles = @(
    'card-mirror-plate.png',
    'card-partition-plate.png',
    'card-storefront-plate.png',
    'left-glass-prism.png',
    'lower-card-doors-plate.png',
    'lower-card-shower-plate.png',
    'right-glass-prism.png'
)

foreach ($file in $plateFiles) {
    $fullPath = Join-Path $platesDir $file
    $img = [System.Drawing.Image]::FromFile($fullPath)
    $tempPath = $fullPath + '.tmp.png'
    $img.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
    Move-Item $tempPath $fullPath -Force
    Write-Host "Converted $file to valid PNG"
}
