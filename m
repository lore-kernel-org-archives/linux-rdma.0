From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-4.3 12/15] cxgb3: Support ib_alloc_mr verb
Date: Thu, 30 Jul 2015 10:32:45 +0300
Message-ID: <1438241568-3685-13-git-send-email-sagig@mellanox.com>
References: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1438241568-3685-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, linux-nfs@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index b1b7323..7e004c7 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -796,7 +796,9 @@ static int iwch_dealloc_mw(struct ib_mw *mw)
 	return 0;
 }
 
-static struct ib_mr *iwch_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
+static struct ib_mr *iwch_alloc_mr(struct ib_pd *pd,
+				   enum ib_mr_type mr_type,
+				   u32 max_num_sg)
 {
 	struct iwch_dev *rhp;
 	struct iwch_pd *php;
@@ -805,6 +807,10 @@ static struct ib_mr *iwch_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
 	u32 stag = 0;
 	int ret = 0;
 
+	if (mr_type != IB_MR_TYPE_MEM_REG ||
+	    max_num_sg > T3_MAX_FASTREG_DEPTH)
+		return ERR_PTR(-EINVAL);
+
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
 	mhp = kzalloc(sizeof(*mhp), GFP_KERNEL);
@@ -812,10 +818,10 @@ static struct ib_mr *iwch_alloc_fast_reg_mr(struct ib_pd *pd, int pbl_depth)
 		goto err;
 
 	mhp->rhp = rhp;
-	ret = iwch_alloc_pbl(mhp, pbl_depth);
+	ret = iwch_alloc_pbl(mhp, max_num_sg);
 	if (ret)
 		goto err1;
-	mhp->attr.pbl_size = pbl_depth;
+	mhp->attr.pbl_size = max_num_sg;
 	ret = cxio_allocate_stag(&rhp->rdev, &stag, php->pdid,
 				 mhp->attr.pbl_size, mhp->attr.pbl_addr);
 	if (ret)
@@ -1439,7 +1445,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.alloc_mw = iwch_alloc_mw;
 	dev->ibdev.bind_mw = iwch_bind_mw;
 	dev->ibdev.dealloc_mw = iwch_dealloc_mw;
-	dev->ibdev.alloc_fast_reg_mr = iwch_alloc_fast_reg_mr;
+	dev->ibdev.alloc_mr = iwch_alloc_mr;
 	dev->ibdev.alloc_fast_reg_page_list = iwch_alloc_fastreg_pbl;
 	dev->ibdev.free_fast_reg_page_list = iwch_free_fastreg_pbl;
 	dev->ibdev.attach_mcast = iwch_multicast_attach;
-- 
1.8.4.3
