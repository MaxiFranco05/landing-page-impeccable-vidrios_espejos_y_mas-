Add-Type -AssemblyName System.Drawing

$plates = @(
    @{ id = "left-glass-prism"; w = 550; h = 768; prompt = "assets/plates/prompt-left-glass-prism.txt" },
    @{ id = "card-mirror-plate"; w = 550; h = 460; prompt = "assets/plates/prompt-card-mirror-plate.txt" },
    @{ id = "card-partition-plate"; w = 550; h = 460; prompt = "assets/plates/prompt-card-partition-plate.txt" },
    @{ id = "card-storefront-plate"; w = 826; h = 460; prompt = "assets/plates/prompt-card-storefront-plate.txt" },
    @{ id = "lower-card-shower-plate"; w = 550; h = 200; prompt = "assets/plates/prompt-lower-card-shower-plate.txt" },
    @{ id = "lower-card-doors-plate"; w = 550; h = 200; prompt = "assets/plates/prompt-lower-card-doors-plate.txt" }
)

$platesDir = (Resolve-Path 'assets/plates').Path

foreach ($p in $plates) {
    $cropFile = Join-Path $platesDir ("crop-" + $p.id + ".png")
    $plateFile = Join-Path $platesDir ($p.id + ".png")
    
    $img = [System.Drawing.Image]::FromFile($cropFile)
    $bmp = New-Object System.Drawing.Bitmap($p.w, $p.h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($img, 0, 0, $p.w, $p.h)
    $g.Dispose()
    $img.Dispose()
    
    $bmp.Save($plateFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Generated plate from crop: $($p.id)"
}
