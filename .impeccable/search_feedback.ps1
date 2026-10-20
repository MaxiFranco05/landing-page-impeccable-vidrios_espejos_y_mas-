$bin = (Get-ChildItem -Recurse 'C:\Users\maxif\.impeccable' -Filter 'impeccable.exe' | Select-Object -First 1).FullName
$bytes = [System.IO.File]::ReadAllBytes($bin)
$str = [System.Text.Encoding]::ASCII.GetString($bytes)
$idx = $str.IndexOf("invalid component feedback")
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 300)
    $len = [Math]::Min(600, $str.Length - $start)
    Write-Host $str.Substring($start, $len)
}
