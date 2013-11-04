From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Improve memory consumption of pkey manager by using
 cl_map for accum_pkeys
Date: Mon, 04 Nov 2013 12:43:08 -0500
Message-ID: <5277DCAC.7070102@dev.mellanox.co.il>
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
diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 2ba80b3..9459b5b 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -82,7 +82,7 @@ struct osm_physp;
 * SYNOPSIS
 */
 typedef struct osm_pkeybl {
-	cl_ptr_vector_t accum_pkeys;
+	cl_map_t accum_pkeys;
 	cl_ptr_vector_t blocks;
 	cl_ptr_vector_t new_blocks;
 	cl_map_t keys;
@@ -300,6 +300,18 @@ static inline ib_pkey_table_t *osm_pkey_tbl_new_block_get(const osm_pkey_tbl_t *
 		&p_pkey_tbl->new_blocks, block) : NULL);
 };
 
+/****f* OpenSM: osm_pkey_find_last_accum_pkey_index
+ * NAME
+ *   osm_pkey_find_last_accum_pkey_index
+ *
+ * DESCRIPTION
+ *   Finds the next last accumulated pkey
+ *
+ * SYNOPSIS
+ */
+void osm_pkey_find_last_accum_pkey_index(IN osm_pkey_tbl_t * p_pkey_tbl);
+
+
 /****f* OpenSM: osm_pkey_tbl_set_accum_pkeys
 * NAME
 *  osm_pkey_tbl_set_accum_pkeys
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 7a8ac0a..463108d 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -58,7 +58,7 @@
 
 void osm_pkey_tbl_construct(IN osm_pkey_tbl_t * p_pkey_tbl)
 {
-	cl_ptr_vector_construct(&p_pkey_tbl->accum_pkeys);
+	cl_map_construct(&p_pkey_tbl->accum_pkeys);
 	cl_ptr_vector_construct(&p_pkey_tbl->blocks);
 	cl_ptr_vector_construct(&p_pkey_tbl->new_blocks);
 	cl_map_construct(&p_pkey_tbl->keys);
@@ -82,7 +82,8 @@ void osm_pkey_tbl_destroy(IN osm_pkey_tbl_t * p_pkey_tbl)
 			free(p_block);
 	cl_ptr_vector_destroy(&p_pkey_tbl->new_blocks);
 
-	cl_ptr_vector_destroy(&p_pkey_tbl->accum_pkeys);
+	cl_map_remove_all(&p_pkey_tbl->accum_pkeys);
+	cl_map_destroy(&p_pkey_tbl->accum_pkeys);
 
 	cl_map_remove_all(&p_pkey_tbl->keys);
 	cl_map_destroy(&p_pkey_tbl->keys);
@@ -90,7 +91,7 @@ void osm_pkey_tbl_destroy(IN osm_pkey_tbl_t * p_pkey_tbl)
 
 ib_api_status_t osm_pkey_tbl_init(IN osm_pkey_tbl_t * p_pkey_tbl)
 {
-	cl_ptr_vector_init(&p_pkey_tbl->accum_pkeys, 0, 1);
+	cl_map_init(&p_pkey_tbl->accum_pkeys, 1);
 	cl_ptr_vector_init(&p_pkey_tbl->blocks, 0, 1);
 	cl_ptr_vector_init(&p_pkey_tbl->new_blocks, 0, 1);
 	cl_map_init(&p_pkey_tbl->keys, 1);
@@ -193,11 +194,44 @@ cl_status_t osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 					 IN uint16_t pkey_idx)
 {
 	uintptr_t ptr = pkey_idx + 1; /* 0 means not found so bias by 1 */
+	uint16_t *p_prev_pkey_idx;
+	cl_status_t status = CL_SUCCESS;
 
 	if (pkey_idx >= p_pkey_tbl->last_pkey_idx)
 		p_pkey_tbl->last_pkey_idx = pkey_idx + 1;
 
