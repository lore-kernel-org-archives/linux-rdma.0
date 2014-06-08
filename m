From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] mlx5: Fix possible race between mr tree insert/delete
Date: Sun,  8 Jun 2014 10:00:59 +0300
Message-ID: <1402210859-2715-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In mlx5_core_destroy_mkey we must first remove the mr from
the radix tree and then destroy it, Otherwise we might
hit a race in case the key was reallocated and we attempted
to insert it to the radix tree.

Also handle radix tree insert/delete failures.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <elic-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 4cc9276..dd26b03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -90,6 +90,11 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 	write_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree, mlx5_base_mkey(mr->key), mr);
 	write_unlock_irq(&table->lock);
+	if (err) {
+		mlx5_core_warn(dev, "failed radix tree insert of mr 0x%x, %d\n",
+			       mlx5_base_mkey(mr->key), err);
+		mlx5_core_destroy_mkey(dev, mr);
+	}
 
 	return err;
 }
@@ -100,12 +105,22 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr)
 	struct mlx5_mr_table *table = &dev->priv.mr_table;
 	struct mlx5_destroy_mkey_mbox_in in;
 	struct mlx5_destroy_mkey_mbox_out out;
+	struct mlx5_core_mr *deleted_mr;
 	unsigned long flags;
 	int err;
 
 	memset(&in, 0, sizeof(in));
 	memset(&out, 0, sizeof(out));
 
+	write_lock_irqsave(&table->lock, flags);
+	deleted_mr = radix_tree_delete(&table->tree, mlx5_base_mkey(mr->key));
+	write_unlock_irqrestore(&table->lock, flags);
+	if (!deleted_mr) {
+		mlx5_core_warn(dev, "failed radix tree delete of mr 0x%x\n",
+			       mlx5_base_mkey(mr->key));
+		return -ENOENT;
+	}
+
 	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_DESTROY_MKEY);
 	in.mkey = cpu_to_be32(mlx5_mkey_to_idx(mr->key));
 	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
@@ -115,10 +130,6 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr)
 	if (out.hdr.status)
 		return mlx5_cmd_status_to_err(&out.hdr);
 
-	write_lock_irqsave(&table->lock, flags);
-	radix_tree_delete(&table->tree, mlx5_base_mkey(mr->key));
-	write_unlock_irqrestore(&table->lock, flags);
-
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_destroy_mkey);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
