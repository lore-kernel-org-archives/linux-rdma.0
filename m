From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next v2 11/20] IB/mlx5: Introduce DEVX
Date: Sun, 17 Jun 2018 12:59:57 +0300
Message-ID: <20180617100006.30663-12-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce DEVX to enable direct device commands in downstream patches
from this series.

In that mode of work the firmware manages the isolation between
processes' resources and as such a DEVX user id is created and assigned
to the given user context upon allocation request.

A capability check is done to make sure that this feature is really
supported by the firmware prior to creating the DEVX user id.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/Makefile           |  1 +
 drivers/infiniband/hw/mlx5/devx.c             | 58 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/main.c             | 24 +++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          | 13 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 ++
 include/linux/mlx5/device.h                   |  3 ++
 include/linux/mlx5/mlx5_ifc.h                 | 15 ++++++-
 include/uapi/rdma/mlx5-abi.h                  |  3 ++
 8 files changed, 117 insertions(+), 4 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/devx.c

diff --git a/drivers/infiniband/hw/mlx5/Makefile b/drivers/infiniband/hw/mlx5/Makefile
index d42b922bede8..577e4c418bae 100644
--- a/drivers/infiniband/hw/mlx5/Makefile
+++ b/drivers/infiniband/hw/mlx5/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_MLX5_INFINIBAND)	+= mlx5_ib.o
 mlx5_ib-y :=	main.o cq.o doorbell.o qp.o mem.o srq.o mr.o ah.o mad.o gsi.o ib_virt.o cmd.o cong.o
 mlx5_ib-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += odp.o
 mlx5_ib-$(CONFIG_MLX5_ESWITCH) += ib_rep.o
+mlx5_ib-$(CONFIG_INFINIBAND_USER_ACCESS) += devx.o
diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
new file mode 100644
index 000000000000..775448910ad1
--- /dev/null
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2018, Mellanox Technologies inc.  All rights reserved.
+ */
+
+#include <rdma/ib_user_verbs.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_types.h>
+#include <rdma/uverbs_ioctl.h>
+#include <rdma/mlx5_user_ioctl_cmds.h>
+#include <rdma/ib_umem.h>
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/fs.h>
+#include "mlx5_ib.h"
+
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev, struct mlx5_ib_ucontext *context)
+{
+	u32 in[MLX5_ST_SZ_DW(create_uctx_in)] = {0};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
+	u64 general_obj_types;
+	void *uctx;
+	void *hdr;
+	int err;
+
+	uctx = MLX5_ADDR_OF(create_uctx_in, in, uctx);
+	hdr = MLX5_ADDR_OF(create_uctx_in, in, hdr);
+
+	general_obj_types = MLX5_CAP_GEN_64(dev->mdev, general_obj_types);
+	if (!(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UCTX) ||
+	    !(general_obj_types & MLX5_GENERAL_OBJ_TYPES_CAP_UMEM))
+		return -EINVAL;
+
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
+	MLX5_SET(general_obj_in_cmd_hdr, hdr, opcode, MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, hdr, obj_type, MLX5_OBJ_TYPE_UCTX);
+
+	err = mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	context->devx_uid = MLX5_GET(general_obj_out_cmd_hdr, out, obj_id);
+	return 0;
+}
+
+void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
+			  struct mlx5_ib_ucontext *context)
+{
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {0};
+	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)] = {0};
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_DESTROY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type, MLX5_OBJ_TYPE_UCTX);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, context->devx_uid);
+
+	mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e52dd21519b4..430a9e36d392 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1676,8 +1676,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 	if (err)
 		return ERR_PTR(err);
 
-	if (req.flags)
-		return ERR_PTR(-EINVAL);
+	if (req.flags & ~MLX5_IB_ALLOC_UCTX_DEVX)
+		return ERR_PTR(-EOPNOTSUPP);
 
 	if (req.comp_mask || req.reserved0 || req.reserved1 || req.reserved2)
 		return ERR_PTR(-EOPNOTSUPP);
@@ -1761,6 +1761,18 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 			goto out_uars;
 	}
 
+	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX) {
+		/* Block DEVX on Infiniband as of SELinux */
+		if (mlx5_ib_port_link_layer(ibdev, 1) != IB_LINK_LAYER_ETHERNET) {
+			err = -EPERM;
+			goto out_td;
+		}
+
+		err = mlx5_ib_devx_create(dev, context);
+		if (err)
+			goto out_td;
+	}
+
 	INIT_LIST_HEAD(&context->vma_private_list);
 	mutex_init(&context->vma_private_list_mutex);
 	INIT_LIST_HEAD(&context->db_page_list);
@@ -1821,7 +1833,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
-		goto out_td;
+		goto out_mdev;
 
 	bfregi->ver = ver;
 	bfregi->num_low_latency_bfregs = req.num_low_latency_bfregs;
@@ -1831,6 +1843,9 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
 
 	return &context->ibucontext;
 
+out_mdev:
+	if (req.flags & MLX5_IB_ALLOC_UCTX_DEVX)
+		mlx5_ib_devx_destroy(dev, context);
 out_td:
 	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
 		mlx5_ib_dealloc_transport_domain(dev, context->tdn);
@@ -1856,6 +1871,9 @@ static int mlx5_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	struct mlx5_ib_dev *dev = to_mdev(ibcontext->device);
 	struct mlx5_bfreg_info *bfregi;
 
