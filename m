From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_ucast_updn.c: Add error codes to a couple
 of log messages
Date: Wed, 03 Oct 2012 19:57:46 -0400
Message-ID: <506CD0FA.2090801@dev.mellanox.co.il>
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
diff --git a/opensm/osm_ucast_updn.c b/opensm/osm_ucast_updn.c
index d6877fe..f3ca4dc 100644
--- a/opensm/osm_ucast_updn.c
+++ b/opensm/osm_ucast_updn.c
@@ -595,7 +595,7 @@ static int updn_lid_matrices(void *ctx)
 		ret = parse_node_map(p_updn->p_osm->subn.opt.root_guid_file,
 				     rank_root_node, p_updn);
 		if (ret)
-			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR : "
+			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR AA02: "
 				"cannot parse root guids file \'%s\'\n",
 				p_updn->p_osm->subn.opt.root_guid_file);
 		if (p_updn->p_osm->subn.opt.connect_roots &&
@@ -614,7 +614,7 @@ static int updn_lid_matrices(void *ctx)
 		ret = parse_node_map(p_updn->p_osm->subn.opt.ids_guid_file,
 				     update_id, p_updn->p_osm);
 		if (ret)
-			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR : "
+			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR AA03: "
 				"cannot parse node ids file \'%s\'\n",
 				p_updn->p_osm->subn.opt.ids_guid_file);
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
