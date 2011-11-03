From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] OpenSM tarball release
Date: Thu, 3 Nov 2011 09:03:03 +0200
Message-ID: <20111103070303.GA10299@calypso.mtl.com>
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

66beeccf6b16550609b37d588c0589ee  opensm-3.3.12.tar.gz

All component versions are from recent master branch. Full list of
changes is below.

Alex Netes (1):
      fixed deprecated conversion from string constant to char* warning

Daniel Klein (1):
      opensm/osmtest/osmtest.c: inventory file parsing bugfix

Hal Rosenstock (21):
      opensm/osmtest/osmt_multicast.c: Fix an unrealistic rate case
      opensm/osm_helper: Add ib_rate_is_valid
      opensm/osm_sa_path_record.c: Add rate validation if supplied
      opensm/osm_sa_mcmember_record.c: Add rate validation if supplied
      opensm/osm_sa_multipath_record.c: Add rate validation if supplied
      osmtest/osmt_multicast.c: Fix first MGID=0 MC group creation case
      osmtest/osmt_multicast.c: Fix check of BAD RATE when connecting to
		existing MGID (o15.0.1.13)
      osmtest/osmt_multicast.c: Fix check of partial JoinState delete request
		- removing NonMember (o15.0.1.14)
      opensm/osm_helper: Add ib_mtu_is_valid
      opensm/osm_sa_path_record.c: Add mtu validation if supplied
      opensm/osm_sa_mcmember_record.c: Add mtu validation if supplied
      opensm/osm_sa_multipath_record.c: Add mtu validation if supplied
      opensm/osm_dump.c: Fix FDR10 speed dumping
      opensm/osmtest/osmt_multicast.c: Fix multicast flow failures on pkey
		validation
      opensm/osm_link_mgr.c: Remove no longer needed memset
      opensm/osm_dump.c: dump SL2VL tables in debug verbosity level when QoS
		is on
      opensm/osm_dump.c: Dump SL2VL tables if routing engine might have
		modified them
      opensm/osm_sa_mcmember_record.c: Commentary changes relating to SA
		assigned MGIDs
      opensm/main.c: Change size parameter in setvbuf call from 0 to BUFSIZ
      opensm: Only log SM PORT "state" when it changes
      opensm: Fix typo in routing section in man page and doc

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
