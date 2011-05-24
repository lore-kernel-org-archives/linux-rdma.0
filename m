From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/4] opensm/PkeyMgr: Don't change end port pkey index when
 simultaneously adding and removing partitions
Date: Tue, 24 May 2011 13:24:57 -0400
Message-ID: <4DDBE9E9.20404@dev.mellanox.co.il>
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
 include/opensm/osm_pkey.h |   35 +++++++++++++++++++
 opensm/osm_pkey.c         |   19 ++++++++++
 opensm/osm_pkey_mgr.c     |   81 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 118 insertions(+), 17 deletions(-)

diff --git a/include/opensm/osm_pkey.h b/include/opensm/osm_pkey.h
index 53e9657..33de7e7 100644
--- a/include/opensm/osm_pkey.h
+++ b/include/opensm/osm_pkey.h
@@ -82,15 +82,21 @@ struct osm_physp;
 * SYNOPSIS
 */
 typedef struct osm_pkeybl {
+	cl_ptr_vector_t accum_pkeys;
 	cl_ptr_vector_t blocks;
 	cl_ptr_vector_t new_blocks;
 	cl_map_t keys;
 	cl_qlist_t pending;
+	uint16_t last_pkey_idx;
 	uint16_t used_blocks;
 	uint16_t max_blocks;
 } osm_pkey_tbl_t;
 /*
 * FIELDS
+*	accum_pkeys
+*		Accumulated pkeys with pkey index. Used to
+*		preserve pkey index.
+*
 *	blocks
 *		The IBA defined blocks of pkey values, updated from the subnet
 *
@@ -288,6 +294,35 @@ static inline ib_pkey_table_t *osm_pkey_tbl_new_block_get(const osm_pkey_tbl_t *
 		&p_pkey_tbl->new_blocks, block) : NULL);
 };
 
+/****f* OpenSM: osm_pkey_tbl_set_accum_pkeys
+* NAME
+*  osm_pkey_tbl_set_accum_pkeys
+*
+* DESCRIPTION
+*   Stores the given pkey in the "accum_pkeys" array and update
+*   update the "map"
+*
+* SYNOPSIS
+*/
+cl_status_t
+osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
+			     IN uint16_t pkey, IN uint16_t pkey_idx);
+/*
+* p_pkey_tbl
+*   [in] Pointer to the PKey table
+*
+* pkey
+*   [in] PKey to store
+*
+* pkey_idx
+*   [in] The overall index
+*
+* RETURN VALUES
+*   CL_SUCCESS if OK
+*   CL_INSUFFICIENT_MEMORY if failed
+*
+*********/
+
 /****f* OpenSM: osm_pkey_tbl_set_new_entry
 * NAME
 *  osm_pkey_tbl_set_new_entry
diff --git a/opensm/osm_pkey.c b/opensm/osm_pkey.c
index 6abc8ed..02b7c59 100644
--- a/opensm/osm_pkey.c
+++ b/opensm/osm_pkey.c
@@ -56,6 +56,7 @@
 
 void osm_pkey_tbl_construct(IN osm_pkey_tbl_t * p_pkey_tbl)
 {
+	cl_ptr_vector_construct(&p_pkey_tbl->accum_pkeys);
 	cl_ptr_vector_construct(&p_pkey_tbl->blocks);
 	cl_ptr_vector_construct(&p_pkey_tbl->new_blocks);
 	cl_map_construct(&p_pkey_tbl->keys);
@@ -79,16 +80,20 @@ void osm_pkey_tbl_destroy(IN osm_pkey_tbl_t * p_pkey_tbl)
 			free(p_block);
 	cl_ptr_vector_destroy(&p_pkey_tbl->new_blocks);
 
+	cl_ptr_vector_destroy(&p_pkey_tbl->accum_pkeys);
+
 	cl_map_remove_all(&p_pkey_tbl->keys);
 	cl_map_destroy(&p_pkey_tbl->keys);
 }
 
 ib_api_status_t osm_pkey_tbl_init(IN osm_pkey_tbl_t * p_pkey_tbl)
 {
+	cl_ptr_vector_init(&p_pkey_tbl->accum_pkeys, 0, 1);
 	cl_ptr_vector_init(&p_pkey_tbl->blocks, 0, 1);
 	cl_ptr_vector_init(&p_pkey_tbl->new_blocks, 0, 1);
 	cl_map_init(&p_pkey_tbl->keys, 1);
 	cl_qlist_init(&p_pkey_tbl->pending);
+	p_pkey_tbl->last_pkey_idx = 0;
 	p_pkey_tbl->used_blocks = 0;
 	p_pkey_tbl->max_blocks = 0;
 	return IB_SUCCESS;
@@ -173,6 +178,20 @@ ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 }
 
 /*
+  Store the given pkey (along with it's overall index) in the accum_pkeys array.
+*/
+cl_status_t osm_pkey_tbl_set_accum_pkeys(IN osm_pkey_tbl_t * p_pkey_tbl,
+					 IN uint16_t pkey,
+					 IN uint16_t pkey_idx)
+{
+	uintptr_t ptr = pkey_idx + 1; /* 0 means not found so bias by 1 */
+
+	if (pkey_idx > p_pkey_tbl->last_pkey_idx)
+		p_pkey_tbl->last_pkey_idx = pkey_idx;
+	return cl_ptr_vector_set(&p_pkey_tbl->accum_pkeys, pkey, (void *)ptr);
+}
+
+/*
   Store the given pkey in the "new" blocks array.
   Also, make sure the regular block exists.
 */
diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 609d753..4c92c05 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -54,12 +54,12 @@
 #include <opensm/osm_opensm.h>
 
 /*
-  The max number of pkey blocks for a physical port is located in
-  a different place for switch external ports (SwitchInfo) and the
+  The max number of pkeys/pkey blocks for a physical port is located
+  in a different place for switch external ports (SwitchInfo) and the
   rest of the ports (NodeInfo).
 */
 static uint16_t
-pkey_mgr_get_physp_max_blocks(IN const osm_physp_t * p_physp)
+pkey_mgr_get_physp_max_pkeys(IN const osm_physp_t * p_physp)
 {
 	osm_node_t *p_node = osm_physp_get_node_ptr(p_physp);
 	uint16_t num_pkeys = 0;
@@ -68,7 +68,13 @@ pkey_mgr_get_physp_max_blocks(IN const osm_physp_t * p_physp)
 		num_pkeys = cl_ntoh16(p_node->node_info.partition_cap);
 	else
 		num_pkeys = cl_ntoh16(p_node->sw->switch_info.enforce_cap);
-	return ((num_pkeys + 31) / 32);
+	return num_pkeys;
+}
+
+static uint16_t
+pkey_mgr_get_physp_max_blocks(IN const osm_physp_t * p_physp)
+{
+	return ((pkey_mgr_get_physp_max_pkeys(p_physp) + 31) / 32);
 }
 
 /*
@@ -244,6 +250,14 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 	return status;
 }
 
+static void last_accum_pkey_index(osm_pkey_tbl_t * p_pkey_tbl,
+				  uint16_t * p_block_idx,
+				  uint8_t * p_pkey_idx)
+{
+	*p_block_idx = p_pkey_tbl->last_pkey_idx / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+	*p_pkey_idx = p_pkey_tbl->last_pkey_idx % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+}
+
 static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 				const osm_port_t * const p_port)
 {
@@ -262,6 +276,9 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	boolean_t found;
 	ib_pkey_table_t empty_block;
 	int ret = 0;
+	void *ptr;
+	uintptr_t pkey_idx_ptr;
+	uint16_t pkey_idx;
 
 	p_physp = p_port->p_physp;
 	if (!p_physp)
@@ -295,26 +312,50 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 	    (osm_pending_pkey_t *) cl_qlist_remove_head(&p_pkey_tbl->pending);
 	while (p_pending !=
 	       (osm_pending_pkey_t *) cl_qlist_end(&p_pkey_tbl->pending)) {
+
+		found = FALSE;
+		ptr = NULL;
+
 		if (p_pending->is_new == FALSE) {
 			block_index = p_pending->block;
 			pkey_index = p_pending->index;
 			found = TRUE;
 		} else {
-			found = osm_pkey_find_next_free_entry(p_pkey_tbl,
-							      &last_free_block_index,
-							      &last_free_pkey_index);
+			if (cl_ntoh16(p_pending->pkey) < cl_ptr_vector_get_size(&p_pkey_tbl->accum_pkeys)) {
+				ptr = cl_ptr_vector_get(&p_pkey_tbl->accum_pkeys,
+							p_pending->pkey);
+				if (ptr != NULL) {
+					pkey_idx_ptr = (uintptr_t) ptr;
+					pkey_idx = pkey_idx_ptr;
+					pkey_idx--; /* adjust pkey index for bias */
+					block_index = pkey_idx / IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+					pkey_index = pkey_idx % IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+					found = TRUE;
+				}
+			}
+
 			if (!found) {
-				OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0504: "
-					"Failed to find empty space for new pkey 0x%04x "
-					"for node 0x%016" PRIx64 " port %u (%s)\n",
-					cl_ntoh16(p_pending->pkey),
-					cl_ntoh64(osm_node_get_node_guid
-						  (p_node)),
-					osm_physp_get_port_num(p_physp),
-					p_physp->p_node->print_desc);
-			} else {
+				last_accum_pkey_index(p_pkey_tbl,
+						      &last_free_block_index,
+						      &last_free_pkey_index);
 				block_index = last_free_block_index;
-				pkey_index = last_free_pkey_index++;
+				pkey_index = last_free_pkey_index + 1;
+				if (pkey_index >= IB_NUM_PKEY_ELEMENTS_IN_BLOCK) {
+					block_index++;
+					pkey_index -= IB_NUM_PKEY_ELEMENTS_IN_BLOCK;
+					if (block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index >= pkey_mgr_get_physp_max_pkeys(p_physp)) {
+						OSM_LOG(p_log, OSM_LOG_ERROR,
+							"ERR 0512: "
+							"Failed to set PKey 0x%04x since Pkey table is full "
+							"for node 0x%016" PRIx64 " port %u (%s)\n",
+
+							cl_ntoh16(p_pending->pkey),
+							cl_ntoh64(osm_node_get_node_guid(p_node)),
+							osm_physp_get_port_num(p_physp),
+							p_physp->p_node->print_desc);
+					}
+				} else
+					found = TRUE;
 			}
 		}
 
@@ -333,6 +374,12 @@ static int pkey_mgr_update_port(osm_log_t * p_log, osm_sm_t * sm,
 					osm_physp_get_port_num(p_physp),
 					p_physp->p_node->print_desc);
 			}
+			if (ptr == NULL &&
+			    CL_SUCCESS !=
+			    osm_pkey_tbl_set_accum_pkeys(p_pkey_tbl,
+							 p_pending->pkey,
+							 block_index * IB_NUM_PKEY_ELEMENTS_IN_BLOCK + pkey_index)) {
+			}
 		}
 
 		free(p_pending);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
