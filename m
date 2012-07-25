From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_sa_inform_info.c: Fix some error log
 messages
Date: Wed, 25 Jul 2012 06:39:56 -0400
Message-ID: <500FCCFC.9050700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make error numbers unique and make log message format consistent for error messages

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_informinfo.c b/opensm/osm_sa_informinfo.c
index ce37372..939adfb 100644
--- a/opensm/osm_sa_informinfo.c
+++ b/opensm/osm_sa_informinfo.c
@@ -428,7 +428,7 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	if (res != IB_SUCCESS) {
 		cl_plock_release(sa->p_lock);
 
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4308 "
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4308: "
 			"Subscribe Request from unknown LID: %u\n",
 			cl_ntoh16(p_madw->mad_addr.dest_lid));
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
@@ -442,7 +442,7 @@ static void infr_rcv_process_set_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 	if (p_recvd_inform_info->subscribe > 1) {
 		cl_plock_release(sa->p_lock);
 
-		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 4308 "
+		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 430A: "
 			"Invalid subscribe: %d\n",
 			p_recvd_inform_info->subscribe);
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_REQ_INVALID);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
