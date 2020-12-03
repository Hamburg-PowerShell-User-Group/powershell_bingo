using namespace System.Net

param($Request, $TriggerMetadata, $userid, $numbers)

if(-not($userid)){
    $status_code = 404
    $return_object = @{
        'response' = 'user not specified'
    }
}else{
    $status_code = 200
    $return_object = [ordered]@{
        'userid' = $userid[0].id
        'bingo_card' = $userid[0].bingo_field
        'numbers' = $numbers[0].numbers
    }
}


Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status_code
    Body = $return_object
})
