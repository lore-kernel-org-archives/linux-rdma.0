From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] opensm/osm_mcast_tbl.c: Fix multicast group removal
Date: Fri, 30 Oct 2009 14:30:21 -0500
Message-ID: <20091030193021.GA5497@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Revert de3171043b3cbe078e410351a00e5756509bd514 and
some of 537d67b19a4b72d72341e529f611e4e30754f8fc

In osm_mcast_tbl_realloc, don't change max_mlid_ho when mlid_offset < p_tbl->mft_depth
Also, restore some checks when mlid_offset >= p_tbl->mft_depth
These changes are needed for proper group removal 

Also, in osm_mcast_tbl_realloc, set max_mlid_ho based on allocated mft_depth
rather than mlid_offset

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Changed osm_mcast_tbl_realloc determination of max_mlid_ho

diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 0a45904..9d647dd 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
 
 	if (mlid_offset < p_tbl->mft_depth)
-		goto done;
+		return 0;
 
 	/*
 	   The number of bytes needed in the mask table is:
@@ -144,8 +144,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 	       size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
 	p_tbl->p_mask_tbl = p_mask_tbl;
 	p_tbl->mft_depth = mft_depth;
-done:
-	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO;
+	p_tbl->max_mlid_ho = mft_depth + IB_LID_MCAST_START_HO;
 	return 0;
 }
 
@@ -167,6 +166,9 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return FALSE;
+
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
@@ -194,6 +196,8 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return FALSE;
 
 		for (position = 0; position <= p_tbl->max_position; position++)
 			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
@@ -247,6 +251,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 
 	if (p_tbl->p_mask_tbl && mlid_ho <= p_tbl->max_mlid_ho) {
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+		if (mlid_offset >= p_tbl->mft_depth)
+			return;
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
 	}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
