From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 06/11] RDMA/cxgb4: Return proper errors in fastreg mr/pbl
	allocation.
Date: Thu, 20 May 2010 16:57:54 -0500
Message-ID: <20100520215754.32394.22638.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/mem.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index e54ff6d..993ed1f 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -712,8 +712,10 @@ struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
 	php = to_c4iw_pd(pd);
 	rhp = php->rhp;
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
-	if (!mhp)
+	if (!mhp) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	mhp->rhp = rhp;
 	ret = alloc_pbl(mhp, pbl_depth);
@@ -730,8 +732,10 @@ struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
 	mhp->attr.state = 1;
 	mmid = (stag) >> 8;
 	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
-	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid))
+	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
+		ret = -ENOMEM;
 		goto err3;
+	}
 
 	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
 	return &(mhp->ibmr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
