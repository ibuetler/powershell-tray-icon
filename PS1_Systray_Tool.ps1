############################################################################################
# Switch Proxy Icon Tray
############################################################################################
$path = ".\"
$ProxyLog = $path + "proxy.log"

Param
 (
	[String]$Restart	
 )

If ($Restart -ne "") 
	{
		sleep 10
	} 

$Current_Folder = split-path $MyInvocation.MyCommand.Path
	
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 	 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing') 		 | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | out-null
[System.Reflection.Assembly]::LoadFrom("$Current_Folder\assembly\MahApps.Metro.dll") | out-null

$icon = [System.Drawing.Icon]::ExtractAssociatedIcon("C:\Windows\System32\mobsync.exe")	


$internetSettings = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings";

# Determines the current state of the proxy
function Get-ProxyState() {
  $settings = Get-ItemProperty -Path $internetSettings;
  return $settings.ProxyEnable;
}

# Enables the proxy.
# IMPORTANT: Change the defaults to something that is useful to you!
function Enable-Proxy-Jona(
    [String] $ProxyServer = "http://192.168.100.10:8080",
    [String] $ProxyScript = "http://192.168.100.10:8080/proxy.pac",
    [String] $ProxyOverrides = "") {

    Set-ItemProperty -Path $internetSettings -Name ProxyServer -Value $ProxyServer
    Set-ItemProperty -Path $internetSettings -Name AutoConfigURL -Value $ProxyScript
    Set-ItemProperty -Path $internetSettings -Name ProxyOverride -Value $ProxyOverrides
    Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 1

    # Also update the environment variables to the right setting.
    # This enables tools like GIT and NPM to use the proxy.
    $env:HTTP_PROXY = "$proxyServer"
    $env:HTTPS_PROXY = "$proxyServer"
}

function Enable-Proxy-Zuerich(
    [String] $ProxyServer = "http://192.168.200.10:8080",
    [String] $ProxyScript = "http://192.168.200.10:8080/proxy.pac",
    [String] $ProxyOverrides = "") {

    Set-ItemProperty -Path $internetSettings -Name ProxyServer -Value $ProxyServer
    Set-ItemProperty -Path $internetSettings -Name AutoConfigURL -Value $ProxyScript
    Set-ItemProperty -Path $internetSettings -Name ProxyOverride -Value $ProxyOverrides
    Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 1

    # Also update the environment variables to the right setting.
    # This enables tools like GIT and NPM to use the proxy.
    $env:HTTP_PROXY = "$proxyServer"
    $env:HTTPS_PROXY = "$proxyServer"
}

function Enable-Proxy-Bern(
    [String] $ProxyServer = "http://192.168.203.10:8080",
    [String] $ProxyScript = "http://192.168.203.10:8080/proxy.pac",
    [String] $ProxyOverrides = "") {

    Set-ItemProperty -Path $internetSettings -Name ProxyServer -Value $ProxyServer
    Set-ItemProperty -Path $internetSettings -Name AutoConfigURL -Value $ProxyScript
    Set-ItemProperty -Path $internetSettings -Name ProxyOverride -Value $ProxyOverrides
    Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 1

    # Also update the environment variables to the right setting.
    # This enables tools like GIT and NPM to use the proxy.
    $env:HTTP_PROXY = "$proxyServer"
    $env:HTTPS_PROXY = "$proxyServer"
}


function Enable-Proxy-Berlin(
    [String] $ProxyServer = "http://192.168.205.10:8080",
    [String] $ProxyScript = "http://192.168.205.10:8080/proxy.pac",
    [String] $ProxyOverrides = "") {

    Set-ItemProperty -Path $internetSettings -Name ProxyServer -Value $ProxyServer
    Set-ItemProperty -Path $internetSettings -Name AutoConfigURL -Value $ProxyScript
    Set-ItemProperty -Path $internetSettings -Name ProxyOverride -Value $ProxyOverrides
    Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 1

    # Also update the environment variables to the right setting.
    # This enables tools like GIT and NPM to use the proxy.
    $env:HTTP_PROXY = "$proxyServer"
    $env:HTTPS_PROXY = "$proxyServer"
}

