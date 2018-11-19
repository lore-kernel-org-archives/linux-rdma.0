From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 mlx5-next 11/12] {net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA
Date: Mon, 19 Nov 2018 10:52:41 -0800
Message-ID: <20181119185242.21961-12-saeedm@mellanox.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use the new generic EQ API to move all ODP RDMA data structures and logic
form mlx5 core driver into mlx5_ib driver.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  10 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  15 +-
 drivers/infiniband/hw/mlx5/odp.c              | 281 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  34 ---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 252 ----------------
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |   8 -
 .../net/ethernet/mellanox/mlx5/core/main.c    |  17 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 -
 include/linux/mlx5/driver.h                   |  49 ---
 include/linux/mlx5/eq.h                       |  21 ++
 10 files changed, 308 insertions(+), 381 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6fbc0cba1bac..fcf4a0328a90 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6040,6 +6040,11 @@ static int mlx5_ib_stage_odp_init(struct mlx5_ib_dev *dev)
 	return mlx5_ib_odp_init_one(dev);
 }
 
+void mlx5_ib_stage_odp_cleanup(struct mlx5_ib_dev *dev)
+{
+	mlx5_ib_odp_cleanup_one(dev);
+}
+
 int mlx5_ib_stage_counters_init(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
@@ -6225,7 +6230,7 @@ static const struct mlx5_ib_profile pf_profile = {
 		     mlx5_ib_stage_dev_res_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ODP,
 		     mlx5_ib_stage_odp_init,
-		     NULL),
+		     mlx5_ib_stage_odp_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
@@ -6395,9 +6400,6 @@ static struct mlx5_interface mlx5_ib_interface = {
 	.add            = mlx5_ib_add,
 	.remove         = mlx5_ib_remove,
 	.event          = mlx5_ib_event,
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	.pfault		= mlx5_ib_pfault,
-#endif
 	.protocol	= MLX5_INTERFACE_PROTOCOL_IB,
 };
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b651a7a6fde9..27999fd32356 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -880,6 +880,15 @@ struct mlx5_ib_lb_state {
 	bool			enabled;
 };
 
+struct mlx5_ib_pf_eq {
+	struct mlx5_ib_dev *dev;
+	struct mlx5_eq *core;
+	struct work_struct work;
+	spinlock_t lock; /* Pagefaults spinlock */
+	struct workqueue_struct *wq;
+	mempool_t *pool;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	const struct uverbs_object_tree_def *driver_trees[7];
@@ -902,6 +911,8 @@ struct mlx5_ib_dev {
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_odp_caps	odp_caps;
 	u64			odp_max_size;
+	struct mlx5_ib_pf_eq	odp_pf_eq;
+
 	/*
 	 * Sleepable RCU that prevents destruction of MRs while they are still
 	 * being used by a page fault handler.
@@ -1158,9 +1169,8 @@ struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev);
-void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
-		    struct mlx5_pagefault *pfault);
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev);
+void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
 void mlx5_ib_invalidate_range(struct ib_umem_odp *umem_odp, unsigned long start,
@@ -1175,6 +1185,7 @@ static inline void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 }
 
 static inline int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev) { return 0; }
+static inline void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev) {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
 static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 7d784b40e017..416d141322a0 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -37,6 +37,46 @@
 #include "mlx5_ib.h"
 #include "cmd.h"
 
+#include <linux/mlx5/eq.h>
+
+/* Contains the details of a pagefault. */
+struct mlx5_pagefault {
+	u32			bytes_committed;
+	u32			token;
+	u8			event_subtype;
+	u8			type;
+	union {
+		/* Initiator or send message responder pagefault details. */
+		struct {
+			/* Received packet size, only valid for responders. */
+			u32	packet_size;
+			/*
+			 * Number of resource holding WQE, depends on type.
+			 */
+			u32	wq_num;
+			/*
+			 * WQE index. Refers to either the send queue or
+			 * receive queue, according to event_subtype.
+			 */
+			u16	wqe_index;
+		} wqe;
+		/* RDMA responder pagefault details */
+		struct {
+			u32	r_key;
+			/*
+			 * Received packet size, minimal size page fault
+			 * resolution required for forward progress.
+			 */
+			u32	packet_size;
+			u32	rdma_op_len;
+			u64	rdma_va;
+		} rdma;
+	};
+
+	struct mlx5_ib_pf_eq	*eq;
+	struct work_struct	work;
+};
+
 #define MAX_PREFETCH_LEN (4*1024*1024U)
 
 /* Timeout in ms to wait for an active mmu notifier to complete when handling
@@ -304,14 +344,20 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 {
 	int wq_num = pfault->event_subtype == MLX5_PFAULT_SUBTYPE_WQE ?
 		     pfault->wqe.wq_num : pfault->token;
-	int ret = mlx5_core_page_fault_resume(dev->mdev,
-					      pfault->token,
-					      wq_num,
-					      pfault->type,
-					      error);
-	if (ret)
-		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x\n",
-			    wq_num);
+	u32 out[MLX5_ST_SZ_DW(page_fault_resume_out)] = { };
+	u32 in[MLX5_ST_SZ_DW(page_fault_resume_in)]   = { };
+	int err;
+
+	MLX5_SET(page_fault_resume_in, in, opcode, MLX5_CMD_OP_PAGE_FAULT_RESUME);
+	MLX5_SET(page_fault_resume_in, in, page_fault_type, pfault->type);
+	MLX5_SET(page_fault_resume_in, in, token, pfault->token);
+	MLX5_SET(page_fault_resume_in, in, wq_number, wq_num);
+	MLX5_SET(page_fault_resume_in, in, error, !!error);
+
+	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		mlx5_ib_err(dev, "Failed to resolve the page fault on WQ 0x%x err %d\n",
+			    wq_num, err);
 }
 
 static struct mlx5_ib_mr *implicit_mr_alloc(struct ib_pd *pd,
@@ -1196,10 +1242,8 @@ static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,
 	}
 }
 
-void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
-		    struct mlx5_pagefault *pfault)
+static void mlx5_ib_pfault(struct mlx5_ib_dev *dev, struct mlx5_pagefault *pfault)
 {
-	struct mlx5_ib_dev *dev = context;
 	u8 event_subtype = pfault->event_subtype;
 
 	switch (event_subtype) {
@@ -1216,6 +1260,203 @@ void mlx5_ib_pfault(struct mlx5_core_dev *mdev, void *context,
 	}
 }
 
+static void mlx5_ib_eqe_pf_action(struct work_struct *work)
+{
+	struct mlx5_pagefault *pfault = container_of(work,
+						     struct mlx5_pagefault,
+						     work);
+	struct mlx5_ib_pf_eq *eq = pfault->eq;
+
+	mlx5_ib_pfault(eq->dev, pfault);
+	mempool_free(pfault, eq->pool);
+}
+
+static void mlx5_ib_eq_pf_process(struct mlx5_ib_pf_eq *eq)
+{
+	struct mlx5_eqe_page_fault *pf_eqe;
+	struct mlx5_pagefault *pfault;
+	struct mlx5_eqe *eqe;
+	int cc = 0;
+
+	while ((eqe = mlx5_eq_get_eqe(eq->core, cc))) {
+		pfault = mempool_alloc(eq->pool, GFP_ATOMIC);
+		if (!pfault) {
+			schedule_work(&eq->work);
+			break;
+		}
+
+		pf_eqe = &eqe->data.page_fault;
+		pfault->event_subtype = eqe->sub_type;
+		pfault->bytes_committed = be32_to_cpu(pf_eqe->bytes_committed);
+
+		mlx5_ib_dbg(eq->dev,
+			    "PAGE_FAULT: subtype: 0x%02x, bytes_committed: 0x%06x\n",
+			    eqe->sub_type, pfault->bytes_committed);
+
+		switch (eqe->sub_type) {
+		case MLX5_PFAULT_SUBTYPE_RDMA:
+			/* RDMA based event */
+			pfault->type =
+				be32_to_cpu(pf_eqe->rdma.pftype_token) >> 24;
+			pfault->token =
+				be32_to_cpu(pf_eqe->rdma.pftype_token) &
+				MLX5_24BIT_MASK;
+			pfault->rdma.r_key =
+				be32_to_cpu(pf_eqe->rdma.r_key);
+			pfault->rdma.packet_size =
+				be16_to_cpu(pf_eqe->rdma.packet_length);
+			pfault->rdma.rdma_op_len =
+				be32_to_cpu(pf_eqe->rdma.rdma_op_len);
+			pfault->rdma.rdma_va =
+				be64_to_cpu(pf_eqe->rdma.rdma_va);
+			mlx5_ib_dbg(eq->dev,
+				    "PAGE_FAULT: type:0x%x, token: 0x%06x, r_key: 0x%08x\n",
+				    pfault->type, pfault->token,
+				    pfault->rdma.r_key);
+			mlx5_ib_dbg(eq->dev,
+				    "PAGE_FAULT: rdma_op_len: 0x%08x, rdma_va: 0x%016llx\n",
+				    pfault->rdma.rdma_op_len,
+				    pfault->rdma.rdma_va);
+			break;
+
+		case MLX5_PFAULT_SUBTYPE_WQE:
+			/* WQE based event */
+			pfault->type =
+				(be32_to_cpu(pf_eqe->wqe.pftype_wq) >> 24) & 0x7;
+			pfault->token =
+				be32_to_cpu(pf_eqe->wqe.token);
+			pfault->wqe.wq_num =
+				be32_to_cpu(pf_eqe->wqe.pftype_wq) &
+				MLX5_24BIT_MASK;
+			pfault->wqe.wqe_index =
+				be16_to_cpu(pf_eqe->wqe.wqe_index);
+			pfault->wqe.packet_size =
+				be16_to_cpu(pf_eqe->wqe.packet_length);
+			mlx5_ib_dbg(eq->dev,
+				    "PAGE_FAULT: type:0x%x, token: 0x%06x, wq_num: 0x%06x, wqe_index: 0x%04x\n",
+				    pfault->type, pfault->token,
+				    pfault->wqe.wq_num,
+				    pfault->wqe.wqe_index);
+			break;
+
+		default:
+			mlx5_ib_warn(eq->dev,
+				     "Unsupported page fault event sub-type: 0x%02hhx\n",
+				     eqe->sub_type);
+			/* Unsupported page faults should still be
+			 * resolved by the page fault handler
+			 */
+		}
+
+		pfault->eq = eq;
+		INIT_WORK(&pfault->work, mlx5_ib_eqe_pf_action);
+		queue_work(eq->wq, &pfault->work);
+
+		cc = mlx5_eq_update_cc(eq->core, ++cc);
+	}
+
+	mlx5_eq_update_ci(eq->core, cc, 1);
+}
+
+static irqreturn_t mlx5_ib_eq_pf_int(int irq, void *eq_ptr)
+{
+	struct mlx5_ib_pf_eq *eq = eq_ptr;
+	unsigned long flags;
+
+	if (spin_trylock_irqsave(&eq->lock, flags)) {
+		mlx5_ib_eq_pf_process(eq);
+		spin_unlock_irqrestore(&eq->lock, flags);
+	} else {
+		schedule_work(&eq->work);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* mempool_refill() was proposed but unfortunately wasn't accepted
+ * http://lkml.iu.edu/hypermail/linux/kernel/1512.1/05073.html
+ * Cheap workaround.
+ */
+static void mempool_refill(mempool_t *pool)
+{
+	while (pool->curr_nr < pool->min_nr)
+		mempool_free(mempool_alloc(pool, GFP_KERNEL), pool);
+}
+
+static void mlx5_ib_eq_pf_action(struct work_struct *work)
+{
+	struct mlx5_ib_pf_eq *eq =
+		container_of(work, struct mlx5_ib_pf_eq, work);
+
+	mempool_refill(eq->pool);
+
+	spin_lock_irq(&eq->lock);
+	mlx5_ib_eq_pf_process(eq);
+	spin_unlock_irq(&eq->lock);
+}
+
+enum {
+	MLX5_IB_NUM_PF_EQE	= 0x1000,
+	MLX5_IB_NUM_PF_DRAIN	= 64,
+};
+
+static int
+mlx5_ib_create_pf_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
+{
+	struct mlx5_eq_param param = {};
+	int err;
+
+	INIT_WORK(&eq->work, mlx5_ib_eq_pf_action);
+	spin_lock_init(&eq->lock);
+	eq->dev = dev;
+
+	eq->pool = mempool_create_kmalloc_pool(MLX5_IB_NUM_PF_DRAIN,
+					       sizeof(struct mlx5_pagefault));
+	if (!eq->pool)
+		return -ENOMEM;
+
+	eq->wq = alloc_workqueue("mlx5_ib_page_fault",
+				 WQ_HIGHPRI | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				 MLX5_NUM_CMD_EQE);
+	if (!eq->wq) {
+		err = -ENOMEM;
+		goto err_mempool;
+	}
+
+	param = (struct mlx5_eq_param) {
+		.index = MLX5_EQ_PFAULT_IDX,
+		.mask = 1 << MLX5_EVENT_TYPE_PAGE_FAULT,
+		.nent = MLX5_IB_NUM_PF_EQE,
+		.context = eq,
+		.handler = mlx5_ib_eq_pf_int
+	};
+	eq->core = mlx5_eq_create_generic(dev->mdev, "mlx5_ib_page_fault_eq", &param);
+	if (IS_ERR(eq->core)) {
+		err = PTR_ERR(eq->core);
+		goto err_wq;
+	}
+
+	return 0;
+err_wq:
+	destroy_workqueue(eq->wq);
+err_mempool:
+	mempool_destroy(eq->pool);
+	return err;
+}
+
+static int
+mlx5_ib_destroy_pf_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
+{
+	int err;
+
+	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
+	cancel_work_sync(&eq->work);
+	destroy_workqueue(eq->wq);
+	mempool_destroy(eq->pool);
+
+	return err;
+}
+
 void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
@@ -1244,7 +1485,7 @@ void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
 
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 {
-	int ret;
+	int ret = 0;
 
 	if (dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT) {
 		ret = mlx5_cmd_null_mkey(dev->mdev, &dev->null_mkey);
@@ -1254,7 +1495,20 @@ int mlx5_ib_odp_init_one(struct mlx5_ib_dev *dev)
 		}
 	}
 
-	return 0;
+	if (!MLX5_CAP_GEN(dev->mdev, pg))
+		return ret;
+
+	ret = mlx5_ib_create_pf_eq(dev, &dev->odp_pf_eq);
+
+	return ret;
+}
+
+void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *dev)
+{
+	if (!MLX5_CAP_GEN(dev->mdev, pg))
+		return;
+
+	mlx5_ib_destroy_pf_eq(dev, &dev->odp_pf_eq);
 }
 
 int mlx5_ib_odp_init(void)
