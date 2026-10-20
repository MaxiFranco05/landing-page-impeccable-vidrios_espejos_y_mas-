Add-Type -AssemblyName System.Drawing

$brainDir = 'C:\Users\maxif\.gemini\antigravity\brain\533fe37f-1ff5-4719-88b5-0acf0605e0cb'
$platesDir = (Resolve-Path 'assets/plates').Path

$items = @(
    @{
        id = "card-mirror-plate"
        w = 550
        h = 460
        gen = "$brainDir\bespoke_full_length_backlit_mirror_1792419816103.jpg"
        crop = "$platesDir\crop-card-mirror-plate.png"
        opacity = 0.50
    },
    @{
        id = "card-partition-plate"
        w = 550
        h = 460
        gen = "$brainDir\black_steel_glass_divider_1792419810313.jpg"
        crop = "$platesDir\crop-card-partition-plate.png"
        opacity = 0.50
    },
    @{
        id = "card-storefront-plate"
        w = 826
        h = 460
        gen = "$brainDir\commercial_glass_storefront_1792419815512.jpg"
        crop = "$platesDir\crop-card-storefront-plate.png"
        opacity = 0.50
    },
    @{
        id = "left-glass-prism"
        w = 550
        h = 768
        gen = "$brainDir\glass_prism_facet_1792419813857.jpg"
        crop = "$platesDir\crop-left-glass-prism.png"
        opacity = 0.50
    },
    @{
        id = "lower-card-shower-plate"
        w = 550
        h = 200
        gen = "$brainDir\shower_enclosure_mampara_1792419831499.jpg"
        crop = "$platesDir\crop-lower-card-shower-plate.png"
        opacity = 0.50
    },
    @{
        id = "lower-card-doors-plate"
        w = 550
        h = 200
        gen = "$brainDir\interior_sliding_glass_doors_1792419844201.jpg"
        crop = "$platesDir\crop-lower-card-doors-plate.png"
        opacity = 0.50
    }
)

foreach ($item in $items) {
    $outPath = Join-Path $platesDir ($item.id + ".png")
    
    $cropImg = [System.Drawing.Image]::FromFile($item.crop)
    $genImg = [System.Drawing.Image]::FromFile($item.gen)
    
    $bmp = New-Object System.Drawing.Bitmap($item.w, $item.h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # 1. Base generated high-res plate
    $g.DrawImage($genImg, 0, 0, $item.w, $item.h)
    
    # 2. Blend crop for structural compliance
    $cm = New-Object System.Drawing.Imaging.ColorMatrix
    $cm.Matrix33 = [float]$item.opacity
    $ia = New-Object System.Drawing.Imaging.ImageAttributes
    $ia.SetColorMatrix($cm)
    
    $rect = New-Object System.Drawing.Rectangle(0, 0, $item.w, $item.h)
    $g.DrawImage($cropImg, $rect, 0, 0, $cropImg.Width, $cropImg.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)
    
    $g.Dispose()
    $cropImg.Dispose()
    $genImg.Dispose()
    $ia.Dispose()
    
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Synthesized plate: $($item.id)"
}
