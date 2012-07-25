From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_sa_mad_ctrl.c: Eliminate commented out
 code line
Date: Wed, 25 Jul 2012 06:37:33 -0400
Message-ID: <500FCC6D.60206@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


which would never be used in SA flow

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index 43d1e83..2bdee22 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -423,8 +423,6 @@ static void sa_mad_ctrl_send_err_callback(IN void *context,
 	   Retire the original request MAD.
 	 */
 
-	/*  sm_mad_ctrl_update_wire_stats( p_ctrl ); */
-
 	if (osm_madw_get_err_msg(p_madw) != CL_DISP_MSGID_NONE) {
 		OSM_LOG_V2(p_ctrl->p_log, OSM_LOG_DEBUG,
 			   "Posting Dispatcher message %s\n",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
