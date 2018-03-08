#Class adding WEM database to SQL Server AlwaysOn availability group
class wembroker::databasehighavailability inherits wembroker {
  if $wembroker::sqlalwayson {
    #Recovery mode configuration
    dsc_sqldatabaserecoverymodel{'WEMDatabaseRecoveryModel':
      dsc_name                 => $wembroker::databasename,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $wembroker::databaseserver,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {'user' => $wembroker::setup_svc_username, 'password' => $wembroker::setup_svc_password}
    }

    #AlwaysOn cluster databases membership activation
    ->dsc_sqlagdatabase{'WEMDatabaseAlwaysOn':
      dsc_databasename          => $wembroker::databasename,
      dsc_availabilitygroupname => $wembroker::sqlavailabilitygroup,
      dsc_servername            => $wembroker::databaseserver,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $wembroker::sqldbbackuppath,
      dsc_psdscrunascredential  => {'user' => $wembroker::setup_svc_username, 'password' => $wembroker::setup_svc_password},
    }
  }
}
