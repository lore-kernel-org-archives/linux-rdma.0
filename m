From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Track asynchronous events on a receive work queue
Date: Sun, 28 Aug 2016 14:58:18 +0300
Message-ID: <1472385498-14353-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track asynchronous events on a receive work queue by using the
mlx5_core_create_rq_tracked API.

In case a fatal error has occurred letting the IB layer know about by
using the ib_wq event handler.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 ++++++-
 drivers/infiniband/hw/mlx5/qp.c      | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a59034a..cde7d53 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -225,7 +225,7 @@ struct mlx5_ib_wq {
 
 struct mlx5_ib_rwq {
 	struct ib_wq		ibwq;
-	u32			rqn;
+	struct mlx5_core_qp	core_qp;
 	u32			rq_num_pas;
 	u32			log_rq_stride;
 	u32			log_rq_size;
@@ -662,6 +662,11 @@ static inline struct mlx5_ib_qp *to_mibqp(struct mlx5_core_qp *mqp)
 	return container_of(mqp, struct mlx5_ib_qp_base, mqp)->container_mibqp;
 }
 
+static inline struct mlx5_ib_rwq *to_mibrwq(struct mlx5_core_qp *core_qp)
+{
+	return container_of(core_qp, struct mlx5_ib_rwq, core_qp);
+}
+
 static inline struct mlx5_ib_mr *to_mibmr(struct mlx5_core_mkey *mmkey)
 {
 	return container_of(mmkey, struct mlx5_ib_mr, mmkey);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f3c943f..1dc5d78 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4500,6 +4500,28 @@ int mlx5_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 	return 0;
 }
 
+static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
+{
+	struct mlx5_ib_rwq *rwq = to_mibrwq(core_qp);
+	struct mlx5_ib_dev *dev = to_mdev(rwq->ibwq.device);
+	struct ib_event event;
+
+	if (rwq->ibwq.event_handler) {
+		event.device     = rwq->ibwq.device;
+		event.element.wq = &rwq->ibwq;
+		switch (type) {
+		case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+			event.event = IB_EVENT_WQ_FATAL;
+			break;
+		default:
+			mlx5_ib_warn(dev, "Unexpected event type %d on WQ %06x\n", type, core_qp->qpn);
+			return;
+		}
+
+		rwq->ibwq.event_handler(&event, rwq->ibwq.wq_context);
+	}
+}
+
 static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		      struct ib_wq_init_attr *init_attr)
 {
@@ -4537,7 +4559,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	MLX5_SET64(wq, wq, dbr_addr, rwq->db.dma);
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
-	err = mlx5_core_create_rq(dev->mdev, in, inlen, &rwq->rqn);
+	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rwq->core_qp);
 	kvfree(in);
 	return err;
 }
@@ -4653,7 +4675,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		return ERR_PTR(-EINVAL);
 	}
 
-	rwq->ibwq.wq_num = rwq->rqn;
+	rwq->ibwq.wq_num = rwq->core_qp.qpn;
 	rwq->ibwq.state = IB_WQS_RESET;
 	if (udata->outlen) {
 		resp.response_length = offsetof(typeof(resp), response_length) +
@@ -4663,10 +4685,12 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
+	rwq->core_qp.event = mlx5_ib_wq_event;
+	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
 err_copy:
-	mlx5_core_destroy_rq(dev->mdev, rwq->rqn);
+	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
 err_user_rq:
 	destroy_user_rq(pd, rwq);
 err:
@@ -4679,7 +4703,7 @@ int mlx5_ib_destroy_wq(struct ib_wq *wq)
 	struct mlx5_ib_dev *dev = to_mdev(wq->device);
 	struct mlx5_ib_rwq *rwq = to_mrwq(wq);
 
-	mlx5_core_destroy_rq(dev->mdev, rwq->rqn);
+	mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
 	destroy_user_rq(wq->pd, rwq);
 	kfree(rwq);
 
@@ -4811,7 +4835,7 @@ int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 	MLX5_SET(modify_rq_in, in, rq_state, curr_wq_state);
 	MLX5_SET(rqc, rqc, state, wq_state);
 
-	err = mlx5_core_modify_rq(dev->mdev, rwq->rqn, in, inlen);
+	err = mlx5_core_modify_rq(dev->mdev, rwq->core_qp.qpn, in, inlen);
 	kvfree(in);
 	if (!err)
 		rwq->ibwq.state = (wq_state == MLX5_RQC_STATE_ERR) ? IB_WQS_ERR : wq_state;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
