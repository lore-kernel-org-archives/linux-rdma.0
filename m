From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 09/12] net/mlx5: EQ, Different EQ types
Date: Fri, 16 Nov 2018 13:58:58 -0800
Message-ID: <20181116215901.5874-10-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

In mlx5 we have three types of usages for EQs,
1. Asynchronous EQs, used internally by mlx5 core for
 a. FW command completions
 b. FW page requests
 c. one EQ for all other Asynchronous events

2. Completion EQs, used for CQ completion (we create one per core)

3. *Special type of EQ (page fault) used for RDMA on demand paging
(ODP).

*The 3rd type shouldn't be special at least in mlx5 core, it is yet
another async events EQ with specific use case, it will be removed in
the next two patches, and will completely move its logic to mlx5_ib,
as it is rdma specific.

In this patch we remove use case (eq type) specific fields from
struct mlx5_eq into a new eq type specific structures.

struct mlx5_eq_async;
truct mlx5_eq_comp;
struct mlx5_eq_pagefault;

Separate between their type specific flows.

In the future we will allow users to create there own generic EQs.
for now we will allow only one for ODP in next patches.

We will introduce event listeners registration API for those who
want to receive mlx5 async events.
After that mlx5 eq handling will be clean from feature/user specific
handling.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 376 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  53 ++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   4 -
 include/linux/mlx5/cq.h                       |   2 +-
 include/linux/mlx5/driver.h                   |  10 +-
 10 files changed, 270 insertions(+), 199 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 6e55d2f37c6d..713a17ee3751 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -93,10 +93,10 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	u32 dout[MLX5_ST_SZ_DW(destroy_cq_out)];
 	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
 	u32 din[MLX5_ST_SZ_DW(destroy_cq_in)];
-	struct mlx5_eq *eq;
+	struct mlx5_eq_comp *eq;
 	int err;
 
-	eq = mlx5_eqn2eq(dev, eqn);
+	eq = mlx5_eqn2comp_eq(dev, eqn);
 	if (IS_ERR(eq))
 		return PTR_ERR(eq);
 
@@ -120,7 +120,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	INIT_LIST_HEAD(&cq->tasklet_ctx.list);
 
 	/* Add to comp EQ CQ tree to recv comp events */
-	err = mlx5_eq_add_cq(eq, cq);
+	err = mlx5_eq_add_cq(&eq->core, cq);
 	if (err)
 		goto err_cmd;
 
@@ -140,7 +140,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	return 0;
 
 err_cq_add:
-	mlx5_eq_del_cq(eq, cq);
+	mlx5_eq_del_cq(&eq->core, cq);
 err_cmd:
 	memset(din, 0, sizeof(din));
 	memset(dout, 0, sizeof(dout));
@@ -162,7 +162,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	if (err)
 		return err;
 
-	err = mlx5_eq_del_cq(cq->eq, cq);
+	err = mlx5_eq_del_cq(&cq->eq->core, cq);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c23caade31bf..0d495a6b3949 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -320,7 +320,7 @@ static void mlx5e_enable_async_events(struct mlx5e_priv *priv)
 static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 {
 	clear_bit(MLX5E_STATE_ASYNC_EVENTS_ENABLED, &priv->state);
-	synchronize_irq(pci_irq_vector(priv->mdev->pdev, MLX5_EQ_VEC_ASYNC));
+	mlx5_eq_synchronize_async_irq(priv->mdev);
 }
 
 static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
