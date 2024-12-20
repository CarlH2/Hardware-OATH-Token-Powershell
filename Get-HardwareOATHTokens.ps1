<#  ==============================================================================================================================================
    Get-HardwareOATHTokens.ps1:  This script Lists unassigned and unactivated Hardware OATH token object(s) in Entra ID
    Usage:
    ======
        .\Get-HardwareOATHTokens.ps1
        
   Output:
   =======
   The script writes to a csv file named Get-HardwareOATHTokens.csv in the current folder
    
   Author: Carl Harrison (Microsoft CSU)
           
   V1.0:   First Cut

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

$hardwareOATHTokensData = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/directory/authenticationMethodDevices/hardwareOathDevices" -OutputType PSObject

# Export the results array to a csv file
# Set up output file with date time stamp
$dateTime=get-date -format s
$dateTime=$dateTime -replace ":","_"
$dateTime=$dateTime.ToString()
$hardwareOATHTokensData.value | Export-Csv -Path ".\HardwareOATHTokens$dateTime.csv" -NoTypeInformation

# Disconnect from Microsoft Graph
Disconnect-MgGraph
