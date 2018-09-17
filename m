From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 23/25] IB/mlx5: Manage device uid for DEVX white list commands
Date: Mon, 17 Sep 2018 14:04:16 +0300
Message-ID: <20180917110418.18937-24-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Manage device uid for DEVX white list commands.
The created device uid will be used on white list commands if the
user didn't supply its own uid.

This will enable the firmware to filter out non privileged functionality
as of the recognition of the uid.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 12 ++++++------
 drivers/infiniband/hw/mlx5/main.c    | 16 ++++++++++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 13 +++++--------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 562c7936bbad..97cac57dcb3d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -45,13 +45,14 @@ static struct mlx5_ib_ucontext *devx_ufile2uctx(struct ib_uverbs_file *file)
 	return to_mucontext(ib_uverbs_get_ucontext(file));
 }
 
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *context)
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {0};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
 	u64 general_obj_types;
 	void *hdr;
 	int err;
+	u16 uid;
 
 	hdr = MLX5_ADDR_OF(create_uctx_in, in, hdr);
 
@@ -70,19 +71,18 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *contex
 	if (err)
 		return err;
 
-	context->devx_uid = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
-	return 0;
+	uid = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+	return uid;
 }
 
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
-			  struct mlx5_ib_ucontext *context)
+void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
 {
 	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {0};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
 
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_UCTX);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, context->devx_uid);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, uid);
 
 	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ac2abfc866a6..8cc285c4da8e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1765,9 +1765,10 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 			goto out_uars;
 		}
 
-		err = mlx5_ib_devx_create(dev, context);
-		if (err)
+		err = mlx5_ib_devx_create(dev);
+		if (err < 0)
 			goto out_uars;
+		context->devx_uid = err;
 	}
 
 	err = mlx5_ib_alloc_transport_domain(dev, &context->tdn,
@@ -1872,7 +1873,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
 out_devx:
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
-		mlx5_ib_devx_destroy(dev, context);
+		mlx5_ib_devx_destroy(dev, context->devx_uid);
 
 out_uars:
 	deallocate_uars(dev, context);
@@ -1899,7 +1900,7 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	mlx5_ib_dealloc_transport_domain(dev, context->tdn, context->devx_uid);
 
 	if (context->devx_uid)
-		mlx5_ib_devx_destroy(dev, context);
+		mlx5_ib_devx_destroy(dev, context->devx_uid);
 
 	deallocate_uars(dev, context);
 	kfree(bfregi->sys_pages);
@@ -6287,6 +6288,8 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 			profile->stage[stage].cleanup(dev);
 	}
 
+	if (dev->devx_whitelist_uid)
+		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
 	ib_dealloc_device((struct ib_device *)dev);
 }
 
@@ -6295,6 +6298,7 @@ void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
 {
 	int err;
 	int i;
+	int uid;
 
 	printk_once(KERN_INFO "%s", mlx5_version);
 
@@ -6306,6 +6310,10 @@ void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
 		}
 	}
 
+	uid = mlx5_ib_devx_create(dev);
+	if (uid > 0)
+		dev->devx_whitelist_uid = uid;
+
 	dev->profile = profile;
 	dev->ib_active = true;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index f582bd05c180..6a0fbd0286ef 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -934,6 +934,7 @@ struct mlx5_ib_dev {
 	struct list_head	ib_dev_list;
 	u64			sys_image_guid;
 	struct mlx5_memic	memic;
+	u16			devx_whitelist_uid;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
@@ -1258,10 +1259,8 @@ void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
 				  u8 port_num);
 
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
-			struct mlx5_ib_ucontext *context);
-void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
-			  struct mlx5_ib_ucontext *context);
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev);
+void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid);
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
 struct mlx5_ib_flow_handler *mlx5_ib_raw_fs_rule_add(
 	struct mlx5_ib_dev *dev, struct mlx5_ib_flow_matcher *fs_matcher,
@@ -1272,10 +1271,8 @@ int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
 void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction);
 #else
 static inline int
-mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
-		    struct mlx5_ib_ucontext *context) { return -EOPNOTSUPP; };
-static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
-					struct mlx5_ib_ucontext *context) {}
+mlx5_ib_devx_create(struct mlx5_ib_dev *dev) { return -EOPNOTSUPP; };
+static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid) {}
 static inline const struct uverbs_object_tree_def *
 mlx5_ib_get_devx_tree(void) { return NULL; }
 static inline bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
-- 
2.14.4
