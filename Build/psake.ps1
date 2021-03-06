Task 'Default' -Depends 'Pester'

Task 'Init' {
    $ModuleRoot = (Split-Path $PSScriptRoot -Parent)

    Import-Module -Name Psake, (Join-Path $ModuleRoot KaceSma.psd1)
   
}


task 'Pester' -depends 'Init' {
    $Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $ModuleRoot = (Split-Path $PSScriptRoot -Parent)
    
    $TestFile = "PSv${PSVersion}_${TimeStamp}_KaceSMA.TestResults.xml"

    $PesterParams = @{
        Path         = (Join-Path (Split-Path $PSScriptRoot -Parent) 'tests')
        PassThru     = $true
        OutputFormat = 'NUnitXml'
        OutputFile   = (Join-Path $ModuleRoot $TestFile)
        Show         = "Header", "Failed", "Summary"
    }

    $TestResults = Invoke-Pester @PesterParams

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed $($TestResults.FailedCount) tests; build failed!"
    }
}