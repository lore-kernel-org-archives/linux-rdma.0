From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_tbl: remove redundant checks
Date: Thu, 29 Oct 2009 21:19:06 +0200
Message-ID: <20091029191906.GD20136@me>
References: <20091023234856.GA1482@comcast.net>
 <20091029191732.GB20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091029191732.GB20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Remove some redundant checks introduced by MFTs reallocation patch.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_tbl.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 6cc97b1..b5ae6f2 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -99,11 +99,9 @@ void osm_mcast_tbl_set(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho,
 	uintn_t bit_mask;
 	int16_t block_num;
 
-	CL_ASSERT(p_tbl);
+	CL_ASSERT(p_tbl && p_tbl->p_mask_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 	CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
-	CL_ASSERT(mlid_ho - IB_LID_MCAST_START_HO < p_tbl->mft_depth);
-	CL_ASSERT(p_tbl->p_mask_tbl);
 
 	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
 	mask_offset = port / IB_MCAST_MASK_SIZE;
@@ -168,8 +166,6 @@ boolean_t osm_mcast_tbl_is_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-		if (mlid_offset >= p_tbl->mft_depth)
-			return FALSE;
 		mask_offset = port_num / IB_MCAST_MASK_SIZE;
 		bit_mask = cl_ntoh16((uint16_t)
 				     (1 << (port_num % IB_MCAST_MASK_SIZE)));
@@ -197,8 +193,6 @@ boolean_t osm_mcast_tbl_is_any_port(IN const osm_mcast_tbl_t * p_tbl,
 		CL_ASSERT(mlid_ho <= p_tbl->max_mlid_ho);
 
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-		if (mlid_offset >= p_tbl->mft_depth)
-			return FALSE;
 
 		for (position = 0; position <= p_tbl->max_position; position++)
 			result |= (*p_tbl->p_mask_tbl)[mlid_offset][position];
@@ -250,10 +244,8 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 
-	if (p_tbl->p_mask_tbl && (mlid_ho <= p_tbl->max_mlid_ho)) {
+	if (p_tbl->p_mask_tbl && mlid_ho <= p_tbl->max_mlid_ho) {
 		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
-		if (mlid_offset >= p_tbl->mft_depth)
-			return;
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
 	}
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
