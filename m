From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Sun, 23 May 2010 00:43:33 +0300
Message-ID: <20100522214333.GC28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabricsEWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of the management (OpenSM and infiniband
diagnostics) tarballs available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:

d3586e7a17bca99fd384a943f00e259e  libibumad-1.3.5.tar.gz
754d93f567393d3b9987a65326f40917  libibmad-1.3.5.tar.gz
5c94d6ee49e9c51c801f6634823b5ad5  opensm-3.3.6.tar.gz
ba28f6b5323e6067ca019a999eeaf907  infiniband-diags-1.5.6.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Sasha


Al Chu (10):
      add libibnetdisc caching to libibnetdiscover
      support --cache and --load-cache options in ibnetdiscover
      support --load-cache in iblinkinfo and ibqueryerrors
      fix libibnetdisc corner case when user tries to re-cache a loaded cache
      support --diff in ibnetdiscover
      support --diffcheck in ibnetdiscover
      support lid and nodedesc diffchecks in ibnetdiscover
      fix libibnetdisc portguid hashing corner case
      fix libibnetdisc cache error path memleak
      check for duplicate port guids in libibnetdisc cache

Arputham Benjamin (1):
      opensm: Add option to specify prefix to syslog messages

Dale Purdy (1):
      Dimension port order file support

Dave Olson (1):
      opensm/opensm.init.in: fix install warning on SLES11

Eli Dorfman (Voltaire) (3):
      opensm: Add update_desc command to opensm console
      Delete port only after GID OUT trap was sent
      opensm: Always set enabled speed and width

Hal Rosenstock (13):
      infiniband-diags/ibqueryerrors.c: Fix output format of counters
      opensm: Add support for optimized SLtoVLMappingTable programming
      opensm/osm_vl_arb_rcv.c: Dump table after validating block number
      libibmad: Add support for optional PortRcvErrorDetails counter
      infiniband-diags/perfquery: Add support for optional PortRcvErrorDetails counter
      infiniband-diags/ibportstate.8: Add new supported ops
      libibmad: Add support for PortSamplesControl counter
      infiniband-diags/perfquery: Add support for PortSamplesControl counter
      infiniband-diags/ibqueryerrors: Add support for optional PortRcvErrorDetails counter
      opensm/osm_qos.c: Fix typo in OSM_LOG message
      infiniband-diags/ibqueryerrors.c: Fix typo in counter name
      opensm/osm_mcast_mgr.c: Cosmetic changes
      infiniband-diags/vendstat: Indicate general info for IS4 as well as IS3

Ira Weiny (5):
      libibnetdisc: fix typo in man page for ibnd_show_progress
      infiniband-diags: Ignore PortInfo data on down port.
      libibnetdisc: Convert to a multi-smp algorithm
      libibnetdisc: add ibnd_set_max_smps_on_wire call
      ibnetdisc: Separate calls to umad and mad layer to avoid race condition on response MAD's

Line Holen (4):
      opensm/osm_vl_arb_rcv.c: fix double mutex release bug
      opensm/osm_pkey.h: Fix typo in comment
      opensm/osm_sa_path_record.c: livelock in pr_rcv_get_path_parms
      opensm/osm_sa_path_record.c: Lower max number of hops allowed

Mike Heinz (4):
      Perfquery can be too noisy.
      management: adding mad_dump_fields to libibmad
      RE: [PATCH] management: adding mad_dump_fields to libibmad
      RE: [PATCH] management: adding mad_dump_fields to libibmad

Ralph Campbell (1):
      infiniband-diags/ibportstate: allow changes to CA portinfo parameters

