From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] management tarballs release
Date: Mon, 2 Nov 2009 02:44:18 +0200
Message-ID: <20091102004418.GB1153@me>
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

5a77490e7f604043f5f902e4e4f5d056  libibumad-1.3.3.tar.gz
5f2615fc152cc6dacdca694c16594351  libibmad-1.3.3.tar.gz
0a50e041932b4abf240c8d4a519e59a4  opensm-3.3.3.tar.gz
2454d7f1103bfaa8692c759332639c3c  infiniband-diags-1.5.3.tar.gz

All component versions are from recent master branch. Full change log is
below.

Sasha


Al Chu (9):
      libibnetdisc cleanup patches
      fix libibnetdisc API consistency and bugs
      fix libibnetdisc API consistency and bugs
      fix libibnetdisc API consistency and bugs
      fix libibnetdisc API consistency and bugs
      fix libibnetdisc API consistency and bugs
      fix libibnetdisc API consistency and bugs
      split out ibnd_fabric_t fields that are only used during a scan
      remove 'dist' field from ibnd_node_t, which was virtually not used

Dale Purdy (1):
      Add LMC support to DOR routing

Doron Shoham (3):
      saquery: fix -c arguement
      osm_port.c: check if op_vls = 0 before max_op_vls comparison
      ibportstate: fixes for width option

Eli Dorfman (Voltaire) (6):
      opensm/osm_lid_mgr.c bug in opensm LID assignment
      infiniband-diags: Do not change port state on SubnSet
      infiniband_diags/ibportstate.c perform reset in a single mad
      opensm/osm_sa.c add attribute and component mask to error message
      opensm/osm_sa_node_record.c use comp mask to match by LID or GUID
      Fix IB network discovery from switch node.

