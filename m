From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mcast_mgr.c: Fix wrong comparison in mcast_mgr_subdivide()
Date: Wed, 20 Nov 2013 18:26:23 -0500
Message-ID: <528D451F.3040404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

port_num must be less than array_size (num of ports on a node).

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mcast_mgr.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index 837428b..029ba40 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -605,7 +605,7 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 			continue;
 		}
 
-		if (port_num > array_size) {
+		if (port_num >= array_size) {
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A04: "
 				"Error routing MLID 0x%X through switch 0x%"
 				PRIx64 " %s\n"
@@ -616,8 +616,6 @@ static void mcast_mgr_subdivide(osm_sm_t * sm, uint16_t mlid_ho,
 				cl_ntoh16(osm_port_get_base_lid
 					  (p_wobj->p_port)));
 			mcast_work_obj_delete(p_wobj);
-			/* This is means OpenSM has a bug. */
-			CL_ASSERT(FALSE);
 			continue;
 		}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
