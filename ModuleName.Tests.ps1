BeforeDiscovery {
    Import-Module ___MODULENAME___ -Force
}

Describe 'Test the module' {
    InModuleScope ___MODULENAME___ {
        Context 'Test context' {
            It 'Test unit' -TestCases @($null) {
                $_ | Should -BeNullOrEmpty
            }
        }
    }
}

AfterAll {
    Remove-Module -Name ___MODULENAME___ -Force
}