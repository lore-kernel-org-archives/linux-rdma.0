From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.6.0 release
Date: Thu, 31 May 2012 18:15:59 -0700
Message-ID: <20120531181559.2dd20fa3.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new release of infiniband-diags.

The tarball is available at:
http://downloads.openfabrics.org/management/infiniband-diags-1.6.0.tar.gz

60c0e5365f1394ccc88d4f22ae2de09a  infiniband-diags-1.6.0.tar.gz

Dependencies:

        1) libibmad >= 1.3.9
        2) libibumad >= 1.3.7
        3) opensm-libs >= 3.3.10
        4) ib_umad kernel module


Release notes v1.5.13 => v1.6.0

   1) Fixed "sa_key" (SA smkey) in saquery.  Along with this the default smkey
      has been changed to 0.  This means the default queries are "untrusted".
      A different default (for example to match OpenSM) can be configured in
      the ibdiags.conf to have "trusted" queries by default.

   2) Some older tools have been deprecated and are no longer in the default
      build.

        ibcheckerrs ibchecknet ibchecknode ibcheckport ibcheckportwidth
        ibcheckportstate ibcheckwidth ibcheckstate ibcheckerrors ibdatacounts
        ibdatacounters ibdiscover.pl ibswportwatch.pl ibqueryerrors.pl
        iblinkinfo.pl ibprintca.pl ibprintswitch.pl ibprintrt.pl
        set_nodedesc.sh ibclearerrors ibclearcounters

      Building these tools can be enabled through configure with the
      --enable-compat-utils option.

      infinband-diags-1.6.x.tar.gz includes this option and will generate the
      *-compat rpm by default.

   3) mkey support

   4) Additional tools ibccquery ibccconfig

   5) "-u" option is no longer supported (use "-h" instead)

   6) New updated man pages

   7) support for new hardware in vendstat

   8) bug fixes and code clean up



Git log
-------

Albert Chu (7):
      Support ibccquery, congestion control query tool.
      support --switches-only and --cas-only options in iblinkinfo
      Fix typo in ibccquery manpage
      infiniband-diags/src/ibccquery.c: Fix off by one output bug, ccti_limit is 0 based not 1 based
      infiniband-diags: Support ibccconfig, congestion control setting tool
      infiniband-diags/src/ibccquery.c: Fix CACongestionSetting inputs
      infiniband-diags ibcconfig: Update documentation examples

Albert L.Chu (2):
      Update check_lft_balance.pl to work with newer infiniband-diag tools
      Add -e heuristic flag to check_lft_balance.pl to detect common scenarios where unbalanced routing will occur.

Alex Netes (1):
      infiniband-diags/scripts/ibcheckport.in: ignore lid/sm lid checks on non zero port switches

Hal Rosenstock (6):
      infiniband-diags/perfquery.c: Fix display of PortExtendedSpeedsCounters
      infiniband-diags/perfquery.c: Fix reset for PortExtendedSpeedsCounters
      infiniband-diags/configure.in: Fix typo
      infiniband-diags/vendstat.c: Support IS4/SX firmware version info
      infiniband-diags/ibportstate.c: Add newly added options to usage
      infiniband-diags/ibportstate.c: Remove an extra space from warning message

Hefty, Sean (1):
      RE: [PATCH v2] ib-diags: Add cast to fix build on windows

