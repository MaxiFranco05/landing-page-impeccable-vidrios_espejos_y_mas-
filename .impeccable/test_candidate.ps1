Add-Type -AssemblyName System.Drawing

$cropPath = (Resolve-Path 'assets/plates/crop-left-glass-prism.png').Path
$testPath = (Resolve-Path 'assets/plates').Path + '\test-left-glass-prism.png'

$img = [System.Drawing.Image]::FromFile($cropPath)
$targetW = 550
$targetH = 768

# Create new bitmap
$bmp = New-Object System.Drawing.Bitmap($targetW, $targetH)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Set image attributes with slight color matrix tweak (e.g. slight brightness/contrast and color tone)
$ia = New-Object System.Drawing.Imaging.ImageAttributes
$cm = New-Object System.Drawing.Imaging.ColorMatrix
# Slightly boost blue and contrast
$cm.Matrix00 = 1.05 # R
$cm.Matrix11 = 1.05 # G
$cm.Matrix22 = 1.10 # B
$cm.Matrix33 = 1.00 # A
$cm.Matrix40 = 0.02 # R offset
$cm.Matrix41 = 0.02 # G offset
$cm.Matrix42 = 0.04 # B offset

$ia.SetColorMatrix($cm)

$rect = New-Object System.Drawing.Rectangle(0, 0, $targetW, $targetH)
$g.DrawImage($img, $rect, 0, 0, $img.Width, $img.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)

$g.Dispose()
$img.Dispose()
$ia.Dispose()

$bmp.Save($testPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "Created $testPath"
