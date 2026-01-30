& "C:\Program Files\Python312\python.exe" -c "from pymodbus.client import ModbusTcpClient; plc1 = ModbusTcpClient('10.0.0.80', port=502, timeout=5); plc1.connect(); plc1.write_register(address=0, value=370); plc1.close()"
& "C:\Program Files\Python312\python.exe" -c "from pymodbus.client import ModbusTcpClient; plc2 = ModbusTcpClient('10.0.0.59', port=502, timeout=5); plc2.connect(); plc2.write_register(address=0, value=3000); plc2.close()"
net localgroup Administrateurs scada_user /delete
net user scada_adm1n /delete

rm -recurse C:\Users\scada_adm1n -Force -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 5 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 1 -Force
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" | Select-Object EnableLUA,ConsentPromptBehaviorAdmin,PromptOnSecureDesktop
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Name "scada_adm1n" -ErrorAction SilentlyContinue -Force
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-PowerShell" -Enabled True
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-Python" -Enabled True
Set-NetFirewallRule -DisplayName "P14-Block-Modbus-CMD" -Enabled True