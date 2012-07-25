From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: Add better logging for traps 257 and
 258
Date: Wed, 25 Jul 2012 06:39:36 -0400
Message-ID: <500FCCE8.6020703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


More logging for Bad P_Key (trap 257) and Bad Q_Key (trap 258)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index e90ad5e..cb7c8ce 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -268,6 +268,20 @@ static void log_trap_info(osm_log_t *p_log, ib_mad_notice_attr_t *p_ntci,
 			cl_ntoh32(ib_notice_get_prod_type(p_ntci)),
 			ib_get_producer_type_str(ib_notice_get_prod_type(p_ntci)),
 			cl_hton16(source_lid), str, cl_ntoh64(trans_id));
+		if ((p_ntci->g_or_v.generic.trap_num == CL_HTON16(257)) ||
+		    (p_ntci->g_or_v.generic.trap_num == CL_HTON16(258))) {
+			OSM_LOG(p_log, OSM_LOG_ERROR,
+				"Bad %s_Key:0x%x on SL:%d from "
+				"LID1:%u QP1:0x%x to "
+				"LID2:%u QP2:0x%x\n",
+				(p_ntci->g_or_v.generic.trap_num == CL_HTON16(257)) ? "P" : "Q",
+				cl_ntoh32(p_ntci->data_details.ntc_257_258.key),
+				cl_ntoh32(p_ntci->data_details.ntc_257_258.qp1) >> 28,
+				cl_ntoh16(p_ntci->data_details.ntc_257_258.lid1),
+				cl_ntoh32(p_ntci->data_details.ntc_257_258.qp1) & 0xfff,
+				cl_ntoh16(p_ntci->data_details.ntc_257_258.lid2),
+				cl_ntoh32(p_ntci->data_details.ntc_257_258.qp2));
+		}
 	} else
 		OSM_LOG(p_log, OSM_LOG_ERROR,
 			"Received Vendor Notice type:%u vend:0x%06X "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
