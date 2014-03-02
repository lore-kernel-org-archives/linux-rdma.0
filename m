From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 17/20] IB/mlx5: Page faults handling infrastructure
Date: Sun,  2 Mar 2014 12:49:35 +0200
Message-ID: <1393757378-16412-18-git-send-email-haggaie@mellanox.com>
References: <1393757378-16412-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393757378-16412-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

* Refactor MR registration and cleanup, and fix reg_pages accounting.
* Create a work queue to handle page fault events in a kthread context.
* Register a fault handler to get events from the core for each QP.

The registered fault handler is empty in this patch, and only a later patch
implements it.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  25 +++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  66 +++++++++++++++-
 drivers/infiniband/hw/mlx5/mr.c      |  45 +++++++----
 drivers/infiniband/hw/mlx5/odp.c     | 145 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c      |  22 ++++++
 include/linux/mlx5/driver.h          |   2 +-
 6 files changed, 286 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f8015ac..535ccac 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -934,7 +934,7 @@ static ssize_t show_reg_pages(struct device *device,
 	struct mlx5_ib_dev *dev =
 		container_of(device, struct mlx5_ib_dev, ib_dev.dev);
 
-	return sprintf(buf, "%d\n", dev->mdev.priv.reg_pages);
+	return sprintf(buf, "%d\n", atomic_read(&dev->mdev.priv.reg_pages));
 }
 
 static ssize_t show_hca(struct device *device, struct device_attribute *attr,
@@ -1468,7 +1468,6 @@ static int init_one(struct pci_dev *pdev,
 		goto err_eqs;
 
 	mutex_init(&dev->cap_mask_mutex);
-	spin_lock_init(&dev->mr_lock);
 
 	err = create_dev_resources(&dev->devr);
 	if (err)
@@ -1489,6 +1488,10 @@ static int init_one(struct pci_dev *pdev,
 			goto err_umrc;
 	}
 
+	err = mlx5_ib_odp_init_one(dev);
+	if (err)
+		goto err_umrc;
+
 	dev->ib_active = true;
 
 	return 0;
@@ -1518,6 +1521,7 @@ static void remove_one(struct pci_dev *pdev)
 {
 	struct mlx5_ib_dev *dev = mlx5_pci2ibdev(pdev);
 
+	mlx5_ib_odp_remove_one(dev);
 	destroy_umrc_res(dev);
 	ib_unregister_device(&dev->ib_dev);
 	destroy_dev_resources(&dev->devr);
@@ -1542,12 +1546,27 @@ static struct pci_driver mlx5_ib_driver = {
 
 static int __init mlx5_ib_init(void)
 {
-	return pci_register_driver(&mlx5_ib_driver);
+	int err;
+
+	err = mlx5_ib_odp_init();
+	if (err)
+		return err;
+
+	err = pci_register_driver(&mlx5_ib_driver);
+	if (err)
+		goto clean_odp;
+
+	return err;
+
+clean_odp:
+	mlx5_ib_odp_cleanup();
+	return err;
 }
 
 static void __exit mlx5_ib_cleanup(void)
 {
 	pci_unregister_driver(&mlx5_ib_driver);
+	mlx5_ib_odp_cleanup();
 }
 
 module_init(mlx5_ib_init);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8d20408..f4240cd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -149,6 +149,29 @@ enum {
 	MLX5_QP_EMPTY
 };
 
+/*
+ * Connect-IB can trigger up to four concurrent pagefaults
+ * per-QP.
+ */
+enum mlx5_ib_pagefault_context {
+	MLX5_IB_PAGEFAULT_RESPONDER_READ,
+	MLX5_IB_PAGEFAULT_REQUESTOR_READ,
+	MLX5_IB_PAGEFAULT_RESPONDER_WRITE,
+	MLX5_IB_PAGEFAULT_REQUESTOR_WRITE,
+	MLX5_IB_PAGEFAULT_CONTEXTS
+};
+
+static inline enum mlx5_ib_pagefault_context
+	mlx5_ib_get_pagefault_context(struct mlx5_pagefault *pagefault)
+{
+	return pagefault->flags & (MLX5_PFAULT_REQUESTOR | MLX5_PFAULT_WRITE);
+}
+
+struct mlx5_ib_pfault {
+	struct work_struct	work;
+	struct mlx5_pagefault	mpfault;
+};
+
 struct mlx5_ib_qp {
 	struct ib_qp		ibqp;
 	struct mlx5_core_qp	mqp;
@@ -194,6 +217,21 @@ struct mlx5_ib_qp {
 
 	/* Store signature errors */
 	bool			signature_en;
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	/*
+	 * A flag that is true for QP's that are in a state that doesn't
+	 * allow page faults, and shouldn't schedule any more faults.
+	 */
+	int                     disable_page_faults;
+	/*
+	 * The disable_page_faults_lock protects a QP's disable_page_faults
+	 * field, allowing for a thread to atomically check whether the QP
+	 * allows page faults, and if so schedule a page fault.
+	 */
+	spinlock_t              disable_page_faults_lock;
+	struct mlx5_ib_pfault	pagefaults[MLX5_IB_PAGEFAULT_CONTEXTS];
+#endif
 };
 
 struct mlx5_ib_cq_buf {
@@ -394,13 +432,17 @@ struct mlx5_ib_dev {
 	struct umr_common		umrc;
 	/* sync used page count stats
 	 */
-	spinlock_t			mr_lock;
 	struct mlx5_ib_resources	devr;
 	struct mlx5_mr_cache		cache;
 	struct timer_list		delay_timer;
 	int				fill_delay;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_odp_caps	odp_caps;
+	/*
+	 * Sleepable RCU that prevents destruction of MRs while they are still
+	 * being used by a page fault handler.
+	 */
+	struct srcu_struct      mr_srcu;
 #endif
 };
 
@@ -587,8 +629,30 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+extern struct workqueue_struct *mlx5_ib_page_fault_wq;
+
 int mlx5_ib_query_odp_caps(struct ib_device *ibdev, struct ib_odp_caps *caps);
 int mlx5_ib_internal_query_odp_caps(struct mlx5_ib_dev *dev);
+void mlx5_ib_mr_pfault_handler(struct mlx5_ib_qp *qp,
+			       struct mlx5_ib_pfault *pfault);
+void mlx5_ib_odp_create_qp(struct mlx5_ib_qp *qp);
+int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev);
+void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev);
+int __init mlx5_ib_odp_init(void);
+void mlx5_ib_odp_cleanup(void);
+void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp);
+void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp);
+
+#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+
+static inline void mlx5_ib_odp_create_qp(struct mlx5_ib_qp *qp)		{}
+static inline int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev) { return 0; }
+static inline void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)	{}
+static inline int mlx5_ib_odp_init(void) { return 0; }
+static inline void mlx5_ib_odp_cleanup(void)				{}
+static inline void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp) {}
+static inline void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp)  {}
+
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 static inline void init_query_mad(struct ib_smp *mad)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 1071cb5..4462ca8 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -51,6 +51,8 @@ static __be64 mlx5_ib_update_mtt_emergency_buffer[
 	__aligned(MLX5_UMR_ALIGN);
 static DEFINE_MUTEX(mlx5_ib_update_mtt_emergency_buffer_mutex);
 
+static int clean_mr(struct mlx5_ib_mr *mr);
+
 static int order2idx(struct mlx5_ib_dev *dev, int order)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
@@ -1039,6 +1041,10 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			mlx5_ib_dbg(dev, "cache empty for order %d", order);
 			mr = NULL;
 		}
