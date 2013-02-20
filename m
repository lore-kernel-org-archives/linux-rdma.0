From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_multipath_record.c: Fix seg fault in mpr_rcv_get_apm_paths
Date: Wed, 20 Feb 2013 14:02:33 -0500
Message-ID: <51251DC9.6030407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When routing fails, mpr_rcv_get_apm_port_pair_paths returns NULL
and this is not handled in mpr_rcv_get_apm_paths

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 03ffd47..9153a58 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1415,26 +1415,46 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG, "APM matrix:\n"
 		"\t{0,0} 0x%X->0x%X (%d)\t| {0,1} 0x%X->0x%X (%d)\n"
 		"\t{1,0} 0x%X->0x%X (%d)\t| {1,1} 0x%X->0x%X (%d)\n",
-		matrix[0][0]->resp.mpr_rec.path_rec.slid,
-		matrix[0][0]->resp.mpr_rec.path_rec.dlid,
-		matrix[0][0]->resp.mpr_rec.hops,
-		matrix[0][1]->resp.mpr_rec.path_rec.slid,
-		matrix[0][1]->resp.mpr_rec.path_rec.dlid,
-		matrix[0][1]->resp.mpr_rec.hops,
-		matrix[1][0]->resp.mpr_rec.path_rec.slid,
-		matrix[1][0]->resp.mpr_rec.path_rec.dlid,
-		matrix[1][0]->resp.mpr_rec.hops,
-		matrix[1][1]->resp.mpr_rec.path_rec.slid,
-		matrix[1][1]->resp.mpr_rec.path_rec.dlid,
-		matrix[1][1]->resp.mpr_rec.hops);
+		matrix[0][0] ? matrix[0][0]->resp.mpr_rec.path_rec.slid : 0,
+		matrix[0][0] ? matrix[0][0]->resp.mpr_rec.path_rec.dlid : 0,
+		matrix[0][0] ? matrix[0][0]->resp.mpr_rec.hops : 0,
+		matrix[0][1] ? matrix[0][1]->resp.mpr_rec.path_rec.slid : 0,
+		matrix[0][1] ? matrix[0][1]->resp.mpr_rec.path_rec.dlid : 0,
+		matrix[0][1] ? matrix[0][1]->resp.mpr_rec.hops : 0,
+		matrix[1][0] ? matrix[1][0]->resp.mpr_rec.path_rec.slid : 0,
+		matrix[1][0] ? matrix[1][0]->resp.mpr_rec.path_rec.dlid : 0,
+		matrix[1][0] ? matrix[1][0]->resp.mpr_rec.hops : 0,
+		matrix[1][1] ? matrix[1][1]->resp.mpr_rec.path_rec.slid : 0,
+		matrix[1][1] ? matrix[1][1]->resp.mpr_rec.path_rec.dlid : 0,
+		matrix[1][1] ? matrix[1][1]->resp.mpr_rec.hops : 0);
+
+	sumA = minA = sumB = minB = 0;
 
 	/* check diagonal A {(0,0), (1,1)} */
-	sumA = matrix[0][0]->resp.mpr_rec.hops + matrix[1][1]->resp.mpr_rec.hops;
-	minA = min(matrix[0][0]->resp.mpr_rec.hops, matrix[1][1]->resp.mpr_rec.hops);
+	if (matrix[0][0]) {
+		sumA += matrix[0][0]->resp.mpr_rec.hops;
+		minA = matrix[0][0]->resp.mpr_rec.hops;
+	}
+	if (matrix[1][1]) {
+		sumA += matrix[1][1]->resp.mpr_rec.hops;
+		if (minA)
+			minA = min(minA, matrix[1][1]->resp.mpr_rec.hops);
+		else
+			minA = matrix[1][1]->resp.mpr_rec.hops;
+	}
 
 	/* check diagonal B {(0,1), (1,0)} */
