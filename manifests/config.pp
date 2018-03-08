#Class configuring WEM database & infrastructure service
class wembroker::config inherits wembroker {
  #Create WEM Database
  dsc_wemdatabase{'WEMDatabase':
    dsc_databasename                    => $wembroker::databasename,
    dsc_databaseserver                  => $wembroker::databaseserver,
    dsc_databasefilesfolder             => $wembroker::databasefilesfolder,
    dsc_vuemusersqlpassword             => $wembroker::vuemusersqlpassword,
    dsc_weminfrastructureserviceaccount => "${facts['domainnetbiosname']}\\${wembroker::wem_svc_username}",
    dsc_defaultadministratorsgroup      => $wembroker::defaultadministratorsgroup,
    dsc_ensure                          => 'Present',
    dsc_psdscrunascredential            => {'user' => $wembroker::setup_svc_username, 'password' => $wembroker::setup_svc_password}
  }

  #Configure WEM Broker
  ->dsc_wembrokerconfig{'WEMBrokerConfig':
    dsc_databasename                                 => $wembroker::databasename,
    dsc_databaseserver                               => $wembroker::databaseserver,
    dsc_setsqluserspecificpassword                   => 'Enable',
    dsc_sqluserspecificpassword                      => $wembroker::vuemusersqlpassword,
    dsc_enableinfrastructureserviceaccountcredential => 'Enable',
    dsc_infrastructureserviceaccountcredential       => {
      'user'     => "${facts['domainnetbiosname']}\\${wembroker::wem_svc_username}",
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
    dsc_licenseservername                            => $wembroker::citrixlicenseserver,
    dsc_licenseserverport                            => 27000
  }
}
