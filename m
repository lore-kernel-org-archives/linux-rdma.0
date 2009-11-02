From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_tbl: Fix size of port mask table array
Date: Mon, 2 Nov 2009 14:06:54 -0500
Message-ID: <20091102190654.GA18937@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Should be IB_MCAST_POSITION_MAX + 1 rather than just IB_MCAST_POSITION_MAX

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/include/opensm/osm_mcast_tbl.h b/opensm/include/opensm/osm_mcast_tbl.h
index 6d3f083..0745b5b 100644
--- a/opensm/include/opensm/osm_mcast_tbl.h
+++ b/opensm/include/opensm/osm_mcast_tbl.h
@@ -76,7 +76,7 @@ typedef struct osm_mcast_fwdbl {
 	uint16_t num_entries;
 	uint16_t max_mlid_ho;
 	uint16_t mft_depth;
-	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
+	uint16_t(*p_mask_tbl)[][IB_MCAST_POSITION_MAX + 1];
 } osm_mcast_tbl_t;
 /*
 * FIELDS
@@ -106,7 +106,7 @@ typedef struct osm_mcast_fwdbl {
 *
 *	p_mask_tbl
 *		Pointer to a two dimensional array of port_masks for this switch.
-*		The first dimension is MLID, the second dimension is mask position.
+*		The first dimension is MLID offset, second dimension is mask position.
 *		This pointer is null for switches that do not support multicast.
 *
 * SEE ALSO
diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 818f2e0..c2c5395 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -119,7 +119,7 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 {
 	size_t mft_depth, size;
-	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
+	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX + 1];
 
 	if (mlid_offset < p_tbl->mft_depth)
 		goto done;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
