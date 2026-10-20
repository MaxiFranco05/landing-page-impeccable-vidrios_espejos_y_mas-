Add-Type -AssemblyName System.Drawing
$comp = [System.Drawing.Bitmap]::FromFile('c:\Users\maxif\Desktop\projects\landing-page-vidrios-espejos-y-mas\.impeccable\mocks\decision\challenger-cityscape.png')

Write-Host "Sampling background at center (x=688) at various Y:"
for ($y = 0; $y -le 200; $y += 20) {
    $p = $comp.GetPixel(688, $y)
    $hex = "#{0:X2}{1:X2}{2:X2}" -f $p.R, $p.G, $p.B
    Write-Host "y=$y : $hex (R=$($p.R), G=$($p.G), B=$($p.B))"
}

Write-Host "`nSampling background at y=139 across X:"
for ($x = 200; $x -le 1100; $x += 100) {
    $p = $comp.GetPixel($x, 139)
    $hex = "#{0:X2}{1:X2}{2:X2}" -f $p.R, $p.G, $p.B
    Write-Host "x=$x : $hex (R=$($p.R), G=$($p.G), B=$($p.B))"
}
$comp.Dispose()
