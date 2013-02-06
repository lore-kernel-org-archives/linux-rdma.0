From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Wed, 6 Feb 2013 12:02:11 +0200
Message-ID: <20130206100211.GG13151@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

There is a new release of OpenSM.
Tarball available in:

http://www.openfabrics.org/downloads/management/

(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
32b16efbaba69d478f8c05df42ce0462  opensm-3.3.16.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (5):
      opensm: Manage ports that do not support congestion control
      opensm: Fix signed vs unsigned int comparison
      opensm: Protect against spurious wakeups when calling cl_event_wait_on
      opensm/osm_perfmgr_db.c: Fix output error due to possible 32bit int overflow
      opensm: Add better error output when parsing node name maps

Alex Netes (15):
      opensm: fix crash in DFSSSP routing engine on reroute
      opensm: fix default cc_max_outstanding_mads assignment
      opensm/osm_subnet.c: Only parameters that marked with can_update flag should be updated during conf file rescan
      opensm: Changed #if to #ifdef when using ENABLE_OSM_PERF_MGR_PROFILE
      opensm/osm_link_mgr.c: Set AM SMSupportExtendedSpeeds bit if port supports ExtPortInfo
      opensm/osm_link_mgr.c: Fix sending PortInfo(Set) with AM SMSupportExtendedSpeeds bit set for switch base port 0
      opensm: Revert "opensm/osm_ucast_ftree: When roots are not connected, update hop count but not lft"
      opensm/osm_sm_mad_ctrl.c: Upon receiving trap repress we should decrease qp0_mads_outstanding_on_wire
      opensm: Add physp_p discovery count support
      opensm/osm_sm_state_mgr.c: Start sweep immedeately when recieving HANDOVER in DISCOVERING state
      opensm/configure.in: Remove Default-Start from opensmd init script
      opensm/osm_req.c: fix first sweep m_key search algorithm
      opensm: update shared library versions
      opensm_release_notes-3.3: update
      opensm: packages versions update

Bart Van Assche (7):
      opensm: osm_pkey: Remove unused variables
      opensm: Add .gitignore
      Correct option names in opensm man page
      Add command-line option --pidfile
      Make it possible to enable opensm with chkconfig
      opensm.spec.in: Improve portability
      /etc/init.d/opensmd: Improve systemd integration

Dan Ben Yosef (3):
      opensm/osm_ucast_dfsssp.c : Fix resource leak
      opensm/osm_ucast_dfsssp.c : fix dereference null return value
      opensm/osm_ucast_dfsssp.c : fix dereference before null check

Daniel Klein (1):
      opensm: improve search common pkeys.

Garrett Cooper (3):
      Fix linker error with clang with -O < 2
      Fix -Wtautological-compare warnings with clang
      Fix -Wformat-security warnings with clang

Hal Rosenstock (51):
      opensm/osm_vendor_ibumad.c: Add management class to error log message
      opensm/osm_sw_info_rcv.c: Fixed locking issue on osm_get_node_by_guid error
      OpenSM: Add new Mellanox OUI
      osmtest/osmt_multicast.c: Fix 02BF error
      opensm/osm_torus.c: Add error code to error log message
      opensm/complib/cl_spinlock.h: Remove some unimplemented routines
      opensm/ib_types.h: Commentary and cosmetic formatting change
      opensm/osm_sa.h: Cosmetic commentary change
      opensm/osm_ucast_updn.c: Add error codes to a couple of log messages
      opensm/osm_helper.c: Add some missing new lines to log message output
      opensm/osm_torus.c: Cosmetic formatting change
      opensm: Track minimum value in the fabric for data VLs supported on switch external ports
      opensm/osm_torus.c: Check fabric minimum data VLs on switch external ports
      opensm/complib/cl_atomic_osd.h: Fix long standing bug in cl_atomic_sub
      opensm/osm_trap_rcv.c: Eliminate unneeded trap_rcv_process_response routine
      opensm/osm_vl15intf.c: Fix commentary typo
      opensm/include/complib/cl_packon.h: Fix some commentary typos
      opensm/osm_sa_mcmember_record.c: Return proper scope for query with valid SA key
      Add Per Module Logging support for Congestion Manager
      opensm/include/osm_opensm.h: Fix commentary typo
      opensm: Add routing specific update_vlarb hook routine
      opensm/osm_torus.c: Require only 2 data VLs supported (PortInfo.VLCap) and use VLs 0-1 on CA links
      opensm: Update doc for changes to torus routing for CA, support
      opensm/osm_torus.c: Improve QoS configuration
      opensm/osm_torus.c: Add copyright
      opensm: Update doc for changes to torus routing for, endport support
      opensm/osm_torus.c: Minor simplification to check_qos_config
      opensm/osm_torus.c: Improve some misconfiguration error messages
      opensm/osm_req.c: In req_determine_mkey, add more info when ERR 1107 occurs
      opensm/osm_subnet.c: Improve error messages in subn_validate_neighbor
      opensm/osm_ucast_ftree.c: Remove duplicate free in fabric_create_leaf_switch_array
      opensm/osm_ucast_ftree.c: Eliminate unneeded NULL pointer checks prior to calls to free
      opensm/osm_torus.c: Fix crash in torus_update_osm_vlarb
      opensm/osm_port_info_rcv.c: Don't modify subnet minimal values when PortState DOWN
      opensm/osm_torus.c: Fix memory leak
      opensm/osm_sa_slvl_record.c: Fix out port for CAs and routers
      opensm/osm_dump.c: Fix output port on SL2VL table for non switch nodes
      opensm/osm_prtn_config.c: Insert autogenerated pkey into MGID for IPoIB
      opensm/osm_torus.c: Consolidate some parsing with parse_unsigned
      opensm/torus: Add configuration for max_changes to report
      opensm/osm_torus.c: Dump torus when OSM_LOG_ROUTING specified
      opensm/osm_req.c: In req_determine_mkey, fix DR algorithm
      opensm/osm_req.c: In req_determine_mkey, use osm_physp APIs
      opensm/osm_dump.c: Remove incorrect assert
      opensm/osm_sa_mcmember_record.c: Only use scope from MC group in copy_from_create_mc_rec
      opensm/osm_torus.c: In dump_torus, make sure switch is present before dumping
      opensm/osm_torus.c: torus routing should fail with VLCap 1 on switch external ports
      opensm/osm_sa_informinfo.c: Add trusted support for InformInfo/InformInfoRecord
      opensm/osm_sa: Improve SA record response handling (osm_sa_respond)
      opensm/osm_sa_informinfo.c: Fix infr_rcv_respond to only copy InformInfo
      opensm: Use IB_PATH_SELECTOR_EXACTLY rather than harded coded constant

Ilya Nelkenbaum (1):
      opensm/osm_congestion_control.c: fix use-after-free found by coverity

Ira Weiny (4):
      opensm/perfmgr/console: add 'pm sweep'
      opensm: update performance manager documentation
      opensm: clean up error message, function name is printed by logging code
      opensm: Fix incorrect use of sizeof

Jens Domke (7):
      DFSSSP: fix a memory leak in dfsssp_build_graph
      OpenSM: dfsssp ignores differences in the lmc value
      OpenSM: dfsssp - add support for base/enhanced switch port
      OpenSM: dfsssp - change the port traversal for sssp
      OpenSM: dfsssp - avoid unnecessary nested loop in vltable_print for OSM_LOG_INFO
      OpenSM: DFSSSP does not find LIDs due to wrong byte order (v2)
      OpenSM: dfsssp - moved paths from one to another VL might be counted multiple times

Shlomi Nimrodi (2):
      opensm/osm_qos_policy.c: fix segmentation fault on osm_qos_policy_match_rule_destroy (osm_qos_policy.c)
      opensm/osm_ucast_ftree.c: Fix unranked nodes bug in FTree

Vincent Ficet (1):
      
opensm/osm_ucast_ftree.c: fix opensm segfault in osm_ucast_ftree.c

Yevgeny Kliteynik (9):
      opensm/configure.in: check that compiler supports __builtin_expect()
      opensm/complib: define macros for for "if" statements with branch prediction hints
      opensm/osm_node_info_rcv.c: using "PF" hint for all the fatal conditions
      opensm/libvendor/osm_vendor_ibumad_sa.c: use wrapper function instead of direct access
      opensm/libvendor/osm_vendor_ibumad.c:rename "mad" to "p_mad" to indicate pointer
      opensm/libvendor/osm_vendor_ibumad.c: validate response MAD properties
      opensm/osm_port_info_rcv.c: check received local_port_num
      opensm/osm_port_info_rcv.c: use PF() hint on fatal conditions
      opensm/osm_log.h: fix function documentation


--Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
