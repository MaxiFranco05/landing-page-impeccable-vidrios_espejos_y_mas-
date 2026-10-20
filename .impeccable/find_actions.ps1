$c = Get-Content -Path '.impeccable/review.js' -Raw
$pattern = 'action:"'
$idx = 0
while (($idx = $c.IndexOf($pattern, $idx)) -ge 0) {
    Write-Host $c.Substring([Math]::Max(0, $idx - 50), 120)
    $idx += 10
}
