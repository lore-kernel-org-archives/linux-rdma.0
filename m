From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Fri, 2 Sep 2011 20:47:43 +0300
Message-ID: <20110902174743.GA2955@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
80ae77e919111761f022c10ca1405db3  opensm-3.3.11.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert L. Chu (4):
      Fix invalid error check, which lead to segfault
      fix segfault corner case w/ updn routing and LMC > 0
      Support port shifting.
      Cleanup scatter ports patch.

Alex Netes (28):
      Makefile: ChangeLog and version generation script path fix
      opensm: fixed getline pointer allocation free in osm_console_io
      opensm: fixed indentation and decreased verbosity of RMPP length message
      opensm: fixed memory leak in multicast spanning tree calculation
      opensm_release_notes-3.3: update
      opensm: update shared library versions
      opensm: packages versions update
      opensm_release_notes-3.3: update
      opensm: packages versions update
      Ignore command line option -timeout 0
      opensm: removed unnecessary checks in main()
      opensm: fixed sizeof of pointer allocation in osm_ucast_lash()
      opensm: Fixed debug message in osm_vendor_send()
      opensm: fixed potential memory leak in osm_ucast_ftree()
      opensm: fixed potential null variable dereferencing in libvendor
      opensm: Proper mfttop initialization when starting/restarting
      opensm/osm_opensm.c: Conditionalize sa_db_file_dump on sa_db_dump option
      opensm: fixed segfault when enable qos on fabric with no switches
      opensm: fixed port order configuration in torus routing engine
      renaming dimn_ports_file parameter to route_port_ordering_file
      opensm: don't set switch hops to lid 0
      fixed unsused-but-set warning for DEBUG variables
      libvendor/osm_vendor_ibumad.c: fix unused-but-set warning
      Remove unused variables from code
      add DnUp to list of supported engine names
      opensm_release_notes-3.3: update
      opensm: update shared library versions
      opensm: packages versions update

David McMillen (1):
      OpenSM torus routing order list

Eli Dorfman (2):
      Allow comma in plugin names parsing
      opensm/osm_pkey_mgr: clean partition enforcement on inter-switch links

Eli Dorfman (Voltaire) (1):
      configure multicast only once during sweep

