#Class installing Citrix WEM Infrastructure Services & Management Console + external requirements
class wembroker::install inherits wembroker {
  dsc_file{ 'WEMSetupDirectory':
    dsc_destinationpath => 'C:\WEMSetup',
    dsc_type            => 'Directory',
    dsc_ensure          => 'Present'
  }

  #Download WEM Broker Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe":
    source             => $::infrastructureservicessourcepath,
    source_permissions => ignore,
    require            => Dsc_file['WEMSetupDirectory']
  }

  ->dsc_package{'WEMBrokerInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Infrastructure Services',
    dsc_productid => $::infrastructureservicesproductid,
    dsc_arguments => '/S /v/qn',
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe',
  }

  #Download WEM Console Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe":
    source             => $::managementconsolesourcepath,
    source_permissions => ignore,
    require            => Dsc_file['WEMSetupDirectory']
  }

  ->dsc_package{'WEMConsoleInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Console',
    dsc_productid => $::managementconsoleproductid,
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe',
  }

  #Download and install SQLSERVER powershell module. Required for database high availability setup (always on citrix databases membership)
  if ($::sqlservermodulesource == 'internet') {
    exec { 'InstallNuGetProviderPSGallery':
      command  => 'Install-PackageProvider -Name NuGet -Confirm:$false -Force',
      onlyif   => 'if (Get-PackageProvider -ListAvailable -Name Nuget) { exit 1 }',
      provider => 'powershell'
    }

    ->exec { 'InstallSQLServerModulePSGallery':
      command  => 'Install-Module -Name SqlServer -RequiredVersion 21.0.17099 -Confirm:$false -Force',
      onlyif   => 'if (Get-Module -ListAvailable -Name SqlServer) { exit 1 }',
      provider => 'powershell'
    }
  }
  else {
    file{ 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_module.zip':
      source             => $::sqlservermodulesourcepath,
      source_permissions => ignore,
    }

    #Unzip function provided by the reidmv-unzip
    ->unzip{'UnzipSqlserverModule':
      source      => 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_module.zip',
      destination => 'C:\Program Files\WindowsPowerShell\Modules',
      creates     => 'C:\Program Files\WindowsPowerShell\Modules\SqlServer'
    }
  }
}
