param([switch]$NoVersionWarn = $false)

if (Get-Module Posh-BpvTools) { return }

$psv = $PSVersionTable.PSVersion

if ($psv.Major -lt 2 -and !$NoVersionWarn) {
    Write-Warning ("Posh-BpvTools requires PowerShell 2.0 and higher; you have version $($psv).`n" +
    "To download version 3.0, please visit https://www.microsoft.com/en-us/download/details.aspx?id=34595`n" +
    "To suppress this warning, change your profile to include 'Import-Module Posh-BpvTools -Args `$true'.")
}

Push-Location $psScriptRoot

# Essential Functions
function Set-HostTitleInfo {
	Param (
		[Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][string]$Path
	)
	$newTitle = ""
	if ($Host.UI.RawUI.WindowTitle.StartsWith("Administrator:")) {
		$newTitle = "Administrator: "
	}
	$newTitle += "PS> $Path"
	$Host.UI.RawUI.WindowTitle = $newTitle
}

function Format-HexDump {
	Param (
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)][string]$Path,
		[Parameter(Mandatory=$false)][int]$Count = 4096
	)
	Get-Content -Encoding Byte -TotalCount $Count -Path $Path |% { Write-Host ("{0,2:x}" -f $_) -noNewline " "}; Write-Host
}

# Essential Aliases
New-Alias -Name hexdump -Value Format-HexDump

Pop-Location

Export-ModuleMember `
    -Alias @(
		'hexdump') `
    -Function @(
		 'Set-HostTitleInfo',
		'Format-HexDump')
