From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] opensm/osm_mcast_mgr.c: fix osm_mcast_mgr_compute_max_hops
 for managed switch
Date: Wed, 23 Dec 2009 16:44:12 +0200
Message-ID: <4B322CBC.1070805@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a certain mcast group has only one member, and this
member is a switch, OSM fails to select this switch
when trying to create spanning tree for this mcast group:

ERR 0A08: Unable to locate a suitable switch for group 0xC000
ERR 0A17: Unable to create spanning tree (IB_ERROR) for mlid 0xc000

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
V2: no need to handle the case with no
    members in mcast group, it is already
    handled by the caller function.

 opensm/opensm/osm_mcast_mgr.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 697fb58..6bcbec4 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -215,11 +215,9 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 			max_hops = hops;
 	}

-	if (max_hops == 0)
-		/*
-		   We should be here if there aren't any ports in the group.
-		 */
-		max_hops = 10001;	/* see later - we use it to realize no hops */
+	/* Note that at this point we might get (max_hops == 0),
+	   which means that there's only one member in the mcast
+	   group, and it's the current switch */

 	OSM_LOG_EXIT(sm->p_log);
 	return (float)max_hops;
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
