<#
#Script name: Get users within an AD group
#Creator: Abdur Rob
#Date: 2018-06-08
#Revision: Wesley Trust
#Date: 2018-06-09
#Version: 2

.Synopsis
   Script which retrieves all the users within an AD Group.
.DESCRIPTION
   Script which will use PowerShell to retrieve all members from a specified goup and export this to a CSV and format on screen.
.EXAMPLE
   Get-UsersInGroup -GroupDisplayName $GroupDisplayName -CSVExportPath $CSVExportPath
#>

function Get-UsersInGroup {
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Enter group display name"
        )]
        [string[]]
        $GroupDisplayName,
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Enter CSV export path"
        )]
        [string[]]
        $CSVExportPath
    )
            
    Begin {
        try {
            # Prompt for input
            if (!$GroupDisplayName) {
                $GroupDisplayName = Read-Host -Prompt "Enter the group name"
            }
            if (!$CSVExportPath) {
                $CSVExportPath = Read-Host -Prompt "Enter the output location for the CSV"
            }
        }
        catch {
            Write-Error -Message $_.Exception

        }
    }

    Process {
        try {
        
            # Split and trim input
            $GroupDisplayName = $GroupDisplayName.Split(",")
            $GroupDisplayName = $GroupDisplayName.Trim()

            # Foreach group
            $ADUsers = foreach ($DisplayName in $GroupDisplayName) {
                # Get the members of the group
                $Members = Get-ADGroupMember -Identity $GroupDisplayName

                # Get the user objects, and select properties
                $Members | Get-ADUser | Select-Object givenname, surname, userprincipalname
            }

            # Export the users into a CSV file
            $ADUsers | Export-Csv -Path $CSVExportPath -NoTypeInformation

            return $ADUsers
        }
        catch {
            Write-Error -Message $_.Exception

        }
    }

    End {
        try {
        
        }
        catch {
            Write-Error -Message $_.Exception

        }
    }
}

# Call function, with variables if present, and format output
Get-UsersInGroup -GroupDisplayName $GroupDisplayName -CSVExportPath $CSVExportPath | Format-Table