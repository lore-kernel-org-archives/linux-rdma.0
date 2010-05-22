From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm_release_notes-3.3: update
Date: Sun, 23 May 2010 00:28:17 +0300
Message-ID: <20100522212817.GZ28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Update OpenSM Release Notes in accordance to recent changes.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/doc/opensm_release_notes-3.3.txt |   47 ++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/opensm/doc/opensm_release_notes-3.3.txt b/opensm/doc/opensm_release_notes-3.3.txt
index 9b5de67..182a027 100644
--- a/opensm/doc/opensm_release_notes-3.3.txt
+++ b/opensm/doc/opensm_release_notes-3.3.txt
@@ -10,7 +10,7 @@ Date:    Dec 2009
 This document describes the contents of the OpenSM 3.3 release.
 OpenSM is an InfiniBand compliant Subnet Manager and Administration,
 and runs on top of OpenIB. The OpenSM version for this release
-is opensm-3.3.5.
+is opensm-3.3.6.
 
 This document includes the following sections:
 1 This Overview section (describing new features and software
@@ -127,6 +127,10 @@ f02f40e opensm: implement 'connect_roots' option in fat-tree routing
 748d41e opensm SA DB dump/restore: added option to dump SA DB on every sweep
 b03a95e complib/cl_fleximap: add cl_fmap_match() function
 b7a8a87 opensm/include/iba/ib_types.h: adding Congestion Control definitions
+fa356f8 opensm: Add support for optimized SLtoVLMappingTable programming
+8aaae91 Dimension port order file support
+7662eec opensm: Add option to specify prefix to syslog messages
+2382cf3 opensm: Add update_desc command to opensm console
 
 1.3 Library API Changes
 
@@ -247,6 +251,8 @@ fa90512 opensm/osm_vendor_*_sa: fix incompatibility with QLogic SM
 55f9772 opensm: Return single PathRecord for SubnAdmGet with DGID/SGID wild
 	carded
 5ec0b5f opensm: compress IPV6 SNM groups to use a single MLID
+26e7e83 opensm/osm_lid_mgr: fix couple of duplicate LIDs bugs
+fedc419 opensm: Multicast root switch calculation
 
 4.2 Other Bug Fixes
 
@@ -507,6 +513,44 @@ c6b4d4a opensm/osm_vendor_ibumad.c: Add transaction ID to osm_vendor_send
 520af84 opensm/osm_sa_path_record.c: don't set dgid pointer for local subnet
 4a878fb opensm/osm_mcast_mgr.c: fix osm_mcast_mgr_compute_max_hops for
 	managed switch
+7c48590 opensm/osm_log.c: add OSM_LOG_SYS to default flags
+89f7cb6 opensm/osm_lid_mgr: use 'first_time_master_sweep' flag
+0cb7fab opensm: conversion to osm_get_port_by_lid()
+9d14fc0 opensm/osm_lid_mgr.c: fix memory leak
+c364aa1 opensm/opensm.init.in: fix install warning on SLES11
+1010c9c opensm/osm_sa_path_record.c: livelock in pr_rcv_get_path_parms
+4b2cd5e opensm/vendor: fix portguids array size
+52bf5b2 opensm/osm_subnet.c: fixing some options to not "hot-swappable"
+8900da0 opensm/osm_subnet.{c,h}: passing options to the event plugins
+051c57f Delete port only after GID OUT trap was sent
+d4ebf7e opensm/complib/cl_passivelock.h: remove unneeded casting
+8fdb17c opensm/complib/cl_types.h: convert cl_status_t to int
+fd7fb1e opensm/osm_mcast_mgr.c: preserve root switch calculation functionality
+fcb0f3a opensm/osm_mcast_mgr.c: code simplifications
+444f559 opensm/osm_mcast_mgr.c: fix bug in MC root switch calculation
+041ebcb opensm/osm_mcast_mgr.c: remove redundant casting
+3717f53 opensm/osm_sa_pkey_record.c: optimize port selection logic
+48352be opensm/osm_mcast_mgr.c: fix memory leak
+f3cf83f opensm/complib/cl_ptr_vector.c: fix bug/compiler warning
+27c8ebd opensm/osm_subnet.h: remove redundant function definition
+f296938 opensm/osm_vl_arb_rcv.c: fix double mutex release bug
+00bc48e opensm/osm_port_info_rcv.c: fix compilation warning
+8823800 opensm/osm_sa.{c,h}: osm_sa_db_file_dump() return values
+f4581f3 opensm/osm_qos.c: Fix typo in OSM_LOG message
+e3c790a opensm/osm_update_node_desc(): minor prototype improvement
+3cc68cb opensm/osm_vl_arb_rcv.c: Dump table after validating block number
+7dbb96e opensm SA DB: dump only if modified
+fa2106d opensm/osm_sa_infrominfo.c: fixes and simplifications in lid range check
+051a1dd opensm/osm_qos.c: split switch external and end ports setup
+a6c0189 opensm/osm_qos.c: merge SL2VL mapping capability check
+3fe8efe opensm/osm_slvl_map_rcv.c: verify port number values received from
+	network
+88c372c opensm/osm_slvl_map_rcv.c: fix mutex double release bug
+d282093 opensm/osm_slvl_map_rcv.c: fix port parsing on BE machine
+8e9dbd3 osm_sa_path_record.c: use PR DGID by reference
+7c9d375 osm_sa_path_record.c: separate mutlicast processing code
+cb2d18e opensm/osm_sa_path_record.c: MGID must be specified explicitly
+bd3932b opensm/osm_mcast_mgr.c: strip log-only variable
 
 * Other less critical or visible bugs were also fixed.
 
@@ -686,6 +730,7 @@ Table 2 - Qualified IB Stacks
 Stack                                    | Version
 -----------------------------------------|--------------------------
 The main stream Linux kernel             |   2.6.x
+OFED                                     |   1.5,1.5.x
 OFED                                     |   1.4
 OFED                                     |   1.3
 OFED                                     |   1.2
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
