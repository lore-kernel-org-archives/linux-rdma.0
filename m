From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [ANNOUNCE] infiniband-diags 1.5.9 tarball release
Date: Fri, 2 Sep 2011 15:01:57 -0700
Message-ID: <20110902150157.195929b2.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of infiniband-diags.
Tarball available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
807680f1e026ad8cacb2ec08ac8d86a6  infiniband-diags-1.5.9.tar.gz

This version requires:
	OpenSM >= 3.3.10
	libibmad >= 1.3.8


All component versions are from recent master branch. Full list of
changes is below.

Albert Chu:
	fix manpage typos
Albert L.Chu:
	perfquery: support many optional performance counters, including congestion control counters

Eli Dorfman:
	infiniband-diags/vendstat: Fixed general info query

Hal Rosenstock:
	infiniband-diags/configure.in: Support override for IBPATH
	infiniband-diags: Fix cap_mask extended link speed supported endian checks
	infiniband-diags/iblinkinfo.c: Changes for extended link speeds
	infiniband-diags/ibnetdiscover.c: Changes for extended link speeds
	infiniband-diags/ibnetdiscover.c: Eliminate blank line when sysimgguid is 0
	infiniband-diags/ibnetdiscover.c: Fix cap_mask endian for extended link speeds
	infiniband-diags/ibnetdiscover.c: Fix typo in help
	infiniband-diags/ibportstate: Add support for FDR10
	infiniband-diags/ibportstate.c: Changes for extended link speeds
	infiniband-diags/ibportstate.c: Fix sizeof
	infiniband-diags/ibqueryerrors.c: Add support for FDR10
	infiniband-diags/ibqueryerrors.c: Changes for extended link speeds
	infiniband-diags/ibqueryerrors.c: Fix typo in help
	infiniband-diags/ibstat.c: Add support for FDR10
	infiniband-diags: Initial changes for extended speed support in libibmad
	infiniband-diags/libibnetdisc/ibnetdisc_cache.c: Fix a couple of memory leaks
	infiniband-diags/libibnetdisc/ibnetdisc.c: Better error message
	infiniband-diags/libibnetdisc/ibnetdisc.c: Changes for extended link speeds
	infiniband-diags/libibnetdisc/ibnetdisc.c: Fix possible overrun of path
	infiniband-diags/libibnetdisc/ibnetdisc.c: Handle calloc failure
	infiniband-diags/libibnetdisc/ibnetdisc.c: Remove compile warning
	infiniband-diags: Make sure buffers are set to zero before calling xxx_query_via
	infiniband-diags/man/ibportstate.8: Update for fdr
	infiniband-diags/perfquery: Add support for extended link speeds
	infiniband-diags/perfquery.c: Use ib_types.h defines for CapabilityMask
	infiniband-diags/saquery: Add extended link speed support for PortInfoRecord queries
	infiniband-diags/saquery: Add GUIDInfoRecord support
	infiniband-diags/saquery.c: Fix SA_ERR_UNKNOWN define
	infiniband-diags/saquery.c: PortInfoRecord now has an options field
	infiniband-diags/smpquery: Add Mellanox extended portinfo query
	infiniband-diags/smpquery: Add support for extended link speeds
	infiniband-diags.spec.in: Remove duplication of ibdiscover.pl

Ira Weiny:
	infiniband-diags: Add FDR10 support to libibnetdisc
	infiniband-diags: add human readable output for data counters
	infiniband-diags: add package requires to spec file.
	infiniband-diags: Add support for FDR10 to ibnetdiscover
	infiniband-diags: Add sysconfdir to spec for config files
	infiniband-diags: change perl install to vendorlib
	infiniband-diags: configure.in; check for more recent function in libibmad
	infiniband-diags: convert ib[linkinfo|queryerrors] to use PortGUIDs
	infiniband-diags: fix "dist" target and subsequent rpm building
	infiniband-diags/iblinkinfo.c: Add support for FDR10
	infiniband-diags: iblinkinfo; remove non-supported -c option from man page
	infiniband-diags: ibqueryerrors; add --counters option
	infiniband-diags: ibqueryerrors; add error thresholds
	infiniband-diags: ibqueryerrors; add ibcheckerrors like summary
	infiniband-diags: ibqueryerrors Clean up exit codes
	infiniband-diags: ibqueryerrors --data; show/clear PortCountersExtended when supported
	infiniband-diags: ibqueryerrors fix null threshold_str
	infiniband-diags: ibqueryerrors; use #defines for CapabilityMask
	infiniband-diags: improve backwards/standalone compatibility
	infiniband-diags: libibnetdisc add port interface
	infiniband-diags: libibnetdisc Allow a DR Path partial fabric query starting at a CA
	infiniband-diags: make library dependancies explicit
	infiniband-diags: move core saquery functionality to ibdiag_common
	infiniband-diags: move get_msg to common code
	infiniband-diags: perfquery; print cap_mask for information
	infiniband-diags: perfquery; Support PortCountersExtendedNoIETF
	infiniband-diags: Remove reference to OpenSM from COPYING
	infiniband-diags: saquery, clean up error code/return types
	infiniband-diags: saquery; clean up name/lid processing
	infiniband-diags: saquery, properly free mad in get_and_dump_any_records
	infiniband-diags: saquery; remove "result" global
	infiniband-diags: test for libosmcomp with a function that is used in the code
	infiniband-diags: update check for latest dump function in libibmad
	Update AUTHORS and make README release notes.

Jason Gunthorpe:
	Fix ibdatacounters
	Fix missing $IBPATH in ibdatacounts

Marcus Epperson:
	infiniband-diags/ibnetdiscover: Make --ports option use remap_node_name()

shefty: ibnetdisc:
	Fix build for windows

Tamir Ronen:
	add support for ibnetdiscover grouping for Mellanox switches

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
