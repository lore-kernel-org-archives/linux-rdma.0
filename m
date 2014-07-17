From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [ANNOUNCE] opensm 3.3.18 release
Date: Thu, 17 Jul 2014 10:54:58 -0400
Message-ID: <53C7E3C2.1060605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Rupert Dance <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is a new 3.3.18 release of OpenSM.

Tarball is available in:
http://www.openfabrics.org/downloads/management/
(listed in http://www.openfabrics.org/downloads/management/latest.txt)

md5sum:
642c2a2fda102a7d11add773a89265af  opensm-3.3.18.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (3):
      osm_perfmgr.c: Remove unnecessary log message
      osm_perfmgr.c: Add log message when perfmgr sweep is skipped
      osm_perfmgr.c: Fix perfmgr sweep_state race

Alex Netes (19):
      ib_types.h: Fix shadow declaration warnings
      Change discovery order of switch data
      Better handling of topology changes in the fabric
      osm_port_info_rcv.c: Reread pkeys from SP0 if switch rebooted during a sweep
      Resend LFTs/VLArb/SL2VL MADs in case of error
      osm_qos.c: Fix possible seg fault
      osm_node_info_rcv.c: Fix multiple switch discovery during a sweep
      ib_types.h: Rename ib_switch_info_set_state_change function
      osm_sw_info_rcv.c: Fix sending PortInfo during lightsweep
      osm_sa_path_record.c: Search for requester port should be under lock
      Fix crash during handover
      osm_sm_state_mgr.c: Reconfigure the fabric when receiving HANDOVER/POLLING_TIMEOUT in MASTER state
      Revert "Reset client reregistration when receiving handover"
      osm_state_mgr.c: Remove redundant unset to first_time_master_sweep
      osm_sminfo_rcv.c: Send trap 144 to a newly found MASTER SM when in MASTER state
      osm_node_info_rcv.c: Update NodeInfo.SysImageGUID on heavy sweep
      All SA queries should validate the requester port under lock
      osm_sa_service_record.c: Improved locking
      Add osm_congestion_control.c to per module logging support

Dan Ben Yosef (3):
      osm_subnet.c: Fix resource leak guid2mkey parser (guid validation function)
      osm_subnet.c: Fix resource leak neighbor parser ("subn_validate_neighbor" function)
      osmtest: Add GRH tests for SA queries

Daniel Klein (4):
      osm_node_info_rcv.c: Update local copy of node info for known nodes
      osm_sa_mcmember_record.c: Fix removing members from existing mc group due to invalid requests
      Fix the creation of empty multicast groups from SADB
      opensm.init.in: Fix return value checking in opensm.init script

Eli Dorfman (1):
      osm_state_mgr.c: Clear first time sweep even after subnet error

Hal Rosenstock (46):
      osm_port.c: Improve ERR 4108 log message
      Handle bad SMP status
      osm_ucast_mgr.c: Use LFT block of all port 0s to indicate resend
      osm_state_mgr.c: Revert commit to "remove redundant unset to first_time_master_sweep"
      osm_sa_path_record.c: In osm_pr_rcv_process, release lock before log message
      man/opensm.8.in: Minor fixes to per module logging configuration
      osm_sa_mcmember_record.c: Fix double locking in mcmr_rcv_join_mgrp
      osm_sa_service_record.c: Fix locking issue in osm_sr_rcv_process
      doc/performance-manager-HOWTO.txt: Fix typo
      osm_sa_mad_ctrl.c: In sa_mad_ctrl_rcv_callback, improve 1A04 error log message
      osm_mcast_mgr.c: Fix endian of port GUID in ERR 0A06 log message
      osm_mcast_mgr.c: Add missing new line at end of ERR 0A21 log message
      osm_perfmgr.c: Add current PerfMgr sweep state to 54FF error log message
      libvendor/osm_vendor_ibumad.c: Cosmetic change to umad_set_grh calls
      libvendor/osm_vendor_ibumad.c: Support GRH (for GS classes)
      osm_guid_info_rcv.c: Fix assert placement in osm_gi_rcv_process
      osm_perfmgr.c: Cosmetic formatting changes
      osm_perfmgr.c: Eliminate unneeded initialization in pc_recv_process
      osm_perfmgr.c: Added Mellanox copyright
      osm_perfmgr_db.c: Add missing clear of new xmit_wait counter in clear_counters
      Add support for additional Mellanox OUI
      osm_subnet.c: Enhance opensm conf file documentation for PerfMgr options
      osm_subnet.c: More cosmetic changes to opensm conf file PerfMgr documentation
      libvendor/osm_vendor_ibumad.c: Commentary change
      doc/opensm_release_notes-3.3.txt: Updated repo location
      osm_perfmgr.c: Minor code factoring in perfmgr_send_mad
      osm_perfmgr.c: In perfmgr_send_mad, handle cl_event_wait_on return status
      PerfMgr: Eliminate no longer used sig_sweep variable
      osm_[sm sa]_mad_ctrl.c: Improve unsupported attribute error messages
      osm_congestion_control.c: In cc_poller_send, handle cl_event_wait_on return status
      osm_mcast_mgr.c: In mcast_mgr_process_mlid, cosmetic change to log message
      osm_trap_rcv.c: In shutup_noisy_port, improve ERR 3811 log message
      osm_sm.c: In sm_sweeper, no need to check for timeout after cl_event_wait_on EVENT_NO_TIMEOUT
      osm_congestion_control.c: Fix error code
      osm_vendor_ibumad.c: Better match table eviction strategy
      osmtest/main.c: Output formatting change for case 'x'
      osm_sa_path_record.c: Fix some commentary typos
      osm_subnet.c: Cosmetic formatting change in subn_validate_neighbor
      Improve scatter ports documentation
      man/opensm.8.in: Update date on man page
      osm_mcast_mgr.c: Cosmetic change to error log mesage
      osm_subnet.c: Change default for perfmgr_query_cpi option
      Add support for additional Mellanox OUI
      Update (internal) shared library versions
      Update opensm_release_notes-3.3.txt
      Update package number for OpenSM to 3.3.18 for release

Ilya Nelkenbaum (3):
      osm_ucast_updn.c: Add missing ERR number to log message
      osm_sw_info_rcv.c: Add check of switch mcast_cap
      Add some missing documentation files to installation

Ira Weiny (2):
      perfmgr: Add xmit_wait support
      perfmgr: Add xmit_wait to event plugin error counters data structure

Jens Domke (2):
      osm_ucast_dfsssp.c: prevent double free error
      dfsssp: avoid crash due to port initialisation errors

Mohammad Ismail (1):
      osm_ucast_updn.c: Fix the AA0B error number

Rafi Wiener (1):
      osm_ucast_ftree.c: Fix memory leak in ftree fabric_rank

Shlomi Nimrodi (6):
      osm_torus.c: Fix torus crash when actual topology is not torus
      osm_ucast_mgr.c: Fix duplicated error codes
      osm_helper.c: In osm_get_lsa_str, fix printing of wrong FDR10 data if link is down
      Shorten long lines while calculating SA rate
      Eliminate redundant calls to ib_port_info_compute_rate
      osm_subnet.c: Remove duplicate strcmp check in osm_subn_rescan_conf_files method

Tomer Cohen (10):
      osm_qos_parser_y.y: Added range check for rate limit parsing
      osm_qos_parser_y.y: Added range check for mtu limit parsing
      osm_subnet.c: Fix bug in parsing configuration file
      osm_sa_[mcmember path]_record.c: Optimize clearing of SA record items
      osm_console_io.c: Handle return value of function setsockopt
      osm_log.c: Fix wrong hour and date display in log when CL_ASSERT fail
      osmtest.c: Fixed missing assignment of return value from function osmtest_get_port_rec_by_num
      osm_port_info_rcv.c: Fixed calculation of min_data_vls
      osm_sa_path_record.c: Fix misleading error messages during sweep
      osm_vl15intf.c: Fix potential NULL dereference in vl15_send_mad

Vladimir Koushnir (8):
      osm_sm_state_mgr.c: Fix opensm crash after handover
      SM should resweep the fabric if vl15_send_mad fails
      osm_sa_guidinfo_record.c: Fix crash when receiving AGUID SET/DELETE with block_num equal to max_block
      osm_trap_rcv.c: Lock released without locking in some cases of trap processing
      libvendor/osm_vendor_ibumad.c: Check the next CA if an error is returned for the current one
      osm_state_mgr.c: Improve error flow with wrong LIDs
      osm_drop_mgr.c: Add missing CR at end of log message in drop_mgr_check_node
      Skip state_mgr_check_tbl_consistency when no LID is changed by lid or link managers

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
