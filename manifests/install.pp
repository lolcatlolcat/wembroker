class wembroker::install inherits wembroker {
  dsc_file{ 'WEMSetupDirectory':
    dsc_destinationpath => 'C:\WEMSetup',
    dsc_type => 'Directory',
    dsc_ensure => 'Present'
  }

  #Download WEM Broker Installer
  file{ "C:\\WEMSetup\\Citrix Workspace Environment Management Infrastructure Services v4.04.00.00 Setup.exe":
    source => 'puppet:///modules/wemmasterbroker/Citrix Workspace Environment Management Infrastructure Services v4.04.00.00 Setup.exe',
    source_permissions => ignore,
    require => Dsc_file['WEMSetupDirectory']
  }->

  dsc_package{'WEMInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Infrastructure Services',
    dsc_productid => '40BF3158-89BA-44A4-96B0-6D806FFD5AA3',
    #dsc_arguments => '/v"WaitForNetwork=\"1\" GpNetworkStartTimeoutPolicyValue=\"45\""',
    dsc_path      => 'C:\\WEMSetup\\Citrix Workspace Environment Management Infrastructure Services v4.04.00.00 Setup.exe',
  }->

  #Download WEM Console Installer
  file{ "C:\\WEMSetup\\Citrix Workspace Environment Management Console v4.04.00.00 Setup.exe":
    source => 'puppet:///modules/wemmasterbroker/Citrix Workspace Environment Management Console v4.04.00.00 Setup.exe',
    source_permissions => ignore,
    require => Dsc_file['WEMSetupDirectory']
  }->

  dsc_package{'WEMInstall':
    dsc_ensure    => 'Present',
    dsc_name      => 'Citrix Workspace Environment Management Console',
    dsc_productid => '0FC446DF-9BE8-4808-A838-208C2D80A2EC',
    #dsc_arguments => '/v"WaitForNetwork=\"1\" GpNetworkStartTimeoutPolicyValue=\"45\""',
    dsc_path      => 'C:\\WEMSetup\\Citrix Workspace Environment Management Console v4.04.00.00 Setup.exe',
  }
}
