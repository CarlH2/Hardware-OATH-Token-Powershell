<#  ==============================================================================================================================================
    Create-HardwareOATHTokens.ps1:  From a CSV file taken as a script parameter this script
                                    creates unassigned and unactivated Hardware OATH token object(s) in Entra ID
    Usage:
    ======
        .\Create-HardwareOATHTokens.ps1 -csvFilePath <PathToYourCSV>
        
        e.g. .\Create-HardwareOATHTokens.ps1 -csvFilePath .\temp\HardwareOATHTokenList.csv

    Parameters:
    ===========
        -csvFilePath    A File in CSV format that contains the data required for each Hardware OATH Token
                        The CSV file header (first line) must contain the following fields\columns, delimited by comma's
                        serialNumber,secretKey,timeIntervalInSeconds,manufacturer,model,hashFunction

   Output:
   =======
   The script writes to a Log named Create-HardwareOATHTokens.log in the current folder
    
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

Param (
[Parameter(Position = 0, Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
[ValidateNotNullOrEmpty()]
[string]$csvFilePath)

# Start Logging
start-transcript .\Create-HardwareOATHTokens.Log -Append -Force

# Import the Microsoft Graph module
Import-Module Microsoft.Graph.Authentication

# Define the required scopes
$scopes = @("Policy.ReadWrite.AuthenticationMethod")

# Authenticate and connect to Microsoft Graph
Connect-MgGraph -Scopes $scopes

# Read the CSV file
$tokens = Import-Csv -Path $csvFilePath

# Loop through each token in the CSV file and create the Hardware OATH token object
foreach ($token in $tokens) {
     $body = @{
        manufacturer = $token.manufacturer
        model = $token.model
        serialNumber = $token.serialNumber
        secretKey = $token.secretKey
        timeIntervalInSeconds = $token.timeIntervalInSeconds
        hashFunction = $token.hashFunction
    }

    # Convert the body to JSON
    $jsonBody = $body | ConvertTo-Json

    # Create the Hardware OATH token object using Invoke-MgGraphRequest
    Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/directory/authenticationMethodDevices/hardwareOathDevices" -Body $jsonBody -ContentType "application/json"
    Write-Host
    # This 1 second delay is required to allow the POST action to complete
    Start-Sleep -Seconds 1
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph

Stop-transcript