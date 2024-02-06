BeforeDiscovery {
    Import-Module ModuleName -Force
}

Describe 'Test the module' {
    InModuleScope ModuleName {
        Context 'Test context' {
            It 'Test unit' -TestCases @($null) {
                $_ | Should -BeNullOrEmpty
            }
        }
    }
}

AfterAll {
    Remove-Module -Name ModuleName -Force
}