-	sumB = matrix[0][1]->resp.mpr_rec.hops + matrix[1][0]->resp.mpr_rec.hops;
-	minB = min(matrix[0][1]->resp.mpr_rec.hops, matrix[1][0]->resp.mpr_rec.hops);
+	if (matrix[0][1]) {
+		sumB += matrix[0][1]->resp.mpr_rec.hops;
+		minB = matrix[0][1]->resp.mpr_rec.hops;
+	}
+	if (matrix[1][0]) {
+		sumB += matrix[1][0]->resp.mpr_rec.hops;
+		if (minB)
+			minB = min(minB, matrix[1][0]->resp.mpr_rec.hops);
+		else
+			minB = matrix[1][0]->resp.mpr_rec.hops;
+	}
 
 	/* and the winner is... */
 	if (minA <= minB || (minA == minB && sumA < sumB)) {
@@ -1442,14 +1462,16 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Diag {0,0} & {1,1} is the best:\n"
 			"\t{0,0} 0x%X->0x%X (%d)\t & {1,1} 0x%X->0x%X (%d)\n",
-			matrix[0][0]->resp.mpr_rec.path_rec.slid,
-			matrix[0][0]->resp.mpr_rec.path_rec.dlid,
-			matrix[0][0]->resp.mpr_rec.hops,
-			matrix[1][1]->resp.mpr_rec.path_rec.slid,
-			matrix[1][1]->resp.mpr_rec.path_rec.dlid,
-			matrix[1][1]->resp.mpr_rec.hops);
-		cl_qlist_insert_tail(p_list, &matrix[0][0]->list_item);
-		cl_qlist_insert_tail(p_list, &matrix[1][1]->list_item);
+			matrix[0][0] ? matrix[0][0]->resp.mpr_rec.path_rec.slid : 0,
+			matrix[0][0] ? matrix[0][0]->resp.mpr_rec.path_rec.dlid : 0,
+			matrix[0][0] ? matrix[0][0]->resp.mpr_rec.hops : 0,
+			matrix[1][1] ? matrix[1][1]->resp.mpr_rec.path_rec.slid : 0,
+			matrix[1][1] ? matrix[1][1]->resp.mpr_rec.path_rec.dlid : 0,
+			matrix[1][1] ? matrix[1][1]->resp.mpr_rec.hops : 0);
+		if (matrix[0][0])
+			cl_qlist_insert_tail(p_list, &matrix[0][0]->list_item);
+		if (matrix[1][1])
+			cl_qlist_insert_tail(p_list, &matrix[1][1]->list_item);
 		free(matrix[0][1]);
 		free(matrix[1][0]);
 	} else {
@@ -1457,14 +1479,16 @@ static void mpr_rcv_get_apm_paths(IN osm_sa_t * sa,
 		OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 			"Diag {0,1} & {1,0} is the best:\n"
 			"\t{0,1} 0x%X->0x%X (%d)\t & {1,0} 0x%X->0x%X (%d)\n",
-			matrix[0][1]->resp.mpr_rec.path_rec.slid,
-			matrix[0][1]->resp.mpr_rec.path_rec.dlid,
-			matrix[0][1]->resp.mpr_rec.hops,
-			matrix[1][0]->resp.mpr_rec.path_rec.slid,
-			matrix[1][0]->resp.mpr_rec.path_rec.dlid,
-			matrix[1][0]->resp.mpr_rec.hops);
-		cl_qlist_insert_tail(p_list, &matrix[0][1]->list_item);
-		cl_qlist_insert_tail(p_list, &matrix[1][0]->list_item);
+			matrix[0][1] ? matrix[0][1]->resp.mpr_rec.path_rec.slid : 0,
+			matrix[0][1] ? matrix[0][1]->resp.mpr_rec.path_rec.dlid : 0,
+			matrix[0][1] ? matrix[0][1]->resp.mpr_rec.hops : 0,
+			matrix[1][0] ? matrix[1][0]->resp.mpr_rec.path_rec.slid : 0,
+			matrix[1][0] ? matrix[1][0]->resp.mpr_rec.path_rec.dlid: 0,
+			matrix[1][0] ? matrix[1][0]->resp.mpr_rec.hops : 0);
+		if (matrix[0][1])
+			cl_qlist_insert_tail(p_list, &matrix[0][1]->list_item);
+		if (matrix[1][0])
+			cl_qlist_insert_tail(p_list, &matrix[1][0]->list_item);
 		free(matrix[0][0]);
 		free(matrix[1][1]);
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
