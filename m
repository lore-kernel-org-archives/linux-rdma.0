From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v3 07/10] IB/mlx5: Keep mlx5 MRs in a radix tree under device
Date: Thu,  7 Nov 2013 17:54:05 +0200
Message-ID: <1383839648-19000-8-git-send-email-sagig@mellanox.com>
References: <1383839648-19000-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383839648-19000-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-PEzghdH756F8UrSeD/g0lQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This will be useful when processing signature errors
on a specific key. The mlx5 driver will lookup the
matching mlx5 memory region structure and mark it as
dirty (contains signature errors).

issue: 333508
Change-Id: I04dbb746012b050d13161d134d2d05c8c333189a
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c   |   24 ++++++++++++++++++++++++
 include/linux/mlx5/driver.h                    |   18 ++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 40a9f5e..6e77c8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -446,6 +446,7 @@ int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev)
 	mlx5_init_cq_table(dev);
 	mlx5_init_qp_table(dev);
 	mlx5_init_srq_table(dev);
+	mlx5_init_mr_table(dev);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index bb746bb..4cc9276 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -36,11 +36,24 @@
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
+void mlx5_init_mr_table(struct mlx5_core_dev *dev)
+{
+	struct mlx5_mr_table *table = &dev->priv.mr_table;
+
+	rwlock_init(&table->lock);
+	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+}
+
+void mlx5_cleanup_mr_table(struct mlx5_core_dev *dev)
+{
+}
+
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 			  struct mlx5_create_mkey_mbox_in *in, int inlen,
 			  mlx5_cmd_cbk_t callback, void *context,
 			  struct mlx5_create_mkey_mbox_out *out)
 {
+	struct mlx5_mr_table *table = &dev->priv.mr_table;
 	struct mlx5_create_mkey_mbox_out lout;
 	int err;
 	u8 key;
@@ -73,14 +86,21 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 	mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n",
 		      be32_to_cpu(lout.mkey), key, mr->key);
 
+	/* connect to MR tree */
+	write_lock_irq(&table->lock);
+	err = radix_tree_insert(&table->tree, mlx5_base_mkey(mr->key), mr);
+	write_unlock_irq(&table->lock);
+
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_create_mkey);
 
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr)
 {
+	struct mlx5_mr_table *table = &dev->priv.mr_table;
 	struct mlx5_destroy_mkey_mbox_in in;
 	struct mlx5_destroy_mkey_mbox_out out;
+	unsigned long flags;
 	int err;
 
 	memset(&in, 0, sizeof(in));
@@ -95,6 +115,10 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr)
 	if (out.hdr.status)
 		return mlx5_cmd_status_to_err(&out.hdr);
 
+	write_lock_irqsave(&table->lock, flags);
+	radix_tree_delete(&table->tree, mlx5_base_mkey(mr->key));
+	write_unlock_irqrestore(&table->lock, flags);
+
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_destroy_mkey);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 58f5b95..1d97762 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -488,6 +488,13 @@ struct mlx5_srq_table {
 	struct radix_tree_root	tree;
 };
 
+struct mlx5_mr_table {
+	/* protect radix tree
+	 */
+	rwlock_t		lock;
+	struct radix_tree_root	tree;
+};
+
 struct mlx5_priv {
 	char			name[MLX5_MAX_NAME_LEN];
 	struct mlx5_eq_table	eq_table;
@@ -517,6 +524,10 @@ struct mlx5_priv {
 	struct mlx5_cq_table	cq_table;
 	/* end: cq staff */
 
+	/* start: mr staff */
+	struct mlx5_mr_table	mr_table;
+	/* end: mr staff */
+
 	/* start: alloc staff */
 	struct mutex            pgdir_mutex;
 	struct list_head        pgdir_list;
@@ -664,6 +675,11 @@ static inline void mlx5_vfree(const void *addr)
 		kfree(addr);
 }
 
+static inline u32 mlx5_base_mkey(const u32 key)
+{
+	return key & 0xffffff00u;
+}
+
 int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev);
 void mlx5_dev_cleanup(struct mlx5_core_dev *dev);
 int mlx5_cmd_init(struct mlx5_core_dev *dev);
@@ -698,6 +714,8 @@ int mlx5_core_query_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_query_srq_mbox_out *out);
 int mlx5_core_arm_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 		      u16 lwm, int is_srq);
+void mlx5_init_mr_table(struct mlx5_core_dev *dev);
+void mlx5_cleanup_mr_table(struct mlx5_core_dev *dev);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 			  struct mlx5_create_mkey_mbox_in *in, int inlen,
 			  mlx5_cmd_cbk_t callback, void *context,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
