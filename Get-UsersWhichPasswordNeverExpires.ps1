<#
    .SYNOPSIS
        Script check and list all users which set password never expires in Active Directory.

    .NOTES
        Created on:   	10-02-2021
	    Created by:   	Michał Bednarek
	    Filename:     	Get-UsersWhichPasswordNeverExpires.ps1

    .EXAMPLE
        PS> .\PassNeverExpires.ps1 C:\tmp

    .PARAMETER Path
        The path where report will be saved.

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [String]$Path
)

process {
    try{
        Write-Verbose -Message "Gathreing informations..." -Verbose
        $currentDateTime = Get-Date -Format 'yyyy-MM-dd hh-mm-ss'
        $fileName = "PasswordNeverExpires-" + $currentDateTime + ".txt"
        $finalPath = Join-Path $Path $fileName

        $data = Get-ADUser -filter * -properties Name, PasswordNeverExpires | 
        where { $_.passwordNeverExpires -eq "true" } | 
        where {$_.enabled -eq "true"}  | 
        select -Property Name, PasswordNeverExpires | Out-File -FilePath $finalPath
        Write-Verbose -Message "Report saved: $($finalPath)" -Verbose
    }catch{
        Write-Error -Message "Error: $($_.Exception.Message)"
    }
}