<#  ==============================================================================================================================================
    Get-HardwareOATHTokens.ps1:  This script Lists Hardware OATH token object(s) in Entra ID
    Usage:
    ======
        .\Get-HardwareOATHTokens.ps1
        
   Output:
   =======
   The script writes to a csv file named Get-HardwareOATHTokens.csv in the current folder
    
   Author: Carl Harrison (Microsoft CSU)
           
   V1.0:   First Cut
   V1.1:   Adjusted to enable export when more than 1000 records exist

Disclaimer:
This sample script is not supported under any Microsoft standard support program or service. 
The sample script is provided AS IS without warranty of any kind. Microsoft further disclaims 
all implied warranties including, without limitation, any implied warranties of merchantability 
or of fitness for a particular purpose. The entire risk arising out of the use or performance of 
the sample scripts and documentation remains with you. In no event shall Microsoft, its authors, 
or anyone else involved in the creation, production, or delivery of the scripts be liable for any 
damages whatsoever (including, without limitation, damages for loss of business profits, business 
interruption, loss of business information, or other pecuniary loss) arising out of the use of or 
inability to use the sample scripts or documentation, even if Microsoft has been advised of the 
possibility of such damages

 ========================================================================================================================================================
#>

# Import the Microsoft Graph module
Import-Module Microsoft.Graph.Authentication

# Define the required scopes
$scopes = @("Policy.Read.All")

# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes $scopes

$uri = "https://graph.microsoft.com/beta/directory/authenticationMethodDevices/hardwareOathDevices"

$all = @()

do {
    $resp = Invoke-MgGraphRequest -Method GET -Uri $uri -OutputType PSObject
    if ($resp.value) {
        $all += $resp.value
    }
    $uri = $resp.'@odata.nextLink'
} while ($uri)

# Output file with date time stamp
$dateTime = (Get-Date -Format s) -replace ":", "_"
$outFile = ".\HardwareOATHTokens$dateTime.csv"

$all | Export-Csv -Path $outFile -NoTypeInformation

Write-Host "Exported $($all.Count) rows to $outFile"

# Disconnect from Microsoft Graph
Disconnect-MgGraph