Hal Rosenstock (127):
      opensm/PerfMgr: Change redir_tbl_size to num_ports for better clarity
      opensm: Add SuperMicro to list of recognized vendors
      infiniband-diags/saquery.c: Display attribute ID in hex rather than decimal
      opensm: Changes to spec and make files for updated release notes
      libibmad: Add support for SA PathRecord SL field
      opensm/PerfMgr: Remove some underbars from internal names
      infiniband-diags/ibnetdiscover.c: Cosmetic formatting changes
      opensm/PerfMgr DB: Remove leading underscores from internal names
      opensm/osm_perfmgr_db.c: Remove unneeded initialization in perfmgr_db_print_by_name
      opensm/PerfMgr: Cosmetic changes
      opensm/osm_port.c: Remove error number from debug level log message
      opensm/PerfMgr: Reduce host name length
      opensm/osm_port.c: Change log level of Invalid OP_VLS 0 message to VERBOSE
      infiniband-diags/ibdiag_common.c: Eliminate compile warning on x86_64 archs
      libibmad/resolve.c: Determine SL properly
      opensm/osm_mesh.c: Use define rather than hard coded constant
      opensm/osm_ucast_lash.c: Fix commentary typo
      opensm/osm_ucast_lash.c: Use calloc rather than malloc/memset
      libibmad/resolve.c: Remove compile warning on x86_64 arch
      opensm/osm_ucast_lash.(h c): Replace memory allocation by array
      opensm/osm_ucast_lash.c: Remove some unused code
      opensm/libvendor/osm_vendor_(ibumad mlx)_sa.c: Handle malloc failure in __osmv_send_sa_req
      opensm/man/osmtest.8: Update email address
      infiniband-diags/ibroute.c: Fix format and typo in printf
      opensm/osmtest: Fix some typos
      opensm/osm_ucast_mgr.c: Add error numbers to some error log messages
      opensm/osm_sa_(path multipath)_record.c: Fix typo in a couple of log messages
      opensm/osm_mcast_tbl.c: In osm_mcast_tbl_init, use calloc
      opensm/osm_switch.c: In osm_switch_prepare_path_rebuild, use realloc
      opensm/osm_ucast_ftree.c: Made error numbers unique in some log messages
      infiniband-diags/README: Update saquery dependencies
      opensm/osm_qos_policy.c: Use proper size in malloc in osm_qos_policy_vlarb_scope_create
      opensm/osm_qos_policy.c: Use calloc rather than malloc/memset
      infiniband-diags/ibtracert.c: Fix comparison to SwitchInfo.MulticastFDBCap in switch_mclookup
      infiniband-diags/ibroute.c: Fix typo in IBWARN message
      opensm/osm_mesh.c: Improve VL utilization
      infiniband-diags/ibtracert.c: Fix linearcap test in switch_lookup
      opensm/lash: Set minimum VL for LASH to use
      opensm/main.c: Display LASH start VL when specified
      opensm/osm_subnet.c: Format lash_start_vl consistent with other uint8 items
      opensm/osm_ucast_lash.c: Minor cleanups
      opensm: Add ability to configure SMSL
      opensm/main.c: Display SMSL when specified
      libibmad/mad.c: Validate DR hop count for SMPs and handle errors
      opensm/osm_ucast_lash.c: Handle malloc failures better
      opensm/osm_lash: Fix use after free problem in osm_mesh_node_delete
      opensm/ib_types.h: Update ib_mad_is_response description
      opensm: osm_dr_path_extend can fail due to invalid hop count
      opensm/osm_path.h: In osm_dr_path_init, only copy needed part of path
      opensm/osm_ucast_lash.c: Remove osm_mesh_node_delete call from switch_delete
      opensm/osm_path.h: Fix osm_dr_path_extend return values comment
      opensm/osm_helper.h: Fix some commentary typos
      opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, indicate failed attribute
      infiniband-diags/ibnetdiscover.8: Add max hops option
      opensm/osm_trap_rcv.c: Use proper flag name in comment
      infiniband-diags/ibsendtrap.c: Fill in capability mask on trap 144
      opensm/osm_ucast_lash.c: Added error numbers to some error log messages
      opensm/osm_ucast_lash.c: Directly call calloc/free rather than create/delete_cdg
      opensm/osm_lin_fwd_rcv.c: Commentary change
      infiniband-diags/ibsendtrap.c: Add support for link_speed_enabled_change trap
      opensm/osm_ucast_lash.c: Handle calloc failure in generate_cdg_for_sp
      opensm/osm_trap_rcv.c: Validate trap is 144 before checking for NodeDescription changed
      opensm/osm_mesh.c: Reorder switches for lash
      opensm/osm_mesh.h: Fix SFW copyright
      opensm/osm_qos_policy.c: Some minor simplifications
      opensm/osm_mcast_tbl.c: In osm_mcast_tbl_get_block, eliminate unneeded check
      infiniband-diags/saquery.c: Fix typo in option name
      opensm/osm_sm_mad_ctrl.c: Fix endian of status in error message
      opensm/osm_helper.c: In osm_dump_dr_smp, fix endian of status
      opensm/libvendor/osm_vendor_ibumad.c: Handle umad_alloc failure in osm_vendor_get
      infiniband-diags/saquery.c: Fix CHECK_AND_SET_VAL macro
      infiniband-diags/saquery.c: Allow pkey and qkey to be hidden
      opensm: Parallelize (Stripe) LFT sets across switches
      opensm/osm_helper.c: Only change method when > rather than >=
      opensm/osm_helper.c: Add SM priority changed into trap 144 description
      opensm/osm_ucast_lash.c: In lash_core, return status -1 for all errors
      libibmad: Add support for MulticastFDBTop
      opensm/ib_types.h: Add CounterSelect2 field to PortCounters attribute
      infiniband-diags/perfquery.c: Indicate whether PortXmitWait counter is supported
      opensm: Add infrastructure support for MulticastFDBTop
      infiniband-diags/ibroute: Add support for MulticastFDBTop
      opensm: Parallelize (Stripe) MFT sets across switches
      opensm/osm_base.h: Add new SA ClassPortInfo:CapabilityMask2 bit allocations
      opensm doc: Indicated limited (rather than partial) partition membership
      opensm/opensm.8.in: Cosmetic formatting change
      opensm/opensm.8.in: Indicate default rule for Default partition
      infiniband-diags/ibportstate: Support changing of link width
      opensm/osm_inform.c: For traps 64-67, use GID from DataDetails in log message
      opensm: Add infrastructure support for more newly allocated PortInfo CapabilityMask bits
      libibmad/dump.c: In mad_dump_portcapmask, decode new capabilities
      libibmad/mad.h: Add a couple of SM class attribute IDs
      osmtest: Add SA get PathRecord stress test
      opensm/osm_perfmgr_db.c: Fix memory leak of db nodes
      libibmad/dump.c: Fix typo
      opensm/osm_mesh.c: Remove edges in lash matrix
      infiniband-diags/ibportstate.c: Eliminate uninitialized variable compile warning
      opensm/osm_mesh.c: Add dump_mesh routine at OSM_LOG_DEBUG level
      opensm/osm_lid_mgr.c: Fix typo in OSM_LOG message
      opensm/osm_pkey.c: Cosmetic changes
      opensm/osm_mcast_mgr.c: In mcast_mgr_set_mft_block, fix node GUID in log message
      opensm/osm_mcast_tbl.c: Cosmetic changes
      opensm: Reduce heap consumption by unicast routing tables (LFTs)
      infiniband-diags/saquery.c: Modify dump_path_record
      opensm: Add infrastructure support for PortInfo IsMulticastPkeyTrapSuppressionSupported
      opensm/ib_types.h: Mask off client rereg bit in set_client_rereg
      opensm/osm_mesh: Cosmetic changes
      opensm/release notes: Fix typo
      opensm/osm_ucast_updn.c: Reduce temporary allocation of cas_per_sw
      opensm/osm_subnet.h: Add mgrp_mgid_tbl description
      opensm/osm_mcast_mgr.c: Cosmetic changes
      opensm/osm_lid_mgr.c: Cosmetic commentary changes
      opensm/osm_ucast_updn.c: Further reduction in cas_per_sw allocation
      opensm/osm_sa_mcmember_record.c: Make mcmr_rcv_create_new_mgrp static function
      opensm: Add some additional HP vendor IDs/OUIs
      opensm/osm_vendor_api.h: Fix some commentary typos
      opensm/osm_sm_state_mgr.c: Cosmetic formatting changes
      opensm: Cosmetic changes
      opensm/osm_ucast_cache.c: Eliminate unneeded define
      opensm/osm_mcast_tbl.(h c): Make max_mlid_ho be maximum MLID configured
      infiniband-diags/ibqueryerrors.c: Cosmetic changes
      opensm: Reduce heap consumption by multicast routing tables (MFTs)
      libibmad: Add support for PortXmitDiscardDetails
      infiniband-diags/perfquery: Add support for optional PortXmitDiscardDetails counter
      opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS rather than UMAD_CA_MAX_AGENTS
      opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, set init failure on PKeyTable and QoS initialization failure
      opensm: Add configurable retries for transactions
      opensm/osm_trap_rcv.c: Minor reorganization of trap_rcv_process_request

