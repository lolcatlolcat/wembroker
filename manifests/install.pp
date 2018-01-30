class wembroker::install inherits wembroker {
  dsc_file{ 'WEMSetupDirectory':
    dsc_destinationpath => 'C:\WEMSetup',
    dsc_type => 'Directory',
    dsc_ensure => 'Present'
  }

  #Download WEM Broker Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe":
    source => $infrastructureServicesSourcePath,
    source_permissions => ignore,
    require => Dsc_file['WEMSetupDirectory']
  }->

  dsc_package{'WEMBrokerInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Infrastructure Services',
    dsc_productid => $infrastructureServicesProductId,
    #dsc_arguments => '/v"WaitForNetwork=\"1\" GpNetworkStartTimeoutPolicyValue=\"45\""',
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe',
  }->

  #Download WEM Console Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe":
    source => $managementConsoleSourcePath,
    source_permissions => ignore,
    require => Dsc_file['WEMSetupDirectory']
  }->

  dsc_package{'WEMConsoleInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Console',
    dsc_productid => $managementConsoleProductId,
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe',
  }
}
