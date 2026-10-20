$bin = (Get-ChildItem -Recurse -Filter "impeccable.exe" "$env:USERPROFILE\.impeccable" | Select-Object -First 1).FullName
$bytes = [System.IO.File]::ReadAllBytes($bin)
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
$idx = $text.IndexOf("accepted a first viewport")
if ($idx -ge 0) {
    Write-Output $text.Substring([Math]::Max(0, $idx - 300), 1000)
} else {
    Write-Output "Not found"
}
