From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/26] IB/ocrdma: Adjust ten checks for null pointers
Date: Wed, 8 Mar 2017 14:07:01 +0100
Message-ID: <8795100d-0577-bdcf-f4f2-04d04154bf71@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 21:32:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl“ pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

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
-- 
2.12.0

