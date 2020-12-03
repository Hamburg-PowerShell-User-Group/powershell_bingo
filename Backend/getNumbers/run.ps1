using namespace System.Net

param($Request, $TriggerMetadata, $numbers)

$bingo_numbers = $numbers[0].numbers

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $bingo_numbers
})
