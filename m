From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 06/10] IB/mlx5: Generate completions in software
Date: Mon, 29 Feb 2016 15:45:08 +0200
Message-ID: <1456753512-17688-7-git-send-email-haggaie@mellanox.com>
References: <1456753512-17688-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456753512-17688-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The GSI QP emulation requires also emulating completions for transmitted
MADs. The CQ on which these completions are generated can also be used by
the hardware, and the MAD layer is free to use any CQ of the device for the
GSI QP.

Add a method for generating software completions to each mlx5 CQ. Software
completions are polled first, and generate calls to the completion handler
callback if necessary.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      | 83 +++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 +++++
 2 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index fd1de31e0611..bff5955e9361 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -565,18 +565,44 @@ repoll:
 	return 0;
 }
 
+static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
+			struct ib_wc *wc)
+{
+	struct mlx5_ib_dev *dev = to_mdev(cq->ibcq.device);
+	struct mlx5_ib_wc *soft_wc, *next;
+	int npolled = 0;
+
+	list_for_each_entry_safe(soft_wc, next, &cq->wc_list, list) {
+		if (npolled >= num_entries)
+			break;
+
+		mlx5_ib_dbg(dev, "polled software generated completion on CQ 0x%x\n",
+			    cq->mcq.cqn);
+
+		wc[npolled++] = soft_wc->wc;
+		list_del(&soft_wc->list);
+		kfree(soft_wc);
+	}
+
+	return npolled;
+}
+
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 {
 	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	struct mlx5_ib_qp *cur_qp = NULL;
 	unsigned long flags;
+	int soft_polled = 0;
 	int npolled;
 	int err = 0;
 
 	spin_lock_irqsave(&cq->lock, flags);
 
-	for (npolled = 0; npolled < num_entries; npolled++) {
-		err = mlx5_poll_one(cq, &cur_qp, wc + npolled);
+	if (unlikely(!list_empty(&cq->wc_list)))
+		soft_polled = poll_soft_wc(cq, num_entries, wc);
+
+	for (npolled = 0; npolled < num_entries - soft_polled; npolled++) {
+		err = mlx5_poll_one(cq, &cur_qp, wc + soft_polled + npolled);
 		if (err)
 			break;
 	}
@@ -587,7 +613,7 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 	spin_unlock_irqrestore(&cq->lock, flags);
 
 	if (err == 0 || err == -EAGAIN)
-		return npolled;
+		return soft_polled + npolled;
 	else
 		return err;
 }
@@ -595,16 +621,27 @@ int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc)
 int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct mlx5_core_dev *mdev = to_mdev(ibcq->device)->mdev;
+	struct mlx5_ib_cq *cq = to_mcq(ibcq);
 	void __iomem *uar_page = mdev->priv.uuari.uars[0].map;
+	unsigned long irq_flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&cq->lock, irq_flags);
+	if (cq->notify_flags != IB_CQ_NEXT_COMP)
+		cq->notify_flags = flags & IB_CQ_SOLICITED_MASK;
 
-	mlx5_cq_arm(&to_mcq(ibcq)->mcq,
+	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
+		ret = 1;
+	spin_unlock_irqrestore(&cq->lock, irq_flags);
+
+	mlx5_cq_arm(&cq->mcq,
 		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
 		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
 		    uar_page,
 		    MLX5_GET_DOORBELL_LOCK(&mdev->priv.cq_uar_lock),
 		    to_mcq(ibcq)->mcq.cons_index);
 
-	return 0;
+	return ret;
 }
 
 static int alloc_cq_buf(struct mlx5_ib_dev *dev, struct mlx5_ib_cq_buf *buf,
@@ -757,6 +794,14 @@ static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
 	mlx5_db_free(dev->mdev, &cq->db);
 }
 
+static void notify_soft_wc_handler(struct work_struct *work)
+{
+	struct mlx5_ib_cq *cq = container_of(work, struct mlx5_ib_cq,
+					     notify_work);
+
+	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
+
 struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
@@ -807,6 +852,8 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 				       &index, &inlen);
 		if (err)
 			goto err_create;
+
+		INIT_WORK(&cq->notify_work, notify_soft_wc_handler);
 	}
 
 	cq->cqe_size = cqe_size;
@@ -832,6 +879,8 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
 	cq->mcq.comp  = mlx5_ib_cq_comp;
 	cq->mcq.event = mlx5_ib_cq_event;
 
+	INIT_LIST_HEAD(&cq->wc_list);
+
 	if (context)
 		if (ib_copy_to_udata(udata, &cq->mcq.cqn, sizeof(__u32))) {
 			err = -EFAULT;
@@ -1219,3 +1268,27 @@ int mlx5_ib_get_cqe_size(struct mlx5_ib_dev *dev, struct ib_cq *ibcq)
 	cq = to_mcq(ibcq);
 	return cq->cqe_size;
 }
+
+/* Called from atomic context */
+int mlx5_ib_generate_wc(struct ib_cq *ibcq, struct ib_wc *wc)
+{
+	struct mlx5_ib_wc *soft_wc;
+	struct mlx5_ib_cq *cq = to_mcq(ibcq);
+	unsigned long flags;
+
+	soft_wc = kmalloc(sizeof(*soft_wc), GFP_ATOMIC);
+	if (!soft_wc)
+		return -ENOMEM;
+
+	soft_wc->wc = *wc;
+	spin_lock_irqsave(&cq->lock, flags);
+	list_add_tail(&soft_wc->list, &cq->wc_list);
+	if (cq->notify_flags == IB_CQ_NEXT_COMP ||
+	    wc->status != IB_WC_SUCCESS) {
+		cq->notify_flags = 0;
+		schedule_work(&cq->notify_work);
+	}
+	spin_unlock_irqrestore(&cq->lock, flags);
+
+	return 0;
+}
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 640840dfc4f4..b2c1005c4373 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -392,6 +392,14 @@ struct mlx5_ib_cq {
 	struct ib_umem	       *resize_umem;
 	int			cqe_size;
 	u32			create_flags;
+	struct list_head	wc_list;
+	enum ib_cq_notify_flags notify_flags;
+	struct work_struct	notify_work;
+};
+
+struct mlx5_ib_wc {
+	struct ib_wc wc;
+	struct list_head list;
 };
 
 struct mlx5_ib_srq {
@@ -784,6 +792,8 @@ int mlx5_ib_gsi_post_recv(struct ib_qp *qp, struct ib_recv_wr *wr,
 			  struct ib_recv_wr **bad_wr);
 void mlx5_ib_gsi_pkey_change(struct mlx5_ib_gsi_qp *gsi);
 
+int mlx5_ib_generate_wc(struct ib_cq *ibcq, struct ib_wc *wc);
+
 static inline void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
