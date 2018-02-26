class wembroker::databasehighavailability inherits wembroker {

	if $sqlalwayson {
		#Recovery mode configuration
		dsc_sqldatabaserecoverymodel{'WEMDatabaseRecoveryModel':
			dsc_name => $databaseName,
			dsc_recoverymodel => 'Full',
			dsc_servername => $databaseServer,
			dsc_instancename => 'MSSQLSERVER',
			dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password}
		}->

		#AlwaysOn cluster databases membership activation
		dsc_sqlagdatabase{'WEMDatabaseAlwaysOn':
			dsc_databasename => $databaseName,
			dsc_availabilitygroupname => $sqlavailabilitygroup,
			dsc_servername => $databaseServer,
			dsc_instancename => 'MSSQLSERVER',
			dsc_backuppath => $sqldbbackuppath,
			dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
		}
	}
}
