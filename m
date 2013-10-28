From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC v1 07/10] IB/mlx5: Keep mlx5 MRs in a radix tree under device
Date: Mon, 28 Oct 2013 16:26:13 +0200
Message-ID: <1382970376-13776-8-git-send-email-sagig@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382970376-13776-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This will be useful when processing signature errors
on a specific key. The mlx5 driver will lookup the
matching mlx5 memory region structure and mark it as
dirty (contains signature errors).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c   |   20 ++++++++++++++++++++
 include/linux/mlx5/driver.h                    |   12 ++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index b47739b..5b7b3c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -428,6 +428,7 @@ int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev)
 	mlx5_init_cq_table(dev);
 	mlx5_init_qp_table(dev);
 	mlx5_init_srq_table(dev);
+	mlx5_init_mr_table(dev);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 2ade604..f72e0b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -36,9 +36,18 @@
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
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 			  struct mlx5_create_mkey_mbox_in *in, int inlen)
 {
+	struct mlx5_mr_table *table = &dev->priv.mr_table;
 	struct mlx5_create_mkey_mbox_out out;
 	int err;
 	u8 key;
@@ -63,14 +72,21 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 	mr->key = mlx5_idx_to_mkey(be32_to_cpu(out.mkey) & 0xffffff) | key;
 	mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n", be32_to_cpu(out.mkey), key, mr->key);
 
+	/* connect to MR tree */
+	write_lock_irq(&table->lock);
+	err = radix_tree_insert(&table->tree, mr->key & 0xffffff00, mr);
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
@@ -85,6 +101,10 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr)
 	if (out.hdr.status)
 		return mlx5_cmd_status_to_err(&out.hdr);
 
+	write_lock_irqsave(&table->lock, flags);
+	radix_tree_delete(&table->tree, mr->key & 0xffffff00);
+	write_unlock_irqrestore(&table->lock, flags);
+
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_destroy_mkey);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7c33487..5fe0690 100644
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
@@ -516,6 +523,10 @@ struct mlx5_priv {
 	struct mlx5_cq_table	cq_table;
 	/* end: cq staff */
 
+	/* start: mr staff */
+	struct mlx5_mr_table	mr_table;
+	/* end: mr staff */
+
 	/* start: alloc staff */
 	struct mutex            pgdir_mutex;
 	struct list_head        pgdir_list;
@@ -691,6 +702,7 @@ int mlx5_core_query_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_query_srq_mbox_out *out);
 int mlx5_core_arm_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 		      u16 lwm, int is_srq);
+void mlx5_init_mr_table(struct mlx5_core_dev *dev);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 			  struct mlx5_create_mkey_mbox_in *in, int inlen);
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
