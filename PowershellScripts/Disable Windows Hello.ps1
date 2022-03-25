Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" -Name "value" -Value 1
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork" -value “default value”
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork -Name DisablePostLogonProvisioning -Type "DWORD” -Value 0

