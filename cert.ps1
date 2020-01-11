$servers=Get-Content "C:\server.TXT"
 
$result=@()
 
foreach ($i in $servers)
 
{
 
$ErrorActionPreference="SilentlyContinue"
 
$a=Invoke-Command -ComputerName $i {Get-ChildItem Cert:\LocalMachine\My -Recurse |
Where-Object {$_ -is [System.Security.Cryptography.X509Certificates.X509Certificate2] -and $_.NotAfter -gt (Get-Date) -and $_.NotAfter -lt (Get-Date).AddDays(30)}
 
}
 
foreach ($c in $a) {
 
$result+=New-Object -TypeName PSObject -Property ([ordered]@{
'Server'=$i;
'Certificate'=$c.Issuer;
'Expires'=$c.NotAfter
 
})
 
}
 
}
$result | Out-File "C:\output.TXT"


$fromaddress = "donotreply@test.net" 
$toaddress = "test@test.com"
#$bccaddress = "test@test.com" 
#$CCaddress = "test1@test.com" 
$Subject = "ACtion Required" 
$body = get-content "c:\server.txt "
$attachment = "C:\output.txt" 
$smtpserver = "smtp@test.com" 
 
#################################### 
 
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress) 
$message.CC.Add($CCaddress) 
$message.Bcc.Add($bccaddress) 
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($attachment) 
$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver) 
$smtp.Send($message) 