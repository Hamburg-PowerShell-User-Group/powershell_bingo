using namespace System.Net

param($Request, $TriggerMetadata, $numbers)

[array]$numbers = $numbers[0].numbers

$new_number = Get-Random -Minimum 1 -Maximum 75
while ($new_number -in $numbers) {
    $new_number = Get-Random -Minimum 1 -Maximum 75
}

$numbers += $new_number

$out = @{
    'id' = '1'
    'numbers' = $numbers
}

Push-OutputBinding -Name outNumber -Value $out

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $numbers
})
