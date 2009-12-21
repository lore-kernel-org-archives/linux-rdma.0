From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_mgr.c: fix osm_mcast_mgr_compute_max_hops
 for managed switch
Date: Mon, 21 Dec 2009 11:46:45 +0200
Message-ID: <4B2F4405.9000300@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a certain mcast group has only one member, and this
member is a switch, OSM fails to select this switch
when trying to create spanning tree for this mcast group:

ERR 0A08: Unable to locate a suitable switch for group 0xC000
ERR 0A17: Unable to create spanning tree (IB_ERROR) for mlid 0xc000

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_mcast_mgr.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/opensm/opensm/osm_mcast_mgr.c b/opensm/opensm/osm_mcast_mgr.c
index 697fb58..16f578b 100644
--- a/opensm/opensm/osm_mcast_mgr.c
+++ b/opensm/opensm/osm_mcast_mgr.c
@@ -204,6 +204,12 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,

 	OSM_LOG_ENTER(sm->p_log);

+	if (cl_qlist_count(l) == 0) {
+		/*  We should be here if there aren't any ports in the group */
+		max_hops = 10001; /* see later - we use it to realize no hops */
+		goto Exit;
+	}
+
 	/*
 	   For each member of the multicast group, compute the
 	   number of hops to its base LID.
@@ -215,12 +221,10 @@ static float osm_mcast_mgr_compute_max_hops(osm_sm_t * sm, cl_qlist_t * l,
 			max_hops = hops;
 	}

-	if (max_hops == 0)
-		/*
-		   We should be here if there aren't any ports in the group.
-		 */
-		max_hops = 10001;	/* see later - we use it to realize no hops */
-
+	/* Note that at this point we might get (max_hops == 0),
+	   which means that there's only one member in the mcast
+	   group, and it's the current switch */
+Exit:
 	OSM_LOG_EXIT(sm->p_log);
 	return (float)max_hops;
 }
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
