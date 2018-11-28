From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 09/11] RDMA/mlx5: Initialize SRQ tables on mlx5_ib
Date: Wed, 28 Nov 2018 20:53:41 +0200
Message-ID: <20181128185343.21669-10-leon@kernel.org>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Transfer initialization and cleanup from mlx5_priv struct of
mlx5_core_dev to be part of mlx5_ib_dev. This completes removal
of SRQ from mlx5_core.

Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           |  4 ++
 drivers/infiniband/hw/mlx5/main.c             |  7 ++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  5 +-
 drivers/infiniband/hw/mlx5/srq.c              |  1 -
 drivers/infiniband/hw/mlx5/srq.h              | 25 +++++++
 drivers/infiniband/hw/mlx5/srq_cmd.c          | 72 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 --
 drivers/net/ethernet/mellanox/mlx5/core/srq.c | 63 ----------------
 include/linux/mlx5/driver.h                   | 25 -------
 include/linux/mlx5/srq.h                      | 14 ----
 11 files changed, 101 insertions(+), 122 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/srq.c
 delete mode 100644 include/linux/mlx5/srq.h

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 584ff2ea7810..8a682d86d634 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -4,6 +4,7 @@
  */
 
 #include "ib_rep.h"
+#include "srq.h"
 
 static const struct mlx5_ib_profile rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_INIT,
@@ -21,6 +22,9 @@ static const struct mlx5_ib_profile rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
 		     mlx5_ib_stage_rep_roce_init,
 		     mlx5_ib_stage_rep_roce_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
+		     mlx5_init_srq_table,
+		     mlx5_cleanup_srq_table),
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_stage_dev_res_init,
 		     mlx5_ib_stage_dev_res_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b15f1a70d33b..24a0957ae630 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -60,6 +60,7 @@
 #include "mlx5_ib.h"
 #include "ib_rep.h"
 #include "cmd.h"
+#include "srq.h"
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/accel.h>
 #include <rdma/uverbs_std_types.h>
@@ -6289,6 +6290,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
 		     mlx5_ib_stage_roce_init,
 		     mlx5_ib_stage_roce_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
+		     mlx5_init_srq_table,
+		     mlx5_cleanup_srq_table),
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_stage_dev_res_init,
 		     mlx5_ib_stage_dev_res_cleanup),
@@ -6343,6 +6347,9 @@ static const struct mlx5_ib_profile nic_rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_ROCE,
 		     mlx5_ib_stage_rep_roce_init,
 		     mlx5_ib_stage_rep_roce_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_SRQ,
+		     mlx5_init_srq_table,
+		     mlx5_cleanup_srq_table),
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_stage_dev_res_init,
 		     mlx5_ib_stage_dev_res_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index fe34129bb780..4ed9f76b49de 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -41,7 +41,6 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/qp.h>
-#include <linux/mlx5/srq.h>
 #include <linux/mlx5/fs.h>
 #include <linux/types.h>
 #include <linux/mlx5/transobj.h>
@@ -50,6 +49,8 @@
 #include <rdma/uverbs_ioctl.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
 
+#include "srq.h"
+
 #define mlx5_ib_dbg(_dev, format, arg...)                                      \
 	dev_dbg(&(_dev)->ib_dev.dev, "%s:%d:(pid %d): " format, __func__,      \
 		__LINE__, current->pid, ##arg)
@@ -774,6 +775,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_CAPS,
 	MLX5_IB_STAGE_NON_DEFAULT_CB,
 	MLX5_IB_STAGE_ROCE,
+	MLX5_IB_STAGE_SRQ,
 	MLX5_IB_STAGE_DEVICE_RESOURCES,
 	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_ODP,
@@ -940,6 +942,7 @@ struct mlx5_ib_dev {
 	u64			sys_image_guid;
 	struct mlx5_memic	memic;
 	u16			devx_whitelist_uid;
+	struct mlx5_srq_table   srq_table;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 2b184c7f531a..91dcd3918d96 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -5,7 +5,6 @@
 
 #include <linux/module.h>
 #include <linux/mlx5/qp.h>
-#include <linux/mlx5/srq.h>
 #include <linux/slab.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index 1110aeaa775e..75eb5839ae95 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -37,6 +37,28 @@ struct mlx5_srq_attr {
 
 struct mlx5_ib_dev;
 
+struct mlx5_core_srq {
+	struct mlx5_core_rsc_common common; /* must be first */
+	u32 srqn;
+	int max;
+	size_t max_gs;
+	size_t max_avail_gather;
+	int wqe_shift;
+	void (*event)(struct mlx5_core_srq *srq, enum mlx5_event e);
+
+	atomic_t refcount;
+	struct completion free;
+	u16 uid;
+};
+
+struct mlx5_srq_table {
+	struct notifier_block nb;
+	/* protect radix tree
+	 */
+	spinlock_t lock;
+	struct radix_tree_root tree;
+};
+
 int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_srq_attr *in);
 int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
@@ -45,4 +67,7 @@ int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		     u16 lwm, int is_srq);
 struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn);