@@ -4117,17 +4117,17 @@ static netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 static bool mlx5e_tx_timeout_eq_recover(struct net_device *dev,
 					struct mlx5e_txqsq *sq)
 {
-	struct mlx5_eq *eq = sq->cq.mcq.eq;
+	struct mlx5_eq_comp *eq = sq->cq.mcq.eq;
 	u32 eqe_count;
 
 	netdev_err(dev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
-		   eq->eqn, eq->cons_index, eq->irqn);
+		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
 
 	eqe_count = mlx5_eq_poll_irq_disabled(eq);
 	if (!eqe_count)
 		return false;
 
-	netdev_err(dev, "Recover %d eqes on EQ 0x%x\n", eqe_count, eq->eqn);
+	netdev_err(dev, "Recover %d eqes on EQ 0x%x\n", eqe_count, eq->core.eqn);
 	sq->channel->stats->eq_rearm++;
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 32ce20221c44..252c9f0569b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -72,13 +72,16 @@ struct mlx5_irq_info {
 };
 
 struct mlx5_eq_table {
-	struct list_head	comp_eqs_list;
-	struct mlx5_eq		pages_eq;
-	struct mlx5_eq		async_eq;
-	struct mlx5_eq		cmd_eq;
+	struct list_head        comp_eqs_list;
+	struct mlx5_eq          pages_eq;
+	struct mlx5_eq          async_eq;
+	struct mlx5_eq	        cmd_eq;
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct mlx5_eq		pfault_eq;
+	struct mlx5_eq_pagefault pfault_eq;
 #endif
+	struct mutex            lock; /* sync async eqs creations */
+	u8			num_async_eqs;
 	int			num_comp_vectors;
 	struct mlx5_irq_info	*irq_info;
 #ifdef CONFIG_RFS_ACCEL
@@ -224,24 +227,24 @@ static void eqe_pf_action(struct work_struct *work)
 	struct mlx5_pagefault *pfault = container_of(work,
 						     struct mlx5_pagefault,
 						     work);
-	struct mlx5_eq *eq = pfault->eq;
+	struct mlx5_eq_pagefault *eq = pfault->eq;
 
-	mlx5_core_page_fault(eq->dev, pfault);
-	mempool_free(pfault, eq->pf_ctx.pool);
+	mlx5_core_page_fault(eq->core.dev, pfault);
+	mempool_free(pfault, eq->pool);
 }
 
-static void eq_pf_process(struct mlx5_eq *eq)
+static void eq_pf_process(struct mlx5_eq_pagefault *eq)
 {
-	struct mlx5_core_dev *dev = eq->dev;
+	struct mlx5_core_dev *dev = eq->core.dev;
 	struct mlx5_eqe_page_fault *pf_eqe;
 	struct mlx5_pagefault *pfault;
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
 
-	while ((eqe = next_eqe_sw(eq))) {
-		pfault = mempool_alloc(eq->pf_ctx.pool, GFP_ATOMIC);
+	while ((eqe = next_eqe_sw(&eq->core))) {
+		pfault = mempool_alloc(eq->pool, GFP_ATOMIC);
 		if (!pfault) {
-			schedule_work(&eq->pf_ctx.work);
+			schedule_work(&eq->work);
 			break;
 		}
 
@@ -311,30 +314,30 @@ static void eq_pf_process(struct mlx5_eq *eq)
 
 		pfault->eq = eq;
 		INIT_WORK(&pfault->work, eqe_pf_action);
-		queue_work(eq->pf_ctx.wq, &pfault->work);
+		queue_work(eq->wq, &pfault->work);
 
-		++eq->cons_index;
+		++eq->core.cons_index;
 		++set_ci;
 
 		if (unlikely(set_ci >= MLX5_NUM_SPARE_EQE)) {
-			eq_update_ci(eq, 0);
+			eq_update_ci(&eq->core, 0);
 			set_ci = 0;
 		}
 	}
 
-	eq_update_ci(eq, 1);
+	eq_update_ci(&eq->core, 1);
 }
 
 static irqreturn_t mlx5_eq_pf_int(int irq, void *eq_ptr)
 {
-	struct mlx5_eq *eq = eq_ptr;
+	struct mlx5_eq_pagefault *eq = eq_ptr;
 	unsigned long flags;
 
-	if (spin_trylock_irqsave(&eq->pf_ctx.lock, flags)) {
+	if (spin_trylock_irqsave(&eq->lock, flags)) {
 		eq_pf_process(eq);
-		spin_unlock_irqrestore(&eq->pf_ctx.lock, flags);
+		spin_unlock_irqrestore(&eq->lock, flags);
 	} else {
-		schedule_work(&eq->pf_ctx.work);
+		schedule_work(&eq->work);
 	}
 
 	return IRQ_HANDLED;
@@ -352,35 +355,61 @@ static void mempool_refill(mempool_t *pool)
 
 static void eq_pf_action(struct work_struct *work)
 {
-	struct mlx5_eq *eq = container_of(work, struct mlx5_eq, pf_ctx.work);
+	struct mlx5_eq_pagefault *eq =
+		container_of(work, struct mlx5_eq_pagefault, work);
 
-	mempool_refill(eq->pf_ctx.pool);
+	mempool_refill(eq->pool);
 
-	spin_lock_irq(&eq->pf_ctx.lock);
+	spin_lock_irq(&eq->lock);
 	eq_pf_process(eq);
-	spin_unlock_irq(&eq->pf_ctx.lock);
+	spin_unlock_irq(&eq->lock);
 }
 
-static int init_pf_ctx(struct mlx5_eq_pagefault *pf_ctx, const char *name)
+static int
+create_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
 {
-	spin_lock_init(&pf_ctx->lock);
-	INIT_WORK(&pf_ctx->work, eq_pf_action);
+	int err;
 
-	pf_ctx->wq = alloc_workqueue(name,
-				     WQ_HIGHPRI | WQ_UNBOUND | WQ_MEM_RECLAIM,
-				     MLX5_NUM_CMD_EQE);
-	if (!pf_ctx->wq)
+	spin_lock_init(&eq->lock);
+	INIT_WORK(&eq->work, eq_pf_action);
+
+	eq->pool = mempool_create_kmalloc_pool(MLX5_NUM_PF_DRAIN,
+					       sizeof(struct mlx5_pagefault));
+	if (!eq->pool)
 		return -ENOMEM;
 
-	pf_ctx->pool = mempool_create_kmalloc_pool
-		(MLX5_NUM_PF_DRAIN, sizeof(struct mlx5_pagefault));
-	if (!pf_ctx->pool)
+	eq->wq = alloc_workqueue("mlx5_page_fault",
+				 WQ_HIGHPRI | WQ_UNBOUND | WQ_MEM_RECLAIM,
+				 MLX5_NUM_CMD_EQE);
+	if (!eq->wq) {
+		err = -ENOMEM;
+		goto err_mempool;
+	}
+
+	err = mlx5_create_async_eq(dev, &eq->core, MLX5_NUM_ASYNC_EQE,
+				   1 << MLX5_EVENT_TYPE_PAGE_FAULT,
+				   "mlx5_page_fault_eq", mlx5_eq_pf_int);
+	if (err)
 		goto err_wq;
 
 	return 0;
 err_wq:
-	destroy_workqueue(pf_ctx->wq);
-	return -ENOMEM;
+	destroy_workqueue(eq->wq);
+err_mempool:
+	mempool_destroy(eq->pool);
+	return err;
+}
+
+static int destroy_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
+{
+	int err;
+
+	err = mlx5_destroy_async_eq(dev, &eq->core);
+	cancel_work_sync(&eq->work);
+	destroy_workqueue(eq->wq);
+	mempool_destroy(eq->pool);
+
+	return err;
 }
 
 int mlx5_core_page_fault_resume(struct mlx5_core_dev *dev, u32 token,
@@ -444,37 +473,88 @@ static struct mlx5_core_cq *mlx5_eq_cq_get(struct mlx5_eq *eq, u32 cqn)
 	return cq;
 }
 
-static void mlx5_eq_cq_completion(struct mlx5_eq *eq, u32 cqn)
+static void mlx5_eq_cq_event(struct mlx5_eq *eq, u32 cqn, int event_type)
 {
 	struct mlx5_core_cq *cq = mlx5_eq_cq_get(eq, cqn);
 
 	if (unlikely(!cq)) {
-		mlx5_core_warn(eq->dev, "Completion event for bogus CQ 0x%x\n", cqn);
+		mlx5_core_warn(eq->dev, "Async event for bogus CQ 0x%x\n", cqn);
 		return;
 	}
 
-	++cq->arm_sn;
-
-	cq->comp(cq);
+	cq->event(cq, event_type);
 
 	mlx5_cq_put(cq);
 }
 
-static void mlx5_eq_cq_event(struct mlx5_eq *eq, u32 cqn, int event_type)
+static irqreturn_t mlx5_eq_comp_int(int irq, void *eq_ptr)
 {
-	struct mlx5_core_cq *cq = mlx5_eq_cq_get(eq, cqn);
+	struct mlx5_eq_comp *eq_comp = eq_ptr;
+	struct mlx5_eq *eq = eq_ptr;
+	struct mlx5_eqe *eqe;
+	int set_ci = 0;
+	u32 cqn = -1;
 
-	if (unlikely(!cq)) {
-		mlx5_core_warn(eq->dev, "Async event for bogus CQ 0x%x\n", cqn);
-		return;
+	while ((eqe = next_eqe_sw(eq))) {
+		struct mlx5_core_cq *cq;
+		/* Make sure we read EQ entry contents after we've
+		 * checked the ownership bit.
+		 */
+		dma_rmb();
+		/* Assume (eqe->type) is always MLX5_EVENT_TYPE_COMP */
+		cqn = be32_to_cpu(eqe->data.comp.cqn) & 0xffffff;
+
+		cq = mlx5_eq_cq_get(eq, cqn);
+		if (likely(cq)) {
+			++cq->arm_sn;
+			cq->comp(cq);
+			mlx5_cq_put(cq);
+		} else {
+			mlx5_core_warn(eq->dev, "Completion event for bogus CQ 0x%x\n", cqn);
+		}
+
+		++eq->cons_index;
+		++set_ci;
+
+		/* The HCA will think the queue has overflowed if we
+		 * don't tell it we've been processing events.  We
+		 * create our EQs with MLX5_NUM_SPARE_EQE extra
+		 * entries, so we must update our consumer index at
+		 * least that often.
+		 */
+		if (unlikely(set_ci >= MLX5_NUM_SPARE_EQE)) {
+			eq_update_ci(eq, 0);
+			set_ci = 0;
+		}
 	}
 
-	cq->event(cq, event_type);
+	eq_update_ci(eq, 1);
 
-	mlx5_cq_put(cq);
+	if (cqn != -1)
+		tasklet_schedule(&eq_comp->tasklet_ctx.task);
+
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
+/* Some architectures don't latch interrupts when they are disabled, so using
+ * mlx5_eq_poll_irq_disabled could end up losing interrupts while trying to
+ * avoid losing them.  It is not recommended to use it, unless this is the last
+ * resort.
+ */
+u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq)
+{
+	u32 count_eqe;
+
+	disable_irq(eq->core.irqn);
+	count_eqe = eq->core.cons_index;
+	mlx5_eq_comp_int(eq->core.irqn, eq);
+	count_eqe = eq->core.cons_index - count_eqe;
+	enable_irq(eq->core.irqn);
+
+	return count_eqe;
+}
+
+static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 {
 	struct mlx5_eq *eq = eq_ptr;
 	struct mlx5_core_dev *dev = eq->dev;
@@ -494,10 +574,6 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 		mlx5_core_dbg(eq->dev, "eqn %d, eqe type %s\n",
 			      eq->eqn, eqe_type_str(eqe->type));
 		switch (eqe->type) {
-		case MLX5_EVENT_TYPE_COMP:
-			cqn = be32_to_cpu(eqe->data.comp.cqn) & 0xffffff;
-			mlx5_eq_cq_completion(eq, cqn);
-			break;
 		case MLX5_EVENT_TYPE_DCT_DRAINED:
 			rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
 			rsn |= (MLX5_RES_DCT << MLX5_USER_INDEX_LEN);
@@ -619,30 +695,9 @@ static irqreturn_t mlx5_eq_int(int irq, void *eq_ptr)
 
 	eq_update_ci(eq, 1);
 
-	if (cqn != -1)
-		tasklet_schedule(&eq->tasklet_ctx.task);
-
 	return IRQ_HANDLED;
 }
 
-/* Some architectures don't latch interrupts when they are disabled, so using
- * mlx5_eq_poll_irq_disabled could end up losing interrupts while trying to
- * avoid losing them.  It is not recommended to use it, unless this is the last
- * resort.
- */
-u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq *eq)
-{
-	u32 count_eqe;
-
-	disable_irq(eq->irqn);
-	count_eqe = eq->cons_index;
-	mlx5_eq_int(eq->irqn, eq);
-	count_eqe = eq->cons_index - count_eqe;
-	enable_irq(eq->irqn);
-
-	return count_eqe;
-}
-
 static void init_eq_buf(struct mlx5_eq *eq)
 {
 	struct mlx5_eqe *eqe;
@@ -656,13 +711,12 @@ static void init_eq_buf(struct mlx5_eq *eq)
 
 static int
 mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
-		   int nent, u64 mask, const char *name, enum mlx5_eq_type type)
+		   int nent, u64 mask, const char *name, irq_handler_t handler)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	struct mlx5_cq_table *cq_table = &eq->cq_table;
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	struct mlx5_priv *priv = &dev->priv;
-	irq_handler_t handler;
 	__be64 *pas;
 	void *eqc;
 	int inlen;
@@ -674,20 +728,12 @@ mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	spin_lock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
 
-	eq->type = type;
 	eq->nent = roundup_pow_of_two(nent + MLX5_NUM_SPARE_EQE);
 	eq->cons_index = 0;
 	err = mlx5_buf_alloc(dev, eq->nent * MLX5_EQE_SIZE, &eq->buf);
 	if (err)
 		return err;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (type == MLX5_EQ_TYPE_PF)
-		handler = mlx5_eq_pf_int;
-	else
-#endif
-		handler = mlx5_eq_int;
-
 	init_eq_buf(eq);
 
 	inlen = MLX5_ST_SZ_BYTES(create_eq_in) +
@@ -732,21 +778,6 @@ mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	if (err)
 		goto err_irq;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (type == MLX5_EQ_TYPE_PF) {
-		err = init_pf_ctx(&eq->pf_ctx, name);
-		if (err)
-			goto err_irq;
-	} else
-#endif
-	{
-		INIT_LIST_HEAD(&eq->tasklet_ctx.list);
-		INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
-		spin_lock_init(&eq->tasklet_ctx.lock);
-		tasklet_init(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb,
-			     (unsigned long)&eq->tasklet_ctx);
-	}
-
 	/* EQs are created in ARMED state
 	 */
 	eq_update_ci(eq, 1);
@@ -780,15 +811,6 @@ static int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 			       eq->eqn);
 	synchronize_irq(eq->irqn);
 
-	if (eq->type == MLX5_EQ_TYPE_COMP) {
-		tasklet_disable(&eq->tasklet_ctx.task);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	} else if (eq->type == MLX5_EQ_TYPE_PF) {
-		cancel_work_sync(&eq->pf_ctx.work);
-		destroy_workqueue(eq->pf_ctx.wq);
-		mempool_destroy(eq->pf_ctx.pool);
-#endif
-	}
 	mlx5_buf_free(dev, &eq->buf);
 
 	return err;
@@ -841,8 +863,15 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 
 	err = mlx5_eq_debugfs_init(dev);
 	if (err)
-		kvfree(eq_table);
+		goto kvfree_eq_table;
 
+	mutex_init(&eq_table->lock);
+
+	return 0;
+
+kvfree_eq_table:
+	kvfree(eq_table);
+	dev->priv.eq_table = NULL;
 	return err;
 }
 
@@ -854,6 +883,43 @@ void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev)
 
 /* Async EQs */
 
+int mlx5_create_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
+			 int nent, u64 mask, const char *name, irq_handler_t handler)
+{
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	u8 vecdix;
+	int err;
+
+	mutex_lock(&eq_table->lock);
+	if (eq_table->num_async_eqs >= MLX5_EQ_MAX_ASYNC_EQS) {
+		err = -ENOSPC;
+		goto unlock;
+	}
+
+	vecdix = eq_table->num_async_eqs + 1;
+
+	err = mlx5_create_map_eq(dev, eq, vecdix, nent, mask, name, handler);
+	if (!err)
+		eq_table->num_async_eqs++;
+
+unlock:
+	mutex_unlock(&eq_table->lock);
+	return err;
+}
+
+int mlx5_destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+{
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	int err;
+
+	mutex_lock(&eq_table->lock);
+	err = mlx5_destroy_unmap_eq(dev, eq);
+	if (!err)
+		eq_table->num_async_eqs--;
+	mutex_unlock(&eq_table->lock);
+	return err;
+}
+
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -887,9 +953,9 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_MCAM_REG(dev, tracer_registers))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DEVICE_TRACER);
 
