From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 1/4] RDMA/vmw_pvrdma: Clarify QP and CQ is_kernel
 logic
Date: Wed, 20 Dec 2017 11:24:33 -0800
Message-ID: <20171220192419.GA29589@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220192305.GA28403-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Be more consistent in setting and checking is_kernel
flag for QPs and CQs.

Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 9 ++++-----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index e529622..cc46161 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -132,8 +132,9 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 	}
 
 	cq->ibcq.cqe = entries;
+	cq->is_kernel = !context;
 
-	if (context) {
+	if (!cq->is_kernel) {
 		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
 			ret = -EFAULT;
 			goto err_cq;
@@ -148,8 +149,6 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 
 		npages = ib_umem_page_count(cq->umem);
 	} else {
-		cq->is_kernel = true;
-
 		/* One extra page for shared ring state */
 		npages = 1 + (entries * sizeof(struct pvrdma_cqe) +
 			      PAGE_SIZE - 1) / PAGE_SIZE;
@@ -202,7 +201,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 	dev->cq_tbl[cq->cq_handle % dev->dsr->caps.max_cq] = cq;
 	spin_unlock_irqrestore(&dev->cq_tbl_lock, flags);
 
-	if (context) {
+	if (!cq->is_kernel) {
 		cq->uar = &(to_vucontext(context)->uar);
 
 		/* Copy udata back. */
@@ -219,7 +218,7 @@ struct ib_cq *pvrdma_create_cq(struct ib_device *ibdev,
 err_page_dir:
 	pvrdma_page_dir_cleanup(dev, &cq->pdir);
 err_umem:
-	if (context)
+	if (!cq->is_kernel)
 		ib_umem_release(cq->umem);
 err_cq:
 	atomic_dec(&dev->num_cqs);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 4059308..9dd556a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -249,8 +249,9 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 		init_completion(&qp->free);
 
 		qp->state = IB_QPS_RESET;
+		qp->is_kernel = !(pd->uobject && udata);
 
-		if (pd->uobject && udata) {
+		if (!qp->is_kernel) {
 			dev_dbg(&dev->pdev->dev,
 				"create queuepair from user space\n");
 
@@ -291,8 +292,6 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 				qp->npages_recv = 0;
 			qp->npages = qp->npages_send + qp->npages_recv;
 		} else {
-			qp->is_kernel = true;
-
 			ret = pvrdma_set_sq_size(to_vdev(pd->device),
 						 &init_attr->cap, qp);
 			if (ret)
@@ -394,7 +393,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 err_pdir:
 	pvrdma_page_dir_cleanup(dev, &qp->pdir);
 err_umem:
-	if (pd->uobject && udata) {
+	if (!qp->is_kernel) {
 		if (qp->rumem)
 			ib_umem_release(qp->rumem);
 		if (qp->sumem)
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
