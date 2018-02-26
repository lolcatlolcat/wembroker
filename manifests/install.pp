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
    dsc_arguments => '/S /v/qn',
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe',
  }

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
  
  #Download and install SQLSERVER powershell module. Required for database high availability setup (always on citrix databases membership)
	file{ "C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip":
	 source => 'puppet:///modules/xd7mastercontroller/sqlserver_powershell_21.0.17199.zip',
	 source_permissions => ignore,
	}

	#Unzip function provided by the reidmv-unzip
	unzip{'UnzipSqlserverModule':
	 source  => 'C:\\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_21.0.17199.zip',
	 destination => 'C:\\Program Files\WindowsPowerShell\Modules',
	 creates => 'C:\\Program Files\WindowsPowerShell\Modules\SqlServer',
	 require => File["C:\\Program Files\\WindowsPowerShell\\Modules\\sqlserver_powershell_21.0.17199.zip"]
	}
}