+	} else if (access_flags & IB_ACCESS_ON_DEMAND) {
+		err = -EINVAL;
+		pr_err("Got MR registration for ODP MR > 512MB, not supported for Connect-IB");
+		goto error;
 	}
 
 	if (!mr)
@@ -1054,9 +1060,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	mr->umem = umem;
 	mr->npages = npages;
-	spin_lock(&dev->mr_lock);
-	dev->mdev.priv.reg_pages += npages;
-	spin_unlock(&dev->mr_lock);
+	atomic_add(npages, &dev->mdev.priv.reg_pages);
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
 
@@ -1100,12 +1104,9 @@ error:
 	return err;
 }
 
-int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+static int clean_mr(struct mlx5_ib_mr *mr)
 {
-	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
-	struct mlx5_ib_mr *mr = to_mmr(ibmr);
-	struct ib_umem *umem = mr->umem;
-	int npages = mr->npages;
+	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 	int umred = mr->umred;
 	int err;
 
@@ -1125,16 +1126,32 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 		free_cached_mr(dev, mr);
 	}
 
+	if (!umred)
+		kfree(mr);
+
+	return 0;
+}
+
+int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	int npages = mr->npages;
+	struct ib_umem *umem = mr->umem;
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (umem)
+		/* Wait for all running page-fault handlers to finish. */
+		synchronize_srcu(&dev->mr_srcu);
+#endif
+
+	clean_mr(mr);
+
 	if (umem) {
 		ib_umem_release(umem);
-		spin_lock(&dev->mr_lock);
-		dev->mdev.priv.reg_pages -= npages;
-		spin_unlock(&dev->mr_lock);
+		atomic_sub(npages, &dev->mdev.priv.reg_pages);
 	}
 
