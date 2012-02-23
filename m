From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_ucast_ftree.c: Fix some typos
Date: Thu, 23 Feb 2012 07:41:36 -0500
Message-ID: <4F463400.8060106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 5828e8f..ee4c34b 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -63,7 +63,7 @@
  *    Switches are stored in two cl_qmaps - one is
  *    ordered by guid, and the other by a key that is
  *    generated from tuple. Since cl_qmap supports only
- *    a 64-bit key, the maximal tuple lenght is 8 bytes.
+ *    a 64-bit key, the maximal tuple length is 8 bytes.
  *    which means that maximal tree rank is 8.
  * Note that the above also implies that each switch
  * can have at max 255 up/down ports.
@@ -2216,7 +2216,7 @@ fabric_route_upgoing_by_going_down(IN ftree_fabric_t * p_ftree,
 			/* Loop in the fabric - we already routed the remote switch
 			   on our way UP, and now we see it again on our way DOWN */
 			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
-				"Loop of lenght %d in the fabric:\n                             "
+				"Loop of length %d in the fabric:\n                             "
 				"Switch %s (LID %u) closes loop through switch %s (LID %u)\n",
 				current_hops,
 				tuple_to_str(p_remote_sw->tuple),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
