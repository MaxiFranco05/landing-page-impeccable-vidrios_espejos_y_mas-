$bin = (Get-ChildItem -Recurse -Filter "impeccable.exe" "$env:USERPROFILE\.impeccable" | Select-Object -First 1).FullName
$bytes = [System.IO.File]::ReadAllBytes($bin)
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
$idx = $text.IndexOf("build-phase advance")
if ($idx -ge 0) {
    Write-Output $text.Substring([Math]::Max(0, $idx - 100), 500)
} else {
    Write-Output "advance not found"
}
