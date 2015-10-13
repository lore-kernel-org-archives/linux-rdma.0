From: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
Subject: [PATCH] OpenSM: LFT update breaks if IB_SMP_DATA_SIZE changes
Date: Tue, 13 Oct 2015 15:25:50 +0200
Message-ID: <1444742750-23875-1-git-send-email-jens.domke@tu-dresden.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is only a precautionary patch for a theoretical
bug which would arise if someone redefines IB_SMP_DATA_SIZE
to a values !=64.

ucast_mgr_pipeline_fwd_tbl() calculates the max. number of
blocks to update using 64 explicitly, while set_lft_block()
uses IB_SMP_DATA_SIZE.
If IB_SMP_DATA_SIZE != 64 then switches would receive too few
or too many blocks.

Signed-off-by: Jens Domke <jens.domke-PZVgAJowwIsUtdQbppsyvg@public.gmane.org>
---
 opensm/osm_ucast_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 7ccaa77..893a70b 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -1036,7 +1036,7 @@ static void ucast_mgr_pipeline_fwd_tbl(osm_ucast_mgr_t * p_mgr)
 {
 	cl_qmap_t *tbl;
 	cl_map_item_t *item;
-	unsigned i, max_block = p_mgr->max_lid / 64 + 1;
+	unsigned i, max_block = p_mgr->max_lid / IB_SMP_DATA_SIZE + 1;
 
 	tbl = &p_mgr->p_subn->sw_guid_tbl;
 	for (i = 0; i < max_block; i++)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
