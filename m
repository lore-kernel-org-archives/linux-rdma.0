From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 24/25] IB/mlx5: Enable DEVX white list commands
Date: Mon, 17 Sep 2018 14:04:17 +0300
Message-ID: <20180917110418.18937-25-leon@kernel.org>
References: <20180917110418.18937-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917110418.18937-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enable DEVX white list commands without the need for CAP_NET_RAW.

DEVX uid must exist from the ucontext or the device so that the firmware
will mask unprivileged capabilities.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 75 +++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 97cac57dcb3d..c11640047f26 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -61,9 +61,6 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev)
 	    !(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UMEM))
 		return -EINVAL;
 
-	if (!capable(CAP_NET_RAW))
-		return -EPERM;
-
 	MLX5_SET(general_obj_in_cmd_hdr, hdr, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, hdr, obj_type, MLX5_OBJ_TYPE_UCTX);
 
@@ -476,12 +473,49 @@ static bool devx_is_obj_query_cmd(const void *in)
 	}
 }
 
+static bool devx_is_whitelist_cmd(void *in)
+{
+	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
+
+	switch (opcode) {
+	case MLX5_CMD_OP_QUERY_HCA_CAP:
+	case MLX5_CMD_OP_QUERY_HCA_VPORT_CONTEXT:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int devx_get_uid(struct mlx5_ib_ucontext *c, void *cmd_in)
+{
+	if (devx_is_whitelist_cmd(cmd_in)) {
+		struct mlx5_ib_dev *dev;
+
+		if (c->devx_uid)
+			return c->devx_uid;
+
+		dev = to_mdev(c->ibucontext.device);
+		if (dev->devx_whitelist_uid)
+			return dev->devx_whitelist_uid;
+
+		return -EOPNOTSUPP;
+	}
+
+	if (!c->devx_uid)
+		return -EINVAL;
+
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
+	return c->devx_uid;
+}
 static bool devx_is_general_cmd(void *in)
 {
 	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
 
 	switch (opcode) {
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
+	case MLX5_CMD_OP_QUERY_HCA_VPORT_CONTEXT:
 	case MLX5_CMD_OP_QUERY_VPORT_STATE:
 	case MLX5_CMD_OP_QUERY_ADAPTER:
 	case MLX5_CMD_OP_QUERY_ISSI:
@@ -589,14 +623,16 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 					MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT);
 	void *cmd_out;
 	int err;
+	int uid;
 
 	c = devx_ufile2uctx(file);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 	dev = to_mdev(c->ibucontext.device);
 
-	if (!c->devx_uid)
-		return -EPERM;
+	uid = devx_get_uid(c, cmd_in);
+	if (uid < 0)
+		return uid;
 
 	/* Only white list of some general HCA commands are allowed for this method. */
 	if (!devx_is_general_cmd(cmd_in))
@@ -606,7 +642,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(
 	if (IS_ERR(cmd_out))
 		return PTR_ERR(cmd_out);
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, c->devx_uid);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	err = mlx5_cmd_exec(dev->mdev, cmd_in,
 			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
 			    cmd_out, cmd_out_len);
@@ -816,9 +852,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
 	struct devx_obj *obj;
 	int err;
+	int uid;
 
-	if (!c->devx_uid)
-		return -EPERM;
+	uid = devx_get_uid(c, cmd_in);
+	if (uid < 0)
+		return uid;
 
 	if (!devx_is_obj_create_cmd(cmd_in))
 		return -EINVAL;
@@ -831,7 +869,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	if (!obj)
 		return -ENOMEM;
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, c->devx_uid);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
 	err = mlx5_cmd_exec(dev->mdev, cmd_in,
@@ -868,9 +906,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	struct devx_obj *obj = uobj->object;
 	void *cmd_out;
 	int err;
+	int uid;
 
-	if (!c->devx_uid)
-		return -EPERM;
+	uid = devx_get_uid(c, cmd_in);
+	if (uid < 0)
+		return uid;
 
 	if (!devx_is_obj_modify_cmd(cmd_in))
 		return -EINVAL;
@@ -882,7 +922,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_MODIFY)(
 	if (IS_ERR(cmd_out))
 		return PTR_ERR(cmd_out);
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, c->devx_uid);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	devx_set_umem_valid(cmd_in);
 
 	err = mlx5_cmd_exec(obj->mdev, cmd_in,
@@ -907,9 +947,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	struct devx_obj *obj = uobj->object;
 	void *cmd_out;
 	int err;
+	int uid;
 
-	if (!c->devx_uid)
-		return -EPERM;
+	uid = devx_get_uid(c, cmd_in);
+	if (uid < 0)
+		return uid;
 
 	if (!devx_is_obj_query_cmd(cmd_in))
 		return -EINVAL;
@@ -921,7 +963,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_QUERY)(
 	if (IS_ERR(cmd_out))
 		return PTR_ERR(cmd_out);
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, c->devx_uid);
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, uid);
 	err = mlx5_cmd_exec(obj->mdev, cmd_in,
 			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OBJ_QUERY_CMD_IN),
 			    cmd_out, cmd_out_len);
@@ -1020,6 +1062,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	int err;
 
 	if (!c->devx_uid)
+		return -EINVAL;
+
+	if (!capable(CAP_NET_RAW))
 		return -EPERM;
 
 	obj = kzalloc(sizeof(struct devx_umem), GFP_KERNEL);
-- 
2.14.4
