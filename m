From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] opensm 3.3.17 release
Date: Thu, 30 Jan 2014 15:16:25 -0500
Message-ID: <52EAB319.2090900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 3.3.17 release of OpenSM.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
9c1b85e47ab495110c1944e0f4d634b7  opensm-3.3.17.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (4):
      opensm/osm_console.c: Support portstatus output for unenabled width/speed
      opensm/osm_console.c: Do not perform portstatus checks on down ports
      opensm/osm_ucast_ftree.c: Fix invalid debug output message
      opensm: Add configure output messages for several configure options

Alex Netes (35):
      opensm/osm_req.c: Better implementation of req_determine_mkey
      osm_lid_mgr.c: Fix duplicate LID assignment after SM port down
      opensm: Fix Q_Key, TClass and limited keys parsing warnings in partitions.conf
      opensm/osm_ucast_dfsssp.c: Fix unused variable in update_mcft()
      When SM fails to load/parse root_guids file use MinHop heuristics
      osm_trap_rcv.c: Fix crash in babbling port feature
      complib/cl_event_wheel.h: Some cosmetic fixes
      Fix test scenario in cl_event_wheel
      complib/cl_event_wheel.c: Fix duplicate error codes
      complib/cl_event_wheel.c: Add print of num_regs in cl_event_wheel_dump
      complib/cl_event_wheel.c: Roundup timeout to nearest msec
      opensm/osm_db_pack.c: Removed uneeded asserts
      osm_vendor_ibumad.c: Fix explicit null derefenced issue found by coverity
      osm_lid_mgr.c: Don't configure MTU and LMC for base SP0
      osm_db_files.c: Fix memory leak when deleting entries from osm db
      osm_trap_rcv.c: Fix locking in aging callback
      Add option to disable M_Key lookup
      Improve m_key lookup
      osm_guid_mgr.c: Fix GUIDInfo SET function
      osm_sa_mcmember_record.c: Fix incorrect comparison of IPv6 MGID when searching for SNM MLID
      Resend trap 144 when detecting remote MASTER SM with lower priority
      osm_ucast_cache.c: Fix memory leak in ucast_cache
      osm_drop_mgr.c: fix timeouts on Get Pkey from ext switch ports
      osm_link_mgr.c: fix uninitialized variable usage
      osm_link_mgr.c: Fix uninitialized value (physp0)
      osm_mcast_mgr.c: Fix wrong comparison in mcast_mgr_subdivide()
      osm_state_mgr.c: Fix error print in state_mgr_check_tbl_consistency()
      Fix minhop population in fabric with duplicate lids
      osm_mtree.c: Cosmetic change in osm_mtree_destroy function
      osm_trap_rcv.c: fix race condition during sweep
      osm_port_info_rcv.c: Reset client reregister bit only on a response to SET
      osm_trap_rcv.c: fix locking in trap_rcv_process_request()
      osm_trap_rcv.c: Removed unneeded lock when disabling port
      osm_opensm.c: Add missing ERR number
      osm_drop_mgr.c: Add missing assert

Ammar Haj Hamad (1):
      opensm: fix dfsssp uninitialized value

Bernd Schubert (2):
      reduce log level for missing partition configuration file.
      Try default partition config if parsing partitions.conf fails

Dan Ben Yosef (14):
      opensm/osm_qos_policy.c: fix memory leak when parsing policy file
      opensm/osmtest.c: half_world_query when creating inventory file
      osm_ucast_dfsssp.c: Fix memory leak in dfsssp_do_dijkstra_routing
      opensm: fix possible double free in osm_ucast_ftree.c
      osm_ucast_ftree.c : fix dereferencing null variable
      osm_ucast_ftree.c: fix dereferencing null variable
      osm_ucast_cache.c : Fix dereference null return value
      osm_sa_sminfo_record.c: fix sminfo sa query returns all sminfo records when filtering by LID in osm_smir_rcv_process
      osm_db_files.c : Fix resource leak guid2lid parser
      osm_helper.c: Fix out-of-bounds read
      Fix handling of get P_KeyTable on timeout
      Fix possible use of lid 0 when sending set PortInfo after failure of the first PortInfo set
      Fix timeout handling for pkeyGet for sw port 0
      Fix dropping node after setPkey mad

Daniel Klein (7):
      libvendor/osm_vendor_ibumad.c: fix mad validation in case of multipath record response
      update man page and usage explanation for --lfts_file
      osm_pkey.c: Fix find common pkey bug fix
      osm_mcast_mgr.c: fixed missing error message number
      osm_sm_state_mgr.c: Fix race condition during sm_state_mgr_send_master_sm_info_req
      osm_mcast_mgr.c: Removed mcast_mgr_purge_tree_node due to code duplication
      osm_ucast_ftree.c: replace assert with error return value

