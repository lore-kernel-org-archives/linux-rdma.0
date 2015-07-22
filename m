From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 18/43] cxgb4: Drop c4iw_alloc_fast_reg_mr
Date: Wed, 22 Jul 2015 09:55:18 +0300
Message-ID: <1437548143-24893-19-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  1 -
 drivers/infiniband/hw/cxgb4/mem.c      | 51 ----------------------------------
 drivers/infiniband/hw/cxgb4/provider.c |  1 -
 3 files changed, 53 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 97b2568..886be9c 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -974,7 +974,6 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
 			    u32 max_entries,
 			    u32 flags);
-struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth);
 int c4iw_dealloc_mw(struct ib_mw *mw);
 struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
 struct ib_mr *c4iw_reg_user_mr(struct ib_pd *pd, u64 start,
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 7ee01ce..5ecf4aa 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -910,57 +910,6 @@ err:
 	return ERR_PTR(ret);
 }
 
-struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
-{
-	struct c4iw_dev *rhp;
-	struct c4iw_pd *php;
-	struct c4iw_mr *mhp;
-	u32 mmid;
-	u32 stag = 0;
-	int ret = 0;
-
-	php = to_c4iw_pd(pd);
-	rhp = php->rhp;
-	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
-	if (!mhp) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	mhp->rhp = rhp;
-	ret = alloc_pbl(mhp, pbl_depth);
-	if (ret)
-		goto err1;
-	mhp->attr.pbl_size = pbl_depth;
-	ret = allocate_stag(&rhp->rdev, &stag, php->pdid,
-				 mhp->attr.pbl_size, mhp->attr.pbl_addr);
-	if (ret)
-		goto err2;
-	mhp->attr.pdid = php->pdid;
-	mhp->attr.type = FW_RI_STAG_NSMR;
-	mhp->attr.stag = stag;
-	mhp->attr.state = 1;
-	mmid = (stag) >> 8;
-	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
-	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
-		ret = -ENOMEM;
-		goto err3;
-	}
-
-	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
-	return &(mhp->ibmr);
-err3:
-	dereg_mem(&rhp->rdev, stag, mhp->attr.pbl_size,
-		       mhp->attr.pbl_addr);
-err2:
-	c4iw_pblpool_free(&mhp->rhp->rdev, mhp->attr.pbl_addr,
-			      mhp->attr.pbl_size << 3);
-err1:
-	kfree(mhp);
-err:
-	return ERR_PTR(ret);
-}
-
 struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(struct ib_device *device,
 						     int page_list_len)
 {
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 2885aba..7746113 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -557,7 +557,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.bind_mw = c4iw_bind_mw;
 	dev->ibdev.dealloc_mw = c4iw_dealloc_mw;
 	dev->ibdev.alloc_mr = c4iw_alloc_mr;
-	dev->ibdev.alloc_fast_reg_mr = c4iw_alloc_fast_reg_mr;
 	dev->ibdev.alloc_fast_reg_page_list = c4iw_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = c4iw_free_fastreg_pbl;
 	dev->ibdev.attach_mcast = c4iw_multicast_attach;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
