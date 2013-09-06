From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix the kernel crash in rmmod ocrdma.
Date: Fri, 6 Sep 2013 15:02:47 +0530
Message-ID: <af65b90e-da30-48e5-ba59-0d9d9bb4aa28@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

1) ocrdma_remove_free funtion is called from a call_rcu callback funtion
context, which can be a bottom-half context. So the code in
ocrdma_remove_free should not call sleep.

But the ocrdma_cleanup_hw can sleep, So moved it to ocrdma_remove
instead of ocrdma_remove_free.

2) Fixed couple of kbuild test robot warnings.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 53 +++++++++++++++--------------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  7 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index adc11d1..294dd27 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -122,6 +122,32 @@ struct mqe_ctx {
 	bool cmd_done;
 };
 
+struct ocrdma_hw_mr {
+	u32 lkey;
+	u8 fr_mr;
+	u8 remote_atomic;
+	u8 remote_rd;
+	u8 remote_wr;
+	u8 local_rd;
+	u8 local_wr;
+	u8 mw_bind;
+	u8 rsvd;
+	u64 len;
+	struct ocrdma_pbl *pbl_table;
+	u32 num_pbls;
+	u32 num_pbes;
+	u32 pbl_size;
+	u32 pbe_size;
+	u64 fbo;
+	u64 va;
+};
+
+struct ocrdma_mr {
+	struct ib_mr ibmr;
+	struct ib_umem *umem;
+	struct ocrdma_hw_mr hwmr;
+};
+
 struct ocrdma_dev {
 	struct ib_device ibdev;
 	struct ocrdma_dev_attr attr;
@@ -169,7 +195,7 @@ struct ocrdma_dev {
 	struct list_head entry;
 	struct rcu_head rcu;
 	int id;
-	u64 stag_arr[OCRDMA_MAX_STAG];
+	struct ocrdma_mr *stag_arr[OCRDMA_MAX_STAG];
 	u16 pvid;
 };
 
@@ -294,31 +320,6 @@ struct ocrdma_qp {
 	u16 db_cache;
 };
 
-struct ocrdma_hw_mr {
-	u32 lkey;
-	u8 fr_mr;
-	u8 remote_atomic;
-	u8 remote_rd;
-	u8 remote_wr;
-	u8 local_rd;
-	u8 local_wr;
-	u8 mw_bind;
-	u8 rsvd;
-	u64 len;
-	struct ocrdma_pbl *pbl_table;
-	u32 num_pbls;
-	u32 num_pbes;
-	u32 pbl_size;
-	u32 pbe_size;
-	u64 fbo;
-	u64 va;
-};
-
-struct ocrdma_mr {
-	struct ib_mr ibmr;
-	struct ib_umem *umem;
-	struct ocrdma_hw_mr hwmr;
-};
 
 struct ocrdma_ucontext {
 	struct ib_ucontext ibucontext;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 56e0049..b047127 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -452,9 +452,6 @@ static void ocrdma_remove_free(struct rcu_head *rcu)
 {
 	struct ocrdma_dev *dev = container_of(rcu, struct ocrdma_dev, rcu);
 
-	ocrdma_free_resources(dev);
-	ocrdma_cleanup_hw(dev);
-
 	idr_remove(&ocrdma_dev_id, dev->id);
 	kfree(dev->mbx_cmd);
 	ib_dealloc_device(&dev->ibdev);
@@ -470,6 +467,10 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	spin_lock(&ocrdma_devlist_lock);
 	list_del_rcu(&dev->entry);
 	spin_unlock(&ocrdma_devlist_lock);
+
+	ocrdma_free_resources(dev);
+	ocrdma_cleanup_hw(dev);
+
 	call_rcu(&dev->rcu, ocrdma_remove_free);
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 0504e73..6dafc92 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2839,7 +2839,7 @@ struct ib_mr *ocrdma_alloc_frmr(struct ib_pd *ibpd, int max_page_list_len)
 		goto mbx_err;
 	mr->ibmr.rkey = mr->hwmr.lkey;
 	mr->ibmr.lkey = mr->hwmr.lkey;
-	dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] = (u64) mr;
+	dev->stag_arr[(mr->hwmr.lkey >> 8) & (OCRDMA_MAX_STAG - 1)] = mr;
 	return &mr->ibmr;
 mbx_err:
 	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
