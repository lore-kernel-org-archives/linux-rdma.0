From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] opensm 3.3.20 release
Date: Fri, 10 Jun 2016 05:26:57 -0400
Message-ID: <ffeb4750-0951-b75d-84ff-3bce680654e5@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 3.3.20 release of opensm.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)
	
md5sum:
ed615b4681e94ef2e13a5de773ab89a3  opensm-3.3.20.tar.gz

Changes since 3.3.19:
Quasi Fat Tree indexing support in fat tree routing (an alternative indexing policy for ftree routing in quasi-ftree topologies that can improve shift-pattern support)
Partition Manager support for PKey index 0 (block 0) configuration
Additional SA MCMemberRecord validation for join and IPoIB group creation
Internal improvements and bug fixes as noted below and in release notes

All component versions are from recent master branch. Full list of changes is below.

Albert Chu (4):
      osm_subnet.c: Correct output error with congestion control table entries
      osm_congestion_control.c: Add additional header status check in cc_rcv_mad
      osm_congestion_control.c: Consistently set cc_unavailable_flag
      osm_congestion_control.c: Reset cc_timeout_count when count threshold passed

Alex Netes (4):
      Add cleanup of SA cache after handover
      osm_mcast_mgr.c: Add check for physp validity to create_mgrp_switch_map
      Add more checks for physp validity
      osm_subnet.c: Add guid_routing_order_no_scatter option to opensm.conf

Daniel Klein (25):
      Add separate dispatcher for SA set and delete requests
      osm_ucast_mgr.c: Force unicast routing to fail when lft allocations fail
      osm_state_mgr.c: Remove new_lft buffers cleanup
      Use routing engine calculated LFT for SA queries
      osm_ucast_cache.c: Rewrite p_sw->lft allocation in osm_ucast_cache_process
      osm_ucast_mgr.c: Select exit ports for lid offset > 0 using new_lft
      Revert "osm_ucast_mgr.c: Force unicast routing to fail when lft allocations fail" patch
      osm_opensm.c: Call cl_disp_shutdown for SA SET dispatcher
      osm_sa_mcmember_record.c: Extend P_Pkey validation on MCMemberRecord(Join)
      osm_console.c: Fix display of negative counters in console
      osm_opensm.c: Fix race condition between traps handling and SA shutdown
      osm_state_mgr.c: Mark port as undiscovered when removed by drop_mgr
      osm_port_info_rcv.c: Sending MEPI(Get) to local switch ports on hop 0
      osmtest/osmt_multicast.c: Fix MC join with unrealistic rate test
      osm_sa_mcmember_record.c: Validate port's neighbor_mtu when joining MC group
      osm_ucast_ftree.c: Mark HCA ports connected to unranked switches
      osm_ucast_ftree.c: Remove no longer needed code in remove_depended_hca
      osm_ucast_ftree.c: Fail routing if max rank is 0 and more than one root
      osm_sa.c: Fix osm_db_file_dump
      osm_sa_path_record.c: Refactored PR [D/S] GID and LID validation
      osm_inform.c: Cosmetic code refactoring in match_inf_rec
      osm_sa_guidinfo_record.c: Fix memory leak in set_guidinfo
      osm_multicast.c: Fix not dumping empty predefined mc groups
      osm_multicast.c: Dump sa after deleting well known mc group
      osm_service.c: Fix missing endian conversion in log message

