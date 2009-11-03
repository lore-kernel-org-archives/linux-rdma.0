From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_tbl.c: In osm_mcast_tbl_clear_mlid, use
	memset to clear port mask entry
Date: Tue, 3 Nov 2009 07:00:58 -0500
Message-ID: <20091103120058.GA31605@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than less efficient for loop

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 462d528..4c58102 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -231,8 +231,9 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 	if (p_tbl->p_mask_tbl && mlid_offset < p_tbl->mft_depth)
-		for (i = 0; i <= p_tbl->max_position; i++)
-			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
+		memset((uint8_t *)p_tbl->p_mask_tbl + mlid_offset * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8,
+		       0,
+		       (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
 }
 
 boolean_t osm_mcast_tbl_get_block(IN osm_mcast_tbl_t * p_tbl,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