Ira Weiny (45):
      Create a new library libibnetdisc
      Convert iblinkinfo.pl to C and use new ibnetdisc library.
      clean up iblinkinfo conversion
      Convert ibnetdiscover to use new ibnetdisc library
      libibnetdisc: change ibnd_discover_fabric to receive ibmad_port
      Add mad_field_name function
      Convert ibqueryerrors.pl to C and use new ibnetdisc library.
      ibqueryerrors: switch_guid_str is required for the string resolve function.
      Fix reversal of DRSLID and DRDLID in MAD_FIELDS enum.
      Add combined routing support to libibnetdisc
      Modify '-S' option of iblinkinfo and ibqueryerrors to do a limited scan of the
      Fix 2 formatting diff's from old ibqueryerrors.
      Clean up printing of switch heading when printing "down links" only.
      Move _with_node_name_map rpm spec option from infiniband-diags to opensm.
      ibnetdiscover: only report max hops discovered when requested
      iblinkinfo, ibqueryerrors: prevent core when switch is not found
      iblinkinfo: remove unused file pointer.
      iblinkinfo: convert to ibdiag_process_opts
      ibqueryerrors: fix custom opts string
      iblinkinfo: optomize -D operation
      ibqueryerrors: optomize -D operation
      ibprintca.pl: fix corner case: print switch information for CA's found at the end of the cache file.
      iblinkinfo, ibqueryerrors: clean up ibdiag_process_opts call
      Fix error return code from mad_send_via
      Add ib_resolve_gid_via and make portid an out only parameter of ib_resolve_portid_str_via
      libibmad: Ensure the proper length is passed into umad_recv on each call
      opensm: remove extra "0x" from debug message.
      infiniband-diags/libibnetdisc: fix DBGFLAGS variable
      libibmad: clear packet buffer correctly before formating and sending
      libibnetdisc: fix potential memory leak of port object
      infiniband-diags/libibnetdisc: remove all IBPANIC's and clean up error handling
      libibmad: make accessors function for timeout values used in libibmad
      libibmad: make accessors function for retry values used in libibmad
      libibnetdisc: make all fields of ibnd_node_t public
      libibnetdisc: make all fields of ibnd_port_t public
      libibnetdisc: make all fields of ibnd_fabric_t public
      opensm/complib: account for nsec overflow in timeout values
      infiniband-diags/libibnetdisc: add missing '\n' to error message
      libibnetdisc: add retract_dpath function
      infiniband-diags/src/ibqueryerrors.c: fix bug when attempting a sub-fabric scan
      infiniband-diags/src/ibqueryerrors.c: Remove --all option and replace it with --switch, --ca, --router
      opensm/opensm/osm_subnet.c: adjust buffer to ensure a '\n' is printed
      infiniband-diags/libibnetdisc/ibnetdisc.c: fix bug in single node processing.
      infiniband-diags/src/ibqueryerrors: Add clear errors and counters options
      infiniband-diags/ibqueryerrors: Use remap'ed node name in clear port error message

