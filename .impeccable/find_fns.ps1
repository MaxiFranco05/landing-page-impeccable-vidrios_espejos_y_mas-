$c = Get-Content -Path '.impeccable/review.js' -Raw
$pattern = 'function $e('
$idx = $c.IndexOf($pattern)
Write-Host "Index: $idx"
if ($idx -ge 0) {
    Write-Host $c.Substring($idx, 500)
}
$pattern2 = 'function me('
$idx2 = $c.IndexOf($pattern2)
Write-Host "Index2: $idx2"
if ($idx2 -ge 0) {
    Write-Host $c.Substring($idx2, 500)
}
