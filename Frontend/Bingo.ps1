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
A unique user Id received from Get-BingoUser

.EXAMPLE
Get-BingoUser | Get-BingoCard

.NOTES
General notes
#>
function Get-BingoCard {
    param (
        [CmdletBinding()]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript( {
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

function Write-Bingo {
    [CmdletBinding()]
    param (
        [CmdletBinding()]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        [ValidateScript( {
                [guid]::TryParse($_, $([ref][guid]::Empty))
            })]
        [string]$UserId
    )
    Write-Host ''
    Write-Host ' .d88888b.                    888                       '
    Write-Host 'd88P" "Y88b                   888                       '
    Write-Host '888     888                   888                       '
    Write-Host '888     888  .d88b.   .d88b.  88888b.                   '
    Write-Host '888     888 d88""88b d88""88b 888 "88b                  '
    Write-Host 'Y88b. .d88P Y88..88P Y88..88P 888  888 d8b              '
    Write-Host ' "Y88888P"   "Y88P"   "Y88P"  888  888 88P              '
    Write-Host '                                       8P               '
    Write-Host '                                       "                '
    Write-Host '888    888               888                            '
    Write-Host '888    888               888                            '
    Write-Host '888888 88888b.   8888b.  888888 .d8888b         8888b.  '
    Write-Host '888    888 "88b     "88b 888    88K                "88b '
    Write-Host '888    888  888 .d888888 888    "Y8888b.       .d888888 '
    Write-Host 'Y88b.  888  888 888  888 Y88b.       X88       888  888 '
    Write-Host ' "Y888 888  888 "Y888888  "Y888  88888P''       "Y888888 '
    Write-Host '                                                        '
    Write-Host '888      d8b                            888             '
    Write-Host '888      Y8P                            888             '
    Write-Host '888                                     888             '
    Write-Host '88888b.  888 88888b.   .d88b.   .d88b.  888             '
    Write-Host '888 "88b 888 888 "88b d88P"88b d88""88b 888             '
    Write-Host '888 d88P 888 888  888 Y88b 888 Y88..88P  "              '
    Write-Host '88888P"  888 888  888  "Y88888  "Y88P"  888             '
    Write-Host '                           888                          '
    Write-Host '                      Y8b d88P                          '
    Write-Host '                       "Y88P"                           '
    Write-Host ' Please let us know your user id:                       '
    Write-Host " $UserId"
}

function Write-BingoHeader {
    [CmdletBinding()]
    param (

    )
    Write-Host '$$$$$$$\  $$\                               '
    Write-Host '$$  __$$\ \__|                              '
    Write-Host '$$ |  $$ |$$\ $$$$$$$\   $$$$$$\   $$$$$$\  '
    Write-Host '$$$$$$$\ |$$ |$$  __$$\ $$  __$$\ $$  __$$\ '
    Write-Host '$$  __$$\ $$ |$$ |  $$ |$$ /  $$ |$$ /  $$ |'
    Write-Host '$$ |  $$ |$$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |'
    Write-Host '$$$$$$$  |$$ |$$ |  $$ |\$$$$$$$ |\$$$$$$  |'
    Write-Host '\_______/ \__|\__|  \__| \____$$ | \______/ '
    Write-Host '                        $$\   $$ |          '
    Write-Host '                        \$$$$$$  |          '
    Write-Host '                         \______/           '
    Write-Host ''
    Write-Host ''
}

function Write-BingoCard {
    param(
        [CmdletBinding()]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        $BingoCard
    )

    # Write Bingo Card Header
    Write-Host "         |------------------------|         "
    Write-Host "         | B  | I  | N  | G  | O  |         "
    Write-Host "         |------------------------|         "

    # Define BINGO rows
    $Rows = @("B", "I", "N", "G", "O")
    $DefaultForegroundColor = (Get-Host).ui.rawui.ForegroundColor

    # Write Bingo Card
    for ($i = 0; $i -lt 5; $i++) {

        # UI
        $Line = '         |'
        Write-Host $Line -NoNewline

        foreach ($Row in $Rows) {
            $CurrentNumber = $BingoCard.bingo_card.$Row[$i]
            # Change color if the number has been drawn
            if ($CurrentNumber -in $BingoCard.numbers) {
                $OutputColor = "DarkGreen"
            } else {
                $OutputColor = $DefaultForegroundColor
            }
            Write-Host " " -NoNewline
            $PrintString = "{0,-2}" -f $CurrentNumber
            Write-Host -NoNewline $PrintString -ForegroundColor $OutputColor
            Write-Host " |" -NoNewline
            Start-Sleep -Milliseconds (Get-Random -Minimum 1 -Maximum 30)
        }
        Write-Host ''
    }

    Write-Host "         |------------------------|"
    Write-Host ''
}

function Invoke-BingoCheck {
    param(
        [CmdletBinding()]
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        $BingoCard
    )

    for ($i = 0; $i -lt 5; $i++) {
        $CorrectNumbers = 0
        # Check every column for five (5) matching numbers
        foreach ($Name in $BingoCard.bingo_card.psobject.Properties.Name) {
            Write-Verbose "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i])"

            if ( $BingoCard.bingo_card.$Name[$i] -in $BingoCard.numbers ) {
                $CorrectNumbers++
                "$($Name)$($i) = $($BingoCard.bingo_card.$Name[$i]) - Treffer"
            }
        }

        # Check if a total of five (5) matches was found
        if ( $CorrectNumbers -eq 5 ) {
            Write-Verbose "Oooh, thats a bingo!"
            $Bingo = $true
            Break
        } else {
            $Bingo = $false
        }
    }

    if (-not $Bingo) {
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

            # Check if a total of five (5) matches was found
            if ( $CorrectNumbers -eq 5 ) {
                Write-Verbose "Oooh, thats a bingo!"
                $Bingo = $true
                Break
            } else {
                $Bingo = $false
            }
        }
    }

    Return $Bingo
}

function Write-BingoKeymap {
    param (

    )
    Write-Host '############################################'
    Write-Host '# r | Reload Bingo Card                    #'
    Write-Host '# v | Validate Bingo Card                  #'
    Write-Host '# e | Exit Bingo Game                      #'
    Write-Host '############################################'
    Write-Host '                                            '
}

function Invoke-Bingo {
    [CmdletBinding()]
    param (

    )

    # Get Bingo User Id from webservice
    $BingoUserId = Get-BingoUser

    #region Print UI
    do {
        Clear-Host
        # Get current Bingo Card information
        $BingoCard = Get-BingoCard -UserId $BingoUserId

        if ( $key.Character -eq "v" ) {
            $Bingo = Invoke-BingoCheck -BingoCard $BingoCard
            if ($Bingo) {
                Write-Bingo -UserId $BingoUserId
                Break
            }

        }

        Write-BingoHeader
        Write-BingoCard -BingoCard $BingoCard

        # Write instructions
        Write-BingoKeymap

        # Query key from player
        Write-Host -NoNewLine 'Press key to continue: ';
        $key = $Host.UI.RawUI.ReadKey('IncludeKeyDown');
    } until ($key.Character -eq "e")
    #endregion
}

Invoke-Bingo