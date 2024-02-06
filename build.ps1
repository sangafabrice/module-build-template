using namespace 'System.IO'

Filter Get-ModuleInstallationRoot {
    [CmdletBinding()]
    Param(
        [string] $ModuleName = 'ModuleName'
    )
    @((Get-Module -Name $ModuleName -ListAvailable)?.ModuleBase)[0]
}

Filter Get-ModuleInstallationVersion {
    [CmdletBinding()]
    Param(
        [string] $ModuleName = 'ModuleName'
    )
    @((Get-Module -Name $ModuleName -ListAvailable)?.Version)[0]
}

Filter New-ModuleInstallationManifest {
    [CmdletBinding()]
    Param(
        [string] $Path = $PSScriptRoot,
        [string] $ProjectUri = (git ls-remote --get-url) -replace '\.git$',
        [string] $ModuleName = 'ModuleName'
    )
    $VerboseFlag = $VerbosePreference -ine 'SilentlyContinue'
    Try {
        # Read the latest version and the release notes from the latest.json file
        $LatestJson = Get-Content "$Path\latest.json" -Raw -ErrorAction Stop -Verbose:$VerboseFlag | ConvertFrom-Json
        $RootModule = "$ModuleName.psm1"
        @{
            # Arguments built for New-ModuleManifest
            Path = "$Path\$ModuleName.psd1"
            RootModule = $RootModule
            ModuleVersion = $LatestJson.version
            GUID = '313d02d6-bb80-472b-b649-18d897072c65'
            Author = 'Fabrice Sanga'
            CompanyName = 'sangafabrice'
            Copyright = "© $((Get-Date).Year) SangaFabrice. All rights reserved."
            Description = "→ To support this project, please visit and like: $ProjectUri"
            PowerShellVersion = '7.0'
            PowerShellHostVersion = '7.0'
            FunctionsToExport = @((Get-Content "$Path\$RootModule").Where{ $_ -like 'Function*' -or $_ -like 'Filter*' }.ForEach{ ($_ -split ' ')[1] })
            CmdletsToExport = @()
            VariablesToExport = @()
            AliasesToExport = @()
            FileList = @("$ModuleName.psd1")
            Tags = @()
            LicenseUri = "$ProjectUri/blob/module/LICENSE.md"
            ProjectUri = $ProjectUri
            IconUri = 'https://gistcdn.githack.com/sangafabrice/a8c75d6031a491c0907d5ca5eb5587e0/raw/406120be7a900c3998e33d7302772827f20539f0/automation.svg'
            ReleaseNotes = $LatestJson.releaseNotes -join "`n"
        }.ForEach{
            New-ModuleManifest @_ -ErrorAction Stop -Verbose:$VerboseFlag
            [Path]::GetFullPath($_.Path)
        }
    }
    Catch { }
}

@{
    Name = 'ModuleBuilder'
    Scriptblock = ([scriptblock]::Create((Invoke-RestMethod 'https://api.github.com/gists/387cc6063e148917a2fe5503e57b823c').files.'ModuleBuilder.psm1'.content)).GetNewClosure()
} | ForEach-Object { New-Module @_ } | Import-Module -Force