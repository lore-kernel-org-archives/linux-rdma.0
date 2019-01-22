From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 01/12] IB/mlx5: Fix locking SRQ object in ODP event
Date: Tue, 22 Jan 2019 08:48:40 +0200
Message-ID: <20190122064851.6032-2-leon@kernel.org>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

QP and SRQ objects are stored in different containers so the action to
get and lock a common resource during ODP event needs to address that.

While that get rid of 'refcount' and 'free' fields in mlx5_core_srq
struct and use the fields with same semantics in common structure.

Fixes: 032080ab43ac ("IB/mlx5: Lock QP during page fault handling")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cq.c      |  4 ++--
 drivers/infiniband/hw/mlx5/odp.c     | 13 ++++++++-----
 drivers/infiniband/hw/mlx5/srq.h     |  2 --
 drivers/infiniband/hw/mlx5/srq_cmd.c | 16 +++++++---------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 202f977e7092..eb149de9f156 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -187,8 +187,8 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			wqe_ctr = be16_to_cpu(cqe->wqe_counter);
 			wc->wr_id = srq->wrid[wqe_ctr];
 			mlx5_ib_free_srq_wqe(srq, wqe_ctr);
-			if (msrq && atomic_dec_and_test(&msrq->refcount))
-				complete(&msrq->free);
+			if (msrq)
+				mlx5_core_res_put(&msrq->common);
 		}
 	} else {
 		wq	  = &qp->rq;
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 82ac6cdc7130..beff8c8908b5 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1115,22 +1115,25 @@ static int mlx5_ib_mr_responder_pfault_handler(
 static inline struct mlx5_core_rsc_common *odp_get_rsc(struct mlx5_ib_dev *dev,
 						       u32 wq_num, int pf_type)
 {
-	enum mlx5_res_type res_type;
+	struct mlx5_core_rsc_common *common = NULL;
+	struct mlx5_core_srq *srq;
 
 	switch (pf_type) {
 	case MLX5_WQE_PF_TYPE_RMP:
-		res_type = MLX5_RES_SRQ;
+		srq = mlx5_cmd_get_srq(dev, wq_num);
+		if (srq)
+			common = &srq->common;
 		break;
 	case MLX5_WQE_PF_TYPE_REQ_SEND_OR_WRITE:
 	case MLX5_WQE_PF_TYPE_RESP:
 	case MLX5_WQE_PF_TYPE_REQ_READ_OR_ATOMIC:
-		res_type = MLX5_RES_QP;
+		common = mlx5_core_res_hold(dev->mdev, wq_num, MLX5_RES_QP);
 		break;
 	default:
-		return NULL;
+		break;
 	}
 
-	return mlx5_core_res_hold(dev->mdev, wq_num, res_type);
+	return common;
 }
 
 static inline struct mlx5_ib_qp *res_to_qp(struct mlx5_core_rsc_common *res)
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index 75eb5839ae95..c330af35ff10 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -46,8 +46,6 @@ struct mlx5_core_srq {
 	int wqe_shift;
 	void (*event)(struct mlx5_core_srq *srq, enum mlx5_event e);
 
-	atomic_t refcount;
-	struct completion free;
 	u16 uid;
 };
 
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 7aaaffbd4afa..63ac38bb3498 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -87,7 +87,7 @@ struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 
 	srq = radix_tree_lookup(&table->tree, srqn);
 	if (srq)
-		atomic_inc(&srq->refcount);
+		atomic_inc(&srq->common.refcount);
 
 	spin_unlock(&table->lock);
 
@@ -594,8 +594,8 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	if (err)
 		return err;
 
-	atomic_set(&srq->refcount, 1);
-	init_completion(&srq->free);
+	atomic_set(&srq->common.refcount, 1);
+	init_completion(&srq->common.free);
 
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree, srq->srqn, srq);
@@ -627,9 +627,8 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	if (err)
 		return err;
 
-	if (atomic_dec_and_test(&srq->refcount))
-		complete(&srq->free);
-	wait_for_completion(&srq->free);
+	mlx5_core_res_put(&srq->common);
+	wait_for_completion(&srq->common.free);
 
 	return 0;
 }
@@ -685,7 +684,7 @@ static int srq_event_notifier(struct notifier_block *nb,
 
 	srq = radix_tree_lookup(&table->tree, srqn);
 	if (srq)
-		atomic_inc(&srq->refcount);
+		atomic_inc(&srq->common.refcount);
 
 	spin_unlock(&table->lock);
 
@@ -694,8 +693,7 @@ static int srq_event_notifier(struct notifier_block *nb,
 
 	srq->event(srq, eqe->type);
 
-	if (atomic_dec_and_test(&srq->refcount))
-		complete(&srq->free);
+	mlx5_core_res_put(&srq->common);
 
 	return NOTIFY_OK;
 }
-- 
2.19.1
