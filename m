From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Mon, 28 May 2012 11:17:10 +0300
Message-ID: <20120528081710.GD13030@calypso>
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
74571e8296c90bcf16123397781f1141  opensm-3.3.14.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Albert Chu (4):
      opensm: Fix opensm handover/relinquish corner case
      opensm: Reset client reregistration when receiving handover
      opensm/include/iba/ib_types.h: fix comment typos and errors
      include/opensm/osm_subnet.h: fix comment typos

Alex Netes (17):
      gen_chlog.sh: fixed version ordering
      opensm: fixed description in osm_routing_engine
      Fix continous looping when clearing accum_pkeys table
      Check block_num validity in set_guidinfo() and del_guidinfo() requests
      opensm: Add support for partition enforcement types to accomodate IBA extended link speeds
      OpenSM/osm_prtn_config.c: Fix non-initialized pointer usage
      opensm/osm_drop_mgr.c: GID out trap fix
      Fix PathRecord reply to be the same for allow_both_pkeys ON and OFF
      Fix Pkey enforcement configuration
      Removed unused variables
      Changed sl_path API to include slid and dlid only
      Fix memory leak on dfsssp_context_destroy()
      opensm/osm_ucast_cache.c: fix crash in ucast cache when switch with lid 0 dropped
      opensm: fix crash in osm_ucast_mgr
      Fix ucast cache crash, when switch doesn't have valid phys ports
      opensm_release_notes-3.3: update
      opensm: packages versions update

Daniel Klein (3):
      opensm/osm_pkey_mgr.c: fix segfault when trying to access not allocated block
      end error resoponse to invalid LID in GUIDInfo request
      opensm: fix search common pkeys

Hal Rosenstock (37):
      opensm/osm_helper.c: Fix commentary typo
      opensm/osm_ucast_ftree.c: Fix some typos
      opensm/opensm.8.in: Fix cut 'n paste error
      opensm/osm_console.c: Add display of FDR10 ports to portstatus_parse
      opensm/man/opensm.8.in: Add description for OSM_LOG_SYS logging flag
      opensm: Add support for alias GUIDs
      opensm: Make SA assigned guids persistent across port down/up events
      opensm: Dump/load SA GUIDInfoRecords
      opensm/osm_sa_guidinfo_record.c: Use OSM_VENDOR_ID_OPENIB define rather than IB_OPENIB_OUI
      opensm/osm_sa_path_record.c: Add support for alias GUIDs
      opensm: Add multicast support for alias GUIDs
      opensm/osm_sa_guidinfo_record.c: In del_guidinfo, validate guid not in use
      opensm/osm_sa_multipath_record.c: Add support for alias GUIDs
      opensm/osm_sa_service_record.c: Alias GUID support
      opensm/osm_sa.c: Change log level of message
      opensm/osm_sa_guidinfo_record.c: Better status for SA response
      opensm: Some cosmetic formatting changes
      opensm: Handle SubnSet GUIDInfo asynchronously from GUIDInfoRecord handling
      opensm/osm_sa_guidinfo_record.c: Fix locking
      opensm/osm_sa_guidinfo_record.c: In set_guidinfo, better SM reassigned guid handing
      opensm/PkeyMgr: Don't change end port pkey index when simultaneously adding and removing partitions
      opensm/osm_pkey_mgr.c: Detect pkey table overflow in pkey_mgr_update_port
      opensm/osm_pkey.h: Commentary change
      opensm/PKeyMgr: Support pkey index reuse when there are no longer any previously unused indices available
      Support allowing both full and limited members of same partition
      opensm: Update partition documentation and man page for (allowing) both (limited and full) memberships in the same partition
      opensm: Add command line option for allow_both_pkeys
      opensm: When allowing both pkeys, on a switch external, (peer) port eliminate limited pkey when full pkey with same base is present
      opensm: Enhance osm_physp_share_this_pkey for allow_both_pkeys policy
      opensm: Add documentation for SRIOV support
      opensm/Makefile.am: Add doc/opensm-sriov.txt to docs
      opensm/osm_state_mgr.c: Cosmetic change to log message
      opensm: Add additional IBM vendor ID/OUI
      opensm/complib/cl_[ptr_]vector.h: Commentary change for consistency
      opensm/osm_link_mgr.c: Fix sending PortInfo Set for ports supporting extended speed
      opensm/osm_switch.c: In osm_switch_set_hops, return, error when port_num is invalid
      opensm/osm_sminfo_rcv.c: Handle SMP status

Jens Domke (1):
      Optimized and deadlock-free routing algorithm for InfiniBand

Mike Heinz (1):
      opensm: osm_subnet.c: Updated patch to add error-reporting to the parsing of opensm.conf

Vladimir Koushnir (1):
      Fix logging messages about op_vls and mtu mismatch


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
