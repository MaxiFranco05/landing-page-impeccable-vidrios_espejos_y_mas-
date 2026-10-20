$packetJson = Get-Content -Path '.impeccable/current_packet.json' -Raw | ConvertFrom-Json
$packet = $packetJson.packet

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

$submission | ConvertTo-Json -Depth 5 | Out-File -FilePath '.impeccable/decision_exact.json' -Encoding utf8
Write-Host "Created .impeccable/decision_exact.json with feedback: empty string and split: false"