-	if (!umred)
-		kfree(mr);
-
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 71ef604..f297f14 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -32,6 +32,8 @@
 
 #include "mlx5_ib.h"
 
+struct workqueue_struct *mlx5_ib_page_fault_wq;
+
 #define COPY_ODP_BIT_MLX_TO_IB(reg, ib_caps, field_name, bit_name) do {	\
 	if (be32_to_cpu(reg.field_name) & MLX5_ODP_SUPPORT_##bit_name)	\
 		ib_caps->field_name |= IB_ODP_SUPPORT_##bit_name;	\
@@ -67,3 +69,146 @@ int mlx5_ib_query_odp_caps(struct ib_device *ibdev, struct ib_odp_caps *caps)
 
 	return 0;
 }
+
+static struct mlx5_ib_mr *mlx5_ib_odp_find_mr_lkey(struct mlx5_ib_dev *dev,
+						   u32 key)
+{
+	u32 base_key = mlx5_base_mkey(key);
+	struct mlx5_core_mr *mmr = __mlx5_mr_lookup(&dev->mdev, base_key);
+
+	if (!mmr || mmr->key != key)
+		return NULL;
+
+	return container_of(mmr, struct mlx5_ib_mr, mmr);
+}
+
+static void mlx5_ib_page_fault_resume(struct mlx5_ib_qp *qp,
+				      struct mlx5_ib_pfault *pfault,
+				      int error) {
+	struct mlx5_ib_dev *dev = to_mdev(qp->ibqp.pd->device);
+	int ret = mlx5_core_page_fault_resume(&dev->mdev, qp->mqp.qpn,
+					       pfault->mpfault.flags,
+					       error);
+	if (ret)
+		pr_err("Failed to resolve the page fault on QP 0x%x\n",
+		       qp->mqp.qpn);
+}
+
+void mlx5_ib_mr_pfault_handler(struct mlx5_ib_qp *qp,
+			       struct mlx5_ib_pfault *pfault)
+{
+	u8 event_subtype = pfault->mpfault.event_subtype;
+
+	switch (event_subtype) {
+	default:
+		pr_warn("Invalid page fault event subtype: 0x%x\n",
+			event_subtype);
+		mlx5_ib_page_fault_resume(qp, pfault, 1);
+		break;
+	}
+}
+
+static void mlx5_ib_qp_pfault_action(struct work_struct *work)
+{
+	struct mlx5_ib_pfault *pfault = container_of(work,
+						     struct mlx5_ib_pfault,
+						     work);
+	enum mlx5_ib_pagefault_context context =
+		mlx5_ib_get_pagefault_context(&pfault->mpfault);
+	struct mlx5_ib_qp *qp = container_of(pfault, struct mlx5_ib_qp,
+					     pagefaults[context]);
+	mlx5_ib_mr_pfault_handler(qp, pfault);
+}
+
+void mlx5_ib_qp_disable_pagefaults(struct mlx5_ib_qp *qp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->disable_page_faults_lock, flags);
+	qp->disable_page_faults = 1;
+	spin_unlock_irqrestore(&qp->disable_page_faults_lock, flags);
+
+	/*
+	 * Note that at this point, we are guarenteed that no more
+	 * work queue elements will be posted to the work queue with
+	 * the QP we are closing.
+	 */
+	flush_workqueue(mlx5_ib_page_fault_wq);
+}
+
+void mlx5_ib_qp_enable_pagefaults(struct mlx5_ib_qp *qp)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&qp->disable_page_faults_lock, flags);
+	qp->disable_page_faults = 0;
+	spin_unlock_irqrestore(&qp->disable_page_faults_lock, flags);
+}
+
+static void mlx5_ib_pfault_handler(struct mlx5_core_qp *qp,
+				   struct mlx5_pagefault *pfault)
+{
+	/*
+	 * Note that we will only get one fault event per QP per context
+	 * (responder/initiator, read/write), until we resolve the page fault
+	 * with the mlx5_ib_page_fault_resume command. Since this function is
+	 * called from within the work element, there is no risk of missing
+	 * events.
+	 */
+	struct mlx5_ib_qp *mibqp = to_mibqp(qp);
+	enum mlx5_ib_pagefault_context context =
+		mlx5_ib_get_pagefault_context(pfault);
+	struct mlx5_ib_pfault *qp_pfault = &mibqp->pagefaults[context];
+
+	qp_pfault->mpfault = *pfault;
+
+	/* No need to stop interrupts here since we are in an interrupt */
+	spin_lock(&mibqp->disable_page_faults_lock);
+	if (!mibqp->disable_page_faults)
+		queue_work(mlx5_ib_page_fault_wq, &qp_pfault->work);
+	spin_unlock(&mibqp->disable_page_faults_lock);
+}
+
+void mlx5_ib_odp_create_qp(struct mlx5_ib_qp *qp)
+{
+	int i;
+
+	qp->disable_page_faults = 1;
+	spin_lock_init(&qp->disable_page_faults_lock);
+
+	qp->mqp.pfault_handler	= mlx5_ib_pfault_handler;
+
+	for (i = 0; i < MLX5_IB_PAGEFAULT_CONTEXTS; ++i)
+		INIT_WORK(&qp->pagefaults[i].work, mlx5_ib_qp_pfault_action);
+}
+
+int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev)
+{
+	int ret;
+
+	ret = init_srcu_struct(&ibdev->mr_srcu);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+void mlx5_ib_odp_remove_one(struct mlx5_ib_dev *ibdev)
+{
+	cleanup_srcu_struct(&ibdev->mr_srcu);
+}
+
+int __init mlx5_ib_odp_init(void)
+{
+	mlx5_ib_page_fault_wq =
+		create_singlethread_workqueue("mlx5_ib_page_faults");
+	if (!mlx5_ib_page_fault_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx5_ib_odp_cleanup(void)
+{
+	destroy_workqueue(mlx5_ib_page_fault_wq);
+}
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 535fea3..a14a43f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -870,6 +870,8 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	int inlen = sizeof(*in);
 	int err;
 
+	mlx5_ib_odp_create_qp(qp);
+
 	mutex_init(&qp->mutex);
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
@@ -1685,6 +1687,15 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (mlx5_st < 0)
 		goto out;
 
+	/* If moving to a reset or error state, we must disable page faults on
+	 * this QP and flush all current page faults. Otherwise a stale page
+	 * fault may attempt to work on this QP after it is reset and moved
+	 * again to RTS, and may cause the driver and the device to get out of
+	 * sync. */
+	if (cur_state != IB_QPS_RESET && cur_state != IB_QPS_ERR &&
+	    (new_state == IB_QPS_RESET || new_state == IB_QPS_ERR))
+		mlx5_ib_qp_disable_pagefaults(qp);
+
 	optpar = ib_mask_to_mlx5_opt(attr_mask);
 	optpar &= opt_mask[mlx5_cur][mlx5_new][mlx5_st];
 	in->optparam = cpu_to_be32(optpar);
@@ -1694,6 +1705,9 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (err)
 		goto out;
 
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
+		mlx5_ib_qp_enable_pagefaults(qp);
+
 	qp->state = new_state;
 
 	if (attr_mask & IB_QP_ACCESS_FLAGS)
@@ -3013,6 +3027,14 @@ int mlx5_ib_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr
 	int mlx5_state;
 	int err = 0;
 
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	/*
+	 * Wait for any outstanding page faults, in case the user frees memory
+	 * based upon this query's result.
+	 */
+	flush_workqueue(mlx5_ib_page_fault_wq);
+#endif
+
 	mutex_lock(&qp->mutex);
 	outb = kzalloc(sizeof(*outb), GFP_KERNEL);
 	if (!outb) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4f162e8..1d6266f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -526,7 +526,7 @@ struct mlx5_priv {
 	struct workqueue_struct *pg_wq;
 	struct rb_root		page_root;
 	int			fw_pages;
-	int			reg_pages;
+	atomic_t		reg_pages;
 	struct list_head	free_list;
 
 	struct mlx5_core_health health;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
