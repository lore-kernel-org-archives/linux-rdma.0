From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_mcast_tbl: fix mlid removal
Date: Fri, 30 Oct 2009 23:32:01 +0200
Message-ID: <20091030213201.GF5829@me>
References: <4AEAEA86.8080309@systemfabricworks.com>
 <f0e08f230910300648m4d802f57w2910cea678a3cd1f@mail.gmail.com>
 <20091030200620.GB5829@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091030200620.GB5829@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Removed mlid can exceed a current max_mlid_ho value, so to prevent MFT
garbage above this the requested mlid should be checked against actual
MFT size.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_mcast_tbl.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_mcast_tbl.c b/opensm/opensm/osm_mcast_tbl.c
index 0a45904..8136c37 100644
--- a/opensm/opensm/osm_mcast_tbl.c
+++ b/opensm/opensm/osm_mcast_tbl.c
@@ -245,11 +245,10 @@ void osm_mcast_tbl_clear_mlid(IN osm_mcast_tbl_t * p_tbl, IN uint16_t mlid_ho)
 	CL_ASSERT(p_tbl);
 	CL_ASSERT(mlid_ho >= IB_LID_MCAST_START_HO);
 
-	if (p_tbl->p_mask_tbl && mlid_ho <= p_tbl->max_mlid_ho) {
-		mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+	mlid_offset = mlid_ho - IB_LID_MCAST_START_HO;
+	if (p_tbl->p_mask_tbl && mlid_offset < p_tbl->mft_depth)
 		for (i = 0; i <= p_tbl->max_position; i++)
 			(*p_tbl->p_mask_tbl)[mlid_offset][i] = 0;
-	}
 }
 
 /**********************************************************************
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
