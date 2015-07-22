From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 04/43] iw_cxgb4: Support ib_alloc_mr verb
Date: Wed, 22 Jul 2015 09:55:04 +0300
Message-ID: <1437548143-24893-5-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 +++
 drivers/infiniband/hw/cxgb4/mem.c      | 57 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/provider.c |  1 +
 3 files changed, 62 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index cc77844..97b2568 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -970,6 +970,10 @@ void c4iw_free_fastreg_pbl(struct ib_fast_reg_page_list *page_list);
 struct ib_fast_reg_page_list *c4iw_alloc_fastreg_pbl(
 					struct ib_device *device,
 					int page_list_len);
+struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
+			    enum ib_mr_type mr_type,
+			    u32 max_entries,
+			    u32 flags);
 struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth);
 int c4iw_dealloc_mw(struct ib_mw *mw);
 struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cff815b..7ee01ce 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -853,6 +853,63 @@ int c4iw_dealloc_mw(struct ib_mw *mw)
 	return 0;
 }
 
+struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
+			    enum ib_mr_type mr_type,
+			    u32 max_entries,
+			    u32 flags)
+{
+	struct c4iw_dev *rhp;
+	struct c4iw_pd *php;
+	struct c4iw_mr *mhp;
+	u32 mmid;
+	u32 stag = 0;
+	int ret = 0;
+
+	if (mr_type != IB_MR_TYPE_FAST_REG || flags)
+		return ERR_PTR(-EINVAL);
+
+	php = to_c4iw_pd(pd);
+	rhp = php->rhp;
+	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
+	if (!mhp) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mhp->rhp = rhp;
+	ret = alloc_pbl(mhp, max_entries);
+	if (ret)
+		goto err1;
+	mhp->attr.pbl_size = max_entries;
+	ret = allocate_stag(&rhp->rdev, &stag, php->pdid,
+				 mhp->attr.pbl_size, mhp->attr.pbl_addr);
+	if (ret)
+		goto err2;
+	mhp->attr.pdid = php->pdid;
+	mhp->attr.type = FW_RI_STAG_NSMR;
+	mhp->attr.stag = stag;
+	mhp->attr.state = 1;
+	mmid = (stag) >> 8;
+	mhp->ibmr.rkey = mhp->ibmr.lkey = stag;
+	if (insert_handle(rhp, &rhp->mmidr, mhp, mmid)) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	PDBG("%s mmid 0x%x mhp %p stag 0x%x\n", __func__, mmid, mhp, stag);
+	return &(mhp->ibmr);
+err3:
+	dereg_mem(&rhp->rdev, stag, mhp->attr.pbl_size,
+		       mhp->attr.pbl_addr);
+err2:
+	c4iw_pblpool_free(&mhp->rhp->rdev, mhp->attr.pbl_addr,
+			      mhp->attr.pbl_size << 3);
+err1:
+	kfree(mhp);
+err:
+	return ERR_PTR(ret);
+}
+
 struct ib_mr *c4iw_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
 {
 	struct c4iw_dev *rhp;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 6eee3d3..2885aba 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -556,6 +556,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.alloc_mw = c4iw_alloc_mw;
 	dev->ibdev.bind_mw = c4iw_bind_mw;
 	dev->ibdev.dealloc_mw = c4iw_dealloc_mw;
+	dev->ibdev.alloc_mr = c4iw_alloc_mr;
 	dev->ibdev.alloc_fast_reg_mr = c4iw_alloc_fast_reg_mr;
 	dev->ibdev.alloc_fast_reg_page_list = c4iw_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = c4iw_free_fastreg_pbl;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
