#
# Module manifest for module 'ADFSToolbox'
#
# Generated by: madpatel
#
# Generated on: 7/30/2018
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'ADFSToolbox.psm1'

    # Version number of this module.
    ModuleVersion     = '1.0.2'

    # ID used to uniquely identify this module
    GUID              = 'cc5b522e-0f34-4122-bdd6-62a91793137e'

    # Author of this module
    Author            = 'Microsoft'

    # Company or vendor of this module
    CompanyName       = 'Microsoft'

    # Copyright statement for this module
    Copyright         = '(c) 2018 Microsoft. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Contains data gathering, health checks, and additional tools for AD FS server deployments.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules     = @(
        'diagnosticsModule\AdfsDiagnosticsModule.psm1',
        'eventsModule\AdfsEventsModule.psm1',
        # 'serviceAccountModule\AdfsServiceAccountModule.psm1', Temporarily removed due to PS 5.0 requirement
        'widSyncModule\AdfsWidSyncModule.psm1'
    )

    # Functions to export from this module
    FunctionsToExport = '*'

    # Cmdlets to export from this module
    CmdletsToExport   = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport   = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = @('ADFS', 'WAP', 'ADFSDiagnostics', 'Troubleshooting')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Microsoft/adfsToolbox/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Microsoft/adfsToolbox/'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    HelpInfoURI       = 'https://github.com/Microsoft/adfsToolbox/'

}

