From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm: Change osm_routing_engine struct to not use C++ reserved
 word
Date: Tue, 27 Dec 2011 14:28:42 -0500
Message-ID: <4EFA1C6A.8020009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Change delete to destroy in osm_routing_engine struct

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_opensm.h b/include/opensm/osm_opensm.h
index 3ebf533..fbf60e3 100644
--- a/include/opensm/osm_opensm.h
+++ b/include/opensm/osm_opensm.h
@@ -136,7 +136,7 @@ struct osm_routing_engine {
 			   IN const osm_port_t *dst_port);
 	ib_api_status_t (*mcast_build_stree)(void *context,
 					     IN OUT osm_mgrp_box_t *mgb);
-	void (*delete) (void *context);
+	void (*destroy) (void *context);
 	struct osm_routing_engine *next;
 };
 /*
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index 1784388..e895b17 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -243,8 +243,8 @@ static void destroy_routing_engines(osm_opensm_t *osm)
 	while (next) {
 		r = next;
 		next = r->next;
-		if (r->delete)
-			r->delete(r->context);
+		if (r->destroy)
+			r->destroy(r->context);
 		free(r);
 	}
 }
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index df46fb8..80d1ca8 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -9307,6 +9307,6 @@ int osm_ucast_torus2QoS_setup(struct osm_routing_engine *r,
 	r->update_sl2vl = torus_update_osm_sl2vl;
 	r->path_sl = torus_path_sl;
 	r->mcast_build_stree = torus_mcast_stree;
-	r->delete = torus_context_delete;
+	r->destroy = torus_context_delete;
 	return 0;
 }
diff --git a/opensm/osm_ucast_dnup.c b/opensm/osm_ucast_dnup.c
index b2f5c62..740de8b 100644
--- a/opensm/osm_ucast_dnup.c
+++ b/opensm/osm_ucast_dnup.c
@@ -489,7 +489,7 @@ int osm_ucast_dnup_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
 	dnup->p_osm = osm;
 
 	r->context = dnup;
-	r->delete = dnup_delete;
+	r->destroy = dnup_delete;
 	r->build_lid_matrices = dnup_lid_matrices;
 
         OSM_LOG_EXIT(&osm->log);
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 06508c8..5828e8f 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -4134,7 +4134,7 @@ int osm_ucast_ftree_setup(struct osm_routing_engine *r, osm_opensm_t * p_osm)
 	r->context = (void *)p_ftree;
 	r->build_lid_matrices = construct_fabric;
 	r->ucast_build_fwd_tables = do_routing;
-	r->delete = delete;
+	r->destroy = delete;
 
 	return 0;
 }
diff --git a/opensm/osm_ucast_lash.c b/opensm/osm_ucast_lash.c
index 8cc84b3..e751971 100644
--- a/opensm/osm_ucast_lash.c
+++ b/opensm/osm_ucast_lash.c
@@ -1314,7 +1314,7 @@ int osm_ucast_lash_setup(struct osm_routing_engine *r, osm_opensm_t *p_osm)
 	r->context = p_lash;
 	r->ucast_build_fwd_tables = lash_process;
 	r->path_sl = get_lash_sl;
-	r->delete = lash_delete;
+	r->destroy = lash_delete;
 
 	return 0;
 }
diff --git a/opensm/osm_ucast_updn.c b/opensm/osm_ucast_updn.c
index 164c6f4..6e828c4 100644
--- a/opensm/osm_ucast_updn.c
+++ b/opensm/osm_ucast_updn.c
@@ -661,7 +661,7 @@ int osm_ucast_updn_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
 	updn->p_osm = osm;
 
 	r->context = updn;
-	r->delete = updn_delete;
+	r->destroy = updn_delete;
 	r->build_lid_matrices = updn_lid_matrices;
 
 	return 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
