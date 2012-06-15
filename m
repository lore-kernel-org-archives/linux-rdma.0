From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_vendor_ibumad.c: Make binding log message
 clearer
Date: Fri, 15 Jun 2012 06:32:02 -0400
Message-ID: <4FDB0F22.4060401@dev.mellanox.co.il>
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
diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index cba60ed..f2432e0 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -783,7 +783,8 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
 	port_guid = p_user_bind->port_guid;
 
 	OSM_LOG(p_vend->p_log, OSM_LOG_INFO,
-		"Binding to port 0x%" PRIx64 "\n", cl_ntoh64(port_guid));
+		"Mgmt class 0x%02x binding to port GUID 0x%" PRIx64 "\n",
+		p_user_bind->mad_class, cl_ntoh64(port_guid));
 
 	if ((umad_port_id = osm_vendor_open_port(p_vend, port_guid)) < 0) {
 		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5424: "
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
