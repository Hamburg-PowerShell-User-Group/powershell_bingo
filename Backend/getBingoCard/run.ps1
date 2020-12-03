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
    # define return code
    $status_code = 200
    # define response to the client
    $return_object = [ordered]@{
        'userid'     = $userid[0].id
        'bingo_card' = $userid[0].bingo_field
        'numbers'    = $numbers[0].numbers
    }
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status_code
        Body       = $return_object
    })