-	err = mlx5_create_map_eq(dev, &table->cmd_eq, MLX5_EQ_VEC_CMD,
-				 MLX5_NUM_CMD_EQE, 1ull << MLX5_EVENT_TYPE_CMD,
-				 "mlx5_cmd_eq", MLX5_EQ_TYPE_ASYNC);
+	err = mlx5_create_async_eq(dev, &table->cmd_eq, MLX5_NUM_CMD_EQE,
+				   1ull << MLX5_EVENT_TYPE_CMD, "mlx5_cmd_eq",
+				   mlx5_eq_async_int);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
 		return err;
@@ -897,19 +963,15 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	mlx5_cmd_use_events(dev);
 
-	err = mlx5_create_map_eq(dev, &table->async_eq, MLX5_EQ_VEC_ASYNC,
-				 MLX5_NUM_ASYNC_EQE, async_event_mask,
-				 "mlx5_async_eq", MLX5_EQ_TYPE_ASYNC);
+	err = mlx5_create_async_eq(dev, &table->async_eq, MLX5_NUM_ASYNC_EQE,
+				   async_event_mask, "mlx5_async_eq", mlx5_eq_async_int);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
 		goto err1;
 	}
 
-	err = mlx5_create_map_eq(dev, &table->pages_eq,
-				 MLX5_EQ_VEC_PAGES,
-				 /* TODO: sriov max_vf + */ 1,
-				 1 << MLX5_EVENT_TYPE_PAGE_REQUEST, "mlx5_pages_eq",
-				 MLX5_EQ_TYPE_ASYNC);
+	err = mlx5_create_async_eq(dev, &table->pages_eq, /* TODO: sriov max_vf + */ 1,
+				   1 << MLX5_EVENT_TYPE_PAGE_REQUEST, "mlx5_pages_eq", mlx5_eq_async_int);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create pages EQ %d\n", err);
 		goto err2;
