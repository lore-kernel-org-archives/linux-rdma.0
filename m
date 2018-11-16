From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 10/12] net/mlx5: EQ, Generic EQ
Date: Fri, 16 Nov 2018 13:58:59 -0800
Message-ID: <20181116215901.5874-11-saeedm@mellanox.com>
References: <20181116215901.5874-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116215901.5874-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Add mlx5_eq_{create/destroy}_generic APIs and EQE access methods, for
mlx5 core consumers generic EQs.

This API will be used in downstream patch to move page fault (RDMA ODP)
EQ logic into mlx5_ib rdma driver, hence it will use a generic EQ.

Current mlx5 EQ allocation scheme:
On load mlx5 allocates 4 (for async) + #cores (for data completions)
MSIX vectors, mlx5 core will assign 3 MSIX vectors for internal async
EQs and will use all of the #cores MSIX vectors for completion EQs,
(One vector is going to be reserved for a generic EQ).

After this patch an external user (e.g mlx5_ib) of mlx5_core
can use this new API to create new generic EQs with the reserved msix
vector index for that eq.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 243 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  12 +-
 include/linux/mlx5/eq.h                       |  39 +++
 3 files changed, 221 insertions(+), 73 deletions(-)
 create mode 100644 include/linux/mlx5/eq.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 252c9f0569b1..ec1f5018546e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/eq.h>
 #include <linux/mlx5/cmd.h>
 #ifdef CONFIG_RFS_ACCEL
 #include <linux/cpu_rmap.h>
