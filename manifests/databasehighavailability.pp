#Class adding WEM database to SQL Server AlwaysOn availability group
class wembroker::databasehighavailability inherits wembroker {
  if $::sqlalwayson {
    #Recovery mode configuration
    dsc_sqldatabaserecoverymodel{'WEMDatabaseRecoveryModel':
      dsc_name                 => $::databasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {'user' => $::setup_svc_username, 'password' => $::setup_svc_password}
    }

    #AlwaysOn cluster databases membership activation
    ->dsc_sqlagdatabase{'WEMDatabaseAlwaysOn':
      dsc_databasename          => $::databasename,
      dsc_availabilitygroupname => $::sqlavailabilitygroup,
      dsc_servername            => $::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $::sqldbbackuppath,
      dsc_psdscrunascredential  => {'user' => $::setup_svc_username, 'password' => $::setup_svc_password},
    }
  }
}
