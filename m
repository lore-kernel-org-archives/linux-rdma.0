From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed memory leak in multicast spanning tree
Date: Fri, 4 Mar 2011 14:18:54 +0200
Message-ID: <20110304121854.GD5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

calculation
Reply-To: 

When number of ports participating in a group is less than 2, port_list isn't
freed.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index df3af26..95b514c 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -751,6 +751,7 @@ static ib_api_status_t mcast_mgr_build_spanning_tree(osm_sm_t * sm,
 		OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 			"MLID 0x%X has %u members - nothing to do\n",
 			mbox->mlid, num_ports);
+		drop_port_list(&port_list);
 		goto Exit;
 	}
 
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
