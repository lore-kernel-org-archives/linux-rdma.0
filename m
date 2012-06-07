From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] opensm: Cosmetic changes
Date: Wed, 06 Jun 2012 20:34:56 -0400
Message-ID: <4FCFF730.3080704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From d3795beefe4a023f043ae522a7ac040d4f232dfb Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 7 Jun 2012 03:04:49 +0300
Subject: [PATCH 2/3] opensm: Cosmetic changes

Fix some typos
Fix some formatting (replaces spaces with tabs)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_mesh.c               |    2 +-
 opensm/osm_prtn.c               |   10 +++++-----
 opensm/osm_sa_guidinfo_record.c |    2 +-
 opensm/osm_torus.c              |    6 +++---
 opensm/osm_ucast_dfsssp.c       |    2 +-
 opensm/osm_ucast_dnup.c         |    6 +++---
 6 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/opensm/osm_mesh.c b/opensm/osm_mesh.c
index d66703e..aede1db 100644
--- a/opensm/osm_mesh.c
+++ b/opensm/osm_mesh.c
@@ -1660,7 +1660,7 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 	 * find dominant switch class
 	 */
 	OSM_LOG(p_log, OSM_LOG_INFO, "found %d node class%s\n",
-		mesh->num_class, (mesh->num_class == 1)? "" : "es");
+		mesh->num_class, (mesh->num_class == 1) ? "" : "es");
 	for (i = 0; i < mesh->num_class; i++) {
 		OSM_LOG(p_log, OSM_LOG_INFO,
 			"class[%d] has %d members with type = %d\n",
diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index a1a870d..129fe51 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -215,11 +215,11 @@ track_mgrp_w_partition(osm_log_t *p_log, osm_prtn_t *p, osm_mgrp_t *mgrp,
 		p->nmgrps++;
 	} else {
 		OSM_LOG(p_log, OSM_LOG_ERROR,
-		        "realloc error to create MC group (%s) in "
-		        "partition (pkey 0x%04x)\n",
-		        inet_ntop(AF_INET6, mgid->raw,
-		                gid_str, sizeof gid_str),
-		        cl_ntoh16(pkey));
+			"realloc error to create MC group (%s) in "
+			"partition (pkey 0x%04x)\n",
+			inet_ntop(AF_INET6, mgid->raw,
+				  gid_str, sizeof gid_str),
+			cl_ntoh16(pkey));
 		mgrp->well_known = FALSE;
 		osm_mgrp_cleanup(p_subn, mgrp);
 		return (IB_ERROR);
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 2b4baf3..a19d526 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -763,7 +763,7 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 		if (!check_mod_comp_mask(p_rcvd_mad->comp_mask)) {
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5106: "
 				"component mask = 0x%016" PRIx64 ", "
-                                "expected comp mask = 0x%016" PRIx64 "\n",
+				"expected comp mask = 0x%016" PRIx64 "\n",
 				cl_ntoh64(p_rcvd_mad->comp_mask),
 				CL_NTOH64(MOD_GIR_COMP_MASK));
 			osm_sa_send_error(sa, p_madw,
diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 051505b..e157229 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -718,14 +718,14 @@ bool build_link(struct fabric *f,
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
 			"ERR 4E0A: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid0));
-			goto out;
+		goto out;
 	}
 	sw1 = find_f_sw(f, sw_guid1);
 	if (!sw1) {
 		OSM_LOG(&f->osm->log, OSM_LOG_ERROR,
 			"ERR 4E0B: missing switch w/GUID 0x%04"PRIx64"\n",
 			cl_ntoh64(sw_guid1));
-			goto out;
+		goto out;
 	}
 	l = alloc_flink(f);
 	if (!l)
@@ -7054,7 +7054,7 @@ bool verify_setup(struct torus *t, struct fabric *f)
 					"ERR 4E21: port_order configured using "
 					"port %u, but only %u ports in "
 					"switch w/ GUID 0x%04"PRIx64"\n",
-					t->port_order[p],  sw->port_cnt - 1,
+					t->port_order[p], sw->port_cnt - 1,
 					cl_ntoh64(sw->n_id));
 				goto out;
 			}
diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index 8687459..20b02cb 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -2038,7 +2038,7 @@ static int dfsssp_do_dijkstra_routing(void *context)
 		     item = cl_qmap_next(item)) {
 			sw = (osm_switch_t *) item;
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-				"Summery of the (new) LFT for switch 0x%" PRIx64
+				"Summary of the (new) LFT for switch 0x%" PRIx64
 				" (%s):\n",
 				cl_ntoh64(osm_node_get_node_guid(sw->p_node)),
 				sw->p_node->print_desc);
diff --git a/opensm/osm_ucast_dnup.c b/opensm/osm_ucast_dnup.c
index a35284d..2afff79 100644
--- a/opensm/osm_ucast_dnup.c
+++ b/opensm/osm_ucast_dnup.c
@@ -176,7 +176,7 @@ static int dnup_bfs_by_node(IN osm_log_t * p_log, IN osm_subn_t * p_subn,
 					current_min_hop+=prune_weight;
 					if(current_min_hop >= 64) {
 						OSM_LOG(p_log, OSM_LOG_ERROR,
-							"ERR AE02 Too many hops on subnet,"
+							"ERR AE02: Too many hops on subnet,"
 							" can't relax illegal Dn/Up transition.");
 						osm_switch_set_hops(p_remote_sw, lid,
 								    pn_rem, OSM_NO_PATH);
@@ -480,7 +480,7 @@ int osm_ucast_dnup_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
 {
 	dnup_t *dnup;
 
-        OSM_LOG_ENTER(&osm->log);
+	OSM_LOG_ENTER(&osm->log);
 
 	dnup = malloc(sizeof(dnup_t));
 	if (!dnup)
@@ -493,6 +493,6 @@ int osm_ucast_dnup_setup(struct osm_routing_engine *r, osm_opensm_t *osm)
 	r->destroy = dnup_delete;
 	r->build_lid_matrices = dnup_lid_matrices;
 
-        OSM_LOG_EXIT(&osm->log);
+	OSM_LOG_EXIT(&osm->log);
 	return 0;
 }
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
