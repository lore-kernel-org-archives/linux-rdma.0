From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 25/43] cxgb4: Allocate a private page list in ib_alloc_mr
Date: Wed, 22 Jul 2015 09:55:25 +0300
Message-ID: <1437548143-24893-26-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 ++++
 drivers/infiniband/hw/cxgb4/mem.c      | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 886be9c..e529ace 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -386,6 +386,10 @@ struct c4iw_mr {
 	struct c4iw_dev *rhp;
 	u64 kva;
 	struct tpt_attributes attr;
+	u64 *mpl;
+	dma_addr_t mpl_addr;
+	u32 max_mpl_len;
+	u32 mpl_len;
 };
 
 static inline struct c4iw_mr *to_c4iw_mr(struct ib_mr *ibmr)
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 5ecf4aa..91aedce 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -864,6 +864,7 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 	u32 mmid;
 	u32 stag = 0;
 	int ret = 0;
+	int length = roundup(max_entries * sizeof(u64), 32);
 
 	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
 		return ERR_PTR(-EINVAL);
@@ -876,6 +877,14 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 		goto err;
 	}
 
+	mhp->mpl = dma_alloc_coherent(&rhp->rdev.lldi.pdev->dev,
+				      length, &mhp->mpl_addr, GFP_KERNEL);
+	if (!mhp->mpl) {
+		ret = -ENOMEM;
+		goto err_mpl;
+	}
+	mhp->max_mpl_len = length;
+
 	mhp->rhp = rhp;
 	ret = alloc_pbl(mhp, max_entries);
 	if (ret)
@@ -905,6 +914,9 @@ err2:
 	c4iw_pblpool_free(&mhp->rhp->rdev, mhp->attr.pbl_addr,
 			      mhp->attr.pbl_size << 3);
 err1:
+	dma_free_coherent(&mhp->rhp->rdev.lldi.pdev->dev,
+			  mhp->max_mpl_len, mhp->mpl, mhp->mpl_addr);
+err_mpl:
 	kfree(mhp);
 err:
 	return ERR_PTR(ret);
@@ -970,6 +982,9 @@ int c4iw_dereg_mr(struct ib_mr *ib_mr)
 	rhp = mhp->rhp;
 	mmid = mhp->attr.stag >> 8;
 	remove_handle(rhp, &rhp->mmidr, mmid);
+	if (mhp->mpl)
+		dma_free_coherent(&mhp->rhp->rdev.lldi.pdev->dev,
+				  mhp->max_mpl_len, mhp->mpl, mhp->mpl_addr);
 	dereg_mem(&rhp->rdev, mhp->attr.stag, mhp->attr.pbl_size,
 		       mhp->attr.pbl_addr);
 	if (mhp->attr.pbl_size)
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
