From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mesh: Cosmetic changes
Date: Tue, 13 Oct 2009 14:59:48 -0400
Message-ID: <20091013185948.GA14761@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/opensm/osm_mesh.h b/opensm/include/opensm/osm_mesh.h
index 3800372..d95b9a9 100644
--- a/opensm/include/opensm/osm_mesh.h
+++ b/opensm/include/opensm/osm_mesh.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008,2009  System Fabric Works, Inc. All rights reserved.
+ * Copyright (c) 2008,2009 System Fabric Works, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
index 9469420..7756695 100644
--- a/opensm/opensm/osm_mesh.c
+++ b/opensm/opensm/osm_mesh.c
@@ -210,9 +210,9 @@ static int *poly_alloc(lash_t *p_lash, int n)
 	osm_log_t *p_log = &p_lash->p_osm->log;
 	int *p;
 
-	if (!(p = calloc(n+1, sizeof(int)))) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating poly - out of memory\n");
-	}
+	if (!(p = calloc(n+1, sizeof(int))))
+		OSM_LOG(p_log, OSM_LOG_ERROR,
+			"Failed allocating poly - out of memory\n");
 
 	return p;
 }
@@ -312,9 +312,10 @@ static int **m_alloc(lash_t *p_lash, int l)
 			break;
 
 		return m;
-	} while(0);
+	} while (0);
 
-	OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating matrix - out of memory\n");
+	OSM_LOG(p_log, OSM_LOG_ERROR,
+		"Failed allocating matrix - out of memory\n");
 
 	m_free(m, l);
 	return NULL;
@@ -373,9 +374,10 @@ static int ***pm_alloc(lash_t *p_lash, int l, int n)
 			break;
 
 		return m;
-	} while(0);
+	} while (0);
 
-	OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating matrix - out of memory\n");
+	OSM_LOG(p_log, OSM_LOG_ERROR,
+		"Failed allocating matrix - out of memory\n");
 
 	pm_free(m, l);
 	return NULL;
@@ -389,7 +391,8 @@ static int determinant(lash_t *p_lash, int n, int rank, int ***m, int *p);
  * compute the determinant of a submatrix of matrix of rank l of polynomials of degree n
  * with row and col removed in poly. caller must free poly
  */
-static int sub_determinant(lash_t *p_lash, int n, int l, int row, int col, int ***matrix, int **poly)
+static int sub_determinant(lash_t *p_lash, int n, int l, int row, int col,
+			   int ***matrix, int **poly)
 {
 	int ret = -1;
 	int ***m = NULL;
@@ -439,7 +442,7 @@ static int sub_determinant(lash_t *p_lash, int n, int l, int row, int col, int *
 		}
 
 		ret = 0;
-	} while(0);
+	} while (0);
 
 	pm_free(m, rank);
 	*poly = p;
@@ -545,9 +548,8 @@ static int char_poly(lash_t *p_lash, int rank, int **matrix, int **poly)
 		if (!matrix)
 			break;
 
-		if (!(p = poly_alloc(p_lash, deg))) {
+		if (!(p = poly_alloc(p_lash, deg)))
 			break;
-		}
 
 		if (!(m = pm_alloc(p_lash, rank, deg))) {
 			free(p);
@@ -569,7 +571,7 @@ static int char_poly(lash_t *p_lash, int rank, int **matrix, int **poly)
 		}
 
 		ret = 0;
-	} while(0);
+	} while (0);
 
 	pm_free(m, rank);
 	*poly = p;
@@ -635,7 +637,7 @@ static int get_switch_metric(lash_t *p_lash, int sw)
 						}
 					}
 				}
-			} while(change);
+			} while (change);
 
 			for (j = 0; j < num_links; j++) {
 				sw2 = node->links[j]->switch_id;
@@ -651,7 +653,7 @@ static int get_switch_metric(lash_t *p_lash, int sw)
 		}
 
 		ret = 0;
-	} while(0);
+	} while (0);
 
 	node->matrix = m;
 
@@ -685,8 +687,7 @@ static void classify_switch(lash_t *p_lash, mesh_t *mesh, int sw)
 			continue;
 
 		mesh->class_count[i]++;
-		OSM_LOG_EXIT(p_log);
-		return;
+		goto done;
 	}
 
 	mesh->class_type[mesh->num_class] = sw;
@@ -695,7 +696,6 @@ static void classify_switch(lash_t *p_lash, mesh_t *mesh, int sw)
 
 done:
 	OSM_LOG_EXIT(p_log);
