From: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband: hw: ocrdma: Replace BUG() with BUG_ON()
Date: Sat, 24 Dec 2016 20:55:49 +0530
Message-ID: <1482593149-6243-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org
Cc: devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 9a30520..ac11c56 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -664,8 +664,7 @@ static void ocrdma_process_qpcat_error(struct ocrdma_dev *dev,
 	enum ib_qp_state new_ib_qps = IB_QPS_ERR;
 	enum ib_qp_state old_ib_qps;
 
-	if (qp == NULL)
-		BUG();
+	BUG_ON(qp == NULL);
 	ocrdma_qp_state_change(qp, new_ib_qps, &old_ib_qps);
 }
 
@@ -964,8 +963,7 @@ static void ocrdma_qp_cq_handler(struct ocrdma_dev *dev, u16 cq_idx)
 	unsigned long flags;
 	struct ocrdma_cq *cq;
 
-	if (cq_idx >= OCRDMA_MAX_CQ)
-		BUG();
+	BUG_ON(cq_idx >= OCRDMA_MAX_CQ);
 
 	cq = dev->cq_tbl[cq_idx];
 	if (cq == NULL)
@@ -1116,9 +1114,7 @@ static int ocrdma_nonemb_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe,
 	int status;
 	struct ocrdma_mbx_rsp *rsp = payload_va;
 
-	if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK) >>
-				OCRDMA_MQE_HDR_EMB_SHIFT)
-		BUG();
+	BUG_ON((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK) >> OCRDMA_MQE_HDR_EMB_SHIFT);
 
 	status = ocrdma_mbx_cmd(dev, mqe);
 	if (!status)
@@ -1773,8 +1769,7 @@ static void ocrdma_unbind_eq(struct ocrdma_dev *dev, u16 eq_id)
 
 	mutex_lock(&dev->dev_lock);
 	i = ocrdma_get_eq_table_index(dev, eq_id);
-	if (i == -EINVAL)
-		BUG();
+	BUG_ON(i == -EINVAL);
 	dev->eq_tbl[i].cq_cnt -= 1;
 	mutex_unlock(&dev->dev_lock);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
