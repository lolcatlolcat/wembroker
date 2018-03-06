#Class configuring WEM database & infrastructure service
class wembroker::config inherits wembroker {
  #Create WEM Database
  dsc_wemdatabase{'WEMDatabase':
    dsc_databasename                    => $::databasename,
    dsc_databaseserver                  => $::databaseserver,
    dsc_databasefilesfolder             => $::databasefilesfolder,
    dsc_vuemusersqlpassword             => $::vuemusersqlpassword,
    dsc_weminfrastructureserviceaccount => "${facts['domainnetbiosname']}\\${::wem_svc_username}",
    dsc_defaultadministratorsgroup      => $::defaultadministratorsgroup,
    dsc_ensure                          => 'Present',
    dsc_psdscrunascredential            => {'user' => $::setup_svc_username, 'password' => $::setup_svc_password}
  }

  #Configure WEM Broker
  ->dsc_wembrokerconfig{'WEMBrokerConfig':
    dsc_databasename                                 => $::databasename,
    dsc_databaseserver                               => $::databaseserver,
    dsc_setsqluserspecificpassword                   => 'Enable',
    dsc_sqluserspecificpassword                      => $::vuemusersqlpassword,
    dsc_enableinfrastructureserviceaccountcredential => 'Enable',
    dsc_infrastructureserviceaccountcredential       => {
      'user'     => "${facts['domainnetbiosname']}\\${::wem_svc_username}",
      'password' => $::wem_svc_password
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
    dsc_licenseservername                            => $::citrixlicenseserver,
    dsc_licenseserverport                            => 27000
  }
}
