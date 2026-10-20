Add-Type -AssemblyName System.Drawing
$comp = [System.Drawing.Bitmap]::FromFile('c:\Users\maxif\Desktop\projects\landing-page-vidrios-espejos-y-mas\comp-badges-crop.png')
$build = [System.Drawing.Bitmap]::FromFile('c:\Users\maxif\Desktop\projects\landing-page-vidrios-espejos-y-mas\.impeccable\review\build-badges-crop.png')

function Get-Energy($bmp) {
    $sum = 0
    $count = 0
    for ($x = 1; $x -lt ($bmp.Width - 1); $x++) {
        for ($y = 1; $y -lt ($bmp.Height - 1); $y++) {
            $p = $bmp.GetPixel($x, $y)
            $lum = 0.299 * $p.R + 0.587 * $p.G + 0.114 * $p.B
            
            # Laplacian 3x3: 4*center - left - right - up - down
            $pl = $bmp.GetPixel($x - 1, $y); $ll = 0.299 * $pl.R + 0.587 * $pl.G + 0.114 * $pl.B
            $pr = $bmp.GetPixel($x + 1, $y); $lr = 0.299 * $pr.R + 0.587 * $pr.G + 0.114 * $pr.B
            $pu = $bmp.GetPixel($x, $y - 1); $lu = 0.299 * $pu.R + 0.587 * $pu.G + 0.114 * $pu.B
            $pd = $bmp.GetPixel($x, $y + 1); $ld = 0.299 * $pd.R + 0.587 * $pd.G + 0.114 * $pd.B
            
            $lap = [math]::Abs(4 * $lum - $ll - $lr - $lu - $ld)
            $sum += $lap
            $count++
        }
    }
    return ($sum / $count)
}

Write-Host "Comp Energy: " (Get-Energy $comp)
Write-Host "Build Energy: " (Get-Energy $build)

$comp.Dispose()
$build.Dispose()
