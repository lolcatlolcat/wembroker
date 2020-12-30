#Class adding WEM database to SQL Server AlwaysOn availability group
class wembroker::databasehighavailability inherits wembroker {
  if $wembroker::sql_alwayson {
    #Recovery mode configuration
    dsc_sqldatabaserecoverymodel{ 'WEMDatabaseRecoveryModel':
      dsc_name                 => $wembroker::db_name,
      dsc_recoverymodel        => 'Full',
      dsc_servername           => $wembroker::db_server,
      dsc_instancename         => 'MSSQLSERVER',
      dsc_psdscrunascredential => {
        'user'     => $wembroker::setup_svc_username,
        'password' => $wembroker::setup_svc_password
      }
    }
    #AlwaysOn cluster databases membership activation
    -> dsc_sqlagdatabase{ 'WEMDatabaseAlwaysOn':
      dsc_db_name               => $wembroker::db_name,
      dsc_availabilitygroupname => $wembroker::sql_availabilitygroup,
      dsc_servername            => $wembroker::db_server,
      dsc_instancename          => 'MSSQLSERVER',
      dsc_backuppath            => $wembroker::sql_dbbackup_path
      dsc_psdscrunascredential  => {
        'user'     => $wembroker::setup_svc_username,
        'password' => $wembroker::setup_svc_password
      },
    }
  }
}
