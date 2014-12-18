From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/14] RDMA/ocrdma: Host crash on destroying device resources.
Date: Thu, 18 Dec 2014 14:13:01 +0530
Message-ID: <a575e3e7-d026-49a3-a13c-d897dda0619f@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

        1. Cleanup sequence in ocrdma_remove(). The device should be unregistered
           from IB stack before any device specific cleanup.
        2. Always return success in the resource destroy path. In case
           destroy command returns error, IB stack will trigger cleanup
           again while closing the uverbs device causing kernel panic BUG_ON().

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |    4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   21 ++++++++-------------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index edd81da..0083360 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -530,11 +530,11 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	/* first unregister with stack to stop all the active traffic
 	 * of the registered clients.
 	 */
-	ocrdma_rem_port_stats(dev);
 	ocrdma_remove_sysfiles(dev);
-
 	ib_unregister_device(&dev->ibdev);
 
+	ocrdma_rem_port_stats(dev);
+
 	spin_lock(&ocrdma_devlist_lock);
 	list_del_rcu(&dev->entry);
 	spin_unlock(&ocrdma_devlist_lock);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index dc18085..44a5ce1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -435,7 +435,6 @@ err:
 
 static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
 {
-	int status = 0;
 	struct ocrdma_pd *pd = uctx->cntxt_pd;
 	struct ocrdma_dev *dev = get_ocrdma_dev(pd->ibpd.device);
 
@@ -444,8 +443,8 @@ static int ocrdma_dealloc_ucontext_pd(struct ocrdma_ucontext *uctx)
 		       __func__, dev->id, pd->id);
 	}
 	uctx->cntxt_pd = NULL;
-	status = _ocrdma_dealloc_pd(dev, pd);
-	return status;
+	(void)_ocrdma_dealloc_pd(dev, pd);
+	return 0;
 }
 
 static struct ocrdma_pd *ocrdma_get_ucontext_pd(struct ocrdma_ucontext *uctx)
@@ -947,9 +946,8 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 {
 	struct ocrdma_mr *mr = get_ocrdma_mr(ib_mr);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ib_mr->device);
-	int status;
 
-	status = ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
+	(void) ocrdma_mbx_dealloc_lkey(dev, mr->hwmr.fr_mr, mr->hwmr.lkey);
 
 	ocrdma_free_mr_pbl_tbl(dev, &mr->hwmr);
 
@@ -960,11 +958,10 @@ int ocrdma_dereg_mr(struct ib_mr *ib_mr)
 
 	/* Don't stop cleanup, in case FW is unresponsive */
 	if (dev->mqe_ctx.fw_error_state) {
-		status = 0;
 		pr_err("%s(%d) fw not responding.\n",
 		       __func__, dev->id);
 	}
-	return status;
+	return 0;
 }
 
 static int ocrdma_copy_cq_uresp(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
@@ -1096,7 +1093,6 @@ static void ocrdma_flush_cq(struct ocrdma_cq *cq)
 
 int ocrdma_destroy_cq(struct ib_cq *ibcq)
 {
-	int status;
 	struct ocrdma_cq *cq = get_ocrdma_cq(ibcq);
 	struct ocrdma_eq *eq = NULL;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibcq->device);
@@ -1113,7 +1109,7 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 	synchronize_irq(irq);
 	ocrdma_flush_cq(cq);
 
-	status = ocrdma_mbx_destroy_cq(dev, cq);
+	(void)ocrdma_mbx_destroy_cq(dev, cq);
 	if (cq->ucontext) {
 		pdid = cq->ucontext->cntxt_pd->id;
 		ocrdma_del_mmap(cq->ucontext, (u64) cq->pa,
@@ -1124,7 +1120,7 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 	}
 
 	kfree(cq);
-	return status;
+	return 0;
 }
 
 static int ocrdma_add_qpn_map(struct ocrdma_dev *dev, struct ocrdma_qp *qp)
@@ -1725,7 +1721,6 @@ void ocrdma_del_flush_qp(struct ocrdma_qp *qp)
 
 int ocrdma_destroy_qp(struct ib_qp *ibqp)
 {
-	int status;
 	struct ocrdma_pd *pd;
 	struct ocrdma_qp *qp;
 	struct ocrdma_dev *dev;
@@ -1747,7 +1742,7 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	 * discarded until the old CQEs are discarded.
 	 */
 	mutex_lock(&dev->dev_lock);
-	status = ocrdma_mbx_destroy_qp(dev, qp);
+	(void) ocrdma_mbx_destroy_qp(dev, qp);
 
 	/*
 	 * acquire CQ lock while destroy is in progress, in order to
@@ -1782,7 +1777,7 @@ int ocrdma_destroy_qp(struct ib_qp *ibqp)
 	kfree(qp->wqe_wr_id_tbl);
 	kfree(qp->rqe_wr_id_tbl);
 	kfree(qp);
-	return status;
+	return 0;
 }
 
 static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
