From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] RDMA/vmw_pvrdma: Cleanup unused variables
Date: Wed, 22 Feb 2017 17:22:56 -0800
Message-ID: <83baafed74beeee75a6a1342d4b37fac50b85b31.1487812849.git.aditr@vmware.com>
References: <cover.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Removed the unused nreq and redundant index variables.
Moved hardcoded async and cq ring pages number to macro.

Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  2 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |  4 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 33 ++++++++++----------------
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 3cd96c1..dbf61c3 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -69,6 +69,8 @@
  */
 #define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
 
+#define PVRDMA_NUM_RING_PAGES		4
+
 struct pvrdma_dev;
 
 struct pvrdma_page_dir {
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 60cdb77..4380d3d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -857,7 +857,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	dev->dsr->resp_slot_dma = (u64)slot_dma;
 
 	/* Async event ring */
-	dev->dsr->async_ring_pages.num_pages = 4;
+	dev->dsr->async_ring_pages.num_pages = PVRDMA_NUM_RING_PAGES;
 	ret = pvrdma_page_dir_init(dev, &dev->async_pdir,
 				   dev->dsr->async_ring_pages.num_pages, true);
 	if (ret)
@@ -866,7 +866,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	dev->dsr->async_ring_pages.pdir_dma = dev->async_pdir.dir_dma;
 
 	/* CQ notification ring */
-	dev->dsr->cq_ring_pages.num_pages = 4;
+	dev->dsr->cq_ring_pages.num_pages = PVRDMA_NUM_RING_PAGES;
 	ret = pvrdma_page_dir_init(dev, &dev->cq_pdir,
 				   dev->dsr->cq_ring_pages.num_pages, true);
 	if (ret)
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index dbbfd35..3ffbb2d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -554,13 +554,13 @@ int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return ret;
 }
 
-static inline void *get_sq_wqe(struct pvrdma_qp *qp, int n)
+static inline void *get_sq_wqe(struct pvrdma_qp *qp, unsigned int n)
 {
 	return pvrdma_page_dir_get_ptr(&qp->pdir,
 				       qp->sq.offset + n * qp->sq.wqe_size);
 }
 
-static inline void *get_rq_wqe(struct pvrdma_qp *qp, int n)
+static inline void *get_rq_wqe(struct pvrdma_qp *qp, unsigned int n)
 {
 	return pvrdma_page_dir_get_ptr(&qp->pdir,
 				       qp->rq.offset + n * qp->rq.wqe_size);
@@ -598,9 +598,7 @@ int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	unsigned long flags;
 	struct pvrdma_sq_wqe_hdr *wqe_hdr;
 	struct pvrdma_sge *sge;
-	int i, index;
-	int nreq;
-	int ret;
+	int i, ret;
 
 	/*
 	 * In states lower than RTS, we can fail immediately. In other states,
@@ -613,9 +611,8 @@ int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
-	index = pvrdma_idx(&qp->sq.ring->prod_tail, qp->sq.wqe_cnt);
-	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		unsigned int tail;
+	while (wr) {
+		unsigned int tail = 0;
 
 		if (unlikely(!pvrdma_idx_ring_has_space(
 				qp->sq.ring, qp->sq.wqe_cnt, &tail))) {
@@ -680,7 +677,7 @@ int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			}
 		}
 
-		wqe_hdr = (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, index);
+		wqe_hdr = (struct pvrdma_sq_wqe_hdr *)get_sq_wqe(qp, tail);
 		memset(wqe_hdr, 0, sizeof(*wqe_hdr));
 		wqe_hdr->wr_id = wr->wr_id;
 		wqe_hdr->num_sge = wr->num_sge;
@@ -771,12 +768,11 @@ int pvrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		/* Make sure wqe is written before index update */
 		smp_wmb();
 
-		index++;
-		if (unlikely(index >= qp->sq.wqe_cnt))
-			index = 0;
 		/* Update shared sq ring */
 		pvrdma_idx_ring_inc(&qp->sq.ring->prod_tail,
 				    qp->sq.wqe_cnt);
+
+		wr = wr->next;
 	}
 
 	ret = 0;
@@ -806,7 +802,6 @@ int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 	struct pvrdma_qp *qp = to_vqp(ibqp);
 	struct pvrdma_rq_wqe_hdr *wqe_hdr;
 	struct pvrdma_sge *sge;
-	int index, nreq;
 	int ret = 0;
 	int i;
 
@@ -821,9 +816,8 @@ int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 
 	spin_lock_irqsave(&qp->rq.lock, flags);
 
-	index = pvrdma_idx(&qp->rq.ring->prod_tail, qp->rq.wqe_cnt);
-	for (nreq = 0; wr; nreq++, wr = wr->next) {
-		unsigned int tail;
+	while (wr) {
+		unsigned int tail = 0;
 
 		if (unlikely(wr->num_sge > qp->rq.max_sg ||
 			     wr->num_sge < 0)) {
@@ -843,7 +837,7 @@ int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 			goto out;
 		}
 
-		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, index);
+		wqe_hdr = (struct pvrdma_rq_wqe_hdr *)get_rq_wqe(qp, tail);
 		wqe_hdr->wr_id = wr->wr_id;
 		wqe_hdr->num_sge = wr->num_sge;
 		wqe_hdr->total_len = 0;
@@ -859,12 +853,11 @@ int pvrdma_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		/* Make sure wqe is written before index update */
 		smp_wmb();
 
-		index++;
-		if (unlikely(index >= qp->rq.wqe_cnt))
-			index = 0;
 		/* Update shared rq ring */
 		pvrdma_idx_ring_inc(&qp->rq.ring->prod_tail,
 				    qp->rq.wqe_cnt);
+
+		wr = wr->next;
 	}
 
 	spin_unlock_irqrestore(&qp->rq.lock, flags);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
