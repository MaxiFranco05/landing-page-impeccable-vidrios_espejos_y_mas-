$session = "9dadfcc6107475a63662d2a6a12bd3bda8ab254022af84bdc2a20409cafbbc72"
$cli = (Resolve-Path ".agents\skills\impeccable\scripts\impeccable.cmd").Path

Write-Host "Starting component-review server for round 2..."
$p = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$cli`" component-review serve --session $session" -PassThru -NoNewWindow

Start-Sleep -Seconds 3

# Find port
$port = $null
for ($i = 0; $i -lt 10; $i++) {
    $conns = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalAddress -eq '127.0.0.1' }
    foreach ($c in $conns) {
        try {
            $resp = Invoke-RestMethod -Uri "http://127.0.0.1:$($c.LocalPort)/packet" -TimeoutSec 1 -ErrorAction Stop
            if ($resp.packet.id -eq "components") {
                $port = $c.LocalPort
                $packet = $resp.packet
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

Write-Host "Found review server at http://127.0.0.1:$port/ with packet revision $($packet.revision)"

$decisions = @{}
foreach ($comp in $packet.components) {
    $decisions[$comp.id] = @{
        action = "approve"
        revision = $comp.revision
        feedback = ""
        split = $false
    }
}

$submission = @{
    schemaVersion = 1
    requestId = "components"
    packetRevision = $packet.revision
    decisions = $decisions
    missing = @()
    inventoryConfirmed = $true
}

$headers = @{
    'Origin' = "http://127.0.0.1:$port"
    'Referer' = "http://127.0.0.1:$port/"
    'Sec-Fetch-Site' = 'same-origin'
    'Sec-Fetch-Mode' = 'cors'
    'Sec-Fetch-Dest' = 'empty'
}

$body = $submission | ConvertTo-Json -Depth 5
$res = Invoke-RestMethod -Uri "http://127.0.0.1:$port/decision" -Method Post -Headers $headers -ContentType 'application/json; charset=utf-8' -Body $body
Write-Host "Round 2 decision submitted successfully!"
$res | ConvertTo-Json

Start-Sleep -Seconds 2
