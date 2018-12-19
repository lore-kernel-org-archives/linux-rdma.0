From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] IB/mlx5: Prevent allocating UMEM and UCTX as some general object
Date: Wed, 19 Dec 2018 16:28:15 +0200
Message-ID: <20181219142815.21480-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Achiad Shochat <achiad@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

The driver needs to prevent a user space application to create a
UMEM and UCTX via the general object command.

The UMEM must go through the kernel UMEM_REG method to prevent the user
from setting physical addresses by himself.  The UCTX is some internal
kernel object and shouldn't be exposed.

As of not being any more part of the general object the caps bits were
moved to be some log_xxx indication in the general HCA caps, 0 means not
supported.

The firmware code was adapted as well to match the above.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Achiad Shochat <achiad@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 34 ++++++++---------
 drivers/infiniband/hw/mlx5/main.c |  3 +-
 include/linux/mlx5/mlx5_ifc.h     | 62 +++++++++++++++++++++----------
 3 files changed, 58 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 5271469aad10..dcc7c974173f 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -51,26 +51,21 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user)
 {
 	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {0};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
-	u64 general_obj_types;
-	void *hdr, *uctx;
+	void *uctx;
 	int err;
 	u16 uid;
 	u32 cap = 0;
 
-	hdr = MLX5_ADDR_OF(create_uctx_in, in, hdr);
-	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
-
-	general_obj_types = MLX5_CAP_GEN_64(dev->mdev, general_obj_types);
-	if (!(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UCTX) ||
-	    !(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UMEM))
+	/* 0 means not supported */
+	if (!MLX5_CAP_GEN(dev->mdev, log_max_uctx))
 		return -EINVAL;
 
+	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
 	if (is_user && capable(CAP_NET_RAW) &&
 	    (MLX5_CAP_GEN(dev->mdev, uctx_cap) & MLX5_UCTX_CAP_RAW_TX))
 		cap |= MLX5_UCTX_CAP_RAW_TX;
 
-	MLX5_SET(general_obj_in_cmd_hdr, hdr, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
-	MLX5_SET(general_obj_in_cmd_hdr, hdr, obj_type, MLX5_OBJ_TYPE_UCTX);
+	MLX5_SET(create_uctx_in, in, opcode, MLX5_CMD_OP_CREATE_UCTX);
 	MLX5_SET(uctx, uctx, cap, cap);
 
 	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
@@ -83,12 +78,11 @@ int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, bool is_user)
 
 void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev, u16 uid)
 {
-	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_uctx_in)] = {0};
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
 
-	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_UCTX);
-	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, uid);
+	MLX5_SET(destroy_uctx_in, in, opcode, MLX5_CMD_OP_DESTROY_UCTX);
+	MLX5_SET(destroy_uctx_in, in, uid, uid);
 
 	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
 }
