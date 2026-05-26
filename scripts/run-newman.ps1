param(
    [string]$Env = "local"
)

switch ($Env) {
    "mock"   { npm run test:mock }
    "local"  { npm run test:local }
    "docker" { npm run test:local }
    default  {
        Write-Error "Usage: .\scripts\run-newman.ps1 [-Env mock|local|docker]"
        exit 1
    }
}