+
+int mlx5_init_srq_table(struct mlx5_ib_dev *dev);
+void mlx5_cleanup_srq_table(struct mlx5_ib_dev *dev);
 #endif /* MLX5_IB_SRQ_H */
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index fdb9443f49f0..6be89c6be40f 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -80,12 +80,9 @@ static void get_srqc(void *srqc, struct mlx5_srq_attr *in)
 
 struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_srq_table *table;
+	struct mlx5_srq_table *table = &dev->srq_table;
 	struct mlx5_core_srq *srq;
 
-	table = &mdev->priv.srq_table;
-
 	spin_lock(&table->lock);
 
 	srq = radix_tree_lookup(&table->tree, srqn);
@@ -576,12 +573,9 @@ static int destroy_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_srq_attr *in)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_srq_table *table;
+	struct mlx5_srq_table *table = &dev->srq_table;
 	int err;
 
-	table = &mdev->priv.srq_table;
-
 	switch (in->type) {
 	case IB_SRQT_XRC:
 		srq->common.res = MLX5_RES_XSRQ;
@@ -616,13 +610,10 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 {
-	struct mlx5_core_dev *mdev = dev->mdev;
-	struct mlx5_srq_table *table;
+	struct mlx5_srq_table *table = &dev->srq_table;
 	struct mlx5_core_srq *tmp;
 	int err;
 
-	table = &mdev->priv.srq_table;
-
 	spin_lock_irq(&table->lock);
 	tmp = radix_tree_delete(&table->tree, srq->srqn);
 	spin_unlock_irq(&table->lock);
@@ -669,3 +660,60 @@ int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		return arm_rmp_cmd(dev, srq, lwm);
 	}
 }
+
+static int srq_event_notifier(struct notifier_block *nb,
+			      unsigned long type, void *data)
+{
+	struct mlx5_srq_table *table;
+	struct mlx5_core_srq *srq;
+	struct mlx5_eqe *eqe;
+	u32 srqn;
+
+	if (type != MLX5_EVENT_TYPE_SRQ_CATAS_ERROR &&
+	    type != MLX5_EVENT_TYPE_SRQ_RQ_LIMIT)
+		return NOTIFY_DONE;
+
+	table = container_of(nb, struct mlx5_srq_table, nb);
+
+	eqe = data;
+	srqn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
+
+	spin_lock(&table->lock);
+
+	srq = radix_tree_lookup(&table->tree, srqn);
+	if (srq)
+		atomic_inc(&srq->refcount);
+
+	spin_unlock(&table->lock);
+
+	if (!srq)
+		return NOTIFY_OK;
+
+	srq->event(srq, eqe->type);
+
+	if (atomic_dec_and_test(&srq->refcount))
+		complete(&srq->free);
+
+	return NOTIFY_OK;
+}
+
+int mlx5_init_srq_table(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_srq_table *table = &dev->srq_table;
+
+	memset(table, 0, sizeof(*table));
+	spin_lock_init(&table->lock);
+	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+
+	table->nb.notifier_call = srq_event_notifier;
+	mlx5_notifier_register(dev->mdev, &table->nb);
+
+	return 0;
+}
+
+void mlx5_cleanup_srq_table(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_srq_table *table = &dev->srq_table;
+
+	mlx5_notifier_unregister(dev->mdev, &table->nb);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 26afe0779a0c..d499b3d00348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_MLX5_CORE) += mlx5_core.o
 # mlx5 core basic
 #
 mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
-		health.o mcg.o cq.o srq.o alloc.o qp.o port.o mr.o pd.o \
+		health.o mcg.o cq.o alloc.o qp.o port.o mr.o pd.o \
 		mad.o transobj.o vport.o sriov.o fs_cmd.o fs_core.o \
 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
 		diag/fs_tracepoint.o diag/fw_tracer.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 4bc27a073dc4..778995573812 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -43,7 +43,6 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
-#include <linux/mlx5/srq.h>
 #include <linux/debugfs.h>
 #include <linux/kmod.h>
 #include <linux/mlx5/mlx5_ifc.h>
@@ -749,8 +748,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 
 	mlx5_init_qp_table(dev);
 
-	mlx5_init_srq_table(dev);
-
 	mlx5_init_mkey_table(dev);
 
 	mlx5_init_reserved_gids(dev);