@@ -1264,4 +1518,3 @@ int mlx5_ib_odp_init(void)
 
 	return 0;
 }
-
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 37ba7c78859d..7eedbea38a78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -139,17 +139,6 @@ void mlx5_add_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 
 		spin_lock_irq(&priv->ctx_lock);
 		list_add_tail(&dev_ctx->list, &priv->ctx_list);
-
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-		if (dev_ctx->intf->pfault) {
-			if (priv->pfault) {
-				mlx5_core_err(dev, "multiple page fault handlers not supported");
-			} else {
-				priv->pfault_ctx = dev_ctx->context;
-				priv->pfault = dev_ctx->intf->pfault;
-			}
-		}
-#endif
 		spin_unlock_irq(&priv->ctx_lock);
 	}
 
@@ -179,15 +168,6 @@ void mlx5_remove_device(struct mlx5_interface *intf, struct mlx5_priv *priv)
 	if (!dev_ctx)
 		return;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	spin_lock_irq(&priv->ctx_lock);
-	if (priv->pfault == dev_ctx->intf->pfault)
-		priv->pfault = NULL;
-	spin_unlock_irq(&priv->ctx_lock);
-
-	synchronize_srcu(&priv->pfault_srcu);
-#endif
-
 	spin_lock_irq(&priv->ctx_lock);
 	list_del(&dev_ctx->list);
 	spin_unlock_irq(&priv->ctx_lock);
