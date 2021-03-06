Describe 'Set-SmaServiceDeskTicket Unit Tests' -Tags 'Unit' {
    InModuleScope KaceSMA {
        Context 'Backend Calls' {
            Mock New-ApiGetRequest { } -ModuleName KaceSMA
            Mock New-ApiPostRequest { } -ModuleName KaceSMA
            Mock New-ApiPutRequest { } -ModuleName KaceSMA
            Mock New-ApiDeleteRequest { } -ModuleName KaceSMA

            It 'should call only New-ApiPUTRequest' {

                Set-SmaServiceDeskTicket -Id 1234 -Body @{'foo' = 'foo' }

                Assert-MockCalled -CommandName New-ApiPUTRequest -ModuleName KaceSMA -Times 1

                $Methods = @('GET', 'DELETE', 'POST')
                Foreach ($Method in $Methods) {
                    Assert-MockCalled -CommandName ("New-Api$Method" + "Request") -ModuleName KaceSMA -Times 0
                }
            }
        }
        Context 'Parameter input' {
            
            Mock New-ApiPUTRequest { } -ModuleName KaceSMA

            It "Should take parameter from pipeline" {
                
                { 1234 | Set-SmaServiceDeskTicket -Body @{'foo' = 'foo' } } | Should -Not -Throw
            }

            It "Should take parameter from position" {
                { Set-SmaServiceDeskTicket -Id 1234 -Body @{'foo' = 'foo' } } | Should -Not -Throw
            }
        }
    }
} 