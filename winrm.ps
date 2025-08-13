# Create self signed certificate
$certParams = @{
    CertStoreLocation = 'Cert:\LocalMachine\My'
    DnsName           = $env:COMPUTERNAME
    NotAfter          = (Get-Date).AddYears(1)
    Provider          = 'Microsoft Software Key Storage Provider'
    Subject           = "CN=$env:COMPUTERNAME"
}
$cert = New-SelfSignedCertificate @certParams

# Create HTTPS listener
$httpsParams = @{
    ResourceURI = 'winrm/config/listener'
    SelectorSet = @{
        Transport = "HTTPS"
        Address   = "*"
    }
    ValueSet = @{
        CertificateThumbprint = $cert.Thumbprint
        Enabled               = $true
    }
}
New-WSManInstance @httpsParams

# Opens port 5986 for all profiles
$firewallParams = @{
    Action      = 'Allow'
    Description = 'Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]'
    Direction   = 'Inbound'
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    LocalPort   = 5986
    Profile     = 'Any'
    Protocol    = 'TCP'
}
New-NetFirewallRule @firewallParams
#
#To view the current listeners that are running on the WinRM service:
winrm enumerate winrm/config/Listener

#*************
#To view the certificate details that is specified by the CertificateThumbprint you can run the following PowerShell command:
# $thumbprint = "E6CDAA82EEAF2ECE8546E05DB7F3E01AA47D76CE"
# Get-Item -Path "Cert:\LocalMachine\My\$thumbprint" | Select-Object *
#
#************
# Creating a HTTPS listener is similar but the Port is now 5986 and the CertificateThumbprint value must be set. The certificate can either be a self signed certificate or a certificate from a certificate authority. How to generate a certificate is outside the scope of this section.

# $listenerParams = @{
#     ResourceURI = 'winrm/config/listener'
#     SelectorSet = @{
#         Transport = "HTTPS"
#         Address   = "*"
#     }
#     ValueSet    = @{
#         CertificateThumbprint = 'E6CDAA82EEAF2ECE8546E05DB7F3E01AA47D76CE'
#         Enabled               = $true
#         Port                  = 5986
#     }
# }
# New-WSManInstance @listenerParams
#
#***********
# Remove Listener
# The following code can remove all listeners or a specific one:

#  # Removes all listeners
#  Remove-Item -Path WSMan:\localhost\Listener\* -Recurse -Force

#  # Removes only HTTP listeners
#  Get-ChildItem -Path WSMan:\localhost\Listener |
#      Where-Object Keys -contains "Transport=HTTP" |
#      Remove-Item -Recurse -Force

# # Removes only HTTPS listeners
#  Get-ChildItem -Path WSMan:\localhost\Listener |
#      Where-Object Keys -contains "Transport=HTTPS" |
#      Remove-Item -Recurse -Force
#
#***********