@@ -917,12 +979,7 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(dev, pg)) {
-		err = mlx5_create_map_eq(dev, &table->pfault_eq,
-					 MLX5_EQ_VEC_PFAULT,
-					 MLX5_NUM_ASYNC_EQE,
-					 1 << MLX5_EVENT_TYPE_PAGE_FAULT,
-					 "mlx5_page_fault_eq",
-					 MLX5_EQ_TYPE_PF);
+		err = create_pf_eq(dev, &table->pfault_eq);
 		if (err) {
 			mlx5_core_warn(dev, "failed to create page fault EQ %d\n",
 				       err);
@@ -932,17 +989,17 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	return err;
 err3:
-	mlx5_destroy_unmap_eq(dev, &table->pages_eq);
+	mlx5_destroy_async_eq(dev, &table->pages_eq);
 #else
 	return err;
 #endif
 
 err2:
-	mlx5_destroy_unmap_eq(dev, &table->async_eq);
+	mlx5_destroy_async_eq(dev, &table->async_eq);
 
 err1:
 	mlx5_cmd_use_polling(dev);
-	mlx5_destroy_unmap_eq(dev, &table->cmd_eq);
+	mlx5_destroy_async_eq(dev, &table->cmd_eq);
 	return err;
 }
 
@@ -953,25 +1010,25 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(dev, pg)) {
-		err = mlx5_destroy_unmap_eq(dev, &table->pfault_eq);
+		err = destroy_pf_eq(dev, &table->pfault_eq);
 		if (err)
 			mlx5_core_err(dev, "failed to destroy page fault eq, err(%d)\n",
 				      err);
 	}
 #endif
 
