Add-Type -AssemblyName System.Drawing
$comp = [System.Drawing.Bitmap]::FromFile('c:\Users\maxif\Desktop\projects\landing-page-vidrios-espejos-y-mas\comp-badges-crop.png')

for ($x = 0; $x -lt 20; $x++) {
    $p = $comp.GetPixel($x, 17)
    $hex = "#{0:X2}{1:X2}{2:X2}" -f $p.R, $p.G, $p.B
    Write-Host "x=$x : $hex (R=$($p.R), G=$($p.G), B=$($p.B))"
}
$comp.Dispose()
