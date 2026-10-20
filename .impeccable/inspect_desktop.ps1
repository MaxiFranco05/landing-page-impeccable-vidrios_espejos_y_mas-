Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path '.impeccable\review\desktop.png').Path)
Write-Host "Image width: $($bmp.Width) height: $($bmp.Height)"

# Find y range of hero headline text 'Vidrios, espejos y más'
# The headline is white (#ffffff) around x=720 (center)
Write-Host "Scanning x=720 from y=0 to y=850 for white/bright pixels (headline)..."
$headlineStart = -1
$headlineEnd = -1
for ($y = 0; $y -lt 850; $y++) {
    $c = $bmp.GetPixel(720, $y)
    if ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240) {
        if ($headlineStart -eq -1) { $headlineStart = $y }
        $headlineEnd = $y
    }
}
Write-Host "Headline at x=720 spans y=$headlineStart to y=$headlineEnd"

# Now let's check the comp image to compare where the headline is in comp
$comp = [System.Drawing.Bitmap]::FromFile((Resolve-Path '.impeccable\mocks\decision\challenger-cityscape.png').Path)
Write-Host "Comp width: $($comp.Width) height: $($comp.Height)"
$compStart = -1
$compEnd = -1
for ($y = 0; $y -lt 768; $y++) {
    $c = $comp.GetPixel(688, $y)
    if ($c.R -gt 240 -and $c.G -gt 240 -and $c.B -gt 240) {
        if ($compStart -eq -1) { $compStart = $y }
        $compEnd = $y
    }
}
Write-Host "Headline in comp at x=688 spans y=$compStart to y=$compEnd"

# Scale factor: 1440 / 1376 = 1.0465116
Write-Host "Expected comp y in desktop (compStart * 1.0465): $($compStart * 1440.0 / 1376.0) to $($compEnd * 1440.0 / 1376.0)"

$bmp.Dispose()
$comp.Dispose()
