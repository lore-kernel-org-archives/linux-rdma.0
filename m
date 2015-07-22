From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 19/43] cxgb3: Drop iwch_alloc_fast_reg_mr
Date: Wed, 22 Jul 2015 09:55:19 +0300
Message-ID: <1437548143-24893-20-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 47 -----------------------------
 1 file changed, 47 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index d0e9e2d..af55b79 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -848,52 +848,6 @@ err:
 	return ERR_PTR(ret);
 }
 
-static struct ib_mr *iwch_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
-{
-	struct iwch_dev *rhp;
-	struct iwch_pd *php;
-	struct iwch_mr *mhp;
-	u32 mmid;
-	u32 stag = 0;
-	int ret = 0;
-
-	php = to_iwch_pd(pd);
-	rhp = php->rhp;
-	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
-	if (!mhp)
-		goto err;
-
-	mhp->rhp = rhp;
-	ret = iwch_alloc_pbl(mhp, pbl_depth);
-	if (ret)
-		goto err1;
-	mhp->attr.pbl_size = pbl_depth;
-	ret = cxio_allocate_stag(&rhp->rdev, &stag, php->pdid,
-				 mhp->attr.pbl_size, mhp->attr.pbl_addr);
-	if (ret)
-		goto err2;
-	mhp->attr.pdid = php->pdid;
-	mhp->attr.type = TPT_NON_SHARED_MR;
-	mhp->attr.stag = stag;
-	mhp->attr.state = 1;
-	mmid = (stag) >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
-	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid))
-		goto err3;
-
-	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
-	return &(mhp->ibmr);
-err3:
-	cxio_dereg_mem(&rhp->rdev, stag, mhp->attr.pbl_size,
-		       mhp->attr.pbl_addr);
-err2:
-	iwch_free_pbl(mhp);
-err1:
-	kfree(mhp);
-err:
-	return ERR_PTR(ret);
-}
-
 static struct ib_fast_reg_page_list *iwch_alloc_fastreg_pbl(
 					struct ib_device *device,
 					int page_list_len)
@@ -1492,7 +1446,6 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.bind_mw = iwch_bind_mw;
 	dev->ibdev.dealloc_mw = iwch_dealloc_mw;
 	dev->ibdev.alloc_mr = iwch_alloc_mr;
-	dev->ibdev.alloc_fast_reg_mr = iwch_alloc_fast_reg_mr;
 	dev->ibdev.alloc_fast_reg_page_list = iwch_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = iwch_free_fastreg_pbl;
 	dev->ibdev.attach_mcast = iwch_multicast_attach;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