@@ -861,6 +855,10 @@ static void devx_obj_build_destroy_cmd(void *in, void *out, void *din,
 		MLX5_SET(general_obj_in_cmd_hdr, din, obj_type, obj_type);
 		break;
 
+	case MLX5_CMD_OP_CREATE_UMEM:
+		MLX5_SET(general_obj_in_cmd_hdr, din, opcode,
+			 MLX5_CMD_OP_DESTROY_UMEM);
+		break;
 	case MLX5_CMD_OP_CREATE_MKEY:
 		MLX5_SET(general_obj_in_cmd_hdr, din, opcode, MLX5_CMD_OP_DESTROY_MKEY);
 		break;
@@ -1234,8 +1232,7 @@ static void devx_umem_reg_cmd_build(struct mlx5_ib_dev *dev,
 	umem = MLX5_ADDR_OF(create_umem_in, cmd->in, umem);
 	mtt = (__be64 *)MLX5_ADDR_OF(umem, umem, mtt);
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd->in, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
-	MLX5_SET(general_obj_in_cmd_hdr, cmd->in, obj_type, MLX5_OBJ_TYPE_UMEM);
+	MLX5_SET(create_umem_in, cmd->in, opcode, MLX5_CMD_OP_CREATE_UMEM);
 	MLX5_SET64(umem, umem, num_of_mtt, obj->ncont);
 	MLX5_SET(umem, umem, log_page_size, obj->page_shift -
 					    MLX5_ADAPTER_PAGE_SHIFT);
@@ -1274,7 +1271,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 
 	devx_umem_reg_cmd_build(dev, obj, &cmd);
 
-	MLX5_SET(general_obj_in_cmd_hdr, cmd.in, uid, c->devx_uid);
+	MLX5_SET(create_umem_in, cmd.in, uid, c->devx_uid);
 	err = mlx5_cmd_exec(dev->mdev, cmd.in, cmd.inlen, cmd.out,
 			    sizeof(cmd.out));
 	if (err)
@@ -1445,8 +1442,7 @@ static bool devx_is_supported(struct ib_device *device)
 {
 	struct mlx5_ib_dev *dev = to_mdev(device);
 
-	return !dev->rep && MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
-				    MLX5_GENERAL_OBJ_TYPES_CAP_UCTX;
+	return !dev->rep && MLX5_CAP_GEN(dev->mdev, log_max_uctx);
 }
 
 const struct uapi_definition mlx5_ib_devx_defs[] = {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f918a15f1152..6584e638387a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5120,8 +5120,7 @@ static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
 	int i;
 	bool is_shared;
 
-	is_shared = MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
-				MLX5_GENERAL_OBJ_TYPES_CAP_UCTX;
+	is_shared = MLX5_CAP_GEN(dev->mdev, log_max_uctx) != 0;
 
 	for (i = 0; i < dev->num_ports; i++) {
 		err = __mlx5_ib_alloc_counters(dev, &dev->port[i].cnts);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0bca5a6387e9..5ae0b0b9914a 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -75,16 +75,6 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 };
 
-enum {
-	MLX5_GENERAL_OBJ_TYPES_CAP_UCTX = (1ULL << 4),
-	MLX5_GENERAL_OBJ_TYPES_CAP_UMEM = (1ULL << 5),
-};
-
-enum {
-	MLX5_OBJ_TYPE_UCTX = 0x0004,
-	MLX5_OBJ_TYPE_UMEM = 0x0005,
-};
-
 enum {
 	MLX5_SHARED_RESOURCE_UID = 0xffff,
 };
@@ -267,6 +257,10 @@ enum {
 	MLX5_CMD_OP_MODIFY_GENERAL_OBJECT         = 0xa01,
 	MLX5_CMD_OP_QUERY_GENERAL_OBJECT          = 0xa02,
 	MLX5_CMD_OP_DESTROY_GENERAL_OBJECT        = 0xa03,
+	MLX5_CMD_OP_CREATE_UCTX                   = 0xa04,
+	MLX5_CMD_OP_DESTROY_UCTX                  = 0xa06,
+	MLX5_CMD_OP_CREATE_UMEM                   = 0xa08,
+	MLX5_CMD_OP_DESTROY_UMEM                  = 0xa0a,
 	MLX5_CMD_OP_MAX
 };
 
@@ -1191,7 +1185,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_440[0x20];
 
-	u8         reserved_at_460[0x10];
+	u8         reserved_at_460[0x3];
+	u8         log_max_uctx[0x5];
+	u8         reserved_at_468[0x3];
+	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
 
 	u8         reserved_at_480[0x3];
@@ -9400,9 +9397,9 @@ struct mlx5_ifc_general_obj_out_cmd_hdr_bits {
 };
 
 struct mlx5_ifc_umem_bits {
-	u8         modify_field_select[0x40];
+	u8         reserved_at_0[0x80];
 
-	u8         reserved_at_40[0x5b];
+	u8         reserved_at_80[0x1b];
 	u8         log_page_size[0x5];
 
 	u8         page_offset[0x20];
@@ -9413,21 +9410,46 @@ struct mlx5_ifc_umem_bits {
 };
 
 struct mlx5_ifc_uctx_bits {
-	u8         modify_field_select[0x40];
-
 	u8         cap[0x20];
 
-	u8         reserved_at_60[0x1a0];
+	u8         reserved_at_20[0x160];
 };
 
 struct mlx5_ifc_create_umem_in_bits {
-	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
-	struct mlx5_ifc_umem_bits                     umem;
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x40];
+
+	struct mlx5_ifc_umem_bits  umem;
 };
 
 struct mlx5_ifc_create_uctx_in_bits {
-	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
-	struct mlx5_ifc_uctx_bits                     uctx;
+	u8         opcode[0x10];
+	u8         reserved_at_10[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x40];
+
+	struct mlx5_ifc_uctx_bits  uctx;
+};
+
+struct mlx5_ifc_destroy_uctx_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_at_10[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_60[0x20];
 };
 
 struct mlx5_ifc_mtrc_string_db_param_bits {
-- 
2.19.1
