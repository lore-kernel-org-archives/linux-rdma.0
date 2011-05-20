From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey_mgr.c: Fix cast
Date: Fri, 20 May 2011 10:35:46 -0400
Message-ID: <4DD67C42.30105@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


introduced by commit 2c5148408d562d86e1dd5d90939a58533ddebbe6

to eliminate compiler warning:
osm_pkey_mgr.c: In function 'osm_pkey_mgr_process':
osm_pkey_mgr.c:561: warning: assignment from incompatible pointer type

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 31e14aa..5d4a2fe 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -558,7 +558,7 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_osm)
 	p_tbl = &p_osm->subn.sw_guid_tbl;
 	p_next = cl_qmap_head(p_tbl);
 	while (p_next != cl_qmap_end(p_tbl)) {
-		p_sw = (osm_switch_t * *) p_next;
+		p_sw = (osm_switch_t *) p_next;
 		p_next = cl_qmap_next(p_next);
 		for (i = 1; i < p_sw->num_ports; i++) {
 			p_physp = osm_node_get_physp_ptr(p_sw->p_node, i);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