Hal Rosenstock (73):
      opensm.spec.in: Add in man5 for torus-2QoS.conf
      opensm: Add support for SwitchInfo:MulticastFDBTop
      osmtest/SA client: Only set attribute offset for RMPP operations
      opensm/PerfMgr: Better redirection support
      opensm/osm_console.c: Add dump and clear redir perfmgr command support
      opensm/osm_pkey_mgr.c: Fix commentary typo
      opensm/osm_pkey_mgr.c: Move clearing of empty_block after any "early" returns
      opensm/include/opensm/osm_mcm_port.h: Cosmetic formatting changes
      opensm/osm_pkey.c: Minor change to comment
      opensm/osm_sa_mcmember_record.c: Changed status in a couple of SA responses
      opensm/osm_sa_mcmember_record.c: Fix handling of invalid PKey
      opensm/osm_pkey.c: Cosmetic formatting change
      opensm/osm_prtn.c: Cosmetic formatting change
      osmtest/osmt_multicast.c: Fixed a couple of typos in OSM_LOG messages
      osmtest/osmt_multicast.c: Fixed some error codes in OSM_LOG messages
      osmtest/osmt_multicast.c: Fix some typos
      opensm/osm_base.h: Fix a commentary typo
      opensm/osm_sa_service_record.c: Cosmetic changes
      opensm: Cosmetic changes
      opensm/osm_helper.c: Add some missing fields to osm_dump_portinfo_record
      opensm/osm_sa_node_record.c: In nr_rcv_create_nr, only set some variables when needed
      opensm: Add OSM_VENDOR_ID_OPENIB support
      osmtest/osmtest.c: Fix trap flow not implemented log message
      opensm/osm_subnet.c: Fix description of max_msg_fifo_timeout
      opensm/osm_pkey_mgr.c: Change log message to reflect used rather than max blocks
      osmtest/osmt_multicast.c: In some multicast flows, insufficient comps is warning
      opensm/osm_helper: Add osm_dump_guid_info
      opensm/libvendor/osm_vendor_mlx_sa.c: Sync with osm_vendor_ibumad_sa.c
      opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port, initialize p_peer_pkey_tbl later in flow
      osmtest/osmt_multicast.c: In osmt_run_mcast_flow, handle invalid status better
      opensm/osm_pkey_mgr.c: In pkey_mgr_update_peer_port, better last block handling
      opensm/osm_sa.c: Fix commentary typo
      osmtest/osmt_multicast.c: Fixed another insufficient component case
      opensm/osm_sa_service_record.c: Remove useless if
      opensm/osm_sa_service_record.c: Fix minor memory leak
      opensm: Fix some OSM_SIGNAL and OSM_SM_SIGNAL numbering
      opensm/osm_subnet.c: In osm_subn_destroy, delete service records
      opensm/osm_state_mgr.c: Don't rely on PortInfo:PortState for base SP0
      opensm/osm_perfmgr.c: Don't rely on PortInfo:PortState for base SP0
      opensm/osm_port: Add infrastructure for alias GUID support
      opensm: Prepare for alias GUID support
      opensm/osm_pkey_mgr.c: Pack switch peer port PKey tables
      opensm/osm_pkey_mgr.c: Handle osm_pkey_tbl_new_block_get returning NULL
      opensm/osm_pkey_mgr.c: Fix cast
      opensm/osm_ucast_ftree.c: Fix some issues found by Coverity
      opensm/osm_ucast_mgr.c: Fix some issues found by Coverity
      opensm/libvendor: Fix compile warnings on 64 bit machines when building --with-osmv=sim
      opensm/osm_switch.c: In switch_find_guid_common, handle NULL parameter
      opensm/osm_ucast_ftree.c: Handle [sw hca]_create failures
      opensm: Provide option to disable use of MulticastFDBTop even if advertised
      opensm/osmtest/osmtest.c: Fix endian in some log messages
      opensm/man/opensm.8.in: Fix some typos
      opensm/current-routing.txt: Add DnUp description
      opensm/osm_switch.c: Fix compile warnings
      opensm/osmtest/osmt_multicast.: Fix typo in log message
      opensm/osm_sminfo_rcv.c: Eliminate unneeded return parameter from internal routine
      opensm/osm_db_files.c: In osm_db_delete, don't free p_key
      opensm/osmtest/osmt_multicast.c: Use proper defines for rate
      opensm: Use forward extensible and safer way to compare mkey_lmc field in PortInfo attribute
      opensm/doc/todo: Minor update
      OpenSM: Add infrastructure for "full" SM PortInfo and SA PortInfoRecord attributes
      opensm/osm_[lid pkey]_mgr.c: Remove no longer needed memset
      opensm/ib_types.h: Update SA PortInfoRecord component masks
      opensm/osm_sa_class_port_info.c: Minor simplification to setting CapabilityMask2
      opensm/osm_helper: Add rate related routines
      opensm/osm_sa_path_record.c: Proper rate comparison and selection
      opensm/osm_sa_mcmember_record.c: Proper rate comparison and selection
      opensm/osm_sa_multipath_record.c: Proper rate comparison and selection
      opensm: Add extended link speeds support
      opensm/osm_sa_portinfo_record.c: In pir_rcv_new_pir, fix switch port 0 physp
      opensm: Add infrastructure support for CapabilityMask2 field in PortInfo
      opensm/osm_sa_portinfo_record.c: Add SA PortInfoRecord support for CapabilityMask2 matching
      opensm: Add FDR10 support

Hefty, Sean (1):
      opensm: Create all directories in database path on Windows

