From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 2/3] IB/mlx5: Manage indirection mkey upon DEVX flow for ODP
Date: Sun, 13 Jan 2019 16:01:17 +0200
Message-ID: <20190113140118.10204-3-leon@kernel.org>
References: <20190113140118.10204-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190113140118.10204-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Manage indirection mkey upon DEVX flow to support ODP.

To support a page fault event on the indirection mkey it needs to be
part of the device mkey radix tree.

Both the creation and the deletion flows for a DEVX object which is
indirection mkey were adapted to handle that.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 89 +++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/main.c    |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++
 include/linux/mlx5/driver.h          |  1 +
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index b7ff2138ac2a..bbf9a26d8fa6 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -17,12 +17,18 @@
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
 
+enum devx_obj_flags {
+	DEVX_OBJ_FLAGS_INDIRECT_MKEY = 1 << 0,
+};
+
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
 struct devx_obj {
 	struct mlx5_core_dev	*mdev;
 	u64			obj_id;
 	u32			dinlen; /* destroy inbox length */
 	u32			dinbox[MLX5_MAX_DESTROY_INBOX_SIZE_DW];
+	u32			flags;
+	struct mlx5_ib_devx_mr	devx_mr;
 };
 
 struct devx_umem {
@@ -1011,6 +1017,36 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
 	}
 }
 
+static int devx_handle_mkey_indirect(struct devx_obj *obj,
+				     struct mlx5_ib_dev *dev,
+				     void *in, void *out)
+{
+	struct mlx5_mkey_table *table = &dev->mdev->priv.mkey_table;
+	struct mlx5_ib_devx_mr *devx_mr = &obj->devx_mr;
+	unsigned long flags;
+	struct mlx5_core_mkey *mkey;
+	void *mkc;
+	u8 key;
+	int err;
+
+	mkey = &devx_mr->mmkey;
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	key = MLX5_GET(mkc, mkc, mkey_7_0);
+	mkey->key = mlx5_idx_to_mkey(
+			MLX5_GET(create_mkey_out, out, mkey_index)) | key;
+	mkey->type = MLX5_MKEY_INDIRECT_DEVX;
+	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
+	mkey->size = MLX5_GET64(mkc, mkc, len);
+	mkey->pd = MLX5_GET(mkc, mkc, pd);
+	devx_mr->ndescs = MLX5_GET(mkc, mkc, translations_octword_size);
+
+	write_lock_irqsave(&table->lock, flags);
+	err = radix_tree_insert(&table->tree, mlx5_base_mkey(mkey->key),
+				mkey);
+	write_unlock_irqrestore(&table->lock, flags);
+	return err;
+}
+
 static int devx_handle_mkey_create(struct mlx5_ib_dev *dev,
 				   struct devx_obj *obj,
 				   void *in, int in_len)
@@ -1030,13 +1066,45 @@ static int devx_handle_mkey_create(struct mlx5_ib_dev *dev,
 	access_mode |= MLX5_GET(mkc, mkc, access_mode_4_2) << 2;
 
 	if (access_mode == MLX5_MKC_ACCESS_MODE_KLMS ||
-		access_mode == MLX5_MKC_ACCESS_MODE_KSM)
+		access_mode == MLX5_MKC_ACCESS_MODE_KSM) {
+		if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
+			obj->flags |= DEVX_OBJ_FLAGS_INDIRECT_MKEY;
 		return 0;
+	}
 
 	MLX5_SET(create_mkey_in, in, mkey_umem_valid, 1);
 	return 0;
 }
 
+static void devx_free_indirect_mkey(struct rcu_head *rcu)
+{
+	kfree(container_of(rcu, struct devx_obj, devx_mr.rcu));
+}
+
+/* This function to delete from the radix tree needs to be called before
+ * destroying the underlying mkey. Otherwise a race might occur in case that
+ * other thread will get the same mkey before this one will be deleted,
+ * in that case it will fail via inserting to the tree its own data.
+ *
+ * Note:
+ * An error in the destroy is not expected unless there is some other indirect
+ * mkey which points to this one. In a kernel cleanup flow it will be just
+ * destroyed in the iterative destruction call. In a user flow, in case
+ * the application didn't close in the expected order it's its own problem,
+ * the mkey won't be part of the tree, in both cases the kernel is safe.
+ */
+static void devx_cleanup_mkey(struct devx_obj *obj)
+{
+	struct mlx5_mkey_table *table = &obj->mdev->priv.mkey_table;
+	struct mlx5_core_mkey *del_mkey;
+	unsigned long flags;
+
+	write_lock_irqsave(&table->lock, flags);
+	del_mkey = radix_tree_delete(&table->tree,
+				     mlx5_base_mkey(obj->devx_mr.mmkey.key));
+	write_unlock_irqrestore(&table->lock, flags);
+}
+
 static int devx_obj_cleanup(struct ib_uobject *uobject,
 			    enum rdma_remove_reason why)
 {
@@ -1044,10 +1112,21 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	struct devx_obj *obj = uobject->object;
 	int ret;
 
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
+		devx_cleanup_mkey(obj);
+
 	ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
 	if (ib_is_destroy_retryable(ret, why, uobject))
 		return ret;
 
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
+		struct mlx5_ib_dev *dev = to_mdev(uobject->context->device);
+
+		call_srcu(&dev->mr_srcu, &obj->devx_mr.rcu,
+			  devx_free_indirect_mkey);
+		return ret;
+	}
+
 	kfree(obj);
 	return ret;
 }
@@ -1108,6 +1187,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 				   &obj_id);
 	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
 
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
+		err = devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
+		if (err)
+			goto obj_destroy;
+	}
+
 	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd_out, cmd_out_len);
 	if (err)
 		goto obj_destroy;
@@ -1116,6 +1201,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	return 0;
 
 obj_destroy:
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
+		devx_cleanup_mkey(obj);
 	mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out, sizeof(out));
 obj_free:
 	kfree(obj);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4b1b56d54301..6e7c21dcaa73 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5724,6 +5724,7 @@ void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_cleanup_multiport_master(dev);
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		srcu_barrier(&dev->mr_srcu);
 		cleanup_srcu_struct(&dev->mr_srcu);
 		drain_workqueue(dev->advise_mr_wq);
 		destroy_workqueue(dev->advise_mr_wq);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b0a37ca2a714..819207190343 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -602,6 +602,12 @@ struct mlx5_ib_mw {
 	int			ndescs;
 };
 
+struct mlx5_ib_devx_mr {
+	struct mlx5_core_mkey	mmkey;
+	int			ndescs;
+	struct rcu_head		rcu;
+};
+
 struct mlx5_ib_umr_context {
 	struct ib_cqe		cqe;
 	enum ib_wc_status	status;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index b6f5839f129a..619d6fee96a1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -364,6 +364,7 @@ struct mlx5_core_sig_ctx {
 enum {
 	MLX5_MKEY_MR = 1,
 	MLX5_MKEY_MW,
+	MLX5_MKEY_INDIRECT_DEVX,
 };
 
 struct mlx5_core_mkey {
-- 
2.19.1