-	err = mlx5_destroy_unmap_eq(dev, &table->pages_eq);
+	err = mlx5_destroy_async_eq(dev, &table->pages_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy pages eq, err(%d)\n",
 			      err);
 
-	err = mlx5_destroy_unmap_eq(dev, &table->async_eq);
+	err = mlx5_destroy_async_eq(dev, &table->async_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy async eq, err(%d)\n",
 			      err);
 	mlx5_cmd_use_polling(dev);
 
-	err = mlx5_destroy_unmap_eq(dev, &table->cmd_eq);
+	err = mlx5_destroy_async_eq(dev, &table->cmd_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy command eq, err(%d)\n",
 			      err);
@@ -982,6 +1039,16 @@ struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev)
 	return &dev->priv.eq_table->async_eq;
 }
 
+void mlx5_eq_synchronize_async_irq(struct mlx5_core_dev *dev)
+{
+	synchronize_irq(dev->priv.eq_table->async_eq.irqn);
+}
+
+void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev)
+{
+	synchronize_irq(dev->priv.eq_table->cmd_eq.irqn);
+}
+
 /* Completion EQs */
 
 static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
@@ -1048,7 +1115,7 @@ static void clear_comp_irqs_affinity_hints(struct mlx5_core_dev *mdev)
 static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq *eq, *n;
