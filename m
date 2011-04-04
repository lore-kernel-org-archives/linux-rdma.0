From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: Add some missing fields to osm_dump_portinfo_record
Date: Mon, 04 Apr 2011 14:46:15 -0400
Message-ID: <4D9A11F7.1040303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 2597e50..db1cc29 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -892,9 +892,13 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			"\t\t\t\tp_key_violations........0x%X\n"
 			"\t\t\t\tq_key_violations........0x%X\n"
 			"\t\t\t\tguid_cap................0x%X\n"
+			"\t\t\t\tclient_reregister.......0x%X\n"
+			"\t\t\t\tmcast_pkey_trap_suppr...0x%X\n"
 			"\t\t\t\tsubnet_timeout..........0x%X\n"
 			"\t\t\t\tresp_time_value.........0x%X\n"
-			"\t\t\t\terror_threshold.........0x%X\n",
+			"\t\t\t\terror_threshold.........0x%X\n"
+			"\t\t\t\tmax_credit_hint.........0x%X\n"
+			"\t\t\t\tlink_round_trip_latency.0x%X\n",
 			cl_ntoh16(p_pir->lid), p_pir->port_num, p_pir->resv,
 			cl_ntoh64(p_pi->m_key), cl_ntoh64(p_pi->subnet_prefix),
 			cl_ntoh16(p_pi->base_lid),
@@ -915,8 +919,11 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			cl_ntoh16(p_pi->m_key_violations),
 			cl_ntoh16(p_pi->p_key_violations),
 			cl_ntoh16(p_pi->q_key_violations), p_pi->guid_cap,
+			ib_port_info_get_client_rereg(p_pi),
+			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
 			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
-			p_pi->error_threshold);
+			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
+			cl_ntoh32(p_pi->link_rt_latency));

 		/*  show the capabilities mask */
 		if (p_pi->capability_mask) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
