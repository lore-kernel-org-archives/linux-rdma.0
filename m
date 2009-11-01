From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm_release_notes-3.3: add newest features/fixes
Date: Sun, 1 Nov 2009 21:05:53 +0200
Message-ID: <20091101190553.GL29434@me>
References: <20091101184357.GK29434@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091101184357.GK29434@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In a new IB management release preparation update features and fixes
lists by recently added stuff.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/doc/opensm_release_notes-3.3.txt |  168 ++++++++++++++++++++++++++++++-
 1 files changed, 165 insertions(+), 3 deletions(-)

diff --git a/opensm/doc/opensm_release_notes-3.3.txt b/opensm/doc/opensm_release_notes-3.3.txt
index 9725ad0..3b339da 100644
--- a/opensm/doc/opensm_release_notes-3.3.txt
+++ b/opensm/doc/opensm_release_notes-3.3.txt
@@ -3,14 +3,14 @@
 
 Version: OpenSM 3.3.x
 Repo:    git://git.openfabrics.org/~sashak/management.git
-Date:    Apr 2009
+Date:    Nov 2009
 
 1 Overview
 ----------
 This document describes the contents of the OpenSM 3.3 release.
 OpenSM is an InfiniBand compliant Subnet Manager and Administration,
 and runs on top of OpenIB. The OpenSM version for this release
