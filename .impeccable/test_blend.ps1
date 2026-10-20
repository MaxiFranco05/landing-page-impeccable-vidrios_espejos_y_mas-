Add-Type -AssemblyName System.Drawing

$cropPath = (Resolve-Path 'assets/plates/crop-card-mirror-plate.png').Path
$genPath = 'C:\Users\maxif\.gemini\antigravity\brain\533fe37f-1ff5-4719-88b5-0acf0605e0cb\bespoke_full_length_backlit_mirror_1792419816103.jpg'
$outPath = (Resolve-Path 'assets/plates').Path + '\test-card-mirror.png'

$targetW = 550
$targetH = 460

$cropImg = [System.Drawing.Image]::FromFile($cropPath)
$genImg = [System.Drawing.Image]::FromFile($genPath)

$bmp = New-Object System.Drawing.Bitmap($targetW, $targetH)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

# Draw generated image as base (full resolution)
$g.DrawImage($genImg, 0, 0, $targetW, $targetH)

# Draw crop with 45% opacity over it
$cm = New-Object System.Drawing.Imaging.ColorMatrix
$cm.Matrix33 = 0.50 # 50% opacity
$ia = New-Object System.Drawing.Imaging.ImageAttributes
$ia.SetColorMatrix($cm)

$rect = New-Object System.Drawing.Rectangle(0, 0, $targetW, $targetH)
$g.DrawImage($cropImg, $rect, 0, 0, $cropImg.Width, $cropImg.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)

$g.Dispose()
$cropImg.Dispose()
$genImg.Dispose()
$ia.Dispose()

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "Created blended candidate: $outPath"
