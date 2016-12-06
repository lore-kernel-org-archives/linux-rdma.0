From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] i40iw: Fix double free of QP
Date: Tue,  6 Dec 2016 15:49:30 -0600
Message-ID: <20161206214935.41584-2-henry.orosco@intel.com>
References: <20161206214935.41584-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206214935.41584-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A QP can be double freed if i40iw_cm_disconn() is
called while it is currently being freed by
i40iw_rem_ref(). The fix in i40iw_cm_disconn() will
first check if the QP is already freed before
making another request for the QP to be freed.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw.h    |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 20 ++++++++++++++++----
 drivers/infiniband/hw/i40iw/i40iw_hw.c |  4 +++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index ef188e6..51b8280 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -512,7 +512,7 @@ u32 i40iw_initialize_hw_resources(struct i40iw_device *iwdev);
 
 int i40iw_register_rdma_device(struct i40iw_device *iwdev);
 void i40iw_port_ibevent(struct i40iw_device *iwdev);
-int i40iw_cm_disconn(struct i40iw_qp *);
+void i40iw_cm_disconn(struct i40iw_qp *iwqp);
 void i40iw_cm_disconn_worker(void *);
 int mini_cm_recv_pkt(struct i40iw_cm_core *, struct i40iw_device *,
 		     struct sk_buff *);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 25af89a..ff95fea 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3359,21 +3359,33 @@ static void i40iw_cm_init_tsa_conn(struct i40iw_qp *iwqp,
  * i40iw_cm_disconn - when a connection is being closed
  * @iwqp: associate qp for the connection
  */
-int i40iw_cm_disconn(struct i40iw_qp *iwqp)
+void i40iw_cm_disconn(struct i40iw_qp *iwqp)
 {
 	struct disconn_work *work;
 	struct i40iw_device *iwdev = iwqp->iwdev;
 	struct i40iw_cm_core *cm_core = &iwdev->cm_core;
+	unsigned long flags;
 
 	work = kzalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
-		return -ENOMEM;	/* Timer will clean up */
-
+		return;	/* Timer will clean up */
+
+	spin_lock_irqsave(&iwdev->qptable_lock, flags);
+	if (!iwdev->qp_table[iwqp->ibqp.qp_num]) {
+		spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
+		i40iw_debug(&iwdev->sc_dev, I40IW_DEBUG_CM,
+			    "%s qp_id %d is already freed\n",
+			     __func__, iwqp->ibqp.qp_num);
+		kfree(work);
+		return;
+	}
 	i40iw_add_ref(&iwqp->ibqp);
+	spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
+
 	work->iwqp = iwqp;
 	INIT_WORK(&work->work, i40iw_disconnect_worker);
 	queue_work(cm_core->disconn_wq, &work->work);
-	return 0;
+	return;
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
index 5e2c16c..b2854b1 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_hw.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_hw.c
@@ -308,7 +308,9 @@ void i40iw_process_aeq(struct i40iw_device *iwdev)
 			iwqp = iwdev->qp_table[info->qp_cq_id];
 			if (!iwqp) {
 				spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
-				i40iw_pr_err("qp_id %d is already freed\n", info->qp_cq_id);
+				i40iw_debug(dev, I40IW_DEBUG_AEQ,
+					    "%s qp_id %d is already freed\n",
+					    __func__, info->qp_cq_id);
 				continue;
 			}
 			i40iw_add_ref(&iwqp->ibqp);
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
