#Class installing Citrix WEM Infrastructure Services & Management Console + external requirements
class wembroker::install inherits wembroker {
  dsc_file{ 'WEMSetupDirectory':
    dsc_destinationpath => 'C:\WEMSetup',
    dsc_type            => 'Directory',
    dsc_ensure          => 'Present'
  }

  #Download WEM Broker Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe":
    source             => $wembroker::services_installer_path,
    source_permissions => ignore,
    require            => Dsc_file['WEMSetupDirectory']
  }
  -> dsc_package{ 'WEMBrokerInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Infrastructure Services',
    dsc_productid => $wembroker::services_productid,
    dsc_arguments => '/S /v /qn',
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementInfrastructureServices.exe',
  }

  #Download WEM Console Installer
  file{ "C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe":
    source             => $wembroker::mgmtconsole_installer_path,
    source_permissions => ignore,
    require            => Dsc_file['WEMSetupDirectory']
  }
  ->dsc_package{'WEMConsoleInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Console',
    dsc_productid => $wembroker::mgmtconsole_productid,
    dsc_path      => 'C:\\WEMSetup\\CitrixWorkspaceEnvironmentManagementConsole.exe',
  }

  #Download and install SQLSERVER powershell module. Required for database high availability setup (always on citrix databases membership)
  if ($wembroker::sqlserver_module_source == 'internet') {
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
    ## Requires: https://forge.puppet.com/modules/puppet/archive
    archive { 'C:\Program Files\WindowsPowerShell\Modules\sqlserver_powershell_module.zip':
      source       => $wembroker::sqlserver_module_sourcepath,
      extract      => true,
      extract_path => 'C:\Program Files\WindowsPowerShell\Modules',
      creates      => 'C:\Program Files\WindowsPowerShell\Modules\SqlServer',
      cleanup      => true
    }
  }
}
