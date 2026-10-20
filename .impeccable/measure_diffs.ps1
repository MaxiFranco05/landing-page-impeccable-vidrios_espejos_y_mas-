Add-Type -AssemblyName System.Drawing

function Inspect-RegionDiff($name) {
    $file = Join-Path (Resolve-Path '.impeccable\review\diff\desktop\regions').Path "$name.png"
    if (!(Test-Path $file)) { return }
    $bmp = [System.Drawing.Bitmap]::FromFile($file)
    $w = $bmp.Width
    $h = $bmp.Height
    $halfW = [int]($w / 2)
    Write-Host "=== $name (Width: $w, Height: $h, Half: $halfW) ==="
    
    # Left is COMP, Right is BUILD
    # Find text ink bounding box in COMP (x: 0 to halfW)
    # Find text ink bounding box in BUILD (x: halfW to w)
    $compMinX = $w; $compMaxX = 0; $compMinY = $h; $compMaxY = 0
    $buildMinX = $w; $buildMaxX = 0; $buildMinY = $h; $buildMaxY = 0
    
    # We ignore the top banner if there's any text in first ~20px
    for ($y = 25; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $halfW; $x++) {
            $c = $bmp.GetPixel($x, $y)
            # Text is generally lighter than background (> 120 in R,G,B)
            if ($c.R -gt 130 -and $c.G -gt 130 -and $c.B -gt 130) {
                if ($x -lt $compMinX) { $compMinX = $x }
                if ($x -gt $compMaxX) { $compMaxX = $x }
                if ($y -lt $compMinY) { $compMinY = $y }
                if ($y -gt $compMaxY) { $compMaxY = $y }
            }
        }
        for ($x = $halfW; $x -lt $w; $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -gt 130 -and $c.G -gt 130 -and $c.B -gt 130) {
                if ($x -lt $buildMinX) { $buildMinX = $x }
                if ($x -gt $buildMaxX) { $buildMaxX = $x }
                if ($y -lt $buildMinY) { $buildMinY = $y }
                if ($y -gt $buildMaxY) { $buildMaxY = $y }
            }
        }
    }
    $buildMinXRel = $buildMinX - $halfW
    $buildMaxXRel = $buildMaxX - $halfW
    Write-Host "COMP ink box : x=[$compMinX, $compMaxX] (w=$($compMaxX - $compMinX)), y=[$compMinY, $compMaxY] (h=$($compMaxY - $compMinY))"
    Write-Host "BUILD ink box: x=[$buildMinXRel, $buildMaxXRel] (w=$($buildMaxXRel - $buildMinXRel)), y=[$buildMinY, $buildMaxY] (h=$($buildMaxY - $buildMinY))"
    $bmp.Dispose()
}

Inspect-RegionDiff "card-mirror-caption"
Inspect-RegionDiff "card-partition-caption"
Inspect-RegionDiff "card-storefront-caption"
Inspect-RegionDiff "lower-card-frameless-plate"
