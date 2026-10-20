Add-Type -AssemblyName System.Drawing
$comp = [System.Drawing.Bitmap]::FromFile("$PWD\.impeccable\build\approved-comp.png")

# hero-cta box: x: 568, y: 319, w: 240, h: 60
$minY = 9999; $maxY = 0; $minX = 9999; $maxX = 0
for ($y=319; $y -lt 379; $y++) {
    for ($x=568; $x -lt 808; $x++) {
        $c = $comp.GetPixel($x,$y)
        # Check green button pixel
        if ($c.G -gt 150 -and $c.R -lt 100) {
            $ry = $y - 319
            $rx = $x - 568
            if ($ry -lt $minY) { $minY = $ry }
            if ($ry -gt $maxY) { $maxY = $ry }
            if ($rx -lt $minX) { $minX = $rx }
            if ($rx -gt $maxX) { $maxX = $rx }
        }
    }
}
Write-Host "Comp button in region: rx=[$minX, $maxX] ry=[$minY, $maxY] width=$(($maxX-$minX)) height=$(($maxY-$minY))"
$comp.Dispose()