+	struct mlx5_eq_comp *eq, *n;
 
 	clear_comp_irqs_affinity_hints(dev);
 
@@ -1060,9 +1127,10 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 #endif
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		list_del(&eq->list);
-		if (mlx5_destroy_unmap_eq(dev, eq))
-			mlx5_core_warn(dev, "failed to destroy EQ 0x%x\n",
-				       eq->eqn);
+		if (mlx5_destroy_unmap_eq(dev, &eq->core))
+			mlx5_core_warn(dev, "failed to destroy comp EQ 0x%x\n",
+				       eq->core.eqn);
+		tasklet_disable(&eq->tasklet_ctx.task);
 		kfree(eq);
 	}
 }
@@ -1071,7 +1139,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
 	char name[MLX5_MAX_IRQ_NAME];
-	struct mlx5_eq *eq;
+	struct mlx5_eq_comp *eq;
 	int ncomp_vec;
 	int nent;
 	int err;
@@ -1094,17 +1162,23 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 			goto clean;
 		}
 
+		INIT_LIST_HEAD(&eq->tasklet_ctx.list);
+		INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
+		spin_lock_init(&eq->tasklet_ctx.lock);
+		tasklet_init(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb,
+			     (unsigned long)&eq->tasklet_ctx);
+
 #ifdef CONFIG_RFS_ACCEL
 		irq_cpu_rmap_add(table->rmap, pci_irq_vector(dev->pdev, vecidx));
 #endif
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
-		err = mlx5_create_map_eq(dev, eq, vecidx, nent, 0,
-					 name, MLX5_EQ_TYPE_COMP);
+		err = mlx5_create_map_eq(dev, &eq->core, vecidx, nent, 0,
+					 name, mlx5_eq_comp_int);
 		if (err) {
 			kfree(eq);
 			goto clean;
 		}
