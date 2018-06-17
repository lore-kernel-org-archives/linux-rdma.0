From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 14/20] IB/mlx5: Add support for DEVX general command
Date: Sun, 17 Jun 2018 13:00:00 +0300
Message-ID: <20180617100006.30663-15-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add support to run general firmware command via the DEVX interface.

A command that works on some object (e.g. CQ, WQ, etc.) will be added
in next patches while maintaining the required object lock.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c        | 87 ++++++++++++++++++++++++++++++++
 include/uapi/rdma/mlx5_user_ioctl_cmds.h | 13 +++++
 2 files changed, 100 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 775448910ad1..9fca6541a175 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -13,6 +13,14 @@
 #include <linux/mlx5/fs.h>
 #include "mlx5_ib.h"
 
+#define UVERBS_MODULE_NAME mlx5_ib
+#include <rdma/uverbs_named_ioctl.h>
+
+static struct mlx5_ib_ucontext *devx_ufile2uctx(struct ib_uverbs_file *file)
+{
+	return to_mucontext(ib_uverbs_get_ucontext(file));
+}
+
 int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *context)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {0};
@@ -56,3 +64,82 @@ void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
 
 	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }
+
+static bool devx_is_general_cmd(void *in)
+{
+	u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
+
+	switch (opcode) {
+	case MLX5_CMD_OP_QUERY_HCA_CAP:
+	case MLX5_CMD_OP_QUERY_VPORT_STATE:
+	case MLX5_CMD_OP_QUERY_ADAPTER:
+	case MLX5_CMD_OP_QUERY_ISSI:
+	case MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT:
+	case MLX5_CMD_OP_QUERY_ROCE_ADDRESS:
+	case MLX5_CMD_OP_QUERY_VNIC_ENV:
+	case MLX5_CMD_OP_QUERY_VPORT_COUNTER:
+	case MLX5_CMD_OP_GET_DROPPED_PACKET_LOG:
+	case MLX5_CMD_OP_NOP:
+	case MLX5_CMD_OP_QUERY_CONG_STATUS:
+	case MLX5_CMD_OP_QUERY_CONG_PARAMS:
+	case MLX5_CMD_OP_QUERY_CONG_STATISTICS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OTHER)(struct ib_device *ib_dev,
+				  struct ib_uverbs_file *file,
+				  struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_ucontext *c = devx_ufile2uctx(file);
+	struct mlx5_ib_dev *dev = to_mdev(ib_dev);
+	void *cmd_in = uverbs_attr_get_alloced_ptr(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN);
+	int cmd_out_len = uverbs_attr_get_len(attrs,
+					MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT);
+	void *cmd_out;
+	int err;
+
+	if (!c->devx_uid)
+		return -EPERM;
+
+	/* Only white list of some general HCA commands are allowed for this method. */
+	if (!devx_is_general_cmd(cmd_in))
+		return -EINVAL;
+
+	cmd_out = kvzalloc(cmd_out_len, GFP_KERNEL);
+	if (!cmd_out)
+		return -ENOMEM;
+
+	MLX5_SET(general_obj_in_cmd_hdr, cmd_in, uid, c->devx_uid);
+	err = mlx5_cmd_exec(dev->mdev, cmd_in,
+			    uverbs_attr_get_len(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_IN),
+			    cmd_out, cmd_out_len);
+	if (err)
+		goto other_cmd_free;
+
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT, cmd_out, cmd_out_len);
+
+other_cmd_free:
+	kvfree(cmd_out);
+	return err;
+}
+
+static DECLARE_UVERBS_NAMED_METHOD(MLX5_IB_METHOD_DEVX_OTHER,
+	&UVERBS_ATTR_PTR_IN_SZ(MLX5_IB_ATTR_DEVX_OTHER_CMD_IN,
+			       UVERBS_ATTR_MIN_SIZE(MLX5_ST_SZ_BYTES(general_obj_in_cmd_hdr)),
+			       UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY |
+					UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO |
+					UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY)),
+	&UVERBS_ATTR_PTR_OUT_SZ(MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT,
+				UVERBS_ATTR_MIN_SIZE(MLX5_ST_SZ_BYTES(general_obj_out_cmd_hdr)),
+				UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY |
+					 UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO))
+);
+
+static DECLARE_UVERBS_GLOBAL_METHODS(MLX5_IB_OBJECT_DEVX,
+	&UVERBS_METHOD(MLX5_IB_METHOD_DEVX_OTHER));
+
+static DECLARE_UVERBS_OBJECT_TREE(devx_objects,
+	&UVERBS_OBJECT(MLX5_IB_OBJECT_DEVX));
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index f7d685ef2d1f..0b456fa91bb4 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -45,4 +45,17 @@ enum mlx5_ib_alloc_dm_attrs {
 	MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
 };
 
+enum mlx5_ib_devx_methods {
+	MLX5_IB_METHOD_DEVX_OTHER  = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum  mlx5_ib_devx_other_attrs {
+	MLX5_IB_ATTR_DEVX_OTHER_CMD_IN = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_DEVX_OTHER_CMD_OUT,
+};
+
+enum mlx5_ib_devx_objects {
+	MLX5_IB_OBJECT_DEVX = (1U << UVERBS_ID_NS_SHIFT),
+};
+
 #endif
-- 
2.14.4
