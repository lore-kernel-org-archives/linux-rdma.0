From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/4] opensm/PKeyMgr: Support pkey index reuse when there are
 no longer any previously unused indices available
Date: Tue, 24 May 2011 13:25:35 -0400
Message-ID: <4DDBEA0F.7020103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_pkey.h |   23 ++++++++++
 opensm/osm_pkey.c         |   39 ++++++++++++++++-
 opensm/osm_pkey_mgr.c     |  101 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 143 insertions(+), 20 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 066bbb3..0d284de 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -322,6 +322,29 @@ osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 *
 *********/
 
+/****f* OpenSM: osm_pkey_tbl_clear_accum_pkeys
+* NAME
+*  osm_pkey_tbl_clear_accum_pkeys
+*
+* DESCRIPTION
+*   Clears the given pkey in the "accum_pkeys" array
+*
+* SYNOPSIS
+*/
+void
+osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
+			       IN uint16_t pkey);
+/*
+* p_pkey_tbl
+*   [in] Pointer to the PKey table
+*
+* pkey
+*   [in] PKey to clear
+*
+* NOTES
+*
+*********/
+
 /****f* OpenSM: osm_pkey_tbl_set_new_entry
 * NAME
 *  osm_pkey_tbl_set_new_entry
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 02b7c59..885f28a 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -186,12 +186,47 @@ cl_status_t osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
 {
 	uintptr_t ptr = pkey_idx + 1; /* 0 means not found so bias by 1 */
 
-	if (pkey_idx > p_pkey_tbl->last_pkey_idx)
-		p_pkey_tbl->last_pkey_idx = pkey_idx;
+	if (pkey_idx >= p_pkey_tbl->last_pkey_idx)
+		p_pkey_tbl->last_pkey_idx = pkey_idx + 1;
+
 	return cl_ptr_vector_set(&p_pkey_tbl->accum_pkeys, pkey, (void *)ptr);
 }
 
 /*
+  Clears the given pkey (along with it's overall index) in the accum_pkeys array.
+*/
+void osm_pkey_tbl_clear_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
+				    IN uint16_t pkey)
+{
+	void *ptr;
+	uintptr_t pkey_idx_ptr;
+	uint16_t pkey_idx, last_pkey_idx, i;
+
+	ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, pkey);
+	if (ptr == NULL)
+		return;
+
+	cl_ptr_vector_set(&p_pkey_tbl->accum_pkeys, pkey, NULL);
+
+	pkey_idx_ptr = (uintptr_t) ptr;
+	pkey_idx = pkey_idx_ptr;
+
+	if (p_pkey_tbl->last_pkey_idx == pkey_idx) {
+		last_pkey_idx = 0;
+		for (i = 0; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
+			ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
+			if (ptr != NULL) {
+				pkey_idx_ptr = (uintptr_t) ptr;
+				pkey_idx = pkey_idx_ptr;
+				if (pkey_idx > last_pkey_idx)
+					last_pkey_idx = pkey_idx;
+			}
+		}
+		p_pkey_tbl->last_pkey_idx = last_pkey_idx;
+	}
+}
+
+/*
   Store the given pkey in the "new" blocks array.
   Also, make sure the regular block exists.
 */
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 70471b0..898a3b8 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -250,12 +250,38 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	return status;
 }
 
-static void last_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
-				  uint16_t * p_block_idx,
-				  uint8_t * p_pkey_idx)
+static void clear_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
+                                   uint16_t pkey_index)
 {
-	*p_block_idx = p_pkey_tbl->last_pkey_idx / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
-	*p_pkey_idx = p_pkey_tbl->last_pkey_idx % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+	uint16_t i, pkey_idx_bias, pkey_idx;
+	void *ptr;
+	uintptr_t pkey_idx_ptr;
+
+	pkey_idx_bias = pkey_index + 1; // adjust for pkey index bias in accum_pkeys
+	for (i = 0; i < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys); i++) {
+		ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys, i);
+		if (ptr != NULL) {
+			pkey_idx_ptr = (uintptr_t) ptr;
+			pkey_idx = pkey_idx_ptr;
+			if (pkey_idx == pkey_idx_bias) {
+				osm_pkey_tbl_clear_accum_pkeys(p_pkey_tbl, i);
+				break;
+			}
+		}
+	}
+}
+
+static int last_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
+				 uint16_t * p_block_idx,
+				 uint8_t * p_pkey_idx)
+{
+	if (p_pkey_tbl->last_pkey_idx) {
+		*p_block_idx = (p_pkey_tbl->last_pkey_idx - 1) / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+		*p_pkey_idx = (p_pkey_tbl->last_pkey_idx - 1) % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+		return 1;
+	}
+
+	return 0;
 }
 
 static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