Eitan Zahavi (1):
      libvendor/osm_pkt_randomizer.c: Fix broken compilation with vendor sim

Hal Rosenstock (65):
      opensm/ib_types.h: Add missing IB_PR_COMPMASK_SERVICEID define
      opensm/osm_torus.c: Cosmetic formatting changes
      opensm/ib_types.h: Add missing IB_MPR_COMPMASK_SERVICEID define
      opensm/osm_qos_policy.c: Fix source & destination GUID policy check
      opensm/osm_dump.c: Fix enhanced switch port 0 handling in print_node_report
      opensm/osm_sa_multipath_record.c: Fix commentary typo
      opensm/osm_sa_multipath_record.c: Fix seg fault in mpr_rcv_get_apm_paths
      opensm/osm_sa_path_record.c: Make sure either none or both ServiceID parameters are supplied
      opensm/osm_sa_multipath_record.c: Make sure either none or both ServiceID parameters are supplied
      opensm/osm_sa_multipath_record.c: Validate required components are indicated
      osmtest/osmt_multicast.c: Fix commentary typo
      osmtest/osmt_multicast.c: Fix IPoIB MC group recognition
      opensm/osm_perfmgr.c: Cosmetic changes
      opensm/osm_console.c: Use ib_port_info_get_link_speed_ext_enabled
      opensm/osm_subnet.c: Change default for perfmgr_query_cpi to FALSE
      osmtest/osmtest.c: Minor reordering of code in osmtest_write_all_path_recs
      osmtest: Add support for full world path records back as option
      opensm/osm_subnet.c: Miscellaneous minor fixes
      opensm/man/osmtest.8: Add option for using full world path queries
      opensm/osm_switch.h: Cosmetic change
      opensm: Fix issues causing const warnings for strings
      opensm/osm_sw_info_rcv.c: Fix double release of lock in osm_si_rcv_process
      opensm/osm_node.h: Fix some commentary typos
      opensm/osm_port_info_rcv.c: Fix min_sw_data_vls calculation
      opensm: Add support for LFT changed event
      ib_types.h: Trap 144 PortInfo:CapabilityMask2 changed bit definition
      osm_lid_mgr.c: Fix a couple of commentary typos
      osm_lid_mgr.c: Some commentary fixes/updates
      osm_log.c: Remove unneeded initialization in osm_log
      osm_congestion_control.c: Simplify some code
      osm_sa_mcmember_record.c: Improve debug log message in validate_modify
      osm_sa_mcmember_record.c: On join and leave, validate subnet prefix in port GID
      Setup SM port GUID in subnet object as soon as it is known
      Change LFT event to be per block/per switch rather than just per switch
      osm_sa_mad_ctrl.c: Drop incoming SA queries when shutting down
      osm_ucast_lash.c: Cosmetic formatting change
      cl_threadpool.h: Remove vestigial mention of cl_thread_pool_construct
      ib_types.h: Fix commentary typo
      Minor log formatting changes
      osm_event_plugin.h: Add Mellanox copyright
      osmeventplugin/osmeventplugin.c: Add Mellanox copyright
      Add flags to OSM_EVENT_ID_UCAST_ROUTING_DONE
      osm_sa_path_record.c: Fix rate setting issue in SA PR handling
      osm_ucast_dfsssp.c: Fix some typos
      osm_sa_guidinfo_record.c: False duplicate GUID error messages
      osm_db_files.c: Add osm_db_domain_init failure handling into test program
      Use trap number defines rather than actual trap numbers
      osm_sa_path_record.c: Eliminate extraneous space in 1F1A log message
      osm_vendor_ibumad.c: Improve ERR 5430 log message
      osm_trap_rcv.c: Log DR path to node when trap 128
      osmtest: Handle other than default subnet prefix
      Add support for synchronizing in memory files with storage
      osm_perfmgr.c: Cosmetic formatting changes
      osm_db_files.c: Some minor fixes/improvements to osm_db_store
      osm_db_files.c: Fix issue introduced in commit aaa7b1e67ec6e5fc2a10accf46d538f9d47c6323
      osm_db_files.c: Minor improvement to fix in previous commit 86cf679666f49f6073c1ddf2b9ff644a41537a57
      osm_subnet.c: Cosmetic change to config file output
      osm_trap_rcv.c: In trap_rcv_process_request, change locking strategy
      osm_trap_rcv.c: Minimize time holding RW lock for SystemImageGUID changed trap 145
      osm_prtn_config.c: Some changes to osm_prtn_config_parse_file
      osmeventplugin: Fix compile warning
      osm_perfmgr.h: Cosmetic formatting changes
      Update (internal) shared library versions
      Update opensm_release_notes-3.3.txt
      Update package number for OpenSM to 3.3.17 for release

