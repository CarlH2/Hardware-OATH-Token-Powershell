# Hardware-OATH-Token-Powershell
**Bulk Managing Hardware OATH Tokens in Entra ID via Powershell by invoking Graph API**

Management of Hardware OATH Tokens in Entra ID has changed and Microsoft have new updated APIs that can be used for managing Tokens using code.
https://learn.microsoft.com/en-gb/entra/identity/authentication/how-to-mfa-manage-oath-tokens

Unfortunately there are not currently any Powershell cmdlets for taking advantage of this API and it is only possible using Microsoft Graph requests directly.
https://learn.microsoft.com/en-us/graph/api/resources/hardwareoathtokenauthenticationmethoddevice?view=graph-rest-beta

Until Microsoft make Powershell cmdlets available I created a couple of scripts in this repo that should be taken as examples of the powershell code required to manage Hardware OATH Tokens in bulk.  Specifically, these scripts are developed to meet the scenario here https://learn.microsoft.com/en-gb/entra/identity/authentication/how-to-mfa-manage-oath-tokens#scenario-admin-creates-multiple-hardware-oath-tokens-in-bulk-that-users-self-assign-and-activate

The Create scripts take a CSV file as input (command line parameter) and the header row must have the following values **serialNumber,secretKey,timeIntervalInSeconds,manufacturer,model,hashFunction** which correspond to the relevant columns provided by the Hardware token vendor. However the CSV files provided by the vendors for Entra utilise the CSV template used by the Entra Portal upload method which is not compatible with these scripts (NOTE: the Entra Portal method of Hardware Token upload requires that the Hardware Tokens are pre-assigned to user UPNs). It should not be too difficult to adjust the CSV file header accordingly.

The Delete script takes a CSV file as input (command line parameter) and the header row must have a sinlge entry that corresponds to the Entra object ID for the Hardware token (this can be acquired using the Get cmdlet and the csv file from this cmdlet is sufficient; remove those Token objects you want to keep in Entra).

The Create and Delete scripts log a transcript of the script operations in a log file named after the script and saved to the location the script is run from.

Further informmation on the scripts is provided in the header of the script.
