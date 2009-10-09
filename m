From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_pkey.c: Cosmetic changes
Date: Fri, 9 Oct 2009 10:48:37 -0400
Message-ID: <20091009144837.GC17861@comcast.net>
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
diff --git a/opensm/opensm/osm_pkey.c b/opensm/opensm/osm_pkey.c
index 6075b6a..6355718 100644
--- a/opensm/opensm/osm_pkey.c
+++ b/opensm/opensm/osm_pkey.c
@@ -97,7 +97,7 @@ ib_api_status_t osm_pkey_tbl_init(IN osm_pkey_tbl_t * p_pkey_tbl)
 	cl_qlist_init(&p_pkey_tbl->pending);
 	p_pkey_tbl->used_blocks = 0;
 	p_pkey_tbl->max_blocks = 0;
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -146,7 +146,7 @@ ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 		p_pkey_block =
 		    (ib_pkey_table_t *) malloc(sizeof(ib_pkey_table_t));
 		if (!p_pkey_block)
-			return (IB_ERROR);
+			return IB_ERROR;
 		memset(p_pkey_block, 0, sizeof(ib_pkey_table_t));
 		cl_ptr_vector_set(&p_pkey_tbl->blocks, block, p_pkey_block);
 	}
@@ -191,7 +191,7 @@ ib_api_status_t osm_pkey_tbl_set(IN osm_pkey_tbl_t * p_pkey_tbl,
 				    );
 		}
 	}
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -210,7 +210,7 @@ ib_api_status_t osm_pkey_tbl_set_new_entry(IN osm_pkey_tbl_t * p_pkey_tbl,
 	if (!(p_block = osm_pkey_tbl_new_block_get(p_pkey_tbl, block_idx))) {
 		p_block = (ib_pkey_table_t *) malloc(sizeof(ib_pkey_table_t));
 		if (!p_block)
-			return (IB_ERROR);
+			return IB_ERROR;
 		memset(p_block, 0, sizeof(ib_pkey_table_t));
 		cl_ptr_vector_set(&p_pkey_tbl->new_blocks, block_idx, p_block);
 	}
@@ -219,7 +219,7 @@ ib_api_status_t osm_pkey_tbl_set_new_entry(IN osm_pkey_tbl_t * p_pkey_tbl,
 	if (p_pkey_tbl->used_blocks <= block_idx)
 		p_pkey_tbl->used_blocks = block_idx + 1;
 
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -275,10 +275,10 @@ ib_api_status_t osm_pkey_tbl_get_block_and_idx(IN osm_pkey_tbl_t * p_pkey_tbl,
 		     block->pkey_entry + IB_NUM_PKEY_ELEMENTS_IN_BLOCK)) {
 			*p_block_idx = block_index;
 			*p_pkey_idx = (uint8_t) (p_pkey - block->pkey_entry);
-			return (IB_SUCCESS);
+			return IB_SUCCESS;
 		}
 	}
-	return (IB_NOT_FOUND);
+	return IB_NOT_FOUND;
 }
 
 /**********************************************************************
@@ -294,9 +294,9 @@ static boolean_t match_pkey(IN const ib_net16_t * pkey1,
 	/* compare if the bases are the same. if they are - then
 	   this is a match */
 	if (ib_pkey_get_base(*pkey1) != ib_pkey_get_base(*pkey2))
-		return (FALSE);
+		return FALSE;
 
-	return (TRUE);
+	return TRUE;
 }
 
 /**********************************************************************
@@ -447,10 +447,9 @@ boolean_t osm_physp_has_pkey(IN osm_log_t * p_log, IN ib_net16_t pkey,
 		res = TRUE;
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"PKey 0x%04x was found\n", cl_ntoh16(pkey));
-	} else {
+	} else
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"PKey 0x%04x was not found\n", cl_ntoh16(pkey));
-	}
 
 Exit:
 	OSM_LOG_EXIT(p_log);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
