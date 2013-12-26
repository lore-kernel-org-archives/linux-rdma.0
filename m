From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_file.c: Fix crash when port is invalid in
 LFT file
Date: Thu, 26 Dec 2013 08:39:12 -0500
Message-ID: <52BC3180.1090203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_file.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_file.c b/opensm/osm_ucast_file.c
index 2c2bf0c..a5408af 100644
--- a/opensm/osm_ucast_file.c
+++ b/opensm/osm_ucast_file.c
@@ -216,6 +216,17 @@ static int do_ucast_file_load(void *context)
 					file_name, lineno, p);
 				goto Exit;
 			}
+			if (port_num >=
+				osm_node_get_num_physp(p_sw->p_node)) {
+					OSM_LOG(&p_osm->log, OSM_LOG_ERROR,
+						"Invalid port %d found "
+						"for switch %016" PRIx64 "\n",
+						port_num,
+						cl_ntoh64(osm_node_get_node_guid
+							(p_sw->p_node)));
+					goto Exit;
+			}
+
 			p = q;
 			/* additionally try to extract guid */
 			q = strstr(p, " portguid 0x");
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
