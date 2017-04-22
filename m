From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 07/12] IB/ocrdma: Adjust 21 checks for null pointers
Date: Sat, 22 Apr 2017 16:47:19 +0200
Message-ID: <3ec5ffa4-8976-e793-f22c-5f01c9d6bb9d@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Apr 2017 14:20:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 20 ++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 20 ++++++++++----------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index d5b988b011d1..8c7f0b108a7f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -665,7 +665,7 @@ static void ocrdma_process_qpcat_error(struct ocrdma_dev *dev,
 	enum ib_qp_state new_ib_qps = IB_QPS_ERR;
 	enum ib_qp_state old_ib_qps;
 
-	if (qp == NULL)
+	if (!qp)
 		BUG();
 	ocrdma_qp_state_change(qp, new_ib_qps, &old_ib_qps);
 }
@@ -693,7 +693,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	if (cqe->qpvalid_qpid & OCRDMA_AE_MCQE_QPVALID) {
 		if (qpid < dev->attr.max_qp)
 			qp = dev->qp_tbl[qpid];
-		if (qp == NULL) {
+		if (!qp) {
 			pr_err("ocrdma%d:Async event - qpid %u is not valid\n",
 			       dev->id, qpid);
 			return;
@@ -703,7 +703,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID) {
 		if (cqid < dev->attr.max_cq)
 			cq = dev->cq_tbl[cqid];
-		if (cq == NULL) {
+		if (!cq) {
 			pr_err("ocrdma%d:Async event - cqid %u is not valid\n",
 			       dev->id, cqid);
 			return;
@@ -882,7 +882,7 @@ static int ocrdma_mq_cq_handler(struct ocrdma_dev *dev, u16 cq_id)
 
 	while (1) {
 		cqe = ocrdma_get_mcqe(dev);
-		if (cqe == NULL)
+		if (!cqe)
 			break;
 		ocrdma_le32_to_cpu(cqe, sizeof(*cqe));
 		cqe_popped += 1;
@@ -948,7 +948,7 @@ static void ocrdma_qp_buddy_cq_handler(struct ocrdma_dev *dev,
 	 * false - Check for RQ CQ
 	 */
 	bcq = _ocrdma_qp_buddy_cq_handler(dev, cq, true);
-	if (bcq == NULL)
+	if (!bcq)
 		bcq = _ocrdma_qp_buddy_cq_handler(dev, cq, false);
 	spin_unlock_irqrestore(&dev->flush_q_lock, flags);
 
@@ -969,7 +969,7 @@ static void ocrdma_qp_cq_handler(struct ocrdma_dev *dev, u16 cq_idx)
 		BUG();
 
 	cq = dev->cq_tbl[cq_idx];
-	if (cq == NULL)
+	if (!cq)
 		return;
 
 	if (cq->ibcq.comp_handler) {
@@ -1289,7 +1289,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
 	int status;
 
 	old_stats = kmalloc(sizeof(*old_stats), GFP_KERNEL);
-	if (old_stats == NULL)
+	if (!old_stats)
 		return -ENOMEM;
 
 	memset(mqe, 0, sizeof(*mqe));
@@ -1676,12 +1676,12 @@ static int ocrdma_mbx_create_ah_tbl(struct ocrdma_dev *dev)
 	dev->av_tbl.pbl.va = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
 						&dev->av_tbl.pbl.pa,
 						GFP_KERNEL);
-	if (dev->av_tbl.pbl.va == NULL)
+	if (!dev->av_tbl.pbl.va)
 		goto mem_err;
 
 	dev->av_tbl.va = dma_alloc_coherent(&pdev->dev, dev->av_tbl.size,
 					    &pa, GFP_KERNEL);
-	if (dev->av_tbl.va == NULL)
+	if (!dev->av_tbl.va)
 		goto mem_err_ah;
 	dev->av_tbl.pa = pa;
 	dev->av_tbl.num_ah = max_ah;
@@ -1722,7 +1722,7 @@ static void ocrdma_mbx_delete_ah_tbl(struct ocrdma_dev *dev)
 	struct ocrdma_delete_ah_tbl *cmd;
 	struct pci_dev *pdev = dev->nic_info.pdev;
 
-	if (dev->av_tbl.va == NULL)
+	if (!dev->av_tbl.va)
 		return;
 
 	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_DELETE_AH_TBL, sizeof(*cmd));
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index e2aa67d6cbb8..b82f6c6942e0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -238,7 +238,7 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 
 	dev->stag_arr = kcalloc(OCRDMA_MAX_STAG, sizeof(*dev->stag_arr),
 				GFP_KERNEL);
-	if (dev->stag_arr == NULL)
+	if (!dev->stag_arr)
 		goto alloc_err;
 
 	ocrdma_alloc_pd_pool(dev);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 5eaf946aeac6..c804889db7e1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -267,7 +267,7 @@ static int ocrdma_add_mmap(struct ocrdma_ucontext *uctx, u64 phy_addr,
 	struct ocrdma_mm *mm;
 
 	mm = kzalloc(sizeof(*mm), GFP_KERNEL);
-	if (mm == NULL)
+	if (!mm)
 		return -ENOMEM;
 	mm->key.phy_addr = phy_addr;
 	mm->key.len = len;
@@ -1194,7 +1194,7 @@ static int ocrdma_add_qpn_map(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
 {
 	int status = -EINVAL;
 
-	if (qp->id < OCRDMA_MAX_QP && dev->qp_tbl[qp->id] == NULL) {
+	if (qp->id < OCRDMA_MAX_QP && !dev->qp_tbl[qp->id]) {
 		dev->qp_tbl[qp->id] = qp;
 		status = 0;
 	}
@@ -1362,11 +1362,11 @@ static int ocrdma_alloc_wr_id_tbl(struct ocrdma_qp *qp)
 {
 	qp->wqe_wr_id_tbl = kcalloc(qp->sq.max_cnt, sizeof(*qp->wqe_wr_id_tbl),
 				    GFP_KERNEL);
-	if (qp->wqe_wr_id_tbl == NULL)
+	if (!qp->wqe_wr_id_tbl)
 		return -ENOMEM;
 	qp->rqe_wr_id_tbl = kcalloc(qp->rq.max_cnt, sizeof(*qp->rqe_wr_id_tbl),
 				    GFP_KERNEL);
-	if (qp->rqe_wr_id_tbl == NULL)
+	if (!qp->rqe_wr_id_tbl)
 		return -ENOMEM;
 
 	return 0;
@@ -1426,7 +1426,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		goto gen_err;
 	}
 	ocrdma_set_qp_init_params(qp, pd, attrs);
-	if (udata == NULL)
+	if (!udata)
 		qp->cap_flags |= (OCRDMA_QP_MW_BIND | OCRDMA_QP_LKEY0 |
 					OCRDMA_QP_FAST_REG);
 
@@ -1438,7 +1438,7 @@ struct ib_qp *ocrdma_create_qp(struct ib_pd *ibpd,
 		goto mbx_err;
 
 	/* user space QP's wr_id table are managed in library */
-	if (udata == NULL) {
+	if (!udata) {
 		status = ocrdma_alloc_wr_id_tbl(qp);
 		if (status)
 			goto map_err;
@@ -1899,11 +1899,11 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 	if (status)
 		goto err;
 
-	if (udata == NULL) {
+	if (!udata) {
 		srq->rqe_wr_id_tbl = kcalloc(srq->rq.max_cnt,
 					     sizeof(*srq->rqe_wr_id_tbl),
 					     GFP_KERNEL);
-		if (srq->rqe_wr_id_tbl == NULL)
+		if (!srq->rqe_wr_id_tbl)
 			goto arm_err;
 
 		srq->bit_fields_len = (srq->rq.max_cnt / 32) +
@@ -1911,7 +1911,7 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 		srq->idx_bit_fields = kmalloc_array(srq->bit_fields_len,
 						    sizeof(*srq->idx_bit_fields),
 						    GFP_KERNEL);
-		if (srq->idx_bit_fields == NULL)
+		if (!srq->idx_bit_fields)
 			goto arm_err;
 		memset(srq->idx_bit_fields, 0xff,
 		       srq->bit_fields_len * sizeof(*srq->idx_bit_fields));
@@ -2885,7 +2885,7 @@ static int ocrdma_poll_hwcq(struct ocrdma_cq *cq, int num_entries,
 		if (qpn == 0)
 			goto skip_cqe;
 		qp = dev->qp_tbl[qpn];
-		BUG_ON(qp == NULL);
+		BUG_ON(!qp);
 
 		expand = is_cqe_for_sq(cqe)
 			 ? ocrdma_poll_scqe(qp, cqe, ibwc, &polled, &stop)
-- 
2.12.2
