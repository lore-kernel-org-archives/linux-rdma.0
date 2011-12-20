From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] opensm/osm_sa_mad_ctrl.c: Enhance send error log message
Date: Tue, 20 Dec 2011 15:08:21 -0500
Message-ID: <4EF0EB35.9040203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index bde88fa..ddf0bb1 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -398,9 +398,6 @@ static void sa_mad_ctrl_send_err_callback(IN void *context,
 
 	OSM_LOG_ENTER(p_ctrl->p_log);
 
-	OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 1A06: "
-		"MAD transaction completed in error\n");
-
 	/*
 	   We should never be here since the SA never originates a request.
 	   Unless we generated a Report(Notice)
@@ -408,14 +405,24 @@ static void sa_mad_ctrl_send_err_callback(IN void *context,
 
 	CL_ASSERT(p_madw);
 
+	OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 1A06: "
+		"MAD completed in error (%s): "
+		"%s(%s), attr_mod 0x%x, LID %u, TID 0x%" PRIx64 "\n",
+		ib_get_err_str(p_madw->status),
+		ib_get_sa_method_str(p_madw->p_mad->method),
+		ib_get_sa_attr_str(p_madw->p_mad->attr_id),
+		cl_ntoh32(p_madw->p_mad->attr_mod),
+		cl_ntoh16(p_madw->mad_addr.dest_lid),
+		cl_ntoh64(p_madw->p_mad->trans_id));
+
+	osm_dump_sa_mad(p_ctrl->p_log, osm_madw_get_sa_mad_ptr(p_madw),
+			OSM_LOG_ERROR);
+
 	/*
 	   An error occurred.  No response was received to a request MAD.
 	   Retire the original request MAD.
 	 */
 
-	osm_dump_sa_mad(p_ctrl->p_log, osm_madw_get_sa_mad_ptr(p_madw),
-			OSM_LOG_ERROR);
-
 	/*  sm_mad_ctrl_update_wire_stats( p_ctrl ); */
 
 	if (osm_madw_get_err_msg(p_madw) != CL_DISP_MSGID_NONE) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