-	return cl_ptr_vector_set(&p_pkey_tbl->accum_pkeys, pkey, (void *)ptr);
+	p_prev_pkey_idx = (uint16_t *) cl_map_get(&p_pkey_tbl->accum_pkeys, pkey);
+
+	if (p_prev_pkey_idx != NULL)
+		cl_map_remove(&p_pkey_tbl->accum_pkeys, pkey);
+
+	if (cl_map_insert(&p_pkey_tbl->accum_pkeys, pkey, (void *) ptr) == NULL)
+		status = CL_INSUFFICIENT_MEMORY;
+
+	return status;
+
+}
+
+/*
++ * Find the next last pkey index
++*/
+void osm_pkey_find_last_accum_pkey_index(IN osm_pkey_tbl_t * p_pkey_tbl)
+{
+	void *ptr;
+	uintptr_t pkey_idx_ptr;
+	uint16_t pkey_idx, last_pkey_idx = 0;
+	cl_map_iterator_t map_iter = cl_map_head(&p_pkey_tbl->accum_pkeys);
+
+	while (map_iter != cl_map_end(&p_pkey_tbl->accum_pkeys)) {
+		ptr = (uint16_t *) cl_map_obj(map_iter);
+		CL_ASSERT(ptr);
+		pkey_idx_ptr = (uintptr_t) ptr;
+		pkey_idx = pkey_idx_ptr;
+		if (pkey_idx > last_pkey_idx)
+			last_pkey_idx = pkey_idx;
+		map_iter = cl_map_next(map_iter);
+	}
+	p_pkey_tbl->last_pkey_idx = last_pkey_idx;
 }
 
 /*
@@ -207,32 +241,12 @@ void osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 				    IN uint16_t pkey)
 {
 	void *ptr;
-	uintptr_t pkey_idx_ptr;
-	uint16_t pkey_idx, last_pkey_idx;
-	uint32_t i;
 
-	ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, pkey);
+	ptr = cl_map_remove(&p_pkey_tbl->accum_pkeys, pkey);
 	if (ptr == NULL)
 		return;
 
-	cl_ptr_vector_set(&p_pkey_tbl->accum_pkeys, pkey, NULL);
-
-	pkey_idx_ptr = (uintptr_t) ptr;
-	pkey_idx = pkey_idx_ptr;
-
-	if (p_pkey_tbl->last_pkey_idx == pkey_idx) {
-		last_pkey_idx = 0;
-		for (i = 1; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
-			ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
-			if (ptr != NULL) {
-				pkey_idx_ptr = (uintptr_t) ptr;
-				pkey_idx = pkey_idx_ptr;
-				if (pkey_idx > last_pkey_idx)
-					last_pkey_idx = pkey_idx;
-			}
-		}
-		p_pkey_tbl->last_pkey_idx = last_pkey_idx;
-	}
+	osm_pkey_find_last_accum_pkey_index(p_pkey_tbl);
 }
 
 /*
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 105473f..d9f2d94 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -279,24 +279,30 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 }
 
 static void clear_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
-                                   uint16_t pkey_index)
+				   uint16_t pkey_index)
 {
 	uint16_t pkey_idx_bias, pkey_idx;
-	uint32_t i;
 	void *ptr;
 	uintptr_t pkey_idx_ptr;
+	cl_map_iterator_t map_iter, map_iter_temp;
+
+	map_iter = cl_map_head(&p_pkey_tbl->accum_pkeys);
 
 	pkey_idx_bias = pkey_index + 1; // adjust for pkey index bias in accum_pkeys
-	for (i = 1; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
-		ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
-		if (ptr != NULL) {
-			pkey_idx_ptr = (uintptr_t) ptr;
-			pkey_idx = pkey_idx_ptr;
-			if (pkey_idx == pkey_idx_bias) {
-				osm_pkey_tbl_clear_accum_pkeys(p_pkey_tbl, i);
-				break;
-			}
+
+	while (map_iter != cl_map_end(&p_pkey_tbl->accum_pkeys)) {
+		map_iter_temp = cl_map_next(map_iter);
+		ptr = (uint16_t *) cl_map_obj(map_iter);
+		CL_ASSERT(ptr);
+		pkey_idx_ptr = (uintptr_t) ptr;
+		pkey_idx = pkey_idx_ptr;
+		if (pkey_idx == pkey_idx_bias) {
+			cl_map_remove_item(&p_pkey_tbl->accum_pkeys, map_iter);
+			if (p_pkey_tbl->last_pkey_idx == pkey_idx)
+				osm_pkey_find_last_accum_pkey_index(p_pkey_tbl);
+			break;
 		}
+		map_iter = map_iter_temp;
 	}
 }
 
@@ -376,17 +382,14 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 			pkey_index = p_pending->index;
 			found = TRUE;
 		} else {
-			if (p_pending->pkey < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys)) {
-				ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys,
-							p_pending->pkey);
-				if (ptr != NULL) {
-					pkey_idx_ptr = (uintptr_t) ptr;
-					pkey_idx = pkey_idx_ptr;
-					pkey_idx--; /* adjust pkey index for bias */
-					block_index = pkey_idx / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
-					pkey_index = pkey_idx % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
-					found = TRUE;
-				}
+			ptr = cl_map_get(&p_pkey_tbl->accum_pkeys,p_pending->pkey);
+			if (ptr != NULL) {
+				pkey_idx_ptr = (uintptr_t) ptr;
+				pkey_idx = pkey_idx_ptr;
+				pkey_idx--; /* adjust pkey index for bias */
+				block_index = pkey_idx / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+				pkey_index = pkey_idx % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+				found = TRUE;
 			}
 
 			if (!found) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