@@ -804,7 +801,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 err_tables_cleanup:
 	mlx5_vxlan_destroy(dev->vxlan);
 	mlx5_cleanup_mkey_table(dev);
-	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 err_events_cleanup:
@@ -828,7 +824,6 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_clock(dev);
 	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cleanup_mkey_table(dev);
-	mlx5_cleanup_srq_table(dev);
 	mlx5_cleanup_qp_table(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_events_cleanup(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
deleted file mode 100644
index 0e80ddbe2510..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ /dev/null
@@ -1,63 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/*
- * Copyright (c) 2013-2018, Mellanox Technologies inc.  All rights reserved.
- */
-
-#include <linux/kernel.h>
-#include <linux/mlx5/driver.h>
-#include <linux/mlx5/srq.h>
-
-static int srq_event_notifier(struct notifier_block *nb,
-			      unsigned long type, void *data)
-{
-	struct mlx5_srq_table *table;
-	struct mlx5_core_srq *srq;
-	struct mlx5_eqe *eqe;
-	u32 srqn;
-
-	if (type != MLX5_EVENT_TYPE_SRQ_CATAS_ERROR &&
-	    type != MLX5_EVENT_TYPE_SRQ_RQ_LIMIT)
-		return NOTIFY_DONE;
-
-	table = container_of(nb, struct mlx5_srq_table, nb);
-
-	eqe = data;
-	srqn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
-
-	spin_lock(&table->lock);
-
-	srq = radix_tree_lookup(&table->tree, srqn);
-	if (srq)
-		atomic_inc(&srq->refcount);
-
-	spin_unlock(&table->lock);
-
-	if (!srq)
-		return NOTIFY_OK;
-
-	srq->event(srq, eqe->type);
-
-	if (atomic_dec_and_test(&srq->refcount))
-		complete(&srq->free);
-
-	return NOTIFY_OK;
-}
-
-void mlx5_init_srq_table(struct mlx5_core_dev *dev)
-{
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
-
-	memset(table, 0, sizeof(*table));
-	spin_lock_init(&table->lock);
-	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
-
-	table->nb.notifier_call = srq_event_notifier;
-	mlx5_notifier_register(dev, &table->nb);
-}
-
-void mlx5_cleanup_srq_table(struct mlx5_core_dev *dev)
-{
-	struct mlx5_srq_table *table = &dev->priv.srq_table;
-
-	mlx5_notifier_unregister(dev, &table->nb);
-}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1096da4fb368..584d8a5df7eb 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -50,7 +50,6 @@
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
-#include <linux/mlx5/srq.h>
 #include <linux/mlx5/eq.h>
 #include <linux/timecounter.h>
 #include <linux/ptp_clock_kernel.h>
@@ -393,20 +392,6 @@ struct mlx5_core_rsc_common {
 	struct completion	free;
 };
 
-struct mlx5_core_srq {
-	struct mlx5_core_rsc_common	common; /* must be first */
-	u32		srqn;
-	int		max;
-	size_t		max_gs;
-	size_t		max_avail_gather;
-	int		wqe_shift;
-	void (*event)	(struct mlx5_core_srq *, enum mlx5_event);
-
-	atomic_t		refcount;
-	struct completion	free;
-	u16		uid;
-};
-
 struct mlx5_uars_page {
 	void __iomem	       *map;
 	bool			wc;
@@ -464,14 +449,6 @@ struct mlx5_qp_table {
 	struct radix_tree_root	tree;
 };
 
-struct mlx5_srq_table {
-	struct notifier_block   nb;
-	/* protect radix tree
-	 */
-	spinlock_t		lock;
-	struct radix_tree_root	tree;
-};
-
 struct mlx5_mkey_table {
 	/* protect radix tree
 	 */
@@ -547,8 +524,6 @@ struct mlx5_priv {
 
 	struct mlx5_core_health health;
 
-	struct mlx5_srq_table	srq_table;
-
 	/* start: qp staff */
 	struct mlx5_qp_table	qp_table;
 	struct dentry	       *qp_debugfs;
diff --git a/include/linux/mlx5/srq.h b/include/linux/mlx5/srq.h
deleted file mode 100644
index 9343306cd188..000000000000
--- a/include/linux/mlx5/srq.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/*
- * Copyright (c) 2013-2018, Mellanox Technologies. All rights reserved.
- */
-
-#ifndef MLX5_SRQ_H
-#define MLX5_SRQ_H
-
-struct mlx5_core_dev;
-
-void mlx5_init_srq_table(struct mlx5_core_dev *dev);
-void mlx5_cleanup_srq_table(struct mlx5_core_dev *dev);
-
-#endif /* MLX5_SRQ_H */
-- 
2.19.1
