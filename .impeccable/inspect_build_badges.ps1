Add-Type -AssemblyName System.Drawing
$build = [System.Drawing.Bitmap]::FromFile('c:\Users\maxif\Desktop\projects\landing-page-vidrios-espejos-y-mas\.impeccable\review\hero-repro.png')

# In hero-repro, badges-strip y is 125 to 154
for ($y = 125; $y -le 154; $y++) {
    $p = $build.GetPixel(550, $y)
    $hex = "#{0:X2}{1:X2}{2:X2}" -f $p.R, $p.G, $p.B
    Write-Host "Build at y=$y (rel $(($y - 125))) : $hex (R=$($p.R), G=$($p.G), B=$($p.B))"
}
$build.Dispose()