-	return;
 }
 
 /*
@@ -995,7 +995,8 @@ static void make_geometry(lash_t *p_lash, int sw)
 					    s1->node->matrix[i][j] <= 4) {
 						if (s1->node->axes[j]) {
 							if (s1->node->axes[j] != opposite(seed, s1->node->axes[i])) {
-								OSM_LOG(p_log, OSM_LOG_DEBUG, "phase 1 mismatch\n");
+								OSM_LOG(p_log, OSM_LOG_DEBUG,
+									"phase 1 mismatch\n");
 							}
 						} else {
 							s1->node->axes[j] = opposite(seed, s1->node->axes[i]);
@@ -1021,7 +1022,8 @@ static void make_geometry(lash_t *p_lash, int sw)
 					continue;
 
 				if (l2 == -1) {
-					OSM_LOG(p_log, OSM_LOG_DEBUG, "no reverse link\n");
+					OSM_LOG(p_log, OSM_LOG_DEBUG,
+						"no reverse link\n");
 					continue;
 				}
 
@@ -1039,7 +1041,8 @@ static void make_geometry(lash_t *p_lash, int sw)
 					change++;
 				} else {
 					if (s2->node->axes[l2] != opposite(seed, s1->node->axes[i])) {
-						OSM_LOG(p_log, OSM_LOG_DEBUG, "phase 2 mismatch\n");
+						OSM_LOG(p_log, OSM_LOG_DEBUG,
+							"phase 2 mismatch\n");
 					}
 				}
 			}
@@ -1103,11 +1106,10 @@ next_j:
 				}
 			}
 		}
-	} while(change);
+	} while (change);
 
 done:
 	OSM_LOG_EXIT(p_log);
-	return;
 }
 
 /*
@@ -1140,13 +1142,15 @@ static int reorder_node_links(lash_t *p_lash, mesh_t *mesh, int sw)
 	int dimension = mesh->dimension;
 
 	if (!(links = calloc(n, sizeof(link_t *)))) {
-		OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating temp array - out of memory\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR,
+			"Failed allocating links array - out of memory\n");
 		return -1;
 	}
 
 	if (!(axes = calloc(n, sizeof(int)))) {
 		free(links);
-		OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating temp array - out of memory\n");
+		OSM_LOG(p_log, OSM_LOG_ERROR,
+			"Failed allocating axes array - out of memory\n");
 		return -1;
 	}
 
@@ -1235,7 +1239,8 @@ static int make_coord(lash_t *p_lash, mesh_t *mesh, int seed)
 				assigned_axes++;
 	}
 
-	OSM_LOG(p_log, OSM_LOG_DEBUG, "%d/%d unassigned/assigned axes\n", unassigned_axes, assigned_axes);
+	OSM_LOG(p_log, OSM_LOG_DEBUG, "%d/%d unassigned/assigned axes\n",
+		unassigned_axes, assigned_axes);
 
 	do {
 		change = 0;
@@ -1479,7 +1484,8 @@ static mesh_t *mesh_create(lash_t *p_lash)
 
 err:
 	mesh_delete(mesh);
-	OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating mesh - out of memory\n");
+	OSM_LOG(p_log, OSM_LOG_ERROR,
+		"Failed allocating mesh - out of memory\n");
 	return NULL;
 }
 
@@ -1556,7 +1562,8 @@ int osm_mesh_node_create(lash_t *p_lash, switch_t *sw)
 
 err:
 	osm_mesh_node_delete(p_lash, sw);
-	OSM_LOG(p_log, OSM_LOG_ERROR, "Failed allocating mesh node - out of memory\n");
+	OSM_LOG(p_log, OSM_LOG_ERROR,
+		"Failed allocating mesh node - out of memory\n");
 	OSM_LOG_EXIT(p_log);
 	return -1;
 }
@@ -1642,17 +1649,21 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 		goto err;
 
 	if (mesh->num_class == 0) {
-		OSM_LOG(p_log, OSM_LOG_INFO, "found no likely mesh nodes - done\n");
+		OSM_LOG(p_log, OSM_LOG_INFO,
+			"found no likely mesh nodes - done\n");
 		goto done;
 	}
 
 	/*
 	 * find dominant switch class
 	 */
-	OSM_LOG(p_log, OSM_LOG_INFO, "found %d node class%s\n", mesh->num_class, (mesh->num_class == 1)? "" : "es");
+	OSM_LOG(p_log, OSM_LOG_INFO, "found %d node class%s\n",
+		mesh->num_class, (mesh->num_class == 1)? "" : "es");
 	for (i = 0; i < mesh->num_class; i++) {
-		OSM_LOG(p_log, OSM_LOG_INFO, "class[%d] has %d members with type = %d\n",
-		i, mesh->class_count[i], p_lash->switches[mesh->class_type[i]]->node->type);
+		OSM_LOG(p_log, OSM_LOG_INFO,
+			"class[%d] has %d members with type = %d\n",
+			i, mesh->class_count[i],
+			p_lash->switches[mesh->class_type[i]]->node->type);
 		if (mesh->class_count[i] > max_class_num) {
 			max_class = i;
 			max_class_num = mesh->class_count[i];
@@ -1663,7 +1674,8 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 	s = p_lash->switches[max_class_type];
 
 	p = buf;
-	p += sprintf( p, "%snode shape is ", (mesh->num_class == 1)? "" : "most common ");
+	p += sprintf(p, "%snode shape is ",
+		    (mesh->num_class == 1) ? "" : "most common ");
 
 	if (s->node->type) {
 		const struct mesh_info *t = &mesh_info[s->node->type];
@@ -1681,7 +1693,8 @@ int osm_do_mesh_analysis(lash_t *p_lash)
 
 	OSM_LOG(p_log, OSM_LOG_INFO, "%s", buf);
 
-	OSM_LOG(p_log, OSM_LOG_INFO, "poly = %s\n", poly_print(s->node->num_links, s->node->poly));
+	OSM_LOG(p_log, OSM_LOG_INFO, "poly = %s\n",
+		poly_print(s->node->num_links, s->node->poly));
 
 	if (s->node->type) {
 		make_geometry(p_lash, max_class_type);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
