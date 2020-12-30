#Class configuring WEM database & infrastructure service
class wembroker::config inherits wembroker {
  #Create WEM Database
  dsc_wemdatabase{ 'WEMDatabase':
    dsc_databasename                    => $wembroker::db_name,
    dsc_databaseserver                  => $wembroker::db_server,
    dsc_databasefilesfolder             => $wembroker::db_files_folder,
    dsc_vuemusersqlpassword             => $wembroker::vuemuser_sql_password,
    dsc_weminfrastructureserviceaccount => "${wembroker::netbios_name}\\${wembroker::wem_svc_username}",
    dsc_defaultadministratorsgroup      => $wembroker::admin_group,
    dsc_ensure                          => 'Present',
    dsc_psdscrunascredential            => {
      'user'     => $wembroker::domain_admin_username,
      'password' => $wembroker::domain_admin_password
    }
  }
  #Configure WEM Broker
  -> dsc_wembrokerconfig{ 'WEMBrokerConfig':
    dsc_databasename                                 => $wembroker::db_name,
    dsc_databaseserver                               => $wembroker::db_server,
    dsc_setsqluserspecificpassword                   => 'Enable',
    dsc_sqluserspecificpassword                      => $wembroker::vuemuser_sql_password,
    dsc_enableinfrastructureserviceaccountcredential => 'Enable',
    dsc_infrastructureserviceaccountcredential       => {
      'user'     => "${::netbios_name}\\${wembroker::wem_svc_username}",
      'password' => $wembroker::wem_svc_password
    },
    dsc_usecacheevenifonline                         => 'Disable',
    dsc_debugmode                                    => 'Disable',
    dsc_sendgoogleanalytics                          => 'Disable',
    dsc_enablescheduledmaintenance                   => 'Enable',
    dsc_statisticsretentionperiod                    => 30,
    dsc_systemmonitoringretentionperiod              => 30,
    dsc_agentregistrationsretentionperiod            => 1,
    dsc_databasemaintenanceexecutiontime             => '02:00',
    dsc_globallicenseserveroverride                  => 'Enable',
    dsc_licenseservername                            => $wembroker::citrix_licenseserver,
    dsc_licenseserverport                            => 27000
  }
}