Ilya Nelkenbaum (2):
      osm_dump.c: Fix typo in dump_lid_matrix
      Add client_rereg flag to Port Info context

Ira Weiny (15):
      opensm/perfmgr: mark/report time of last counter update
      opensm/perfmgr: skip data counters when only printing errors
      opensm/perfmgr: update node name when Node Description is received from node
      opensm/libibvendor: osm_vendor_get_all_port_attr include sm_sl value in port attribute struct
      opensm/perfmgr: add failed port guid to error message
      opensm: make osm_get_path_params public
      opensm: make osm_pr_rcv_get_end_points, osm_pr_rcv_process_pair, osm_pr_rcv_process_half public
      opensm/perfmgr: issue ClassPortInfo as first query to each port.
      opensm/perfmgr: clean up: break out redirect processing from pc_recv_process
      opensm/perfmgr: Issue PortCountersExtended query when supported
      opensm/perfmgr; add support for PortCountersExtended NOIETF
      opensm/perfmgr: don't clear data counters in PortCounters when ExtendedPortCounters is supported
      opensm/perfmgr: fix access to shared sweep_state variable
      opensm/osmtest: fix debug build
      osm_console_io.c: Handle another write-strings issue

Jeff Becker (1):
      Permit toggling log flush from console

Jens Domke (6):
      OpenSM: dfsssp - add support for multicast
      DFSSSP - workaround for better VL balancing
      dfsssp - add missing and change existing return values
      dfsssp: send multicast forwarding tables to switches
      dfsssp: send multicast forwarding tables to switches
      dfsssp: optimization for dedicated compute and IO nodes

Jim Schutt (2):
      opensm/osm_torus.c: avoid the possibility of following stale ->priv pointers
      opensm/osm_torus.c: clarify log messages on stale priv pointers

Line Holen (19):
      osm_sa_multipath_record.c Use aliasGUIDs when building responses
      osm_subnet.c Remove empty syslog message
      Fix segfault in osm_mgrp_delete_port()
      osm_console_io.c Memory leak when closing console
      Add trap details to notice log message
      osm_sa_mcmember_record.c Reduce number of error messages the for same event
      osm_sm_state_mgr.c Don't clear IS_SM bit when changing state to NOT_ACTIVE
      Add attribute information to SA request error messages
      Some log changes
      Log changes related to event subscription and forwarding
      osm_sm_state_mgr.c Trivial log changes
      osm_sa_mcmember_record.c validate_requested_mgid returning boolean
      osm_port_info_rcv.c Issue a log message if we cannot read the MKey of a port
      osm_sa_informinfo.c Add attribute info to log messages
      Clean up event subscriptions if a port goes away
      Handle memory allocation failure in osm_db_domain_init()
      osm_state_mgr.c Add info to some error messages
      osm_mcast_mgr.c Add block number to error message
      osm_sm_state_mgr.c: Fix handling of polling retry number

Roland Dreier (1):
      osmtest: Make the "-guid" option's argument mandatory

Shlomi Nimrodi (1):
      osm_link_mgr.c: Fix uninitialized value (physp0)

Vladimir Koushnir (21):
      Fix fat-tree routing for CAs with more than 1 connected port
      Fix shift pattern support in FTREE routing for native ftree topologies
      ftree: Allow defining only io_guids file and consider rest of nodes as CN nodes
      osm_ucast_mgr.c: Fix duplicated code for fallback routing engine
      complib: Fix memory leak in cl_thread_pool_destroy function
      osm_ucast_mgr.c: Fix extra copy in set_lft_block routine
      osm_subnet.c: Fix memory leak caused by commit dc0760cb8088fbe079e19682570a884ba01e94ff
      Use after free in osm_prtn_delete
      osm_link_mgr.c: active_transition parameter in PortInfo(Set) context may not be initialized
      osm_opensm.c: When exiting, update SADB only in MASTER state
      Improve memory consumption of pkey manager by using cl_map for accum_pkeys
      Remove unused lid matrix calculation in Torus_2Qos routing
      Implement atomic update operation for sa_db_file
      Redundant remove() function call during db file generation
      Only rewrite db files during heavy sweep when there is a real change
      osm_sa_path_record.c: path_sl may return SL different from requested SL
      osm_pkey.[h c]: Remove dead function osm_pkey_tbl_clear_accum_pkeys
      osm_sa_path_record.c: Improve ERR 1F1D to show the pkey specified in PathQuery
      osm_ucast_file.c: Fix crash when port is invalid in LFT file
      osm_ucast_mgr.c: After applying guid_order options, add nodes sorted by neighbor switch load
      Add new option for guid_routing_order_no_scatter


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
