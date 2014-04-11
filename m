From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mad_ctrl.c: In sa_mad_ctrl_rcv_callback, improve
 1A04 error log message
Date: Fri, 11 Apr 2014 07:23:06 -0400
Message-ID: <5347D09A.9050707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Susan Coulter (skc-YOWKrPYUwWM@public.gmane.org)" <skc-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to include more info on incoming SA MAD

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index 902803e..61fcb0b 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -331,9 +331,12 @@ static void sa_mad_ctrl_rcv_callback(IN osm_madw_t * p_madw, IN void *context,
 	if (p_sa_mad->sm_key != 0 &&
 	    p_sa_mad->sm_key != p_ctrl->p_subn->opt.sa_key) {
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 1A04: "
-			"Non-Zero SA MAD SM_Key: 0x%" PRIx64 " != SM_Key: 0x%"
-			PRIx64 "; MAD ignored\n", cl_ntoh64(p_sa_mad->sm_key),
-			cl_ntoh64(p_ctrl->p_subn->opt.sa_key));
+			"Non-Zero MAD SM_Key: 0x%" PRIx64 " != SM_Key: 0x%"
+			PRIx64 "; SA MAD ignored for method 0x%X attribute 0x%X (%s)\n",
+			cl_ntoh64(p_sa_mad->sm_key),
+			cl_ntoh64(p_ctrl->p_subn->opt.sa_key),
+			p_sa_mad->method, cl_ntoh16(p_sa_mad->attr_id),
+			ib_get_sa_attr_str(p_sa_mad->attr_id));
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