Jason Gunthorpe (1):
      Clarify the syntax of the hop_weights_file

Joachim Fenkes (1):
      libibmad: Handle MAD redirection

Keshetti Mahesh (3):
      infiniband-diags/: Cosmetic changes, mostly typos
      'ibcheckportwidth' : Exit if LWS is 1X
      infiniband-diags/libibnetdisc: Removed trivial comments

Line.Holen-UdXhSnd/wVw@public.gmane.org (7):
      opensm/osm_ucast_ftree.c Increase the size of the hop table
      osm_sa_patch_record.c Remove unneeded break statement
      osm_dump.c dump port if lft is set up
      osm_ucast_ftree.c Count number of hops instead of calculating it
      opensm: Add new Sun vendor ID
      opensm/osm_ucast_ftree.c Fix assert comparing number of CAs to CN ports
      osm_ucast_ftree.c missing reset of ca_ports

Nicolas Morey-Chaisemartin (9):
      management: Fixed custom_release in SPEC files
      OpenSM: include/vendor/osm_vendor.h - Replaced #elif with no condition by #else
      infiniband-diags: Added libibnetdiscover to .spec file
      opensm/osm_ucast_ftree.c: Enhanced Fat-Tree algorithm
      opensm/osm_ucast_ftree.c: Fixed issue with reverse_hops introduced by commit 1d7dd18b531c1d6370f80cc7303493d6f3e3e777.
      opensm/osm_ucast_ftree.cd: Added support for same level links
      osm_ucast_ftree.c: Removed reverse_hop parameters from fabric_route_upgoing_by_going_down
      osm_ucast_ftree.c: Cleaned up many comments
      osm_ucast_ftree.c: Applied osm_indent