@@ -69,6 +70,7 @@ enum {
 struct mlx5_irq_info {
 	cpumask_var_t mask;
 	char name[MLX5_MAX_IRQ_NAME];
+	void *context; /* dev_id provided to request_irq */
 };
 
 struct mlx5_eq_table {
@@ -81,7 +83,6 @@ struct mlx5_eq_table {
 	struct mlx5_eq_pagefault pfault_eq;
 #endif
 	struct mutex            lock; /* sync async eqs creations */
-	u8			num_async_eqs;
 	int			num_comp_vectors;
 	struct mlx5_irq_info	*irq_info;
 #ifdef CONFIG_RFS_ACCEL
@@ -229,19 +230,19 @@ static void eqe_pf_action(struct work_struct *work)
 						     work);
 	struct mlx5_eq_pagefault *eq = pfault->eq;
 
-	mlx5_core_page_fault(eq->core.dev, pfault);
+	mlx5_core_page_fault(eq->core->dev, pfault);
 	mempool_free(pfault, eq->pool);
 }
 
 static void eq_pf_process(struct mlx5_eq_pagefault *eq)
 {
-	struct mlx5_core_dev *dev = eq->core.dev;
+	struct mlx5_core_dev *dev = eq->core->dev;
 	struct mlx5_eqe_page_fault *pf_eqe;
 	struct mlx5_pagefault *pfault;
 	struct mlx5_eqe *eqe;
 	int set_ci = 0;
 
-	while ((eqe = next_eqe_sw(&eq->core))) {
+	while ((eqe = next_eqe_sw(eq->core))) {
 		pfault = mempool_alloc(eq->pool, GFP_ATOMIC);
 		if (!pfault) {
 			schedule_work(&eq->work);
@@ -316,16 +317,16 @@ static void eq_pf_process(struct mlx5_eq_pagefault *eq)
 		INIT_WORK(&pfault->work, eqe_pf_action);
 		queue_work(eq->wq, &pfault->work);
 
-		++eq->core.cons_index;
+		++eq->core->cons_index;
 		++set_ci;
 
 		if (unlikely(set_ci >= MLX5_NUM_SPARE_EQE)) {
-			eq_update_ci(&eq->core, 0);
+			eq_update_ci(eq->core, 0);
 			set_ci = 0;
 		}
 	}
 
-	eq_update_ci(&eq->core, 1);
+	eq_update_ci(eq->core, 1);
 }
 
 static irqreturn_t mlx5_eq_pf_int(int irq, void *eq_ptr)
@@ -368,6 +369,7 @@ static void eq_pf_action(struct work_struct *work)
 static int
 create_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
 {
+	struct mlx5_eq_param param = {};
 	int err;
 
 	spin_lock_init(&eq->lock);
@@ -386,11 +388,19 @@ create_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq)
 		goto err_mempool;
 	}
 
-	err = mlx5_create_async_eq(dev, &eq->core, MLX5_NUM_ASYNC_EQE,
-				   1 << MLX5_EVENT_TYPE_PAGE_FAULT,
-				   "mlx5_page_fault_eq", mlx5_eq_pf_int);
-	if (err)
+	param = (struct mlx5_eq_param) {
+		.index = MLX5_EQ_PFAULT_IDX,
+		.mask = 1 << MLX5_EVENT_TYPE_PAGE_FAULT,
+		.nent = MLX5_NUM_ASYNC_EQE,
+		.context = eq,
+		.handler = mlx5_eq_pf_int
+	};
+
+	eq->core = mlx5_eq_create_generic(dev, "mlx5_page_fault_eq", &param);
+	if (IS_ERR(eq->core)) {
+		err = PTR_ERR(eq->core);
 		goto err_wq;
+	}
 
 	return 0;
 err_wq:
@@ -404,7 +414,7 @@ static int destroy_pf_eq(struct mlx5_core_dev *dev, struct mlx5_eq_pagefault *eq
 {
 	int err;
 
-	err = mlx5_destroy_async_eq(dev, &eq->core);
+	err = mlx5_eq_destroy_generic(dev, eq->core);
 	cancel_work_sync(&eq->work);
 	destroy_workqueue(eq->wq);
 	mempool_destroy(eq->pool);
@@ -710,25 +720,29 @@ static void init_eq_buf(struct mlx5_eq *eq)
 }
 
 static int
-mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
-		   int nent, u64 mask, const char *name, irq_handler_t handler)
+create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, const char *name,
+	      struct mlx5_eq_param *param)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	struct mlx5_cq_table *cq_table = &eq->cq_table;
 	u32 out[MLX5_ST_SZ_DW(create_eq_out)] = {0};
 	struct mlx5_priv *priv = &dev->priv;
+	u8 vecidx = param->index;
 	__be64 *pas;
 	void *eqc;
 	int inlen;
 	u32 *in;
 	int err;
 
+	if (eq_table->irq_info[vecidx].context)
+		return -EEXIST;
+
 	/* Init CQ table */
 	memset(cq_table, 0, sizeof(*cq_table));
 	spin_lock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
 
-	eq->nent = roundup_pow_of_two(nent + MLX5_NUM_SPARE_EQE);
+	eq->nent = roundup_pow_of_two(param->nent + MLX5_NUM_SPARE_EQE);
 	eq->cons_index = 0;
 	err = mlx5_buf_alloc(dev, eq->nent * MLX5_EQE_SIZE, &eq->buf);
 	if (err)
@@ -749,7 +763,7 @@ mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	mlx5_fill_page_array(&eq->buf, pas);
 
 	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
-	MLX5_SET64(create_eq_in, in, event_bitmask, mask);
+	MLX5_SET64(create_eq_in, in, event_bitmask, param->mask);
 
 	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
 	MLX5_SET(eqc, eqc, log_eq_size, ilog2(eq->nent));
@@ -764,13 +778,15 @@ mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 
 	snprintf(eq_table->irq_info[vecidx].name, MLX5_MAX_IRQ_NAME, "%s@pci:%s",
 		 name, pci_name(dev->pdev));
+	eq_table->irq_info[vecidx].context = param->context;
 
+	eq->vecidx = vecidx;
 	eq->eqn = MLX5_GET(create_eq_out, out, eq_number);
 	eq->irqn = pci_irq_vector(dev->pdev, vecidx);
 	eq->dev = dev;
 	eq->doorbell = priv->uar->map + MLX5_EQ_DOORBEL_OFFSET;
-	err = request_irq(eq->irqn, handler, 0,
-			  eq_table->irq_info[vecidx].name, eq);
+	err = request_irq(eq->irqn, param->handler, 0,
+			  eq_table->irq_info[vecidx].name, param->context);
 	if (err)
 		goto err_eq;
 
@@ -799,12 +815,19 @@ mlx5_create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq, u8 vecidx,
 	return err;
 }
 
-static int mlx5_destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
+	struct mlx5_irq_info *irq_info;
 	int err;
 
+	irq_info = &eq_table->irq_info[eq->vecidx];
+
 	mlx5_debug_eq_remove(dev, eq);
-	free_irq(eq->irqn, eq);
+
+	free_irq(eq->irqn, irq_info->context);
+	irq_info->context = NULL;
+
 	err = mlx5_cmd_destroy_eq(dev, eq->eqn);
 	if (err)
 		mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
@@ -883,48 +906,38 @@ void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev)
 
 /* Async EQs */
 
-int mlx5_create_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
-			 int nent, u64 mask, const char *name, irq_handler_t handler)
+static int create_async_eq(struct mlx5_core_dev *dev, const char *name,
+			   struct mlx5_eq *eq, struct mlx5_eq_param *param)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
-	u8 vecdix;
 	int err;
 
 	mutex_lock(&eq_table->lock);