Hal Rosenstock (55):
      osm_ucast_mgr.c: Cosmetic formatting change
      osm_subnet.c: Add more supported device IDs
      osm_sa_mcmember_record.c: Cosmetic formatting change
      osm_prtn_config.c: Cosmetic formatting change
      osm_sa_mcmember_record.c: Removed redundancy in comment
      osm_node.h: Fix commentary typo
      osm_port_info_rcv.c: In pi_rcv_process_switch_port0, determine mkey
      osm_req.c: Cosmetic formatting change
      osm_port_info_rcv.c: In pi_rcv_process_switch_port0, store port 0's PortInfo before querying switch external ports
      osm_subnet.c: Improved m_key_lookup description in generated conf file
      osm_sa_mcmember_record.c: Change to log messages for PKey consistency
      man/osmtest.8: Minor tweaks to inventory option description
      osm_subnet.c: Minor clarification to SwitchCongestionSetting Control Map description in generated option file
      doc/QoS_management_in_OpenSM.txt: Cosmetic changes
      libvendor/osm_vendor_ibumad_sa.c: Cosmetic formatting changes to osmv_query_sa
      osm_sa_path_record.c: Handle path query by DGID and SLID
      osm_sa_path_record.c: When both [D S] GID and LID are supplied, validate that underlying ports are the same
      libvendor/osm_vendor_ibumad_sa.c: Cosmetic formatting change to ERR 5501 log message
      osm_state_mgr.c: Cosmetic formatting changes
      osm_ucast_ftree.c: Cosmetic formatting change
      osm_sa_path_record.c: Cosmetic formatting change
      osm_ucast_ftree.c: Cosmetic variable name changes in ftree_port_group_t struct
      osm_ucast_ftree.c: Cosmetic formatting change
      iba/ib_types.h: Fix commentary typo
      osm_ucast_ftree.c: Cosmetic formatting changes in fabric_construct_hca_ports
      Updated Mellanox copyrights in some recently changed files
      osm_sa_mcmember_record.c: When joining MC group and MC group already exists, validate other components if supplied
      osm_sa_mcmember_record.c: Add error logging for mismatches to validate_other_comp_fields
      osm_drop_mgr.c: Eliminated redundant check for switch node type
      osmtest/osmt_multicast.c: Cosmetic changes
      ib_types.h: Cosmetic formatting change
      Use SM trap defines from ib_types.h rather than hard coded values
      Set Type field in Notice attribute using IB_NOTICE_TYPE_SUBN_MGMT define
      Updated some Mellanox copyrights
      osm_ucast_mgr.c: Cosmetic formatting change
      osm_ucast_dfsssp.c: Fix some commentary typos
      osm_ucast_dfsssp.c: In dfsssp_do_mcast_routing, update adj_list first
      osm_sa_mcmember_record.c: Validate IPoIB non broadcast group parameters on group creation
      osm_sa_mcmember_record.c: Conditionalize multicast join parameter validation on new mcgroup_join_validation option
      osm_prtn.c: Cosmetic formatting change
      osm_mcast_mgr.c: Cosmetic formatting change in create_mgrp_switch_map
      osm_prtn_config.c: Updated Mellanox copyright years
      osm_prtn_config.c: Cosmetic formatting changes in manage_membership_change
      osm_sa_mcmember_record.c: Cosmetic formatting change to mcmr_rcv_create_new_mgrp
      osm_sa_mcmember_record.c: Updated Mellanox copyright years
      opensm/osm_pkey_mgr.c: Fix pkey index wraparound/reuse
      ib_types.h: Cosmetic commentary fix
      doc/current-routing.txt: Fix typo
      man/opensm.8.in: Fix typo (missing close parenthesis)
      ib_types.h: Cosmetic formatting changes
      ib_types.h: Comment change to indicate 1.3.1 rather than 1.2 IBA spec
      osm_state_mgr.c: Update comment in state_mgr_check_tbl_consistency
      Update (internal) shared library versions
      Update package number for OpenSM to 3.3.20 for release
      Update opensm_release_notes-3.3.txt

Ilya Nelkenbaum (2):
      osmeventplugin.c: Modify osm_event_plugin_t initialization
      osm_mcast_tbl.c: Wrong assert placement in osm_mcast_tbl_get_block

Jens Domke (5):
      Fix documentation on ignore-guids command line option
      osm_subnet.[h c]: Fix wrong function documentation and parameter list
      osm_ucast_dfsssp.c: Fix dangling pointer when dfsssp used with ucast cache
      osm_ucast_dfsssp.c: Minor change to setting dropped when switch exists
      osm_ucast_mgr.c: LFT update breaks if IB_SMP_DATA_SIZE changes

Rafi Wiener (2):
      osm_sa.c: Fix race condition when writing SA DB file
      osm_state_mgr.c: Fix uninitialized area of SMInfo SET mad

Shlomi Nimrodi (10):
      partition_config.txt: Small correction in doc file
      osm_pkey.h: Fix osm_physp_has_pkey method description
      osm_prtn_config.c: Handle valgrind warning in osm_prtn_config_parse_file
      osm_base.h: Fix OSM_CAP2_IS_PORT_INFO_CAPMASK2_MATCH_SUPPORTED definition
      osm_pkey.[h c], osm_prtn.c: Create method to set pkey at indx0
      osm_sa_mcmember_record.c: Prevent log errors swamp in MC query scenario
      osm_subnet.c: Add support for Switch-IB2 in is_mlnx_ext_port_info_supported
      osm_sm_mad_ctrl.c: Add ':' to "ERR 3120" error message
      osm_state_mgr.c: Fix bug in handling of PortInfo Set timeout
      Fix various coverity issues

Tomer Cohen (3):
      osm_drop_mgr.c: Do not set SM port discovery count to 0 when switch remote port is nonresponsive
      Support configuration for index 0 in pkey table
      Change precedence in pkey manager with indx0 feature

Vangelis Tasoulas (3):
      osm_switch.c: Fix wrong assertion failed in osm_switch_get_lft_block()
      osm_ucast_ftree.c: Removed *p_ftree parameter from sw_create function
      osm_ucast_ftree.c: Removed *p_ftree parameter from sw_destroy function

Vladimir Koushnir (9):
      osm_ucast_mgr.c: Support diverse paths for LMC > 0 when scatter_ports is enabled
      osm_subnet.c: Remove support for changing allow_both_pkeys on the fly
      Support another new MLNX OUI
      osm_prtn_config.c: Fix wrong pkey table calculation in allow_both_pkeys mode
      osm_port_info_rcv.c: Fix calculation of minimum data VLs
      osm_ucast_ftree.c: ftree calculates wrong number of compute nodes per leaf
      osm_ucast_ftree.c: Fix wrong handling of dual port HCA
      osm_ucast_ftree.c: Fix wrong is_io assignment to the second HCA port
      ftree: Additional ftree indexing algorithm

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