# Disables the proxy everywhere
function Disable-Proxy() {
  $proxyState = Get-ProxyState

  if($proxyState -eq 1) {
    # Disable the proxy and remove the auto configure script.
    # Otherwise it is partially enabled.
    Set-ItemProperty -Path $internetSettings -Name ProxyEnable -Value 0
    Set-ItemProperty -Path $internetSettings -Name AutoConfigURL -Value ""
    Set-ItemProperty -Path $internetSettings -Name ProxyOverride -Value ""

    # Remove the proxy environment variables so that tools like GIT and NPM
    # won't complain about the proxy being unreachable.
    $env:HTTP_PROXY = $Null
    $env:HTTPS_PROXY = $Null
  }
}



################################################################################################################################"
# ACTIONS FROM THE SYSTRAY
################################################################################################################################"

# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------		
	
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "Switch Proxy"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true

$Menu_Jona_Proxy = New-Object System.Windows.Forms.MenuItem
$Menu_Jona_Proxy.Text = "Proxy Jona"

$Menu_Zuerich_Proxy = New-Object System.Windows.Forms.MenuItem
$Menu_Zuerich_Proxy.Text = "Proxy Zuerich"

$Menu_Bern_Proxy = New-Object System.Windows.Forms.MenuItem
$Menu_Bern_Proxy.Text = "Proxy Bern"

$Menu_Berlin_Proxy = New-Object System.Windows.Forms.MenuItem
$Menu_Berlin_Proxy.Text = "Proxy Berlin"

$Menu_Disable_Proxy = New-Object System.Windows.Forms.MenuItem
$Menu_Disable_Proxy.Text = "Disable Proxy"

$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Exit"

$contextmenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.ContextMenu = $contextmenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Jona_Proxy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Zuerich_Proxy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Bern_Proxy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Berlin_Proxy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Disable_Proxy)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)


# ---------------------------------------------------------------------
# Action after right-clicking on Proxy Jona
# ---------------------------------------------------------------------
$Menu_Jona_Proxy.Add_Click({	
    Write-Output "Proxy Jona executed" | Out-File -FilePath $ProxyLog -Append
    Enable-Proxy-Jona
})

# ---------------------------------------------------------------------
# Action after right-clicking on Proxy Zuerich
# ---------------------------------------------------------------------
$Menu_Zuerich_Proxy.Add_Click({	
    Write-Output "Proxy Zuerich executed" | Out-File -FilePath $ProxyLog -Append
    Enable-Proxy-Zuerich
})

# ---------------------------------------------------------------------
# Action after right-clicking on Proxy Bern
# ---------------------------------------------------------------------
$Menu_Bern_Proxy.Add_Click({	
    Write-Output "Proxy Bern executed" | Out-File -FilePath $ProxyLog -Append
    Enable-Proxy-Bern
})

# ---------------------------------------------------------------------
# Action after right-clicking on Proxy Berlin
# ---------------------------------------------------------------------
$Menu_Berlin_Proxy.Add_Click({	
    Write-Output "Proxy Berlin executed" | Out-File -FilePath $ProxyLog -Append
    Enable-Proxy-Berlin
})


# ---------------------------------------------------------------------
# Action after right-clicking on Disable Proxy
# ---------------------------------------------------------------------
$Menu_Disable_Proxy.Add_Click({	
    Write-Output "Disable Proxy executed" | Out-File -FilePath $ProxyLog -Append
    Disable-Proxy
})

# ---------------------------------------------------------------------
# Action after clicking on Computer Analysis
# ---------------------------------------------------------------------
$Menu_Computers.Add_Click({
	[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($Computers_Window)
	$Computers_Window.Show()
	$Computers_Window.Activate()	
})




# When Exit is clicked, close everything and kill the PowerShell process
$Menu_Exit.add_Click({
	$Main_Tool_Icon.Visible = $false
	$window.Close()
	Stop-Process $pid
 })

 

# Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()


# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)
