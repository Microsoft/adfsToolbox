<#
.SYNOPSIS
Performs applicable health checks on the AD FS server (Proxy or STS)

.DESCRIPTION
The health checks generated by the Test-AdfsServerHealth cmdlet return a container of results with the following properties:
    - Name : Mnemonic identifier for the test
    - ComputerName: The name of the computer the test was run on
    - Result : One value of 'Pass','Fail','NotRun','Error','Warning'
    - Detail : Explanation of the 'Fail' and 'NotRun' result. It is typically empty when the check passes.
    - Output : Data collected for the specific test. It is a list of Key value pairs
    - ExceptionMessage: If the test encountered an exception, this property contains the exception message.
    - Exception: If the test encountered an exception, this property contains the exception.

.PARAMETER VerifyO365
Boolean parameter that will enable Office 365 targeted checks. It is true by default.

.PARAMETER VerifyTrustCerts
Boolean parameter that will enable additional checks for relying party trust and claims provider trust certificates. It is false by default.

.PARAMETER SslThumbprint
String parameter that corresponds to the thumbprint of the AD FS SSL certificate. This is required for running test cases on proxy servers.

.PARAMETER AdfsServers
Array of fully qualified domain names (FQDN) of all of the AD FS STS servers that you want to run health checks on. For Windows Server 2016 this is automatically populated using Get-AdfsFarmInformation.
By default the tests are already run on the local machine, so it is not necessary include the FQDN of the current machine in this parameter.

.PARAMETER Local
Switch that indicates that you only want to run the health checks on the local machine. This takes precedence over -AdfsServers parameter.

.EXAMPLE
Test-AdfsServerHealth | Where-Object {$_.Result -ne "Pass"}
Execute test suite and get only the tests that did not pass

.EXAMPLE
Test-AdfsServerHealth -verifyOffice365:$false
Execute test suite in an AD FS farm where Office 365 is not configured

.EXAMPLE
Test-AdfsServerHealth -verifyTrustCerts:$true
Execute test suite in an AD FS farm and examine the relying party trust and claims provider trust certificates

.EXAMPLE
Test-AdfsServerHealth -adfsServers  @("sts1.contoso.com", "sts2.contoso.com", "sts3.contoso.com")
Execute test suite in an AD FS farm and run the test on the following servers: ADFS1.contoso.com, ADFS2.contoso.com, ADFS3.contoso.com. This automatically runs the test on the local machine as well.

.EXAMPLE
Test-AdfsServerHealth -sslThumbprint ‎c1994504c91dfef663b5ce8dd22d1a44748a6e16
Execute test suite on a WAP server and utilize the provided thumbprint to check SSL bindings.

.NOTES
Most of the checks require executing AD FS cmdlets. As a result:
1. The most comprehensive analysis occurs when running from the Primary Computer in a Windows Internal Database farm.
2. For secondary computers in a Windows Internal Database farm, the majority of checks will be marked as "NotRun"
3. For a SQL Server farm, all applicable tests will run succesfully.
4. If the AD FS service is stopped, the majority of checks will be returned as 'NotRun'
#>
Function Test-AdfsServerHealth()
{
    [CmdletBinding(DefaultParameterSetName='AdfsServerLocal')]
    Param
    (
        [Parameter(ParameterSetName='AdfsServerLocal')]
        [Parameter(ParameterSetName='AdfsServerRemote')]
        $verifyO365 = $true,
        [Parameter(ParameterSetName='AdfsServerLocal')]
        [Parameter(ParameterSetName='AdfsServerRemote')]
        $verifyTrustCerts = $false,
        [Parameter(ParameterSetName='ProxyServer')]
        [string]
        $sslThumbprint = $null,
        [Parameter(ParameterSetName='AdfsServerRemote')]
        [string[]]
        $adfsServers = $null,
        [Parameter(ParameterSetName='AdfsServerLocal')]
        [switch]
        $local = $false
    )

    switch (Get-ADFSRole)
    {
        $adfsRoleSTS
        {
            Write-Host "Performing applicable health checks on your AD FS server."
            return TryTestAdfsSTSHealthOnFarmNodes -verifyO365 $verifyO365 -verifyTrustCerts $verifyTrustCerts -adfsServers $adfsServers -local:$local;
        }
        $adfsRoleProxy
        {
            Write-Host "Performing applicable health checks on your WAP server."
            return TestAdfsProxyHealth -sslThumbprint $sslThumbprint;
        }
        default
        {
            throw "Error: Unable to determine server role. This script should only be run on AD FS servers (Proxy or STS)";
        }
    }
}