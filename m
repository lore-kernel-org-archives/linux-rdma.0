From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/libopensm.map: Removed unimplemented routine
Date: Mon, 09 Jul 2012 13:15:16 -0400
Message-ID: <4FFB11A4.1060109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


osm_dump_pkey_table is not implemented so shouldn't be in map

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index f7eae57..1735488 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -49,7 +49,6 @@ OPENSM_1.5 {
 		osm_dump_switch_info_v2;
 		osm_dump_switch_info_record;
 		osm_dump_switch_info_record_v2;
-		osm_dump_pkey_table;
 		osm_dump_slvl_map_table;
 		osm_dump_slvl_map_table_v2;
 		osm_dump_vl_arb_table;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
