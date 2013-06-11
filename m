From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 6/6] When SM fails to load/parse root_guids file use MinHop
 heuristics
Date: Tue, 11 Jun 2013 14:13:59 -0400
Message-ID: <51B768E7.2020706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 21765ade61c96c319d157293e57e10f2f0e07846 Mon Sep 17 00:00:00 2001
From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 28 Apr 2013 10:06:00 +0300
Subject: [PATCH 6/6] When SM fails to load/parse root_guids file use MinHop
 heuristics

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c      |   11 -----------
 opensm/osm_ucast_ftree.c |    8 +++++---
 opensm/osm_ucast_updn.c  |    8 +++++---
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index bd68957..0c199c5 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2048,17 +2048,6 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
 		}
 	}
 
-	if (p_opts->root_guid_file != NULL) {
-		FILE *root_file = fopen(p_opts->root_guid_file, "r");
-		if (!root_file) {
-			log_report("Root guid file provided: %s doesn't exist.\n"
-				    "Using default roots discovery algorithm\n",
-				    p_opts->root_guid_file);
-			p_opts->root_guid_file = NULL;
-		} else
-			fclose(root_file);
-	}
-
 	return 0;
 }
 
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 9b47c74..bd2817b 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3558,6 +3558,9 @@ static boolean_t fabric_load_roots(IN ftree_fabric_t * p_ftree,
 		context.list = p_ranking_bfs_list;
 		if (parse_node_map(p_ftree->p_osm->subn.opt.root_guid_file,
 				   rank_root_sw_by_guid, &context)) {
+			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_ERROR, "ERR AB2A: "
+				"cannot parse root guids file \'%s\'\n",
+				p_ftree->p_osm->subn.opt.root_guid_file);
 			return FALSE;
 		}
 
@@ -3722,10 +3725,9 @@ static int fabric_rank(IN ftree_fabric_t * p_ftree)
 
 	OSM_LOG_ENTER(&p_ftree->p_osm->log);
 
-	if (fabric_roots_provided(p_ftree)){
-		if (fabric_load_roots(p_ftree, &ranking_bfs_list))
+	if (fabric_roots_provided(p_ftree) &&
+	    fabric_load_roots(p_ftree, &ranking_bfs_list))
 			res = fabric_rank_from_roots(p_ftree, &ranking_bfs_list);
-	}
 	else {
 		res = fabric_rank_from_hcas(p_ftree);
 		if (!res)
diff --git a/opensm/osm_ucast_updn.c b/opensm/osm_ucast_updn.c
index f3ca4dc..2da17de 100644
--- a/opensm/osm_ucast_updn.c
+++ b/opensm/osm_ucast_updn.c
@@ -594,12 +594,14 @@ static int updn_lid_matrices(void *ctx)
 
 		ret = parse_node_map(p_updn->p_osm->subn.opt.root_guid_file,
 				     rank_root_node, p_updn);
-		if (ret)
+		if (ret) {
 			OSM_LOG(&p_updn->p_osm->log, OSM_LOG_ERROR, "ERR AA02: "
 				"cannot parse root guids file \'%s\'\n",
 				p_updn->p_osm->subn.opt.root_guid_file);
-		if (p_updn->p_osm->subn.opt.connect_roots &&
-		    p_updn->num_roots > 1)
+			osm_ucast_mgr_build_lid_matrices(&p_updn->p_osm->sm.ucast_mgr);
+			updn_find_root_nodes_by_min_hop(p_updn);
+		} else if (p_updn->p_osm->subn.opt.connect_roots &&
+			   p_updn->num_roots > 1)
 			osm_ucast_mgr_build_lid_matrices(&p_updn->p_osm->sm.ucast_mgr);
 	} else {
 		osm_ucast_mgr_build_lid_matrices(&p_updn->p_osm->sm.ucast_mgr);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
