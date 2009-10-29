From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/mcast_tbl: set max_mlid_ho as actually configured
 mlid
Date: Thu, 29 Oct 2009 21:19:45 +0200
Message-ID: <20091029191945.GE20136@me>
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


Set switch's mcast table max_mlid_ho as actually configured mlid for the
switch instead of a value extended to MFT block size aligned. This makes
mlid handling checks to be more reliable.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_tbl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index b5ae6f2..eee9290 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -122,7 +122,7 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 	uint16_t (*p_mask_tbl)[][IB_MCAST_POSITION_MAX];
 
 	if (mlid_offset < p_tbl->mft_depth)
-		return 0;
+		goto done;
 
 	/*
 	   The number of bytes needed in the mask table is:
@@ -144,7 +144,8 @@ int osm_mcast_tbl_realloc(IN osm_mcast_tbl_t * p_tbl, IN uintn_t mlid_offset)
 	       size - p_tbl->mft_depth * (IB_MCAST_POSITION_MAX + 1) * IB_MCAST_MASK_SIZE / 8);
 	p_tbl->p_mask_tbl = p_mask_tbl;
 	p_tbl->mft_depth = mft_depth;
-	p_tbl->max_mlid_ho = mft_depth + IB_LID_MCAST_START_HO - 1;
+done:
+	p_tbl->max_mlid_ho = mlid_offset + IB_LID_MCAST_START_HO - 1;
 	return 0;
 }
 
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
