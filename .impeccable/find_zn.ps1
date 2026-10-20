$c = Get-Content -Path '.impeccable/review.js' -Raw
$pattern = 'function zn('
$idx = $c.IndexOf($pattern)
Write-Host "zn Index: $idx"
if ($idx -ge 0) {
    Write-Host $c.Substring($idx, 400)
}
$pattern2 = 'function Pn('
$idx2 = $c.IndexOf($pattern2)
Write-Host "Pn Index: $idx2"
if ($idx2 -ge 0) {
    Write-Host $c.Substring($idx2, 400)
}