Ira Weiny (8):
      Fix compile warning introduced by patch "fixed getline pointer allocation free in osm_console_io"
      opensm/perfmgr: fix overflow processing
      opensm: fix strtoull error handling
      opensm: ib_types.h add defines for PM CPI SamplesOnlySupported and PortCountersXmitWaitSupported
      opensm: perfmgr only run sweep timer when enabled.
      opensm: enable perfmgr build by default
      opensm: make loopback console compile on by default.
      opensm: add torus-2QoS to list of supported engine names

Jared Carr (1):
      Support scatter ports.

Jason Gunthorpe (2):
      Decode the SAPKeyTableRecord block number properly, and don't segv
      Fix SANodeRecord.nodeInfo.localPortNum

Jim Schutt (35):
      opensm: Prepare for routing engine input to path record SL lookup and SL2VL map setup.
      opensm: Allow the routing engine to influence SL2VL calculations.
      opensm: Allow the routing engine to participate in path SL calculations.
      opensm: Track the minimum value in the fabric of data VLs supported.
      opensm: Add struct osm_routing_engine callback to build spanning trees for multicast.
      opensm: Make mcast_mgr_purge_tree() available outside osm_mcast_mgr.c.
      opensm: Add torus-2QoS routing engine, part 1.
      opensm: Add torus-2QoS routing engine, part 2.
      opensm: Add torus-2QoS routing engine, part 3.
      opensm: Add torus-2QoS routing engine, part 4.
      opensm: Update documentation to describe torus-2QoS.
      opensm: Enable torus-2QoS routing engine.
      opensm: Add opensm option to specify file name for extra torus-2QoS configuration information.
      opensm: Do not require -Q option for torus-2QoS routing engine.
      opensm: Make it possible to configure no fallback routing engine.
      opensm: Avoid havoc in minhop caused by torus-2QoS persistent use of osm_port_t:priv.
      opensm: Avoid havoc in dump_ucast_routes() caused by torus-2QoS persistent use of osm_port_t:priv.
      opensm: Cause status of unicast routing attempt to propogate to callers of osm_ucast_mgr_process().
      opensm/osm_torus.c: Add check for invalid topology discovery due to user misconfiguration.
      opensm/osm_torus.c: Handle calloc() failure on routing engine context creation.
      Revert "opensm: Do not require -Q option for torus-2QoS routing engine."
      opensm: torus-2QoS requires that QoS be enabled.
      opensm/osm_ucast_mgr.c: ensure osm_ucast_mgr_process() returns failure when no routing engine runs.
      opensm: Fill in default QoS values at last possible moment.
      opensm: Cause torus-2QoS to warn if QoS configuration will cause issues.
      opensm/osm_torus.c: Also parse DOS line endings in torus-2QoS.conf.
      opensm/osm_torus.c: Use PRIx64 for GUID printing.
      opensm/osm_torus.c: Ignore multiple configurations of torus size.
      opensm/osm_subnet.c: Add torus-2QoS config file option to those configurable via opensm config file.
      opensm/main.c: Add description of "no_fallback" to "--routing_engine" option documentation.
      opensm/man/opensm.8.in: Add references to torus-2QoS.
      opensm: Add torus-2QoS man pages.
      opensm/doc/current-routing.txt: Sync torus-2QoS information with new man pages.
      opensm: fail if configured torus port order references a port not available in all switches
      opensm: use OSM_LOG_INFO on duplicate torus port order parsing

Ken Schmidt (1):
      OpenSM - The DnUp routing algorithm.

Sasha Khapyorsky (1):
      Merge branch 'torus-2qos' into master

Weiny, Ira K (1):
      opensm: perfmgr, only set orig_lid when we have a valid port. Otherwise leave it as 0

Yevgeny Kliteynik (1):
      pensm/osm_qos_parser: QOS parser doesn't work after syntax error

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
