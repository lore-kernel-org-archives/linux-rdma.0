From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mcmember_record.c: On join and leave, validate
 subnet prefix in port GID
Date: Mon, 08 Apr 2013 07:36:41 -0400
Message-ID: <5162ABC9.8040606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 4a9ad71..242fcde 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -911,6 +919,18 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	mcmember_rec = *p_recvd_mcmember_rec;
 
+	/* Validate the subnet prefix in the PortGID */
+	if (p_recvd_mcmember_rec->port_gid.unicast.prefix !=
+	    sa->p_subn->opt.subnet_prefix) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"PortGID subnet prefix 0x%" PRIx64
+			" does not match configured prefix 0x%" PRIx64 "\n",
+			cl_ntoh64(p_recvd_mcmember_rec->port_gid.unicast.prefix),
+			cl_ntoh64(sa->p_subn->opt.subnet_prefix));
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_INVALID_GID);
+		goto Exit;
+	}
+
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
 		osm_physp_t *p_req_physp;
 
@@ -998,6 +1018,18 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 
 	mcmember_rec = *p_recvd_mcmember_rec;
 
+        /* Validate the subnet prefix in the PortGID */
+	if (p_recvd_mcmember_rec->port_gid.unicast.prefix !=
+	    sa->p_subn->opt.subnet_prefix) {
+		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			"PortGID subnet prefix 0x%" PRIx64
+			" does not match configured prefix 0x%" PRIx64 "\n",
+			cl_ntoh64(p_recvd_mcmember_rec->port_gid.unicast.prefix),
+			cl_ntoh64(sa->p_subn->opt.subnet_prefix));
+		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_INVALID_GID);
+		goto Exit;
+	}
+
 	if (OSM_LOG_IS_ACTIVE_V2(sa->p_log, OSM_LOG_DEBUG)) {
 		osm_physp_t *p_req_physp;
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
