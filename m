From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Sun, 13 Dec 2009 22:12:27 +0200
Message-ID: <20091213201227.GR5262@me>
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

md5sum:

1281c3497086f3348b8ede7c3c5dcacf  libibumad-1.3.4.tar.gz
02d0c65079c067e0e933c4822dad8b28  libibmad-1.3.4.tar.gz
ad3f5181f9e8c91de73c0165212f11ea  opensm-3.3.4.tar.gz
7a784405b8c3e4766c543658da5da7f4  infiniband-diags-1.5.4.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Sasha


Al Chu (8):
      remove unused headers in libibnetdiscover
      remove ibnd_update_node
      consistently type lids and lmcs libibnetdisc
      fix potential segfault in ibnd_node_t destroy path
      split out scan specific data from ibnd_node_t [attempt #2]
      remove unnecessary casting in libibnetdiscover
      use nodes/switches lists instead of nodesdist array in libibnetdiscover
      splice out chassis scan specific from general scan in libibnetdiscover

Doron Shoham (1):
      Add different print macros

Eli Dorfman (Voltaire) (1):
      infiniband-diags/saquery: Report SA MAD Class specific status.

Hal Rosenstock (23):
      opensm/main.c: Use strtoul rather than strtol for parsing transaction timeout
      opensm/osm_mcast_tbl: Fix size of port mask table array
      opensm/osm_mcast_tbl.c: In osm_mcast_tbl_clear_mlid, use memset to clear port mask entry
      opensm/osm_switch.h: Remove dead osm_switch_get_physp_ptr routine
      infiniband-diags/ibqueryerrors: Add support for PortXmitDiscardDetails
      opensm/ib_types.h: Fix some commentary typos
      opensm/osm_base.h: Update IBA reference to use 1.2.1
      opensm: Only clear SMP beyond end of PortInfo attribute
      infiniband-diags/ibsendtrap.c: Add support for SysImageGuid changed trap (145)
      opensm/osm_link_mgr.c: Fix IBA reference for PortInfo attribute
      infiniband-diags/saquery.c: Change lids and port numbers to decimal
      libibmad: Add support for new PortInfo:McastPkeyTrapSuppressionEnabled field
      opensm: Cosmetic changes
      opensm/osm_ucast_ftree.c: Cosmetic commentary changes
      opensm/libvendor/osm_vendor_ibumad.c: Cosmetic change to OSM_LOG message
      opensm/osm_vendor_api.h: Fix commentary typo
      opensm/complib/cl_event.c: Cosmetic changes
      opensm/osm_vl15intf.c: Cosmetic commentary change
      opensm/osm_sm_mad_ctrl.c: Fix qp0_mads_accounting
      opensm/osm_trap_rcv.c: Eliminate heavy sweep on receipt of trap 145
      opensm/osm_vendor_ibumad.c: Change LID format to decimal in log message
      opensm/osm_sm_mad_ctrl.c: Make some minor simplifications
      opensm/osm_sm_mad_ctrl.c: Add missing call to return mad to mad pool

Ira Weiny (9):
      infiniband-diags/ibnetdisc.h: Clarify "ports" member of ibnd_node_t with more descriptive comment
      OpenSM: Fix unused variable compiler warning.
      infiniband-diags/ibqueryerrors: Reformat the output of the xmtdiscard details.
      infiniband-diags/libibnetdisc: clean up PortInfo queries
      infiniband-diags/libibnetdisc: Remove nearly duplicate "get_node_info" function
      infiniband-diags/ibqueryerrors: Fix remote node name printing
      infiniband-diags/ibqueryerrors: Change realloc of suppressed fields to a static array
      infiniband-diags/ibqueryerrors: Properly exit and clean up resources when node info query fails
      libibmad: libibumad: Print warnings and errors to stderr not stdout

Keshetti Mahesh (1):
      opensm/: Removed empty comments

Line Holen (8):
      opensm/osm_state_mgr.c Added more info to some error messages
      opensm/osm_ucast_ftree.c Changed log level
      opensm/osm_helper.c Log format changes
      opensm/osm_vl15intf.c Log change
      opensm/osm_sm_mad_ctrl.c Changes to some error messages
      opensm/osm_vendor_ibumad.c: Move error info into single message
      opensm/osm_vendor_ibumad.c: Move error info into single message
      opensm: Added print_desc to various log messages

Michael Reed (1):
      opensm/main.c: opensm cannot be killed while asking for port guid

Sasha Khapyorsky (39):
      opensm/osm_sa_path_record.c: flow simplification
      opensm/osm_trap_rcv.c: some simplification
      opensm/osm_trap_rcv.c: use source_lid and port_num for logging
      opensm/osm_trap_rcv.c: some consolidation
      libibnetdisc: remove man page of removed API
      opensm/partition: keep multicast group pointer
      opensm/osm_mcast_mgr.c: fix return value on alloc_mfts() failures
      infiniband-diags/ibqueryerrors: minor improvements
      opensm/main.c: kill unneeded braces
      opensm: cleanup intn_t uses
      complib/fleximap: make compar callback to return int
      opensm/osm_mgrp_new(): add subnet db insertion
      opensm/osm_console.c: make const functions
      opensm/osm_perfmgr_db.c: remove casting
      opensm: remove braces around value in return statements
      osmtest/osmt_mtl_regular_qp.c: cleaning uintn_t use
      complib: replace intn_t types by C99 intptr_t
      opensm/osm_sa_mcmember_record.c: move mgid allocation code
      opensm/osm_sa_member_record.c: mlid independent MGID generator
      opensm/osm_mcast_mgr.c: cosmetic fixes
      osm_sa_mcmember_record.c: pass MCM Record data to mlid allocator
      complib/cl_fleximap: add cl_fmap_match() function
      opensm: compress IPV6 SNM groups to use a single MLID
      opensm: osm_get_mgrp_by_mgid() helper
      opensm/osm_ucast_mgr.c: fix memory leak
      libibmad: remove repeated comment
      complib/cl_fleximap.h: fix comment typo
      opensm: IPv6 SNM update for man page and usage
      opensm/osm_db_files.c: add '/' path delimited
      opensm/osm_base.h: remove trailing '/' in OSM_DEFAULT_CACHE_DIR
      opensm/osm_db_files.c: kill useless malloc() castings
      opensm/osm_trap_rcv.c: some cleaning
      opensm/osm_state_mgr.c: cosmetic
      opensm/osm_sm_mad_ctrl.c: minor optimizations
      opensm/osm_sa.c: check for SA DB file only if requested
      opensm/osm_vendor_ibumad.c: dump DR path at same log level as its error message
      opensm_release_notes-3.3.txt: updates for 3.3.4 version
      management: update library versions
      management: package versions bump

Slava Strebkov (1):
      osm_mgrp_box: infrastructure for mgid compression

Stan C. Smith (5):
      osmtest - code cleanup: remove Windows specific items.
      opensm - remove useless goto
      opensm - use C99 transportable data type for pointer storage
      remove unnecessary leading '/' from filename
      opensm - standardize on a single Windows #define - take #2

Yevgeny Kliteynik (15):
      opensm/osm_sa_mcmember_record.c: fsmall code optimization
      opensm: copyright updates
      opensm: copyright updates
      opensm/osm_state_mgr.c: do not probe remote side of port 0
      opensm/complib: bug in cl_list_insert_array_head/tail functions
      opensm/include/iba/ib_types.h: adding Congestion Control definitions
      opensm/osm_subnet.c: fixing bug in dumping options file
      opensm/osm_vendor_mlx_txn.c: eliminate bunch of compilation warnings
      opensm/osm_vendor_mlx: fix compilation error
      opensm/osm_sa_mcmember_record.c: print mcast join/create failures in VERBOSE instead of DEBUG level
      opensm/osm_sa_mcmember_record.c: trivial optimization
      opensm/libvendor//osm_vendor_ibumad_sa.c: uninitialized fields
      opensm: implement 'connect_roots' option in fat-tree routing
      opensm SA DB dump/restore: load SA DB only once
      opensm SA DB dump/restore: added option to dump SA DB on every sweep

elid (1):
      opensm: Return single PathRecord for SubnAdmGet with DGID/SGID wild carded

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