Sasha Khapyorsky (117):
      ibnetdiscover: fix types to avoid portability castings
      infiniband-diags: cosmetic fixes
      infiniband-diags: remove not used ibnetdiscover.h
      ibdiag_common: remove duplicated ibdebug variable
      Merge branch 'pq/ibn4'
      libibumad: keep port capmask as 32-bit variable
      ibstat.c: use htohl() for 32-bit capmask conversion
      opensm/osm_sa_node_record.c: simplify flows
      opensm/osm_ucast_ftree.c: indentation fixes
      opensm: sweep component processors return status value
      opensm/osm_sminfo_rcv.c: clean type of smi_rcv_process_get_sm()
      complib/Makefile.am: prevent file duplications
      libibnetdisc/Makefile.am: add internal.h to SOURCES list
      infiniband-diags/libibnetdisc: add man pages to EXTRA_DIST
      opensm: find MC group by MGID using fleximap
      opensm/osm_sm.c: code consolidation
      opensm/osm_mcst_mgr.c: check number of switches only once
      opensm/osm_macst_mgr.c: merge functions
      opensm/main.c: indentation fixes
      bibnetdisc/ibnetdisc.c: fix parameter incompatibility warning
      infiniband-diags/ibnetdiscover: remove not used var
      libibmad: use NULL as null pointer
      opensm/osm_req.c: indentation fixes
      infiniband-diags/man: break long lines
      infiniband-diags/ibsendtrap.c: fix array size
      infiniband-diags/ibsendtrap.c: code consolidation
      libibnetdisc/ibnetdisc.c: typo fix
      libibnetdisc: indentation fixes
      infiniband-diags/ibportstate.c: consolidate flows
      infiniband-diags/ibportstat.c: simplify conditions
      infiniabnd-diags: indentation fixes
      libibumad: indentation fixes
      libibmad: fix warnings
      libibmad: indentation fixes
      libibnetdisc: fix again typo in dump_node()
      complib/cl_event.c: change nanosec var type long
      complib: indentation fixes
      complib: format comment blocks
      opensm/osm_ucast_mgr.c: simplify fwd tables setup flow
      opensm/osm_ucast_mgr: better lft setup
      opensm/osm_ucast_mgr.c: better function names
      opensm/osm_ucast_mgr.c: move fwd tables setup function
      infiniband-diags/perfquery: indentation fixes
      libibnetdisc: fix compilation warning
      infiniband-diags/ibroute: minor flow optimization
      opensm: use mgrp pointer in port mcm_info
      opensm: use mgrp pointer as osm_sm_mcgrp_join/leave() parameter
      opensm: remove not used osm_mgrp_apply_func() function
      opensm: improve multicast re-routing requests processing
      opensm/multicast: remove change id tracking
      opensm/osm_mcast_mgr.c: multicast routing by mlid - renaming
      opensm/osm_mcast_mgr.c: almost cosmetic
      opensm/osm_sa_mcmember_record.c: cosmetic
      opensm/multicast: kill mc group to_be_deleted flag
      opensm/osm_ucast_ftree.c: indentation fixes
      opensm/osm_multicast.[hc]: cosmetic changes
      opensm/osm_prtn.c: minor improvements
      opensm/osm_multicast: remove unused osm_mcast_mgr_ctxt_t
      opensm: fix uninitialized return value in osm_sm_mcgrp_leave()
      opensm: port object reference in mcm ports list
      opensm/multicast: consolidate port addition/removing code
      opensm/multicast: merge mcm_port and mcm_info
      opensm/osm_sa_node_record.c: dump NodeInfo with debug verbosity
      opensm: remove not used osm_mcm_info.[ch] files
      opensm/multicast: consolidate osm_mgrp_cleanup() calls
      opensm/osm_notice.c: move logging code to separate function
      opensm/osm_sa_mcmember_record.c: clean uninitialized variable use
      opensm/osm_prtn.c: cosmetic
      opensm/multicast: improve function prototypes
      opensm/osm_sa_path_record.c: validate multicast membership
      opensm: discard multicast SA PR with wildcard DGID
      opensm: osm_get_port_by_lid() helper
      opensm/osm_ucast_lash: fix use after free bug
      infiniband-diags/ibqueryerrors: simplify node_type_to_print setup.
      opensm/osm_mesh.c: remove some castings
      opensm/osm_helper.c: fix compiler warning
      opensm/osm_mesh.c: simplify compare_switches() function
      opensm/osm_get_port_by_lid(): use faster cl_ptr_vector_get()
      opensm/osm_get_port_by_lid(): speedup a port lookup
      opensm/osm_get_port_by_lid(): don't bother with lmc
      opensm: fix some obvious -Wsign-compare warnings
      opensm/osm_helper: remove meanless 'const' keywords
      opensm: fix endless looping in mcast_mgr
      opensm/osm_qos_parser_y.y: fix endless loop
      opensm: remove meanless 'const' keywords in APIs
      opensm: fix gcc-4.4.1 warnings
      opensm/osm_helper.c: fix indentations
      opensm/osm_sa_path_record.c: separate router guid resolution code
      osmtest: initialize attr_array[] on declaration
      osmtest/osmtest.c: remove strings.h inclusion
      opensm/osm_state_mgr.c: in cleanup_switch() check only relevant LFT part
      opensm/osm_ucast_cache: reduce OSM_LOG_INFO debug printouts
      opensm: fix LFT allocation size
      osmtest/osmt_multicast: kill some duplications
      osmtest/osmt_multicast.c: cleanups
      infiniband-diags: minor cosmetic fixes
      infiniband-diags/ibqueryerrors.c: use common portid in query_cap_mask()
      infiniband-diags/ibqueryerrors.c: use common node_name
      opensm: make subnet's max mlid update implementation independent
      osmtest/osmt_multicast.c: fix strict aliasing breakage warning
      libibmad: fix strinct-aliasing breakage warnings
      opensm/osm_mcast_mgr: simplify alloc_mfts()
      opensm/osm_mcast_tbl: remove redundant checks
      opensm/mcast_tbl: set max_mlid_ho as actually configured mlid
      libibnetdisc: rename ibnd_scan variable to scan
      libibnetdisc: some cleanups
      opensm/osm_mcast_tbl: fix max_mlid_ho setup
      infiniband-diags/perfquery: merge some code
      opensm/osm_mcast_tbl: fix mlid removal
      opensm/link_mgr: verify port's lid
      opensm/osm_trap_rcv.c: Improvements in log_trap_info()
      management: update/add Voltaire copyright
      opensm_release_notes-3.3.txt: align formatting
      opensm_release_notes-3.3: remove OFED dependency
      opensm_release_notes-3.3: add newest features/fixes
      management: update libraries version information
      management: bump package versions

