using namespace System.Net

param($Request, $TriggerMetadata, $users)

Function Get-StringHash { 
    param(
        [String] $String
    )
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    $algorithm = [System.Security.Cryptography.HashAlgorithm]::Create('MD5')
    $StringBuilder = New-Object System.Text.StringBuilder 
  
    $algorithm.ComputeHash($bytes) | 
    ForEach-Object { 
        $null = $StringBuilder.Append($_.ToString("x2")) 
    } 
  
    return $StringBuilder.ToString() 
}

$client_ip_hash = Get-StringHash $TriggerMetadata.Headers.'X-Forwarded-For'.Split(':')[0]

$user_available = $users | Where-Object {$_.ip_hash -eq $client_ip_hash}

if($user_available){
    $user_guid = $user_available.id

    $body = @{
        'response' = 'only one user can be registered'
        'userid' = $user_guid
    }
}else{
    $user_guid = (new-guid).guid

    $bingo_column = [System.Collections.ArrayList]@('B','I','N','G','O')
    $bingo_field = [System.Collections.Specialized.OrderedDictionary]@{}

    (0..4 | %{ $bingo_field.Add($bingo_column[$_], (($x=15*$_+1)..($x+14)| random -c 5 | sort) )})

    $body = @{
        'id' = $user_guid
        'ip_hash' = $client_ip_hash
        'bingo_field' = $bingo_field
    }
    
    Push-OutputBinding -Name userout -Value $body
}


$StatusCode = 200
$body = @{
    'id' = $user_guid
}


Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $StatusCode
    Body = $body
})
