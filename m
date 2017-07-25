From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: fix misuse of integer variable
Date: Tue, 25 Jul 2017 06:51:15 -0700
Message-ID: <20170725140248.D4532E0C82@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: ee30f7d507c0 ("iw_cxgb4: Max fastreg depth depends on DSGL support")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 5332f06..c2fba76 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -661,7 +661,7 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 	rhp = php->rhp;
 
 	if (mr_type != IB_MR_TYPE_MEM_REG ||
-	    max_num_sg > t4_max_fr_depth(&rhp->rdev.lldi.ulptx_memwrite_dsgl &&
+	    max_num_sg > t4_max_fr_depth(rhp->rdev.lldi.ulptx_memwrite_dsgl &&
 					 use_dsgl))
 		return ERR_PTR(-EINVAL);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
