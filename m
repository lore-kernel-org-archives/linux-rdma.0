From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 5/7] IB/mlx5: Enforce DEVX privilege by firmware
Date: Mon, 26 Nov 2018 08:28:36 +0200
Message-ID: <20181126062838.5907-6-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enforce DEVX privilege by firmware, this enables future device
functionality without the need to make driver changes unless a new
privilege type will be introduced.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 17 +++++++++--------
 drivers/infiniband/hw/mlx5/main.c    |  4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +++--
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index f80b78aab4da..80053324dd31 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -47,24 +47,31 @@ devx_ufile2uctx(const struct uverbs_attr_bundle *attrs)
 	return to_mucontext(ib_uverbs_get_ucontext(attrs));
 }
 
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev)
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {0};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
 	u64 general_obj_types;
-	void *hdr;
+	void *hdr, *uctx;
 	int err;
 	u16 uid;
+	u32 cap = 0;
 
 	hdr = MLX5_ADDR_OF(create_uctx_in, in, hdr);
+	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
 
 	general_obj_types = MLX5_CAP_GEN_64(dev->mdev, general_obj_types);
 	if (!(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UCTX) ||
 	    !(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UMEM))
 		return -EINVAL;
 
+	if (is_user && capable(CAP_NET_RAW) &&
+	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX))
+		cap |= MLX5_UCTX_CAP_RAW_TX;
+
 	MLX5_SET(general_obj_in_cmd_hdr, hdr, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, hdr, obj_type, MLX5_OBJ_TYPE_UCTX);
+	MLX5_SET(uctx, uctx, cap, cap);
 
 	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 	if (err)
@@ -672,9 +679,6 @@ static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
 	if (!c->devx_uid)
 		return -EINVAL;
 
-	if (!capable(CAP_NET_RAW))
-		return -EPERM;
-
 	return c->devx_uid;
 }
 static bool devx_is_general_cmd(void *in)
@@ -1239,9 +1243,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	if (!c->devx_uid)
 		return -EINVAL;
 
-	if (!capable(CAP_NET_RAW))
-		return -EPERM;
-
 	obj = kzalloc(sizeof(struct devx_umem), GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b3986bc961ca..2b09e6896e5a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1763,7 +1763,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 #endif
 
 	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
-		err = mlx5_ib_devx_create(dev);
+		err = mlx5_ib_devx_create(dev, true);
 		if (err < 0)
 			goto out_uars;
 		context->devx_uid = err;
@@ -6234,7 +6234,7 @@ static int mlx5_ib_stage_devx_init(struct mlx5_ib_dev *dev)
 {
 	int uid;
 
-	uid = mlx5_ib_devx_create(dev);
+	uid = mlx5_ib_devx_create(dev, false);
 	if (uid > 0)
 		dev->devx_whitelist_uid = uid;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 59e1664a107f..4d33965369cc 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1268,7 +1268,7 @@ void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
 				  u8 port_num);
 
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
-int mlx5_ib_devx_create(struct mlx5_ib_dev *dev);
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user);
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid);
 const struct uverbs_object_tree_def *mlx5_ib_get_devx_tree(void);
 extern const struct uapi_definition mlx5_ib_devx_defs[];
@@ -1283,7 +1283,8 @@ int mlx5_ib_get_flow_trees(const struct uverbs_object_tree_def **root);
 void mlx5_ib_destroy_flow_action_raw(struct mlx5_ib_flow_action *maction);
 #else
 static inline int
-mlx5_ib_devx_create(struct mlx5_ib_dev *dev) { return -EOPNOTSUPP; };
+mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
+			   bool is_user) { return -EOPNOTSUPP; }
 static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid) {}
 static inline bool mlx5_ib_devx_is_flow_dest(void *obj, int *dest_id,
 					     int *dest_type)
-- 
2.19.1