-		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->eqn);
+		mlx5_core_dbg(dev, "allocated completion EQN %d\n", eq->core.eqn);
 		/* add tail, to keep the list ordered, for mlx5_vector2eqn to work */
 		list_add_tail(&eq->list, &table->comp_eqs_list);
 	}
@@ -1126,14 +1200,14 @@ int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 		    unsigned int *irqn)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq *eq, *n;
+	struct mlx5_eq_comp *eq, *n;
 	int err = -ENOENT;
 	int i = 0;
 
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		if (i++ == vector) {
-			*eqn = eq->eqn;
-			*irqn = eq->irqn;
+			*eqn = eq->core.eqn;
+			*irqn = eq->core.irqn;
 			err = 0;
 			break;
 		}
@@ -1166,13 +1240,13 @@ struct cpu_rmap *mlx5_eq_table_get_rmap(struct mlx5_core_dev *dev)
 #endif
 }
 
-struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
+struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq *eq;
+	struct mlx5_eq_comp *eq;
 
 	list_for_each_entry(eq, &table->comp_eqs_list, list) {
-		if (eq->eqn == eqn)
+		if (eq->core.eqn == eqn)
 			return eq;
 	}
 
@@ -1183,7 +1257,7 @@ struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn)
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq *eq;
+	struct mlx5_eq_comp *eq;
 
 	clear_comp_irqs_affinity_hints(dev);
 
@@ -1194,14 +1268,14 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 	}
 #endif
 	list_for_each_entry(eq, &table->comp_eqs_list, list)
-		free_irq(eq->irqn, eq);
+		free_irq(eq->core.irqn, eq);
 
 	free_irq(table->pages_eq.irqn, &table->pages_eq);
 	free_irq(table->async_eq.irqn, &table->async_eq);
 	free_irq(table->cmd_eq.irqn, &table->cmd_eq);
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(dev, pg))
-		free_irq(table->pfault_eq.irqn, &table->pfault_eq);
+		free_irq(table->pfault_eq.core.irqn, &table->pfault_eq.core);
 #endif
 	pci_free_irq_vectors(dev->pdev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 324606227b1a..2346b6ba3d54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1568,7 +1568,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, int vport_num)
 	/* Mark this vport as disabled to discard new events */
 	vport->enabled = false;
 
-	synchronize_irq(pci_irq_vector(esw->dev->pdev, MLX5_EQ_VEC_ASYNC));
+	mlx5_eq_synchronize_async_irq(esw->dev);
 	/* Wait for current already scheduled events to complete */
 	flush_workqueue(esw->work_queue);
 	/* Disable events from this vport */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b5be6f0b9ed5..066883003aea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -85,7 +85,7 @@ static void trigger_cmd_completions(struct mlx5_core_dev *dev)
 	u64 vector;
 
 	/* wait for pending handlers to complete */
