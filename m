From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] ftree: Allow defining only io_guids file and consider
 rest of nodes as CN nodes
Date: Tue, 18 Jun 2013 07:03:06 -0400
Message-ID: <51C03E6A.1030808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 2068a60399865590aff094738e3350f972c6e9b4 Mon Sep 17 00:00:00 2001
From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 9 Jun 2013 18:05:01 +0300
Subject: [PATCH] ftree: Allow defining only io_guids file and consider rest of nodes as CN nodes

In the current implementation cn_guids and io_guids files
should be provided in order to separate between
Compute Nodes and IO Nodes for ftree routing.
This approach is not optimal when there are several IO Nodes
the fabric compared to thousands of CNs.
Provided patch considers all nodes to be Compute nodes by default.
If some guid is presenting in io_guids file and not presenting in
cn_guid file the corresponding node will be considered as IO node.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c      |    7 ++++-
 opensm/osm_ucast_ftree.c |   53 +++++++++++++++++++++++----------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index bc05ae0..5e06d83 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -2879,11 +2879,14 @@ int osm_subn_output_conf(FILE *out, IN osm_subn_opt_t * p_opts)
 
 	fprintf(out,
 		"# The file holding the fat-tree I/O node guids\n"
-		"# One guid in each line\nio_guid_file %s\n\n",
+		"# One guid in each line.\n"
+		"# If only io_guid file is provided, the rest of nodes\n"
+		"# are considered as compute nodes.\n"
+		"io_guid_file %s\n\n",
 		p_opts->io_guid_file ? p_opts->io_guid_file : null_str);
 
 	fprintf(out,
-		"# Number of reverse hops allowed for I/O nodes \n"
+		"# Number of reverse hops allowed for I/O nodes\n"
 		"# Used for connectivity between I/O nodes connected to Top Switches\nmax_reverse_hops %d\n\n",
 		p_opts->max_reverse_hops);
 
diff --git a/opensm/osm_ucast_ftree.c b/opensm/osm_ucast_ftree.c
index 58e51d4..a069edb 100644
--- a/opensm/osm_ucast_ftree.c
+++ b/opensm/osm_ucast_ftree.c
@@ -3268,8 +3268,11 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 	osm_physp_t *p_remote_osm_port;
 	uint8_t i;
 	uint8_t remote_port_num;
-	boolean_t is_cn = FALSE;
+	boolean_t is_cn = TRUE;
+	boolean_t is_in_cn_file = FALSE;
 	boolean_t is_io = FALSE;
+	boolean_t is_cns_file_provided = fabric_cns_provided(p_ftree);
+	boolean_t is_ios_file_provided = fabric_ios_provided(p_ftree);
 	int res = 0;
 
 	for (i = 0; i < osm_node_get_num_physp(p_node); i++) {
@@ -3325,16 +3328,27 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 		/* If CN file is not supplied, then all the CAs considered as Compute Nodes.
 		   Otherwise all the CAs are not CNs, and only guids that are present in the
 		   CN file will be marked as compute nodes. */
-		if (!fabric_cns_provided(p_ftree)) {
-			is_cn = TRUE;
-		} else {
+		if (is_cns_file_provided == TRUE) {
 			name_map_item_t *p_elem = (name_map_item_t *)
-			    cl_qmap_get(&p_ftree->cn_guid_tbl,
-					cl_ntoh64(osm_physp_get_port_guid
-						  (p_osm_port)));
+			cl_qmap_get(&p_ftree->cn_guid_tbl,
+				    cl_ntoh64(osm_physp_get_port_guid
+					     (p_osm_port)));
+			if (p_elem == (name_map_item_t *)
+				cl_qmap_end(&p_ftree->cn_guid_tbl))
+				is_cn = FALSE;
+			else
+				is_in_cn_file = TRUE;
+		}
+		if (is_in_cn_file == FALSE && is_ios_file_provided == TRUE) {
+			name_map_item_t *p_elem = (name_map_item_t *)
+			cl_qmap_get(&p_ftree->io_guid_tbl,
+				    cl_ntoh64(osm_physp_get_port_guid
+					     (p_osm_port)));
 			if (p_elem != (name_map_item_t *)
-			    cl_qmap_end(&p_ftree->cn_guid_tbl))
-				is_cn = TRUE;
+				cl_qmap_end(&p_ftree->io_guid_tbl)) {
+				is_io = TRUE;
+				is_cn = FALSE;
+			}
 		}
 
 		if (is_cn) {
@@ -3343,32 +3357,19 @@ fabric_construct_hca_ports(IN ftree_fabric_t * p_ftree, IN ftree_hca_t * p_hca)
 			OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 				"Marking CN port GUID 0x%016" PRIx64 "\n",
 				cl_ntoh64(osm_physp_get_port_guid(p_osm_port)));
-		} else {
-			if (fabric_ios_provided(p_ftree)) {
-				name_map_item_t *p_elem = (name_map_item_t *)
-				    cl_qmap_get(&p_ftree->io_guid_tbl,
-						cl_ntoh64
-						(osm_physp_get_port_guid
-						 (p_osm_port)));
-				if (p_elem != (name_map_item_t *)
-				    cl_qmap_end(&p_ftree->io_guid_tbl))
-					is_io = TRUE;
-			}
-
-			if (is_io) {
+		} else if (is_io) {
 				OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 					"Marking I/O port GUID 0x%016" PRIx64
 					"\n",
 					cl_ntoh64(osm_physp_get_port_guid
-						  (p_osm_port)));
+						 (p_osm_port)));
 
-			} else {
+		} else {
 				OSM_LOG(&p_ftree->p_osm->log, OSM_LOG_DEBUG,
 					"Marking non-CN port GUID 0x%016" PRIx64
 					"\n",
 					cl_ntoh64(osm_physp_get_port_guid
-						  (p_osm_port)));
-			}
+						 (p_osm_port)));
 		}
 		p_ftree->ca_ports++;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
