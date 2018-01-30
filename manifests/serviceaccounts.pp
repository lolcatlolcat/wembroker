class wembroker::serviceaccounts inherits wembroker {
  #Needed for ActiveDirectory remote management using Powershell
	dsc_windowsfeature{ 'RSAT-AD-Powershell':
	 dsc_ensure => 'Present',
	 dsc_name => 'RSAT-AD-Powershell'
	}

	#WEM service account creation (Active Directory)
	dsc_xaduser{'WemSvcAccount':
		dsc_domainname => $domain,
		dsc_domainadministratorcredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
		dsc_username => $wem_svc_username,
		dsc_password => {'user' => $wem_svc_username, 'password' => $wem_svc_password},
		dsc_ensure => 'Present',
		require => Dsc_windowsfeature['RSAT-AD-Powershell']
	}

	#Configure SPN on WEM service account
	#In A load-balanced deployment, the SPN is linked to the FQDN of the WEM virtual server configured on the load-balancer
	if $loadbalandedWem {
		dsc_xadserviceprincipalname{'WemLoadBalancedSPN':
	    dsc_account => $wem_svc_username,
	    dsc_serviceprincipalname => "http/${loadbalancedWemFqdn}",
		  dsc_ensure => present,
		  dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
      require => Dsc_xaduser['WemSvcAccount']
		}
	}
	#In a standalone deployment, the SPN is linked to the computer FQDN
	else {
	  dsc_xadserviceprincipalname{'WemStandaloneSPN':
      dsc_account => $wem_svc_username,
      dsc_serviceprincipalname => "http/${fqdn}",
      dsc_ensure => present,
      dsc_psdscrunascredential => {'user' => $setup_svc_username, 'password' => $setup_svc_password},
      require => Dsc_xaduser['WemSvcAccount']
    }
	}

	#The WEM service account must be in the local Administrators group on the WEM server (local machine)
	dsc_xgroup{'WemSvcAdministratorsGroup':
		dsc_groupname => 'Administrators',
		dsc_ensure => 'Present',
		dsc_memberstoinclude => "${domainnetbiosname}\\$wem_svc_username",
		require => Dsc_xaduser['WemSvcAccount']
	}

}
