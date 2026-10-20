Add-Type -AssemblyName System.Drawing

$brainDir = 'C:\Users\maxif\.gemini\antigravity\brain\533fe37f-1ff5-4719-88b5-0acf0605e0cb'
$platesDir = (Resolve-Path 'assets/plates').Path

$outPath = Join-Path $platesDir "lower-card-doors-plate.png"
$cropPath = Join-Path $platesDir "crop-lower-card-doors-plate.png"
$genPath = "$brainDir\interior_sliding_glass_doors_1792419844201.jpg"

$cropImg = [System.Drawing.Image]::FromFile($cropPath)
$genImg = [System.Drawing.Image]::FromFile($genPath)

$w = 550
$h = 200

$bmp = New-Object System.Drawing.Bitmap($w, $h)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$g.DrawImage($genImg, 0, 0, $w, $h)

$cm = New-Object System.Drawing.Imaging.ColorMatrix
$cm.Matrix33 = 0.65 # 65% opacity
$ia = New-Object System.Drawing.Imaging.ImageAttributes
$ia.SetColorMatrix($cm)

$rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
$g.DrawImage($cropImg, $rect, 0, 0, $cropImg.Width, $cropImg.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)

$g.Dispose()
$cropImg.Dispose()
$genImg.Dispose()
$ia.Dispose()

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Updated lower-card-doors-plate.png"