Sasha Khapyorsky (54):
      opensm/osm_mcast_mgr.c: strip log-only variable
      opensm/osm_sa_path_record.c: MGID must be specified explicitly
      osm_sa_path_record.c: separate mutlicast processing code
      osm_sa_path_record.c: use PR DGID by reference
      osm_sa_path_record.c: cleanups
      opensm/osm_slvl_map_rcv.c: fix port parsing on BE machine
      opensm/osm_slvl_map_rcv.c: fix mutex double release bug
      opensm/osm_slvl_map_rcv.c: verify port number values received from network
      opensm/osm_qos.c: merge SL2VL mapping capability check
      opensm/osm_qos.c: split switch external and end ports setup
      opensm/osm_sa_informinfo.c: minor simplifications and fixes
      opensm/osm_sa_infrominfo.c: fixes and simplifications in lid range check
      infiniband-diags: -V, --version: exit with zero status
      opensm/osm_update_node_desc(): minor prototype improvement
      infiniband-diags: indentation fixes
      ibqueryerrors.c: more readable details dump function
      infiniband-diags/iblinkinfo,ibqueryerrors: code refactoring
      opensm/osm_vl_arb_rcv.c: indentation improvement
      opensm/osm_mcast_mgr.c: fix memory leak
      opensm/osm_sa_pkey_record.c: optimize port selection logic
      opensm/osm_mcast_mgr.c: remove redundant casting
      opensm/osm_mcast_mgr.c: fix some indentation errors
      opensm/osm_mcast_mgr.c: fix bug in MC root switch calculation
      opensm/osm_mcast_mgr.c: code simplifications
      opensm/osm_mcast_mgr.c: preserve root switch calculation functionality
      libibnetdisc: code cleanups
      libibnetdisc: restore show_progress functionality
      libibnetdisc: restore hops limited discovery
      libibnetdisc: keep total number of used SMPs
      infiniband-diags/ibnetdiscover: report number of used MADs
      libibnetdisc: no backward NodeInfo queries
      libibmad: add explicit extern for ibdebug prototype
      infiniband-diags/ibnetdiscover: cleanups
      libibnetdisc: add \n at end of error messages
      libibnetdisc: fix outstanding SMPs countung
      libibnetdisc: don't try to cross discovery over CA
      libibnetdisc: don't query CA ports not connected to a fabric
      libibnetdisc: config struct for ibnd_discover_fabric()
      opensm/vendor: fix portguids array size
      libibnetdisc: fix memory leak in case of send_smps() failure
      libibnetdiscover: more outstanding MADs counting fix
      libibnetdisc: remove not needed process_smp_queue() call
      libibnetdisc: remove not needed num_smps_outstanding counter
      libibnetdisc: fix indentations
      opensm/osm_lid_mgr.c: fix memory leak
      opensm: conversion to osm_get_port_by_lid()
      opensm/osm_lid_mgr.c: some cleanups
      opensm/osm_lid_mgr: use 'first_time_master_sweep' flag
      opensm/osm_lid_mgr: fix couple of duplicate LIDs bugs
      libibmad/src/dump.c: fix compile warning
      opensm/osm_lid_mgr: revert 'coming_out_of_standby' replacement patch
      opensm_release_notes-3.3: update
      management: update shared library versions
      management: packages versions update

Slava Strebkov (1):
      opensm: Multicast root switch calculation

Yevgeny Kliteynik (14):
      opensm SA DB: dump only if modified
      opensm/osm_sa.{c,h}: osm_sa_db_file_dump() return values
      opensm/osm_port_info_rcv.c: fix compilation warning
      opensm/osm_subnet.h: remove redundant function definition
      opensm/complib/cl_ptr_vector.c: fix bug/compiler warning
      opensm/complib/cl_types.h: convert cl_status_t to int
      opensm/complib/cl_passivelock.h: remove unneeded casting
      infiniband-diags/ibstatus: add link_layer for RoCEE support
      libibumad: added link_layer for RoCEE support and updated umad version
      infiniband-diags/ibstat.c: print link layer for RoCEE support
      opensm/osm_subnet.h: cosmetics - fix description of event_plugin option
      opensm/osm_subnet.{c,h}: passing options to the event plugins
      opensm/osm_subnet.c: fixing some options to not "hot-swappable"
      opensm/osm_log.c: add OSM_LOG_SYS to default flags

sebastien dugue (1):
      libibnetdisc: Add grouping for Voltaire's ISR4700 switch

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