Ira Weiny (50):
      infiniband-diags: ibnetdisc Wrap header for use in C++ code
      infiniband-diags: ibqueryerrors add query failure count
      Update version in prep for next release
      Master branch is not moving on to 1.6
      infiniband-diags: fix installation of error_thresholds file
      infiniband-diags: iblinkinfo: fix error message
      infiniband-diags: saquery: use ib-node-name-map file
      infiniband-diags: iblinkinfo flag ports which were not scanned
      infiniband-diags: clean up build
      infiniband-diags: add ibccquery man page to build
      infiniband-diags: add a general config file
      infiniband-diags: ibqueryerrors: don't exit on reset error
      check_lft_balance.pl: Add extra check when using -e heuristic flag in check_lft_balance.pl
      infiniband-diags: check_lft_balance.pl add -C/-P options
      infiniband-diags: fix printing of extended speeds when port is down
      infiniband-diags: move is_mlnx_ext_port_info_supported to common code
      infiniband-diags: add config file option for Mellanox ExtPortInfo queries
      infiniband-diags/ibccquery Fix field name
      ibswitches: fix output when switch names have "base" or "enhanced" in them
      Fix ibping server when client stops sending.
      infiniband-diags: Fix saquery error reporting
      infiniband-diags: remove ib_resolve_smlid_via requirement for sa queries
      infiniband-diags: remove unused options from check_lft_balance.pl
      infiniband-diags: saquery further error value clean up.
      infiniband-diags: preserve long_opts global for use in ibdiag_show_usage
      infiniband-diags: mark duplicate/lower performing scripts as deprecated.
      infiniband-diags: move deprecated scripts to "compat" rpm
      infiniband-diags: remove mad.h from ibstat
      infiniband-diags: remove SMI class registration where possible
      infiniband-diags: remove -u common option
      infiniband-diags: smpdump fix option 'string'
      infiniband-diags: update ib[hosts|switches|routers] to standard options
      infiniband-diags: move deprecated scripts to "compat" rpm
      infiniband-diags: move ibidsverify man page to main rpm
      infiniband-diags: fix ibidsverify portguid validation.
      infiniband-diags: ibidsverify exit status 1 on errors found
      infiniband-diags: check_lft_balance.pl remove unused options
      infiniband-diags: convert documentation from nroff to rst
      infiniband-diags: move man/dump_[ml]fts to rst documentation
      infiniband-diags: move man/ibcc[config|query] to rst documentation
      infiniband-diags: move man/ibping,ibnodes,ibhosts,ibswitches,ibrouters to rst documentation
      infiniband-diags: move man/ibportstate,ibstat,ibroute,ibtracert to rst documentation
      infiniband-diags: move man/perfquery,sminfo,smpdump,smpquery to rst documentation
      infiniband-diags: move man/saquery,vendstat,ibsysstat,ibfindnodesusing to rst documentation
      infiniband-diags: move man/check_lft_balance,ibcacheedit,ibstatus,ibidsverify to rst documentation
      infiniband-diags: fix autogen with new rst documentation
      infiniband-diags: saquery clarify default smkey option value
      infiniband-diags: Add SMP/QP0 usage explanation to general man page
      infiniband-diags: udpate smp documentation in infiniband-diags page
      infiniband-diags: update README for 1.6.0 release

Jim Foraker (14):
      infiniband-diags/ibroute.c: Dead code removal
      infiniband-diags/mcm_rereg_test.c: dead code removal
      infiniband-diags/mcm_rereg_test.c: Include ib_types.h
      infiniband-diags: Remove dependencies on ib_resolve_smlid/ib_resolve_self
      infiniband-diags: migrate resolve_portid_str in from libibmad
      infiniband-diags: clean up exclude arguments to ibdiag_process_opts()
      infiniband-diags: Obfuscate sensitive output by default
      infiniband-diags: install config file mode 400
      infiniband-diags/ibportstate.c: Display MKey, lease, and protect bits
      infiniband-diags: Allow specification of an mkey to use on the command line
      infiniband-diags/ibportstate.c: Support changing MKey, lease, and protect bits
      infiniband-diags: Add m_key option to config file
      ib-diags/saquery: Fix smkey handling
      infiniband-diags: Add SA smkey option to config file

Marcus R Epperson (2):
      infiniband-diags/src/ibqueryerrors.c: fix segv due to CA port 0 reference
      infiniband-diags/src/ibqueryerrors.c: don't increment bad_ports for port ALL



-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