+	if (context->devx_uid)
+		mlx5_ib_devx_destroy(dev, context);
+
 	bfregi = &context->bfregi;
 	if (MLX5_CAP_GEN(dev->mdev, log_max_transport_domain))
 		mlx5_ib_dealloc_transport_domain(dev, context->tdn);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d89c8fe626f6..5e8abd8bcd71 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -143,6 +143,7 @@ struct mlx5_ib_ucontext {
 
 	u64			lib_caps;
 	DECLARE_BITMAP(dm_pages, MLX5_MAX_MEMIC_PAGES);
+	u16			devx_uid;
 };
 
 static inline struct mlx5_ib_ucontext *to_mucontext(struct ib_ucontext *ibucontext)
@@ -1217,6 +1218,18 @@ struct mlx5_core_dev *mlx5_ib_get_native_port_mdev(struct mlx5_ib_dev *dev,
 void mlx5_ib_put_native_port_mdev(struct mlx5_ib_dev *dev,
 				  u8 port_num);
 
+#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
+int mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
+			struct mlx5_ib_ucontext *context);
+void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
+			  struct mlx5_ib_ucontext *context);
+#else
+static inline int
+mlx5_ib_devx_create(struct mlx5_ib_dev *dev,
+		    struct mlx5_ib_ucontext *context) { return -EOPNOTSUPP; };
+static inline void mlx5_ib_devx_destroy(struct mlx5_ib_dev *dev,
+					struct mlx5_ib_ucontext *context) {}
+#endif
 static inline void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index b99d6df3905b..d07f24de8fa3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -310,6 +310,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_ENCAP_HEADER:
 	case MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT:
 	case MLX5_CMD_OP_FPGA_DESTROY_QP:
+	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
 		return MLX5_CMD_STAT_OK;
 
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -427,6 +428,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_FPGA_MODIFY_QP:
 	case MLX5_CMD_OP_FPGA_QUERY_QP:
 	case MLX5_CMD_OP_FPGA_QUERY_QP_COUNTERS:
+	case MLX5_CMD_OP_CREATE_GENERAL_OBJECT:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -599,6 +601,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(FPGA_QUERY_QP);
 	MLX5_COMMAND_STR_CASE(FPGA_QUERY_QP_COUNTERS);
 	MLX5_COMMAND_STR_CASE(FPGA_DESTROY_QP);
+	MLX5_COMMAND_STR_CASE(CREATE_GENERAL_OBJECT);
+	MLX5_COMMAND_STR_CASE(DESTROY_GENERAL_OBJECT);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 02f72ebf31a7..f8671c0a43aa 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1071,6 +1071,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_GEN(mdev, cap) \
 	MLX5_GET(cmd_hca_cap, mdev->caps.hca_cur[MLX5_CAP_GENERAL], cap)
 
+#define MLX5_CAP_GEN_64(mdev, cap) \
+	MLX5_GET64(cmd_hca_cap, mdev->caps.hca_cur[MLX5_CAP_GENERAL], cap)
+
 #define MLX5_CAP_GEN_MAX(mdev, cap) \
 	MLX5_GET(cmd_hca_cap, mdev->caps.hca_max[MLX5_CAP_GENERAL], cap)
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 78d4993a2920..f810772e80c0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -75,6 +75,15 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 };
 
+enum {
+	MLX5_GENERAL_OBJ_TYPES_CAP_UCTX = (1ULL << 4),
+	MLX5_GENERAL_OBJ_TYPES_CAP_UMEM = (1ULL << 5),
+};
+
+enum {
+	MLX5_OBJ_TYPE_UCTX = 0x0004,
+};
+
 enum {
 	MLX5_CMD_OP_QUERY_HCA_CAP                 = 0x100,
 	MLX5_CMD_OP_QUERY_ADAPTER                 = 0x101,
@@ -242,6 +251,8 @@ enum {
 	MLX5_CMD_OP_FPGA_QUERY_QP                 = 0x962,
 	MLX5_CMD_OP_FPGA_DESTROY_QP               = 0x963,
 	MLX5_CMD_OP_FPGA_QUERY_QP_COUNTERS        = 0x964,
+	MLX5_CMD_OP_CREATE_GENERAL_OBJECT         = 0xa00,
+	MLX5_CMD_OP_DESTROY_GENERAL_OBJECT        = 0xa03,
 	MLX5_CMD_OP_MAX
 };
 
@@ -1113,7 +1124,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_3f8[0x3];
 	u8         log_max_current_uc_list[0x5];
 
-	u8         reserved_at_400[0x80];
+	u8         general_obj_types[0x40];
+
+	u8         reserved_at_440[0x40];
 
 	u8         reserved_at_480[0x3];
 	u8         log_max_l2_table[0x5];
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 8daec1fa49cf..5d591ff28139 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -76,6 +76,9 @@ enum mlx5_lib_caps {
 	MLX5_LIB_CAP_4K_UAR	= (__u64)1 << 0,
 };
 
+enum mlx5_ib_alloc_uctx_v2_flags {
+	MLX5_IB_ALLOC_UCTX_DEVX	= 1 << 0,
+};
 struct mlx5_ib_alloc_ucontext_req_v2 {
 	__u32	total_num_bfregs;
 	__u32	num_low_latency_bfregs;
-- 
2.14.4