-	if (eq_table->num_async_eqs >= MLX5_EQ_MAX_ASYNC_EQS) {
+	if (param->index >= MLX5_EQ_MAX_ASYNC_EQS) {
 		err = -ENOSPC;
 		goto unlock;
 	}
 
-	vecdix = eq_table->num_async_eqs + 1;
-
-	err = mlx5_create_map_eq(dev, eq, vecdix, nent, mask, name, handler);
-	if (!err)
-		eq_table->num_async_eqs++;
-
+	err = create_map_eq(dev, eq, name, param);
 unlock:
 	mutex_unlock(&eq_table->lock);
 	return err;
 }
 
-int mlx5_destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+static int destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
 {
 	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
 	int err;
 
 	mutex_lock(&eq_table->lock);
-	err = mlx5_destroy_unmap_eq(dev, eq);
-	if (!err)
-		eq_table->num_async_eqs--;
+	err = destroy_unmap_eq(dev, eq);
 	mutex_unlock(&eq_table->lock);
 	return err;
 }
 
-static int create_async_eqs(struct mlx5_core_dev *dev)
+static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
 {
-	struct mlx5_eq_table *table = dev->priv.eq_table;
 	u64 async_event_mask = MLX5_ASYNC_EVENT_MASK;
-	int err;
 
 	if (MLX5_VPORT_MANAGER(dev))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_NIC_VPORT_CHANGE);
@@ -953,9 +966,23 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	if (MLX5_CAP_MCAM_REG(dev, tracer_registers))
 		async_event_mask |= (1ull << MLX5_EVENT_TYPE_DEVICE_TRACER);
 
-	err = mlx5_create_async_eq(dev, &table->cmd_eq, MLX5_NUM_CMD_EQE,
-				   1ull << MLX5_EVENT_TYPE_CMD, "mlx5_cmd_eq",
-				   mlx5_eq_async_int);
+	return async_event_mask;
+}
+
+static int create_async_eqs(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_table *table = dev->priv.eq_table;
+	struct mlx5_eq_param param = {};
+	int err;
+
+	param = (struct mlx5_eq_param) {
+		.index = MLX5_EQ_CMD_IDX,
+		.mask = 1ull << MLX5_EVENT_TYPE_CMD,
+		.nent = MLX5_NUM_CMD_EQE,
+		.context = &table->cmd_eq,
+		.handler = mlx5_eq_async_int,
+	};
+	err = create_async_eq(dev, "mlx5_cmd_eq", &table->cmd_eq, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
 		return err;
@@ -963,15 +990,27 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	mlx5_cmd_use_events(dev);
 
-	err = mlx5_create_async_eq(dev, &table->async_eq, MLX5_NUM_ASYNC_EQE,
-				   async_event_mask, "mlx5_async_eq", mlx5_eq_async_int);
+	param = (struct mlx5_eq_param) {
+		.index = MLX5_EQ_ASYNC_IDX,
+		.mask = gather_async_events_mask(dev),
+		.nent = MLX5_NUM_ASYNC_EQE,
+		.context = &table->async_eq,
+		.handler = mlx5_eq_async_int,
+	};
+	err = create_async_eq(dev, "mlx5_async_eq", &table->async_eq, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
 		goto err1;
 	}
 
-	err = mlx5_create_async_eq(dev, &table->pages_eq, /* TODO: sriov max_vf + */ 1,
-				   1 << MLX5_EVENT_TYPE_PAGE_REQUEST, "mlx5_pages_eq", mlx5_eq_async_int);
+	param = (struct mlx5_eq_param) {
+		.index = MLX5_EQ_PAGEREQ_IDX,
+		.mask =  1 << MLX5_EVENT_TYPE_PAGE_REQUEST,
+		.nent = /* TODO: sriov max_vf + */ 1,
+		.context = &table->pages_eq,
+		.handler = mlx5_eq_async_int,
+	};
+	err = create_async_eq(dev, "mlx5_pages_eq", &table->pages_eq, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create pages EQ %d\n", err);
 		goto err2;
@@ -989,17 +1028,17 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 
 	return err;
 err3:
-	mlx5_destroy_async_eq(dev, &table->pages_eq);
+	destroy_async_eq(dev, &table->pages_eq);
 #else
 	return err;
 #endif
 
 err2:
-	mlx5_destroy_async_eq(dev, &table->async_eq);
+	destroy_async_eq(dev, &table->async_eq);
 
 err1:
 	mlx5_cmd_use_polling(dev);
-	mlx5_destroy_async_eq(dev, &table->cmd_eq);
+	destroy_async_eq(dev, &table->cmd_eq);
 	return err;
 }
 
@@ -1017,18 +1056,18 @@ static void destroy_async_eqs(struct mlx5_core_dev *dev)
 	}
 #endif
 
-	err = mlx5_destroy_async_eq(dev, &table->pages_eq);
+	err = destroy_async_eq(dev, &table->pages_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy pages eq, err(%d)\n",
 			      err);
 
-	err = mlx5_destroy_async_eq(dev, &table->async_eq);
+	err = destroy_async_eq(dev, &table->async_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy async eq, err(%d)\n",
 			      err);
 	mlx5_cmd_use_polling(dev);
 
-	err = mlx5_destroy_async_eq(dev, &table->cmd_eq);
+	err = destroy_async_eq(dev, &table->cmd_eq);
 	if (err)
 		mlx5_core_err(dev, "failed to destroy command eq, err(%d)\n",
 			      err);
@@ -1049,6 +1088,77 @@ void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev)
 	synchronize_irq(dev->priv.eq_table->cmd_eq.irqn);
 }
 