-	synchronize_irq(pci_irq_vector(dev->pdev, MLX5_EQ_VEC_CMD));
+	mlx5_eq_synchronize_cmd_irq(dev);
 	spin_lock_irqsave(&dev->cmd.alloc_lock, flags);
 	vector = ~dev->cmd.bitmask & ((1ul << (1 << dev->cmd.log_sz)) - 1);
 	if (!vector)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 48ee37797b3f..706d58383dbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -8,11 +8,8 @@
 #define MLX5_MAX_IRQ_NAME       (32)
 
 enum {
-	MLX5_EQ_VEC_PAGES	 = 0,
-	MLX5_EQ_VEC_CMD		 = 1,
-	MLX5_EQ_VEC_ASYNC	 = 2,
-	MLX5_EQ_VEC_PFAULT	 = 3,
-	MLX5_EQ_VEC_COMP_BASE,
+	MLX5_EQ_MAX_ASYNC_EQS = 4, /* mlx5_core needs at least 3 */
+	MLX5_EQ_VEC_COMP_BASE = MLX5_EQ_MAX_ASYNC_EQS,
 };
 
 struct mlx5_eq_tasklet {
@@ -22,13 +19,6 @@ struct mlx5_eq_tasklet {
 	spinlock_t            lock; /* lock completion tasklet list */
 };
 
-struct mlx5_eq_pagefault {
-	struct work_struct       work;
-	spinlock_t               lock; /* Pagefaults spinlock */
-	struct workqueue_struct  *wq;
-	mempool_t                *pool;
-};
-
 struct mlx5_cq_table {
 	spinlock_t              lock;	/* protect radix tree */
 	struct radix_tree_root  tree;
@@ -44,29 +34,48 @@ struct mlx5_eq {
 	unsigned int            irqn;
 	u8                      eqn;
 	int                     nent;
-	struct list_head        list;
 	struct mlx5_rsc_debug   *dbg;
-	enum mlx5_eq_type       type;
-	union {
-		struct mlx5_eq_tasklet   tasklet_ctx;
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-		struct mlx5_eq_pagefault pf_ctx;
-#endif
-	};
+};
+
+struct mlx5_eq_comp {
+	struct mlx5_eq          core; /* Must be first */
+	struct mlx5_eq_tasklet  tasklet_ctx;
+	struct list_head        list;
+};
+
+struct mlx5_eq_pagefault {
+	struct mlx5_eq           core; /* Must be first */
+	struct work_struct       work;
+	spinlock_t               lock; /* Pagefaults spinlock */
+	struct workqueue_struct  *wq;
+	mempool_t                *pool;
 };
 
 int mlx5_eq_table_init(struct mlx5_core_dev *dev);
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_eq_table_create(struct mlx5_core_dev *dev);
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
+int mlx5_create_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
+			 int nent, u64 mask, const char *name,
+			 irq_handler_t handler);
+int mlx5_destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
+
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-struct mlx5_eq *mlx5_eqn2eq(struct mlx5_core_dev *dev, int eqn);
+struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn);
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
-u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq *eq);
 void mlx5_cq_tasklet_cb(unsigned long data);
 struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
 
+u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq);
+void mlx5_eq_synchronize_async_irq(struct mlx5_core_dev *dev);
+void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev);
+
+int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
+void mlx5_debug_eq_remove(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
+int mlx5_eq_debugfs_init(struct mlx5_core_dev *dev);
+void mlx5_eq_debugfs_cleanup(struct mlx5_core_dev *dev);
+
 /* This function should only be called after mlx5_cmd_force_teardown_hca */
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5d11ef92c8b6..3de83fe65f2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -53,8 +53,8 @@
 #endif
 #include <net/devlink.h>
 #include "mlx5_core.h"
-#include "fs_core.h"
 #include "lib/eq.h"
+#include "fs_core.h"
 #include "lib/mpfs.h"
 #include "eswitch.h"
 #include "lib/mlx5.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 4d39adcfb0eb..4728b027cb9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -125,10 +125,6 @@ int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev);
 u64 mlx5_read_internal_timer(struct mlx5_core_dev *dev);
 
 void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
-int mlx5_debug_eq_add(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
-void mlx5_debug_eq_remove(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
-int mlx5_eq_debugfs_init(struct mlx5_core_dev *dev);
-void mlx5_eq_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_cq_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev);
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 31a750570c38..28b757a64029 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -60,7 +60,7 @@ struct mlx5_core_cq {
 	} tasklet_ctx;
 	int			reset_notify_added;
 	struct list_head	reset_notify;
-	struct mlx5_eq		*eq;
+	struct mlx5_eq_comp	*eq;
 	u16 uid;
 };
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4d6246cb6c19..fe9b552aa649 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -210,14 +210,6 @@ enum mlx5_port_status {
 	MLX5_PORT_DOWN      = 2,
 };
 
-enum mlx5_eq_type {
-	MLX5_EQ_TYPE_COMP,
-	MLX5_EQ_TYPE_ASYNC,
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	MLX5_EQ_TYPE_PF,
-#endif
-};
-
 struct mlx5_bfreg_info {
 	u32		       *sys_pages;
 	int			num_low_latency_bfregs;
@@ -692,7 +684,7 @@ struct mlx5_pagefault {
 		} rdma;
 	};
 
-	struct mlx5_eq	       *eq;
+	struct mlx5_eq_pagefault *eq;
 	struct work_struct	work;
 };
 
-- 
2.19.1
