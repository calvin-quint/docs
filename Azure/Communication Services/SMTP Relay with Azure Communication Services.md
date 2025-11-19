## SMTP Relay with Azure Communication Services
1. Prerequisites
Ensure the following are ready:

Azure Subscription: Active with contributor or owner permissions.

Azure Communication Services (ACS) Resource: Already created.

Custom Domain: e.g., smtp.omniapartners.com, verified in Azure AD.

App Registration (Service Principal): Registered in Entra ID (Azure AD).

DNS Management Access: To configure SPF, DKIM, and DMARC.

PowerShell Access: Installed with Az modules for testing and automation.

## 2. Create ACS Resource
Go to Azure Portal.

Navigate to Create a resource > Communication Services.

Fill in resource details and click Create.

After deployment, open the resource and go to the Email blade.

3. Add Custom Domain to ACS
In the ACS resource, go to Email > Domains.

Click + Add.

Enter your domain (e.g., smtp.example.com) and click Add.

Azure will provide SPF, DKIM*, and MX DNS entries.

*NOTE: The provided records for DKIM will not be accurate if you're using a subdomain. The subdomain will need to be appended after a period on the CNAME Name entry.
Ex: for "smtp.omniapartners.com",
       Azure provides the CNAME      "selector2-azurecomm-prod-net._domainkey",
       but you'll need to change it to  "selector2-azurecomm-prod-net._domainkey.smtp".
4. Configure DNS Records
✅ SPF Record
Add the following TXT record at your DNS provider:

Name: @ Type: TXT Value: v=spf1 include:smtp.omniapartners.com -all
✅ DKIM Records
In Email > DKIM under ACS:

Azure will generate two CNAME records similar to:

Record Type	Name (Host)	Value (Points to)
CNAME	selector1-azurecomm-prod-net._domainkey.smtp	selector1-azurecomm-prod-net._domainkey.azurecomm.net
CNAME	selector2-azurecomm-prod-net._domainkey.smtp	selector2-azurecomm-prod-net._domainkey.azurecomm.net
Ensure the subdomain smtp is reflected correctly in both name and value.

✅ DMARC Record
Name: _dmarc Type: TXT Value: v=DMARC1; p=none; rua=mailto:dmarc-reports@smtp.omniapartners.com
5. Create and Assign Custom Role
✅ Create Custom Role
Go to Subscriptions > Access control (IAM).

Click + Add > Add custom role.

Set name, e.g., ACS Email Relay Role.

Under Permissions, include:

"Microsoft.Communication/CommunicationServices/read"
"Microsoft.Communication/CommunicationServices/write"
"Microsoft.Communication/EmailServices/write"
✳️ Ensure EmailService_CreateOrUpdate is covered under write permissions.

Click Review + Create.

✅ Assign Custom Role to App Registration
Still under Access control (IAM) in the subscription:

Click + Add > Add role assignment.

Choose the custom role you created.

For Assign access to, select User, group, or service principal.

Find and select your App Registration (Service Principal).

Click Save.

6. Configure App Registration (Service Principal)
Go to Azure Active Directory > App registrations.

Click + New registration.

Provide a name (e.g., smtp-relay-app) and register.

Under Certificates & secrets, generate a Client Secret.

Copy:

Application (client) ID

Directory (tenant) ID

Client Secret

7. Set Up SMTP Relay
Setting	Value
SMTP Server	smtp.azurecomm.net
SMTP Username	
<App Name>.<Application ID>.<Tenant ID>
IT-Ops-Communication-Service.4a97118c-f293-4ab5-8645-e9f32d1547ce.1bd768b7-86dd-4ae8-8cd2-038cbb7d165c
SMTP Password	Client Secret from App Registration
8. Create MailFrom Address Using PowerShell
Run the following in PowerShell:

New-AzEmailServiceSenderUsername `
    -ResourceGroupName "MyResourceGroup" `
    -EmailServiceName "MyEmailService" `
    -DomainName "smtp.example.com" `
    -SenderUsername "noreply" `
    -Username "noreply"

New-AzEmailServiceSenderUsername `
    -ResourceGroupName IT_Management `
    -EmailServiceName OP `
    -DomainName smtp.omniapartners.com `
    -SenderUsername curator `
    -Username curator

New-AzEmailServiceSenderUsername `
    -ResourceGroupName IT_Management `
    -EmailServiceName OP `
    -DomainName smtp.omniapartners.com `
    -SenderUsername curator -Username curator
This sets up curator@smtp.omniapartners.com.

9. Test SMTP Relay Using PowerShell
$smtpCredentials = Get-Credential 
$sendMailMessageSplat = @{
    From = 'noreply@smtp.omniapartners.com'
    To = 'servicedesk@omniapartners.com'
    Subject = 'Test Email'
    Body = "This is a test email"
    Priority = 'High'
    DeliveryNotificationOption = 'OnSuccess', 'OnFailure'
    SmtpServer = 'smtp.azurecomm.net'
    UseSsl = $True
    Credential = $smtpCredentials
    Port = 587
}
Send-MailMessage @sendMailMessageSplat
✅ When prompted, enter the SMTP username and client secret.
