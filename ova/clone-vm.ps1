Write-Host ' '                                                                                       
Write-Host '                                 ,/////////////////,'
Write-Host '                               .(((((((((((((((((((('
Write-Host '                              *((((((((((((((((((((('
Write-Host '                             /((((((((/****/(((((((('
Write-Host '                           .((((((((/,,,,,,,,/(((((('
Write-Host '           .**************/(((((((((,,,,,,,,,,(((((('
Write-Host '           ##############(((((((((((,,,,,,,,,,(((((('
Write-Host '           #############(((((((((((((*,,,,,,*((((((('
Write-Host '           ###########((((((((((((((((((//(((((((((('
Write-Host '           ##########((((((((((///(((((((((((((((((('
Write-Host '           #########(((((((((/////(((((((((((((((/.'
Write-Host '           .#######(((((((#/////((((((((((((((/.'
Write-Host '             ,####((((((#/////(#((((((((((((.'
Write-Host '               ,##..((#(////(#(((((((((((#'
Write-Host '                     *////(###(((((((##%##'
Write-Host '                    ****(##(((((((##%%%###'
Write-Host '           ***       ..  .(((((#%%%%%#####'
Write-Host '           ***           *%%#%%%%%%%%%%%##'
Write-Host '           ***           ,#%%%%%%%%%%%%%%#'
Write-Host '           ****,,,,,,      ,#%%%%%%%%%%%%#'
Write-Host '           **********        ,#%%%%%%%%%%/'

#Set-PowerCLIConfiguration -invalidcertificateaction "ignore" -confirm:$false |out-null
#Set-PowerCLIConfiguration -Scope Session -WebOperationTimeoutSeconds -1 -confirm:$false |out-null   

if ( !(Get-Module -ListAvailable -Name VMware.PowerCLI -ErrorAction SilentlyContinue) ) {
    write-host ("VMware PowerCLI PowerShell module not found. Please verify installation and retry.") -BackgroundColor Red
    write-host "Terminating Script" -BackgroundColor Red
    return
}

try {
    Import-Module VMware.PowerCLI
}
Catch {
    $_ | Write-Host
}

#Connect to vCenter server
try {
    # connect to vi server using username and password from azure pipelines
    Connect-VIserver -Server 192.168.254.20 -User $Env:viuser -Password $ENV:vipass
}
Catch {
    write-host "Unable to Connect to VMware vCenter Server"
    $_ | Write-Host
    return
}

# Clone Ubuntu 18.04 LTS template named 'ubuntu18.04lts'
$myDatastore = Get-Datastore -Name "VNX5300-SAS"
$myCluster = Get-Cluster -Name "New Cluster"
$myTemplate = Get-Template -Name "ubuntu1804lts"
$mySpec = Get-OSCustomizationSpec -Name "zplanner"
$vmname = $Env:buildnumber
Write-Host "clone name: $vmname"

try{
    New-VM -Name $vmname -Template $myTemplate -OSCustomizationSpec $mySpec -Datastore $myDatastore -resourcepool $myCluster
}
Catch {
    write-host "Unable to Clone Template"
    $_ | Write-Host
}

Start-VM -VM $vmname -confirm:$false
Start-Sleep -Seconds 60

$vm_ip = ""
do {
    Start-Sleep -Seconds 10
    $VMInfo = Get-VM -Name $vmname | Select-Object Name, @{N="IP Address";E={@($_.guest.IPAddress[0])}}
    $vm_ip = $VMInfo."IP Address"
    Write-Output $ip
} While(!$vm_ip)

Write-Output "The VM has an IP of $vm_ip"
Write-Output "##vso[task.setvariable variable=vm_ip]$vm_ip"
add-content $logfile ("Disconnecting vCenter session. Script Complete")
