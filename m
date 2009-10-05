From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_tbl.c: Cosmetic changes
Date: Mon, 5 Oct 2009 13:30:57 -0400
Message-ID: <20091005173057.GA25025@comcast.net>
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
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index dc5e5f3..d7c9529 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -37,7 +37,7 @@
 /*
  * Abstract:
  *    Implementation of osm_mcast_tbl_t.
- * This object represents an multicast forwarding table.
+ * This object represents a multicast forwarding table.
  * This object is part of the opensm family of objects.
  */
 
@@ -68,7 +68,7 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 		   This switch apparently doesn't support multicast.
 		   Everything is initialized to zero already, so return.
 		 */
-		return (IB_SUCCESS);
+		return IB_SUCCESS;
 	}
 
 	p_tbl->num_entries = capacity;
@@ -98,9 +98,9 @@ ib_api_status_t osm_mcast_tbl_init(IN osm_mcast_tbl_t * p_tbl,
 				    1) * IB_MCAST_MASK_SIZE / 8);
 
 	if (p_tbl->p_mask_tbl == NULL)
-		return (IB_INSUFFICIENT_MEMORY);
+		return IB_INSUFFICIENT_MEMORY;
 
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -162,7 +162,7 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 			bit_mask);
 	}
 
-	return (FALSE);
+	return FALSE;
 }
 
 /**********************************************************************
@@ -203,15 +203,15 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	CL_ASSERT(p_block);
 
 	if (block_num > p_tbl->max_block)
-		return (IB_INVALID_PARAMETER);
+		return IB_INVALID_PARAMETER;
 
 	if (position > p_tbl->max_position)
-		return (IB_INVALID_PARAMETER);
+		return IB_INVALID_PARAMETER;
 
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
 
 	if (mlid_start_ho + IB_MCAST_BLOCK_SIZE - 1 > p_tbl->max_mlid_ho)
-		return (IB_INVALID_PARAMETER);
+		return IB_INVALID_PARAMETER;
 
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
 		(*p_tbl->p_mask_tbl)[mlid_start_ho + i][position] = p_block[i];
@@ -219,7 +219,7 @@ ib_api_status_t osm_mcast_tbl_set_block(IN osm_mcast_tbl_t * p_tbl,
 	if (block_num > p_tbl->max_block_in_use)
 		p_tbl->max_block_in_use = (uint16_t) block_num;
 
-	return (IB_SUCCESS);
+	return IB_SUCCESS;
 }
 
 /**********************************************************************
@@ -252,14 +252,14 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 	CL_ASSERT(p_block);
 
 	if (block_num > p_tbl->max_block_in_use)
-		return (FALSE);
+		return FALSE;
 
 	if (position > p_tbl->max_position) {
 		/*
 		   Caller shouldn't do this for efficiency's sake...
 		 */
 		memset(p_block, 0, IB_SMP_DATA_SIZE);
-		return (TRUE);
+		return TRUE;
 	}
 
 	mlid_start_ho = (uint16_t) (block_num * IB_MCAST_BLOCK_SIZE);
@@ -267,5 +267,5 @@ boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
 	for (i = 0; i < IB_MCAST_BLOCK_SIZE; i++)
 		p_block[i] = (*p_tbl->p_mask_tbl)[mlid_start_ho + i][position];
 
-	return (TRUE);
+	return TRUE;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
