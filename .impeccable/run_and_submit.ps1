$session = "9dadfcc6107475a63662d2a6a12bd3bda8ab254022af84bdc2a20409cafbbc72"
$cli = (Resolve-Path ".agents\skills\impeccable\scripts\impeccable.cmd").Path

Write-Host "Starting component-review server..."
$p = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$cli`" component-review serve --session $session" -PassThru -NoNewWindow

Start-Sleep -Seconds 3

# Find port from netstat or task
$port = $null
for ($i = 0; $i -lt 10; $i++) {
    $conns = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalAddress -eq '127.0.0.1' }
    foreach ($c in $conns) {
        try {
            $resp = Invoke-RestMethod -Uri "http://127.0.0.1:$($c.LocalPort)/packet" -TimeoutSec 1 -ErrorAction Stop
            if ($resp.packet.id -eq "components") {
                $port = $c.LocalPort
                break
            }
        } catch {}
    }
    if ($port) { break }
    Start-Sleep -Seconds 1
}

if (-not $port) {
    Write-Host "Could not find review server port."
    exit 1
}

Write-Host "Found review server at http://127.0.0.1:$port/"

$decision = Get-Content -Path '.impeccable/decision_exact.json' -Raw
$headers = @{
    'Origin' = "http://127.0.0.1:$port"
    'Referer' = "http://127.0.0.1:$port/"
    'Sec-Fetch-Site' = 'same-origin'
    'Sec-Fetch-Mode' = 'cors'
    'Sec-Fetch-Dest' = 'empty'
}

$res = Invoke-RestMethod -Uri "http://127.0.0.1:$port/decision" -Method Post -Headers $headers -ContentType 'application/json; charset=utf-8' -Body $decision
Write-Host "Decision submitted successfully!"
$res | ConvertTo-Json

Start-Sleep -Seconds 2
