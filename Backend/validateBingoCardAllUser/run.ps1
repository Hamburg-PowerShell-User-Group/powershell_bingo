using namespace System.Net
# define parameters for this function
param($Request, $TriggerMetadata, $userids, $numbers)


[System.Collections.ArrayList]$return = @()
$DrawnNumbers = $numbers[0].numbers


foreach($userid in $userids){
    $BingoCard = $userid.bingo_field

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
            Write-Verbose "Oooh, thats a bingo! for $($userid.id)"
            $Bingo = $true
            $return.Add($userid.id) | Out-Null
            Continue
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
                Write-Verbose "Oooh, thats a bingo! for $($userid.id)"
                $Bingo = $true
                $return.Add($userid.id) | Out-Null
                Continue
            } else {
                $Bingo = $false
            }
        }

    }
}


if($return){
    $status_code = 200
} else {
    $status_code = 204
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status_code
    Body       = ($return | Select-Object -Unique)
})
