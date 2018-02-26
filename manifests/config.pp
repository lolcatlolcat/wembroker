class wembroker::config inherits wembroker {
  #Create WEM Database
  dsc_wemdatabase{'WEMDatabase':
    dsc_databasename => $databaseName,
    dsc_databaseserver => $databaseServer,
    dsc_databasefilesfolder => $databaseFilesFolder,
    dsc_vuemusersqlpassword => $vuemUserSqlPassword,
    dsc_weminfrastructureserviceaccount => "${domainnetbiosname}\\$wem_svc_username",
    dsc_defaultadministratorsgroup => $defaultAdministratorsGroup,
    dsc_ensure => 'Present',
    dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password}
  }->

  #Configure WEM Broker
  dsc_wembrokerconfig{'WEMBrokerConfig':
    dsc_databasename => $databaseName,
    dsc_databaseserver => $databaseServer,
    dsc_setsqluserspecificpassword => 'Enable',
    dsc_sqluserspecificpassword => $vuemUserSqlPassword,
    dsc_enableinfrastructureserviceaccountcredential => 'Enable',
    dsc_infrastructureserviceaccountcredential => {'user' => "${domainnetbiosname}\\$wem_svc_username", 'password' => $wem_svc_password},
    dsc_usecacheevenifonline => 'Disable',
    dsc_debugmode => 'Disable',
    dsc_sendgoogleanalytics => 'Disable',
    dsc_enablescheduledmaintenance => 'Enable',
    dsc_statisticsretentionperiod => 30,
    dsc_systemmonitoringretentionperiod => 30,
    dsc_agentregistrationsretentionperiod => 1,
    dsc_databasemaintenanceexecutiontime => '02:00',
    dsc_globallicenseserveroverride => 'Enable',
    dsc_licenseservername => $citrixLicenseServer,
    dsc_licenseserverport => 27000
  }
}
