<#
.SYNOPSIS
Get a Bingo User Id to identify against the webservice.

.DESCRIPTION
Get a Bingo User Id to identify against the webservice.

.EXAMPLE
Get-BingoUser

.NOTES
Hamburg PowerShell Usergroup 12-2020
#>
function Get-BingoUser {
    $UserId = Invoke-RestMethod -Method Post -Uri 'https://bingo.hhpsug.de/api/createUser'
    Return $UserId.id
}

<#
.SYNOPSIS
Get a Bingo card based on your Bingo User Id

.DESCRIPTION
Get a Bingo card based on your Bingo User Id
Only one Bingo card per Bingo User Id

.PARAMETER UserId
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Get-BingoCard {
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({
            [guid]::TryParse($_, $([ref][guid]::Empty))
        })]
        [string]$UserId
    )

    # Connect to server and request bingo card
    $Uri = 'https://bingo.hhpsug.de/api/getUser?userId=' + $UserId
    $BingoCard = Invoke-RestMethod -Method Get -Uri $Uri

    # Output bingo card
    Return $BingoCard
}



function Write-BingoCard {
    Clear-Host
    $Spalten = @("B", "I", "N", "G", "O")

    Write-Host "|------------------------|"
    Write-Host "| B  | I  | N  | G  | O  |"
    Write-Host "|------------------------|"

    for ($i = 0; $i -lt 5; $i++) {
        $Line = "|"
        foreach ($Spalte in $Spalten) {
            $Line = $Line + " {0,-2} |" -f $BingoCard.bingo_card.$Spalte[$i]
            Start-Sleep -Milliseconds (Get-Random -Minimum 1 -Maximum 30)
        }
        Write-Host $Line
    }
    Write-Host "|------------------------|"

}

Write-BingoCard

$BingoCard.numbers | Measure-Object

for ($i = 0; $i -lt 5; $i++) {
    $CorrectNumbers = 0
    # Spalten validieren
    foreach ($Name in $BingoCard.bingo_card.psobject.Properties.Name) {
        Write-Verbose "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i])"
        
        if ( $BingoCard.bingo_card.$Name[$i] -in $BingoCard.numbers ) {
            $CorrectNumbers++
            "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i]) - Treffer"
        }
    }
    if ( $CorrectNumbers -eq 5 ) {
        $Bingo = $true
        "BINGO"
        Break
    } else {
        $Bingo = $false
    }
}

foreach ($Name in $BingoCard.bingo_card.psobject.Properties.Name) {
    $CorrectNumbers = 0
    # Spalten validieren
    for ($i = 0; $i -lt 5; $i++) {
        Write-Verbose "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i])"
        
        if ( $BingoCard.bingo_card.$Name[$i] -in $BingoCard.numbers ) {
            $CorrectNumbers++
            "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i]) - Treffer"
        }
    }
    if ( $CorrectNumbers -eq 5 ) {
        $Bingo = $true
        "BINGO"
        Break
    } else {
        $Bingo = $false
    }
}

if ( $Bingo ) {

}
