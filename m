From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/8] i40iw: Avoid memory leak of CQP request objects
Date: Fri, 23 Jun 2017 16:04:02 -0500
Message-ID: <20170623210402.19988-9-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Control Queue Pair (CQP) request objects, which have
not received a completion upon interface close, remain
in memory.

To fix this, identify and free all pending CQP request
objects during destroy CQP OP.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h       |  1 +
 drivers/infiniband/hw/i40iw/i40iw_main.c  |  2 ++
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 52 +++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index da2eb5a..9b15664 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -527,6 +527,7 @@ enum i40iw_status_code i40iw_add_mac_addr(struct i40iw_device *iwdev,
 int i40iw_modify_qp(struct ib_qp *, struct ib_qp_attr *, int, struct ib_udata *);
 void i40iw_cq_wq_destroy(struct i40iw_device *iwdev, struct i40iw_sc_cq *cq);
 
+void i40iw_cleanup_pending_cqp_op(struct i40iw_device *iwdev);
 void i40iw_rem_pdusecount(struct i40iw_pd *iwpd, struct i40iw_device *iwdev);
 void i40iw_add_pdusecount(struct i40iw_pd *iwpd);
 void i40iw_rem_devusecount(struct i40iw_device *iwdev);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index d2ca107..30da619 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -243,6 +243,8 @@ static void i40iw_destroy_cqp(struct i40iw_device *iwdev, bool free_hwcqp)
 	if (free_hwcqp)
 		dev->cqp_ops->cqp_destroy(dev->cqp);
 
+	i40iw_cleanup_pending_cqp_op(iwdev);
+
 	i40iw_free_dma_mem(dev->hw, &cqp->sq);
 	kfree(cqp->scratch_array);
 	iwdev->cqp.scratch_array = NULL;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index ded8e48..e311ec5 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -337,6 +337,7 @@ struct i40iw_cqp_request *i40iw_get_cqp_request(struct i40iw_cqp *cqp, bool wait
  */
 void i40iw_free_cqp_request(struct i40iw_cqp *cqp, struct i40iw_cqp_request *cqp_request)
 {
+	struct i40iw_device *iwdev = container_of(cqp, struct i40iw_device, cqp);
 	unsigned long flags;
 
 	if (cqp_request->dynamic) {
@@ -350,6 +351,7 @@ void i40iw_free_cqp_request(struct i40iw_cqp *cqp, struct i40iw_cqp_request *cqp
 		list_add_tail(&cqp_request->list, &cqp->cqp_avail_reqs);
 		spin_unlock_irqrestore(&cqp->req_lock, flags);
 	}
+	wake_up(&iwdev->close_wq);
 }
 
 /**
@@ -365,6 +367,56 @@ void i40iw_put_cqp_request(struct i40iw_cqp *cqp,
 }
 
 /**
+ * i40iw_free_pending_cqp_request -free pending cqp request objs
+ * @cqp: cqp ptr
+ * @cqp_request: to be put back in cqp list
+ */
+static void i40iw_free_pending_cqp_request(struct i40iw_cqp *cqp,
+					   struct i40iw_cqp_request *cqp_request)
+{
+	struct i40iw_device *iwdev = container_of(cqp, struct i40iw_device, cqp);
+
+	if (cqp_request->waiting) {
+		cqp_request->compl_info.error = true;
+		cqp_request->request_done = true;
+		wake_up(&cqp_request->waitq);
+	}
+	i40iw_put_cqp_request(cqp, cqp_request);
+	wait_event_timeout(iwdev->close_wq,
+			   !atomic_read(&cqp_request->refcount),
+			   1000);
+}
+
+/**
+ * i40iw_cleanup_pending_cqp_op - clean-up cqp with no completions
+ * @iwdev: iwarp device
+ */
+void i40iw_cleanup_pending_cqp_op(struct i40iw_device *iwdev)
+{
+	struct i40iw_sc_dev *dev = &iwdev->sc_dev;
+	struct i40iw_cqp *cqp = &iwdev->cqp;
+	struct i40iw_cqp_request *cqp_request = NULL;
+	struct cqp_commands_info *pcmdinfo = NULL;
+	u32 i, pending_work, wqe_idx;
+
+	pending_work = I40IW_RING_WORK_AVAILABLE(cqp->sc_cqp.sq_ring);
+	wqe_idx = I40IW_RING_GETCURRENT_TAIL(cqp->sc_cqp.sq_ring);
+	for (i = 0; i < pending_work; i++) {
+		cqp_request = (struct i40iw_cqp_request *)(unsigned long)cqp->scratch_array[wqe_idx];
+		if (cqp_request)
+			i40iw_free_pending_cqp_request(cqp, cqp_request);
+		wqe_idx = (wqe_idx + 1) % I40IW_RING_GETSIZE(cqp->sc_cqp.sq_ring);
+	}
+
+	while (!list_empty(&dev->cqp_cmd_head)) {
+		pcmdinfo = (struct cqp_commands_info *)i40iw_remove_head(&dev->cqp_cmd_head);
+		cqp_request = container_of(pcmdinfo, struct i40iw_cqp_request, info);
+		if (cqp_request)
+			i40iw_free_pending_cqp_request(cqp, cqp_request);
+	}
+}
+
+/**
  * i40iw_free_qp - callback after destroy cqp completes
  * @cqp_request: cqp request for destroy qp
  * @num: not used
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
