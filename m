From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Thu, 2 Aug 2012 12:17:19 +0300
Message-ID: <20120802091719.GB3374@calypso>
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

md5sum: ad4c179c119bbb78be740e33b59746ad opensm-3.3.15.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (2):
      opensm: Add initial congestion control configuration support
      opensm/osm_congestion_control.c: Fix initialization hex string

Alex Netes (18):
      opensm: fix locking in osm_guid_mgr_process
      opensm: fix part_enforce parameter parsing crash
      opensm: Move per_mod_log_tbl array from subn to log structure
      Add support to reread configuration file when stacked in rediscovery loop.
      Fixed Multicast precreation parsing
      Fix deadlock between sminfo_set_req() and osm_sm_state_mgr()
      Fix SL2VL configuration
      Fix base port0 sl2vl mapping optimization
      Fix pre-creation of MC group with MGID containing P_Key
      Fix crash in ucast cache when ucast cache invalidates after updating one of the switches
      Fix crash in ucast cache when chain of switches connected back at once to the fabric
      Fix transaction id casting
      Skip TID 0 on 32 bit wraparound for SMP, SA and PerfMgt queries
      Increase p_port->discovery_count only when received PortInfo for port 0 of the switch
      Call drop manager before checking for other Master SM in the fabric
      opensm: update shared library versions
      opensm_release_notes-3.3: update
      opensm: packages versions update

Bart Van Assche (1):
      opensm: Fix pthread_create() return value checks

Daniel Klein (1):
      opensm/osmtest: fix osmtest ignores timeout parameter

Hal Rosenstock (52):
      opensm/osm_ucast_ftree.c: Add a couple of asserts
      opensm/include/opensm/osm_log.h: Fix commentary cut 'n paste error
      opensm/complib/cl_fleximap.h: Cosmetic changes
      opensm/osm_ucast_dfsssp.c: Use osm_log_is_active
      opensm/opensm_release_notes-3.3.txt: Update Unsupported IB Compliance Statements
      opensm/osm_subnet.c: Fixed ftree/updn configuration failure when root_guid_file points to non-existing file
      opensm: Add partition manager configuration doc to docs
      opensm: Cosmetic changes
      opensm: Add per module logging support
      opensm: Add enum for FILE_ID for per module logging
      opensm/osm_vendor_ibumad.c: Make binding log message clearer
      opensm/osm_port.h: Fix commentary typo
      opensm: Dump info functions update for per module logging
      opensm/osm_state_mgr.c: Force subn->need_update when coming out of STANDBY
      opensm: Eliminate unneeded field in DR path structure
      opensm/osm_node_info_rec.c: Also handle non compliant SMA in ni_rcv_process_existing
      opensm/osm_subnet.c: Support MLNX ExtendedPortInfo for ConnectIB device
      opensm/main.c: Handle daemon mode with guid specified as 0 more gracefully
      opensm/libopensm.map: Removed unimplemented routine
      opensm/osm_subnet.c: Indicate lmc and lmc_esp0 are not changeable "on the fly"
      opensm/osm_node_info_rcv.c: In ni_rcv_process_existing_ca_or_router, handle error
      opensm/osm_sa_mad_ctrl.c: Eliminate commented out code line
      opensm/osm_trap_rcv.c: Add better logging for traps 257 and 258
      opensm/osm_inform.c: Make log message format consistent for error messages
      opensm/osm_sa_inform_info.c: Fix some error log messages
      opensm/osm_trap_rcv.c: Remove vestigial comment
      opensm/osm_sa_path_record.c: Add missing end-of-line in the log message
      opensm/osm_madw.h: Fix a couple of cut 'n paste commentary errors
      opensm/ib_types.h: Add CapabilityMask2 to notice for trap 144
      opensm/osm_helper.c: Add CapabilityMask2 to notice dump for trap 144
      opensm/cl_atomic_osd.h: Cosmetic formatting change
      opensm/torus-2QoS: Fix some typos in documentation
      opensm/osm_link_mgr.c: Set PortInfo:PortState to LinkDown when remote port isn't accessible
      opensm/osm_subnet.c: Cosmetic formatting change
      opensm/osm_sa_mcmember_record.c: Dump MCMemberRecord in mcmr_query_mgrp
      opensm/osm_sa_mcmember_record.c: In mcmr_rcv_join_mgrp, add MGID to log message
      opensm/osm_sa_path_record.c: Add debug logging to pr_match_mgrp_attributes
      opensm/osm_sa_path_record.c: Log requester port GUID at DEBUG level
      opensm/osm_sa_mcmember_record.c: Log requester port GUID at DEBUG level
      opensm/osm_sa*.c: Log requester port GUID at DEBUG level
      opensm/osm_vendor_ibumad: Add management class into match criteria
      opensm/osm_node_info_rcv.c: Handle non-compliant SMA gracefully
      opensm: Remove unused per_module_logging option
      opensm/osm_perfmgr.c: Eliminate compile warning
      opensm: Support (null) being specified for per_module_logging_file option
      opensm/osm_sa_path_record.c: Restore osm_get_path_params functionality
      opensm/osm_perfmgr.c: Use non conflicting error codes in log messages
      opensm/osm_congestion_control.c: Skip TID 0 on 32 bit wraparound
      opensm/osm_base.h: Add some SA ClassPortInfo CapabilityMask2 bits
      opensm/osm_sa_class_port_info.c: Indicate support for PortInfo CapMask2 matching in SA ClassPortInfo:CapabilityMask2
      opensm: Add support for multicast service records
      osmtest/osmtest.c: Fix permissions

Ira Weiny (13):
      opensm/perfmgr: Add config option to ignore Channel Adapters.
      opensm/console: protect against 0 entered for the perfmgr sweep_time
      opensm: perfmgr fix dump_counters
      opensm: perfmgr delete "inactive" nodes from the DB
      opensm: perfmgr mark inactive nodes in perfmgr db
      opensm/console: add "print all" to print_counters console command
      opensm/console; add port option to perfmgr print_counters
      opensm/console: add abreviations for perfmgr commands
      opensm/console: Add human readable output for perfmgr data counters
      opensm/console: add perfmgr "print_errors" (pe) console command.
      opensm/perfmgr: add logging of error counters
      opensm/perfmgr: fix endian conversion of PortCounters
      opensm/perfmgr: update new error codes to '54' prefix

Jim Foraker (10):
      opensm: Add guid2mkey cache file support
      opensm: Allow recovery of subnets with misset mkeys
      opensm: Add locking where necessary around osm_req_*
      opensm: Add support for setting mkey protection levels
      opensm: Log errors on SubnGet timeouts
      opensm: Add neighboring link cache file
      opensm: Check for valid mkey protection level in config file
      opensm: Ensure sweep interval/mkey lease are sensibly set
      opensm/scripts/sldd.sh: Update to support guid2mkey/neighbors
      opensm/man/opensm.8.in: Add section for MKey support

Vladimir Koushnir (3):
      Fixed crash in sm_state_mgr_send_master_sm_info_req() during fabric merge
      Fixes in SL2VL table distribution algorithm
      Sending SL2VL and VLARB SET MADs in distributed manner

Yevgeny Kliteynik (1):
      opensm: Fix crash found with ucast cache

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