+/* Generic EQ API for mlx5_core consumers
+ * Needed For RDMA ODP EQ for now
+ */
+struct mlx5_eq *
+mlx5_eq_create_generic(struct mlx5_core_dev *dev, const char *name,
+		       struct mlx5_eq_param *param)
+{
+	struct mlx5_eq *eq = kvzalloc(sizeof(*eq), GFP_KERNEL);
+	int err;
+
+	if (!eq)
+		return ERR_PTR(-ENOMEM);
+
+	err = create_async_eq(dev, name, eq, param);
+	if (err) {
+		kvfree(eq);
+		eq = ERR_PTR(err);
+	}
+
+	return eq;
+}
+EXPORT_SYMBOL(mlx5_eq_create_generic);
+
+int mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
+{
+	int err;
+
+	if (IS_ERR(eq))
+		return -EINVAL;
+
+	err = destroy_async_eq(dev, eq);
+	if (err)
+		goto out;
+
+	kvfree(eq);
+out:
+	return err;
+}
+EXPORT_SYMBOL(mlx5_eq_destroy_generic);
+
+struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc)
+{
+	u32 ci = eq->cons_index + cc;
+	struct mlx5_eqe *eqe;
+
+	eqe = get_eqe(eq, ci & (eq->nent - 1));
+	eqe = ((eqe->owner & 1) ^ !!(ci & eq->nent)) ? NULL : eqe;
+	/* Make sure we read EQ entry contents after we've
+	 * checked the ownership bit.
+	 */
+	if (eqe)
+		dma_rmb();
+
+	return eqe;
+}
+EXPORT_SYMBOL(mlx5_eq_get_eqe);
+
+void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm)
+{
+	__be32 __iomem *addr = eq->doorbell + (arm ? 0 : 2);
+	u32 val;
+
+	eq->cons_index += cc;
+	val = (eq->cons_index & 0xffffff) | (eq->eqn << 24);
+
+	__raw_writel((__force u32)cpu_to_be32(val), addr);
+	/* We still want ordering, just not swabbing, so add a barrier */
+	mb();
+}
+EXPORT_SYMBOL(mlx5_eq_update_ci);
+
 /* Completion EQs */
 
 static int set_comp_irq_affinity_hint(struct mlx5_core_dev *mdev, int i)
@@ -1127,7 +1237,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 #endif
 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
 		list_del(&eq->list);
-		if (mlx5_destroy_unmap_eq(dev, &eq->core))
+		if (destroy_unmap_eq(dev, &eq->core))
 			mlx5_core_warn(dev, "failed to destroy comp EQ 0x%x\n",
 				       eq->core.eqn);
 		tasklet_disable(&eq->tasklet_ctx.task);