@@ -447,20 +427,6 @@ void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
 	spin_unlock_irqrestore(&priv->ctx_lock, flags);
 }
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-void mlx5_core_page_fault(struct mlx5_core_dev *dev,
-			  struct mlx5_pagefault *pfault)
-{
-	struct mlx5_priv *priv = &dev->priv;
-	int srcu_idx;
-
-	srcu_idx = srcu_read_lock(&priv->pfault_srcu);
-	if (priv->pfault)
-		priv->pfault(dev, priv->pfault_ctx, pfault);
-	srcu_read_unlock(&priv->pfault_srcu, srcu_idx);
-}
-#endif
-
 void mlx5_dev_list_lock(void)
 {
 	mutex_lock(&mlx5_intf_mutex);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index ec1f5018546e..895401609c63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -56,13 +56,6 @@ enum {
 	MLX5_EQ_STATE_ALWAYS_ARMED	= 0xb,
 };
 
-enum {
-	MLX5_NUM_SPARE_EQE	= 0x80,
-	MLX5_NUM_ASYNC_EQE	= 0x1000,
-	MLX5_NUM_CMD_EQE	= 32,
-	MLX5_NUM_PF_DRAIN	= 64,
-};
-
 enum {
 	MLX5_EQ_DOORBEL_OFFSET	= 0x40,
 };
@@ -79,9 +72,6 @@ struct mlx5_eq_table {
 	struct mlx5_eq          async_eq;
 	struct mlx5_eq	        cmd_eq;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct mlx5_eq_pagefault pfault_eq;
-#endif
 	struct mutex            lock; /* sync async eqs creations */
 	int			num_comp_vectors;
 	struct mlx5_irq_info	*irq_info;
@@ -222,224 +212,6 @@ static void eq_update_ci(struct mlx5_eq *eq, int arm)
 	mb();
 }
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-static void eqe_pf_action(struct work_struct *work)
-{
-	struct mlx5_pagefault *pfault = container_of(work,
-						     struct mlx5_pagefault,
-						     work);
-	struct mlx5_eq_pagefault *eq = pfault->eq;
-
-	mlx5_core_page_fault(eq->core->dev, pfault);
-	mempool_free(pfault, eq->pool);
-}
-
-static void eq_pf_process(struct mlx5_eq_pagefault *eq)
-{
-	struct mlx5_core_dev *dev = eq->core->dev;
-	struct mlx5_eqe_page_fault *pf_eqe;
-	struct mlx5_pagefault *pfault;
-	struct mlx5_eqe *eqe;
-	int set_ci = 0;
-
-	while ((eqe = next_eqe_sw(eq->core))) {
-		pfault = mempool_alloc(eq->pool, GFP_ATOMIC);
-		if (!pfault) {
-			schedule_work(&eq->work);
-			break;
-		}
-
-		dma_rmb();
-		pf_eqe = &eqe->data.page_fault;
-		pfault->event_subtype = eqe->sub_type;
-		pfault->bytes_committed = be32_to_cpu(pf_eqe->bytes_committed);
-
-		mlx5_core_dbg(dev,
-			      "PAGE_FAULT: subtype: 0x%02x, bytes_committed: 0x%06x\n",
-			      eqe->sub_type, pfault->bytes_committed);
-
-		switch (eqe->sub_type) {
-		case MLX5_PFAULT_SUBTYPE_RDMA:
-			/* RDMA based event */
-			pfault->type =
-				be32_to_cpu(pf_eqe->rdma.pftype_token) >> 24;
-			pfault->token =
-				be32_to_cpu(pf_eqe->rdma.pftype_token) &
-				MLX5_24BIT_MASK;
-			pfault->rdma.r_key =
-				be32_to_cpu(pf_eqe->rdma.r_key);
-			pfault->rdma.packet_size =
-				be16_to_cpu(pf_eqe->rdma.packet_length);
-			pfault->rdma.rdma_op_len =
-				be32_to_cpu(pf_eqe->rdma.rdma_op_len);
-			pfault->rdma.rdma_va =
-				be64_to_cpu(pf_eqe->rdma.rdma_va);
-			mlx5_core_dbg(dev,
-				      "PAGE_FAULT: type:0x%x, token: 0x%06x, r_key: 0x%08x\n",
-				      pfault->type, pfault->token,
-				      pfault->rdma.r_key);
-			mlx5_core_dbg(dev,
-				      "PAGE_FAULT: rdma_op_len: 0x%08x, rdma_va: 0x%016llx\n",
-				      pfault->rdma.rdma_op_len,
-				      pfault->rdma.rdma_va);
-			break;
-
-		case MLX5_PFAULT_SUBTYPE_WQE:
-			/* WQE based event */
-			pfault->type =
-				(be32_to_cpu(pf_eqe->wqe.pftype_wq) >> 24) & 0x7;
-			pfault->token =
-				be32_to_cpu(pf_eqe->wqe.token);
-			pfault->wqe.wq_num =
-				be32_to_cpu(pf_eqe->wqe.pftype_wq) &
-				MLX5_24BIT_MASK;
-			pfault->wqe.wqe_index =
-				be16_to_cpu(pf_eqe->wqe.wqe_index);
-			pfault->wqe.packet_size =
-				be16_to_cpu(pf_eqe->wqe.packet_length);
-			mlx5_core_dbg(dev,
-				      "PAGE_FAULT: type:0x%x, token: 0x%06x, wq_num: 0x%06x, wqe_index: 0x%04x\n",
-				      pfault->type, pfault->token,
-				      pfault->wqe.wq_num,
-				      pfault->wqe.wqe_index);
-			break;
-
-		default:
-			mlx5_core_warn(dev,
-				       "Unsupported page fault event sub-type: 0x%02hhx\n",
-				       eqe->sub_type);
-			/* Unsupported page faults should still be
-			 * resolved by the page fault handler
-			 */
-		}
-
-		pfault->eq = eq;
-		INIT_WORK(&pfault->work, eqe_pf_action);
-		queue_work(eq->wq, &pfault->work);
-
-		++eq->core->cons_index;
-		++set_ci;
-
-		if (unlikely(set_ci >= MLX5_NUM_SPARE_EQE)) {
-			eq_update_ci(eq->core, 0);
-			set_ci = 0;
-		}
-	}
-
-	eq_update_ci(eq->core, 1);
-}
-
-static irqreturn_t mlx5_eq_pf_int(int irq, void *eq_ptr)
-{
-	struct mlx5_eq_pagefault *eq = eq_ptr;
-	unsigned long flags;
-
-	if (spin_trylock_irqsave(&eq->lock, flags)) {
-		eq_pf_process(eq);
-		spin_unlock_irqrestore(&eq->lock, flags);
-	} else {
-		schedule_work(&eq->work);
-	}
-
-	return IRQ_HANDLED;
-}
-
-/* mempool_refill() was proposed but unfortunately wasn't accepted
- * http://lkml.iu.edu/hypermail/linux/kernel/1512.1/05073.html
- * Chip workaround.
- */
-static void mempool_refill(mempool_t *pool)
-{
-	while (pool->curr_nr < pool->min_nr)
-		mempool_free(mempool_alloc(pool, GFP_KERNEL), pool);
-}
-
-static void eq_pf_action(struct work_struct *work)
-{
-	struct mlx5_eq_pagefault *eq =
-		container_of(work, struct mlx5_eq_pagefault, work);
-
-	mempool_refill(eq->pool);
-
-	spin_lock_irq(&eq->lock);
-	eq_pf_process(eq);
-	spin_unlock_irq(&eq->lock);
-}
-
-static int
-create_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
-{
-	struct mlx5_eq_param param = {};
-	int err;
-
-	spin_lock_init(&eq->lock);
-	INIT_WORK(&eq->work, eq_pf_action);
-
-	eq->pool = mempool_create_kmalloc_pool(MLX5_NUM_PF_DRAIN,
-					       sizeof(struct mlx5_pagefault));
-	if (!eq->pool)
-		return -ENOMEM;
-
-	eq->wq = alloc_workqueue("mlx5_page_fault",
-				 WQ_HIGHPRI | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				 MLX5_NUM_CMD_EQE);
-	if (!eq->wq) {
-		err = -ENOMEM;
-		goto err_mempool;
-	}
-
-	param = (struct mlx5_eq_param) {
-		.index = MLX5_EQ_PFAULT_IDX,
-		.mask = 1 << MLX5_EVENT_TYPE_PAGE_FAULT,
-		.nent = MLX5_NUM_ASYNC_EQE,
-		.context = eq,
-		.handler = mlx5_eq_pf_int
-	};
-
-	eq->core = mlx5_eq_create_generic(dev, "mlx5_page_fault_eq", &param);
-	if (IS_ERR(eq->core)) {
-		err = PTR_ERR(eq->core);
-		goto err_wq;
-	}
-
-	return 0;
-err_wq:
-	destroy_workqueue(eq->wq);
-err_mempool:
-	mempool_destroy(eq->pool);
-	return err;
-}
-
-static int destroy_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
-{
-	int err;
-
-	err = mlx5_eq_destroy_generic(dev, eq->core);
-	cancel_work_sync(&eq->work);
-	destroy_workqueue(eq->wq);
-	mempool_destroy(eq->pool);
-
-	return err;
-}
-
-int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
-				u32 wq_num, u8 type, int error)
-{
-	u32 out[MLX5_ST_SZ_DW(page_fault_resume_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(page_fault_resume_in)]   = {0};
-
-	MLX5_SET(page_fault_resume_in, in, opcode,
-		 MLX5_CMD_OP_PAGE_FAULT_RESUME);
-	MLX5_SET(page_fault_resume_in, in, error, !!error);
-	MLX5_SET(page_fault_resume_in, in, page_fault_type, type);
-	MLX5_SET(page_fault_resume_in, in, wq_number, wq_num);
-	MLX5_SET(page_fault_resume_in, in, token, token);
-
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-EXPORT_SYMBOL_GPL(mlx5_core_page_fault_resume);
-#endif
-
 static void general_event_handler(struct mlx5_core_dev *dev,
 				  struct mlx5_eqe *eqe)
 {
@@ -1016,22 +788,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 		goto err2;
 	}
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (MLX5_CAP_GEN(dev, pg)) {
-		err = create_pf_eq(dev, &table->pfault_eq);
-		if (err) {
-			mlx5_core_warn(dev, "failed to create page fault EQ %d\n",
-				       err);
-			goto err3;
-		}
-	}
-
-	return err;
-err3:
-	destroy_async_eq(dev, &table->pages_eq);
-#else
 	return err;
-#endif
 
 err2:
 	destroy_async_eq(dev, &table->async_eq);
@@ -1047,15 +804,6 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 	int err;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (MLX5_CAP_GEN(dev, pg)) {
-		err = destroy_pf_eq(dev, &table->pfault_eq);
-		if (err)
-			mlx5_core_err(dev, "failed to destroy page fault eq, err(%d)\n",
-				      err);
-	}
-#endif
-
 	err = destroy_async_eq(dev, &table->pages_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy pages eq, err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index db32057ad054..4cc2d442cef6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -39,14 +39,6 @@ struct mlx5_eq_comp {
 	struct list_head        list;
 };
 
-struct mlx5_eq_pagefault {
-	struct mlx5_eq          *core;
-	struct work_struct       work;
-	spinlock_t               lock; /* Pagefaults spinlock */
-	struct workqueue_struct  *wq;
-	mempool_t                *pool;
-};
-
 int mlx5_eq_table_init(struct mlx5_core_dev *dev);
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_eq_table_create(struct mlx5_core_dev *dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 3de83fe65f2b..91022f141855 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1169,14 +1169,6 @@ static int init_one(struct pci_dev *pdev,
 	INIT_LIST_HEAD(&priv->waiting_events_list);
 	priv->is_accum_events = false;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	err = init_srcu_struct(&priv->pfault_srcu);
-	if (err) {
-		dev_err(&pdev->dev, "init_srcu_struct failed with error code %d\n",
-			err);
-		goto clean_dev;
-	}
-#endif
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
 	INIT_LIST_HEAD(&priv->bfregs.reg_head.list);
@@ -1185,7 +1177,7 @@ static int init_one(struct pci_dev *pdev,
 	err = mlx5_pci_init(dev, priv);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_pci_init failed with error code %d\n", err);
-		goto clean_srcu;
+		goto clean_dev;
 	}
 
 	err = mlx5_health_init(dev);
@@ -1218,11 +1210,7 @@ static int init_one(struct pci_dev *pdev,
 	mlx5_health_cleanup(dev);
 close_pci:
 	mlx5_pci_close(dev, priv);
-clean_srcu:
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	cleanup_srcu_struct(&priv->pfault_srcu);
 clean_dev:
-#endif
 	devlink_free(devlink);
 
 	return err;
@@ -1246,9 +1234,6 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	mlx5_pci_close(dev, priv);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	cleanup_srcu_struct(&priv->pfault_srcu);
-#endif
 	devlink_free(devlink);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 4728b027cb9e..21727d9eeb84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -100,8 +100,6 @@ int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev);
 
 void mlx5_core_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
 		     unsigned long param);
-void mlx5_core_page_fault(struct mlx5_core_dev *dev,
-			  struct mlx5_pagefault *pfault);
 void mlx5_port_module_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force);
 void mlx5_disable_device(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index fe9b552aa649..f41e6713df10 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -510,7 +510,6 @@ struct mlx5_fc_stats {
 struct mlx5_mpfs;
 struct mlx5_eswitch;
 struct mlx5_lag;
-struct mlx5_pagefault;
 struct mlx5_eq_table;
 
 struct mlx5_rate_limit {
@@ -619,13 +618,6 @@ struct mlx5_priv {
 
 	struct mlx5_port_module_event_stats  pme_stats;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	void		      (*pfault)(struct mlx5_core_dev *dev,
-					void *context,
-					struct mlx5_pagefault *pfault);
-	void		       *pfault_ctx;
-	struct srcu_struct      pfault_srcu;
-#endif
 	struct mlx5_bfreg_data		bfregs;
 	struct mlx5_uars_page	       *uar;
 };
@@ -650,44 +642,6 @@ enum mlx5_pagefault_type_flags {
 	MLX5_PFAULT_RDMA      = 1 << 2,
 };
 
-/* Contains the details of a pagefault. */
-struct mlx5_pagefault {
-	u32			bytes_committed;
-	u32			token;
-	u8			event_subtype;
-	u8			type;
-	union {
-		/* Initiator or send message responder pagefault details. */
-		struct {
-			/* Received packet size, only valid for responders. */
-			u32	packet_size;
-			/*
-			 * Number of resource holding WQE, depends on type.
-			 */
-			u32	wq_num;
-			/*
-			 * WQE index. Refers to either the send queue or
-			 * receive queue, according to event_subtype.
-			 */
-			u16	wqe_index;
-		} wqe;
-		/* RDMA responder pagefault details */
-		struct {
-			u32	r_key;
-			/*
-			 * Received packet size, minimal size page fault
-			 * resolution required for forward progress.
-			 */
-			u32	packet_size;
-			u32	rdma_op_len;
-			u64	rdma_va;
-		} rdma;
-	};
-
-	struct mlx5_eq_pagefault *eq;
-	struct work_struct	work;
-};
-
 struct mlx5_td {
 	struct list_head tirs_list;
 	u32              tdn;
@@ -1118,9 +1072,6 @@ struct mlx5_interface {
 	void			(*detach)(struct mlx5_core_dev *dev, void *context);
 	void			(*event)(struct mlx5_core_dev *dev, void *context,
 					 enum mlx5_dev_event event, unsigned long param);
-	void			(*pfault)(struct mlx5_core_dev *dev,
-					  void *context,
-					  struct mlx5_pagefault *pfault);
 	void *                  (*get_dev)(void *context);
 	int			protocol;
 	struct list_head	list;
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index c733673ba5f6..71d82c5a1a02 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -17,6 +17,10 @@ enum {
 	MLX5_EQ_VEC_COMP_BASE = MLX5_EQ_MAX_ASYNC_EQS,
 };
 
+#define MLX5_NUM_CMD_EQE   (32)
+#define MLX5_NUM_ASYNC_EQE (0x1000)
+#define MLX5_NUM_SPARE_EQE (0x80)
+
 struct mlx5_eq;
 
 struct mlx5_eq_param {
@@ -36,4 +40,21 @@ mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
 struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc);
 void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm);
 
+/* The HCA will think the queue has overflowed if we
+ * don't tell it we've been processing events.  We
+ * create EQs with MLX5_NUM_SPARE_EQE extra entries,
+ * so we must update our consumer index at
+ * least that often.
+ *
+ * mlx5_eq_update_cc must be called on every EQE @EQ irq handler
+ */
+static inline u32 mlx5_eq_update_cc(struct mlx5_eq *eq, u32 cc)
+{
+	if (unlikely(cc >= MLX5_NUM_SPARE_EQE)) {
+		mlx5_eq_update_ci(eq, cc, 0);
+		cc = 0;
+	}
+	return cc;
+}
+
 #endif /* MLX5_CORE_EQ_H */
-- 
2.19.1
