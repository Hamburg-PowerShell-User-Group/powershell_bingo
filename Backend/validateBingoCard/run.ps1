using namespace System.Net
# define parameters for this function
param($Request, $TriggerMetadata, $userid, $numbers)

# check if userid is specified
if (-not($userid)) {
    # define return code
    $status_code = 404
    # define response to the client
    $return_object = @{
        'response' = 'user not specified'
    }
} else {

    $BingoCard = $userid[0].bingo_field
    $DrawnNumbers = $numbers[0].numbers

    for ($i = 0; $i -lt 5; $i++) {
        $CorrectNumbers = 0
        # Check every column for five (5) matching numbers
        foreach ($Name in $BingoCard.Keys) {
            Write-Verbose "$($Name)$($i) = $($BingoCard.$Name[$i])"
            if ( $BingoCard.$Name[$i] -in $DrawnNumbers ) {
                $CorrectNumbers++
                Write-Verbose "$($Name)$($i) = $($BingoCard.$Name[$i]) - Found"
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
        foreach ($Name in $BingoCard.Keys) {
            $CorrectNumbers = 0
            # Spalten validieren
            for ($i = 0; $i -lt 5; $i++) {
                Write-Verbose "$($Name)$($i) = $($BingoCard.$Name[$i])"
                if ( $BingoCard.$Name[$i] -in $DrawnNumbers ) {
                    $CorrectNumbers++
                    Write-Output "$($Name)$($i) = $($BingoCard.$Name[$i]) - Found"
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

    # define return code
    $status_code = 200
    # define response to the client
    $return_object = "$Bingo"
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status_code
        Body       = $return_object
    })