@@ -1155,6 +1265,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 #endif
 	for (i = 0; i < ncomp_vec; i++) {
 		int vecidx = i + MLX5_EQ_VEC_COMP_BASE;
+		struct mlx5_eq_param param = {};
 
 		eq = kzalloc(sizeof(*eq), GFP_KERNEL);
 		if (!eq) {
@@ -1172,8 +1283,14 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		irq_cpu_rmap_add(table->rmap, pci_irq_vector(dev->pdev, vecidx));
 #endif
 		snprintf(name, MLX5_MAX_IRQ_NAME, "mlx5_comp%d", i);
-		err = mlx5_create_map_eq(dev, &eq->core, vecidx, nent, 0,
-					 name, mlx5_eq_comp_int);
+		param = (struct mlx5_eq_param) {
+			.index = vecidx,
+			.mask = 0,
+			.nent = nent,
+			.context = &eq->core,
+			.handler = mlx5_eq_comp_int
+		};
+		err = create_map_eq(dev, &eq->core, name, &param);
 		if (err) {
 			kfree(eq);
 			goto clean;
@@ -1257,7 +1374,7 @@ struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn)
 void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq_comp *eq;
+	int i, max_eqs;
 
 	clear_comp_irqs_affinity_hints(dev);
 
@@ -1267,16 +1384,16 @@ void mlx5_core_eq_free_irqs(struct mlx5_core_dev *dev)
 		table->rmap = NULL;
 	}
 #endif
-	list_for_each_entry(eq, &table->comp_eqs_list, list)
-		free_irq(eq->core.irqn, eq);
 
-	free_irq(table->pages_eq.irqn, &table->pages_eq);
-	free_irq(table->async_eq.irqn, &table->async_eq);
-	free_irq(table->cmd_eq.irqn, &table->cmd_eq);
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (MLX5_CAP_GEN(dev, pg))
-		free_irq(table->pfault_eq.core.irqn, &table->pfault_eq.core);
-#endif
+	mutex_lock(&table->lock); /* sync with create/destroy_async_eq */
+	max_eqs = table->num_comp_vectors + MLX5_EQ_VEC_COMP_BASE;
+	for (i = max_eqs - 1; i >= 0; i--) {
+		if (!table->irq_info[i].context)
+			continue;
+		free_irq(pci_irq_vector(dev->pdev, i), table->irq_info[i].context);
+		table->irq_info[i].context = NULL;
+	}
+	mutex_unlock(&table->lock);
 	pci_free_irq_vectors(dev->pdev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 706d58383dbd..db32057ad054 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -7,11 +7,6 @@
 
 #define MLX5_MAX_IRQ_NAME       (32)
 
-enum {
-	MLX5_EQ_MAX_ASYNC_EQS = 4, /* mlx5_core needs at least 3 */
-	MLX5_EQ_VEC_COMP_BASE = MLX5_EQ_MAX_ASYNC_EQS,
-};
-
 struct mlx5_eq_tasklet {
 	struct list_head      list;
 	struct list_head      process_list;
@@ -31,6 +26,7 @@ struct mlx5_eq {
 	u32                     cons_index;
 	struct mlx5_frag_buf    buf;
 	int                     size;
+	unsigned int            vecidx;
 	unsigned int            irqn;
 	u8                      eqn;
 	int                     nent;
@@ -44,7 +40,7 @@ struct mlx5_eq_comp {
 };
 
 struct mlx5_eq_pagefault {
-	struct mlx5_eq           core; /* Must be first */
+	struct mlx5_eq          *core;
 	struct work_struct       work;
 	spinlock_t               lock; /* Pagefaults spinlock */
 	struct workqueue_struct  *wq;
@@ -55,10 +51,6 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev);
 void mlx5_eq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_eq_table_create(struct mlx5_core_dev *dev);
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
-int mlx5_create_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
-			 int nent, u64 mask, const char *name,
-			 irq_handler_t handler);
-int mlx5_destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
 
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
new file mode 100644
index 000000000000..c733673ba5f6
--- /dev/null
+++ b/include/linux/mlx5/eq.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2018 Mellanox Technologies. */
+
+#ifndef MLX5_CORE_EQ_H
+#define MLX5_CORE_EQ_H
+
+#include <linux/mlx5/driver.h>
+
+enum {
+	MLX5_EQ_PAGEREQ_IDX        = 0,
+	MLX5_EQ_CMD_IDX            = 1,
+	MLX5_EQ_ASYNC_IDX          = 2,
+	/* reserved to be used by mlx5_core ulps (mlx5e/mlx5_ib) */
+	MLX5_EQ_PFAULT_IDX         = 3,
+	MLX5_EQ_MAX_ASYNC_EQS,
+	/* completion eqs vector indices start here */
+	MLX5_EQ_VEC_COMP_BASE = MLX5_EQ_MAX_ASYNC_EQS,
+};
+
+struct mlx5_eq;
+
+struct mlx5_eq_param {
+	u8             index;
+	int            nent;
+	u64            mask;
+	void          *context;
+	irq_handler_t  handler;
+};
+
+struct mlx5_eq *
+mlx5_eq_create_generic(struct mlx5_core_dev *dev, const char *name,
+		       struct mlx5_eq_param *param);
+int
+mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq);
+
+struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc);
+void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm);
+
+#endif /* MLX5_CORE_EQ_H */
-- 
2.19.1
