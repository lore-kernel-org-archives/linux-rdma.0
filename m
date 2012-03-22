From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Applied pending OpenSM SRIOV patches
Date: Thu, 22 Mar 2012 10:33:51 +0200
Message-ID: <20120322083351.GA2613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After internal testing, applied the following list of the patches that were
submitted to the list by Hal Rosenstock.

7fce500 opensm/Makefile.am: Add doc/opensm-sriov.txt to docs
264aeb1 opensm: Add documentation for SRIOV support
c639832 opensm: Enhance osm_physp_share_this_pkey for allow_both_pkeys policy
b17b63c opensm: When allowing both pkeys, on a switch external, (peer) port
	eliminate limited pkey when full pkey with same base is present
a758da2 opensm: Add command line option for allow_both_pkeys
f412de3 opensm: Update partition documentation and man page for (allowing)
	both (limited and full) memberships in the same partition
726ce6a Support allowing both full and limited members of same partition
4ccf32f opensm/PKeyMgr: Support pkey index reuse when there are no longer any
	previously unused indices available
ef9cf49 opensm/osm_pkey.h: Commentary change
eb375a6 opensm/osm_pkey_mgr.c: Detect pkey table overflow in
	pkey_mgr_update_port
411e742 opensm/PkeyMgr: Don't change end port pkey index when simultaneously
	adding and removing partitions
15e7223 opensm/osm_sa_guidinfo_record.c: In set_guidinfo, better SM reassigned
	guid handing
8d49c5d opensm/osm_sa_guidinfo_record.c: Fix locking
e79b725 opensm: Handle SubnSet GUIDInfo asynchronously from GUIDInfoRecord
	handling
96c741d opensm: Some cosmetic formatting changes
1d5e370 opensm/osm_sa_guidinfo_record.c: Better status for SA response
efd3ba2 opensm/osm_sa.c: Change log level of message
db8b7da opensm/osm_sa_service_record.c: Alias GUID support
5330986 opensm/osm_sa_multipath_record.c: Add support for alias GUIDs
44168c9 opensm/osm_sa_guidinfo_record.c: In del_guidinfo, validate guid not in
	use
63eb65b opensm: Add multicast support for alias GUIDs
700d15f opensm/osm_sa_path_record.c: Add support for alias GUIDs
f818387 opensm/osm_sa_guidinfo_record.c: Use OSM_VENDOR_ID_OPENIB define
	rather than IB_OPENIB_OUI
97e360e opensm: Dump/load SA GUIDInfoRecords
fe74f1d opensm: Make SA assigned guids persistent across port down/up events
eb8f1d9 opensm: Add support for alias GUIDs
-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