@@ -275,7 +301,7 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	osm_pending_pkey_t *p_pending;
 	boolean_t found;
 	ib_pkey_table_t empty_block;
-	int ret = 0;
+	int ret = 0, full = 0;
 	void *ptr;
 	uintptr_t pkey_idx_ptr;
 	uint16_t pkey_idx;
@@ -335,24 +361,54 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 			}
 
 			if (!found) {
-				last_accum_pkey_index(p_pkey_tbl,
+				if (last_accum_pkey_index(p_pkey_tbl,
 						      &last_free_block_index,
-						      &last_free_pkey_index);
-				block_index = last_free_block_index;
-				pkey_index = last_free_pkey_index + 1;
+						      &last_free_pkey_index)) {
+					block_index = last_free_block_index;
+					pkey_index = last_free_pkey_index + 1;
+				} else {
+					block_index = 0;
+					pkey_index = 0;
+				}
 				if (pkey_index >= IB_NUM_PKEY_ELEMENTS_IN_BLOCK) {
 					block_index++;
 					pkey_index -= IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
 				}
 				if (block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index >= pkey_mgr_get_physp_max_pkeys(p_physp)) {
-					OSM_LOG(p_log, OSM_LOG_ERROR,
-						"ERR 0512: "
-						"Failed to set PKey 0x%04x because Pkey table is full "
-						"for node 0x%016" PRIx64 " port %u (%s)\n",
-						cl_ntoh16(p_pending->pkey),
-						cl_ntoh64(osm_node_get_node_guid(p_node)),
-						osm_physp_get_port_num(p_physp),
-						p_physp->p_node->print_desc);
+					last_free_block_index = 0;
+					last_free_pkey_index = 0;
+					found = osm_pkey_find_next_free_entry(p_pkey_tbl, &last_free_block_index, &last_free_pkey_index);
+					if (!found)
+						full = 1;
+					else {
+						block_index = last_free_block_index;
+						pkey_index = last_free_pkey_index;
+						if (block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index >= pkey_mgr_get_physp_max_pkeys(p_physp)) {
+							full = 1;
+							found = FALSE;
+						} else {
+							OSM_LOG(p_log, OSM_LOG_INFO,
+								"Reusing PKeyTable block index %u pkey index %u "
+								"for pkey 0x%x on 0x%016" PRIx64 " port %u (%s)\n",
+								block_index,
+								pkey_index,
+								cl_ntoh16(p_pending->pkey),
+								cl_ntoh64(osm_node_get_node_guid(p_node)),
+								osm_physp_get_port_num(p_physp),
+								p_physp->p_node->print_desc);
+
+							clear_accum_pkey_index(p_pkey_tbl, block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index);
+						}
+					}
+					if (full)
+						OSM_LOG(p_log, OSM_LOG_ERROR,
+							"ERR 0512: "
+							"Failed to set PKey 0x%04x because Pkey table is full "
+							"for node 0x%016" PRIx64 " port %u (%s)\n",
+							cl_ntoh16(p_pending->pkey),
+							cl_ntoh64(osm_node_get_node_guid(p_node)),
+							osm_physp_get_port_num(p_physp),
+							p_physp->p_node->print_desc);
 				} else
 					found = TRUE;
 			}
@@ -378,6 +434,15 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 			    osm_pkey_tbl_set_accum_pkeys(p_pkey_tbl,
 							 p_pending->pkey,
 							 block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index)) {
+				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0508: "
+					"Failed to set accum_pkeys PKey 0x%04x "
+					"in block %u idx %u for node 0x%016"
+					PRIx64 " port %u (%s)\n",
+					cl_ntoh16(p_pending->pkey), block_index,
+					pkey_index,
+					cl_ntoh64(osm_node_get_node_guid(p_node)),
+					osm_physp_get_port_num(p_physp),
+					p_physp->p_node->print_desc);
 			}
 		}
 
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