-is opensm-3.3.2.
+is opensm-3.3.3.
 
 This document includes the following sections:
 1 This Overview section (describing new features and software
@@ -53,7 +53,9 @@ This document includes the following sections:
   around to improve connectivity. I/O nodes list is provided using file
   and --io_guid_file command line option.
 
-* Many (not yet) code improvements, optimizations and cleanups.
+* Many code improvements, optimizations and cleanups.
+
+* Windows support (very early stage yet).
 
 1.2 Minor New Features:
 
@@ -90,6 +92,32 @@ cf88e93 opensm: Add new partition keyword for all hca, switches and routers
 587ce14 opensm/osm_inform.c report IB traps to plugin
 ced5a6e opensm/opensm/osm_console.c: move reporting of plugins to "status"
 	command.
+696aca2 opensm: Add configurable retries for transactions
+0d932ff opensm/osm_sa_mcmember_record.c: optimization in zero mgid comparison
+254c2ef opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, set init
+	failure on PKeyTable and QoS initialization failure
+83bd10a opensm: Reduce heap consumption by multicast routing tables (MFTs)
+cd33bc5 opensm: Add some additional HP vendor IDs/OUIs
+f78ec3a opensm/osm_mcast_tbl.(h c): Make max_mlid_ho be maximum MLID configured
+2d13530 opensm: Add infrastructure support for PortInfo
+	IsMulticastPkeyTrapSuppressionSupported
+3ace760 opensm: Reduce heap consumption by unicast routing tables (LFTs)
+eec568e osmtest: Add SA get PathRecord stress test
+aabc476 opensm: Add infrastructure support for more newly allocated PortInfo
+	CapabilityMask bits
+c83c331 opensm: improve multicast re-routing requests processing
+46db92f opensm: Parallelize (Stripe) MFT sets across switches
+00c6a6e opensm: Parallelize (Stripe) LFT sets across switches
+e21c651 opensm/osm_base.h: Add new SA ClassPortInfo:CapabilityMask2 bit
+	allocations
+09056b1 opensm/ib_types.h: Add CounterSelect2 field to PortCounters attribute
+6a63003 opensm: Add ability to configure SMSL
+25f071f opensm/lash: Set minimum VL for LASH to use
+622d853 opensm/osm_ucast_ftree.cd: Added support for same level links
+8146ba7 opensm: Add new Sun vendor ID
+1d7dd18 opensm/osm_ucast_ftree.c: Enhanced Fat-Tree algorithm
+e07a2f1 Add LMC support to DOR routing
+1acfe8a opensm: Add SuperMicro to list of recognized vendors
 
 1.3 Library API Changes
 
@@ -281,6 +309,140 @@ ccc7621 opensm/osm_ucast_ftree.c: fixing errors in comments
 1a802b3 Corrected incoherency in __osm_ftree_fabric_route_to_non_cns comments
 85a7e54 opensm/osm_sm.c: fix MC group creation in race condition
 
+aad1af2 opensm/osm_trap_rcv.c: Improvements in log_trap_info()
+f619d67 opensm/osm_trap_rcv.c: Minor reorganization of trap_rcv_process_request
+084335b opensm/link_mgr: verify port's lid
+d525931 opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS rather than UMAD_CA_MAX_AGENTS
+f342c62 opensm/osm_sa.c: don't ignore failure in osm_mgrp_add_port()
+587fda4 osmtest/osmt_multicast.c: fix strict aliasing breakage warning
+6931f3e opensm: make subnet's max mlid update implementation independent
+30f1acd osm_ucast_ftree.c missing reset of ca_ports
+ac04779 opensm: fix LFT allocation size
+a7838d0 opensm/osm_ucast_cache: reduce OSM_LOG_INFO debug printouts
+c027335 opensm/osm_ucast_updn.c: Further reduction in cas_per_sw allocation
+e8ee292 opensm/opensm/osm_subnet.c: adjust buffer to ensure a '\n' is printed
+84d9830 opensm/osm_ucast_updn.c: Reduce temporary allocation of cas_per_sw
+347ad64 opensm/ib_types.h: Mask off client rereg bit in set_client_rereg
+
+c2ab189 opensm/osm_state_mgr.c: in cleanup_switch() check only relevant
+	LFT part
+40c93d3 use transportable constant attributes
+c8fa71a osmtest -code cleanup - use strncasecmp()
+770704a opensm/osm_mcast_mgr.c: In mcast_mgr_set_mft_block, fix node GUID
+	in log message
+3d20f82 opensm/osm_sa_path_record.c: separate router guid resolution code
+27ea3c8 opensm: fix gcc-4.4.1 warnings
+c88bfd3 opensm/osm_lid_mgr.c: Fix typo in OSM_LOG message
+a9ea08c opensm/osm_mesh.c: Add dump_mesh routine at OSM_LOG_DEBUG level
+bc2a61e C++ style coding does not compile
+6647600 opensm: remove meanless 'const' keywords in APIs
+323a74f opensm/osm_qos_parser_y.y: fix endless loop
+0121a81 opensm: fix endless looping in mcast_mgr
+696c022 opensm: fix some obvious -Wsign-compare warnings
+b91e3c3 opensm/osm_get_port_by_lid(): don't bother with lmc
+ca582df opensm/osm_get_port_by_lid(): speedup a port lookup
+fd846ee opensm/osm_mesh.c: simplify compare_switches() function
+fe20080 osm_sa.c - void * arithmetic causes problems
+220130f osm_helper.c use explicit value for struct init
+0168ece use standard varargs syntax in macro OSM_LOG()
+180b335 update functions to match .h prototypes
+9240ef4 opensm/osm_ucast_lash: fix use after free bug
+6f1a21a opensm: osm_get_port_by_lid() helper
+7ec9f7c opensm: discard multicast SA PR with wildcard DGID
+c9e2818 opensm/osm_sa_path_record.c: validate multicast membership
+225dcf5 opensm/osm_mesh.c: Remove edges in lash matrix
+4dd928b opensm/osm_sa_mcmember_record.c: clean uninitialized variable use
+c48f0bc opensm/osm_perfmgr_db.c: Fix memory leak of db nodes
+82d3585 opensm/osm_notice.c: move logging code to separate function
+9557f60 opensm/osm_inform.c: For traps 64-67, use GID from DataDetails in
+	log message
+e2e78d9 opensm/opensm.8.in: Indicate default rule for Default partition
+08c5beb opensm/osm_sa_node_record.c: dump NodeInfo with debug verbosity
+1fe88f0 opensm/multicast: merge mcm_port and mcm_info
+ba75747 opensm/multicast: consolidate port addition/removing code
+5e61ab8 opensm: port object reference in mcm ports list
+5c5dacf opensm: fix uninitialized return value in osm_sm_mcgrp_leave()
+7cfe18d osm_ucast_ftree.c: Removed reverse_hop parameters from
+	fabric_route_upgoing_by_going_down
+aa7fb47 opensm/multicast: kill mc group to_be_deleted flag
+a4910fe opensm/osm_mcast_mgr.c: multicast routing by mlid - renaming
+1d14060 opensm/multicast: remove change id tracking
+5a84951 opensm: use mgrp pointer as osm_sm_mcgrp_join/leave() parameter
+d8e3ff5 opensm: use mgrp pointer in port mcm_info
+0631cd3 opensm doc: Indicated limited (rather than partial) partition
+	membership
+1010535 opensm/osm_ucast_lash.c: In lash_core, return status -1 for all errors
+942e20f opensm/osm_helper.c: Add SM priority changed into trap 144 description
+2372999 opensm/osm_ucast_mgr: better lft setup
+e268b32 opensm/osm_helper.c: Only change method when > rather than >=
+9309e8c complib/cl_event.c: change nanosec var type long
+d93b126 opensm/complib: account for nsec overflow in timeout values
+ef4c8ac opensm/osm_qos_policy.c: matching PR query to QoS level with pkey
+c93b58b opensm: fixing some data types in osm_req_get/set
+2b89177 opensm/libvendor/osm_vendor_ibumad.c: Handle umad_alloc failure in
+	osm_vendor_get
+2cba163 opensm/osm_helper.c: In osm_dump_dr_smp, fix endian of status
+47397e3 opensm/osm_sm_mad_ctrl.c: Fix endian of status in error message
+e83b7ca opensm/osm_mesh.c: Reorder switches for lash
+9256239 opensm/osm_trap_rcv.c: Validate trap is 144 before checking for
+	NodeDescription changed
+011d9ca opensm/osm_ucast_lash.c: Handle calloc failure in generate_cdg_for_sp
+59964d7 opensm: fixing handling of opt.max_wire_smps
+f4e3cd0 opensm/osm_ucast_lash.c: Directly call calloc/free rather than
+	create/delete_cdg
+5a208bd opensm/osm_ucast_lash.c: Added error numbers to some error log messages
+3b80d10 opensm/osm_helper.c: fix printing trap 258 details
+f682fe0 opensm: do not configure MFTs when mcast support is disabled
+cc42095 opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, indicate
+	failed attribute
+aebf215 opensm/osm_ucast_lash.c: Remove osm_mesh_node_delete call from
+	switch_delete
+1ef4694 opensm/osm_path.h: In osm_dr_path_init, only copy needed part of path
+c594a2d opensm: osm_dr_path_extend can fail due to invalid hop count
+46e5668 opensm/osm_lash: Fix use after free problem in osm_mesh_node_delete
+81841dc opensm/osm_ucast_lash.c: Handle malloc failures better
+2801203 opensm: remove extra "0x" from debug message.
+88821d2 opensm/main.c: Display SMSL when specified
+f814dcd opensm/osm_subnet.c: Format lash_start_vl consistent with other
+	uint8 items
+66669c9 opensm/main.c: Display LASH start VL when specified
+31bb0a7 opensm/osm_mcst_mgr.c: check number of switches only once
+75e672c opensm: find MC group by MGID using fleximap
+2b7260d Clarify the syntax of the hop_weights_file
+e6f0070 opensm/osm_mesh.c: Improve VL utilization
+27497a0 opensm/osm_ucast_ftree.c Fix assert comparing number of CAs to CN ports
+3b98131 opensm/osm_qos_policy.c: Use proper size in malloc in
+	osm_qos_policy_vlarb_scope_create
+e6f367d opensm/osm_ucast_ftree.c: Made error numbers unique in some log
+	messages
+83261a8 osm_ucast_ftree.c Count number of hops instead of calculating it
+7bdf4ff opensm/osm_sa_(path multipath)_record.c: Fix typo in a couple of
+	log messages
+0f8ed87 opensm/osm_ucast_mgr.c: Add error numbers to some error log messages
+0b5ccb4 complib/Makefile.am: prevent file duplications
+e0b8ec9 opensm/osm_sminfo_rcv.c: clean type of smi_rcv_process_get_sm()
+4d01005 opensm: sweep component processors return status value
+6ad8d78 opensm/libvendor/osm_vendor_(ibumad mlx)_sa.c: Handle malloc
+	failure in __osmv_send_sa_req
+cf97ebf opensm/osm_ucast_lash.(h c): Replace memory allocation by array
+5cdb53f opensm/osm_sa_node_record.c use comp mask to match by LID or GUID
+957461c opensm/osm_sa.c add attribute and component mask to error message
+5d339a1 osm_dump.c dump port if lft is set up
+518083d osm_port.c: check if op_vls = 0 before max_op_vls comparison
+b6964cb opensm/osm_port.c: Change log level of Invalid OP_VLS 0 message
+	to VERBOSE
+b27568c opensm/PerfMgr: Reduce host name length
+bc495c0 opensm/osm_lid_mgr.c bug in opensm LID assignment
+5a466fd opensm/osm_perfmgr_db.c: Remove unneeded initialization in
+	perfmgr_db_print_by_name
+57cf328 opensm/osm_ucast_ftree.c Increase the size of the hop table
+8323cf1 opensm/PerfMgr: Remove some underbars from internal names
+65b1c15 opensm: Changes to spec and make files for updated release notes
+cd226c7 OpenSM: include/vendor/osm_vendor.h - Replaced #elif with no
+	condition by #else
+9f8bd4a management: Fixed custom_release in SPEC files
+c0b8207 opensm/PerfMgr: Change redir_tbl_size to num_ports for better clarity
+
 * Other less critical or visible bugs were also fixed.
 
 5 Main Verification Flows
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