Sean Hefty (9):
      ib-mgmt/ibn3 branch: diags updated for continued windows support
      ib-mgmt/ibn3 branch: libibmad update for windows support
      ib-mgmt/ibn3 branch: libibmad: remove ib_resolve_guid function prototype
      ib-mgmt/ibn3 branch: libibnetdisc add windows support
      ib-mgmt/libibmad: export ibdebug
      ib-mgmt: fixup ibsendtrap for windows
      ib-mgmt/libibnetdisc: fix typecast warning
      libibmad/rpc: fix build warning casting from uint32 to uint8
      libibmad/resolve: add include to pick up inet_pton

Smith, Stan (1):
      C++ style coding does not compile

Stan C. Smith (14):
      update osm_db_files.c & osm_pack.c functions to match .h prototypes
      update functions to match .h prototypes
      use standard varargs syntax in macro OSM_LOG()
      osm_helper.c use explicit value for struct init
      osm_sa.c - void * arithmetic causes problems
      cast to remove warnings about signed vs. unsigned comparisons
      cast to remove compiler warning.
      osmtest - clarify assignment operation
      osmtest - fix signed unsigned comparisons
      osmtest -code cleanup - use strncasecmp()
      osmtest - code cleanup
      use transportable constant attributes
      remove extraneous Windows include
      opemsm code cleanup

Vincent Ficet (1):
      Duplicated file man/umad_get_mad.3 in libibumad/Makefile.am

Yevgeny Kliteynik (8):
      opensm: do not configure MFTs when mcast support is disabled
      opensm/osm_helper.c: fix printing trap 258 details
      opensm: fixing handling of opt.max_wire_smps
      opensm: fixing some data types in osm_req_get/set
      opensm/osm_qos_policy.c: matching PR query to QoS level with pkey
      opensm/osm_ucast_updn.c: cosmetics - rename function
      opensm/osm_sa.c: don't ignore failure in osm_mgrp_add_port()
      opensm/osm_sa_mcmember_record.c: optimization in zero mgid comparison

sebastien dugue (1):
      infiniband-diags/ibnetdiscover: Add separator when printing chassis type

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
