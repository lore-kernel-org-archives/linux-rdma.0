From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 4/5] IB/mlx5: Add extended atomic support
Date: Mon,  3 Nov 2014 10:02:45 +0200
Message-ID: <1415001766-8366-5-git-send-email-eli@mellanox.com>
References: <1415001766-8366-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415001766-8366-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Connect-IB extended atomic operations provides masked compare and swap and
multi field fetch and add operations with arguments sizes bigger than 64 bits.

Also, Connect-IB supports BE replies to atomic opertation, add that
to the advertized capabilities.

Add the required functionality to mlx5 and publish capabilities.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c              | 47 +++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/qp.c                | 26 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 51 +++++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 21 +++-------
 include/linux/mlx5/device.h                    |  4 +-
 include/linux/mlx5/driver.h                    | 55 ++++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h                  | 20 ++++++++++
 7 files changed, 194 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1ba6c42e4df8..3c6fa99c4256 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -151,6 +151,47 @@ static void free_comp_eqs(struct mlx5_ib_dev *dev)
 	spin_unlock(&table->lock);
 }
 
+static void update_atomic_caps(struct mlx5_caps	*caps,
+			       struct ib_device_attr *props)
+{
+	struct mlx5_atomic_caps *atom = &caps->atom;
+	unsigned long last;
+	unsigned long arg;
+	int tmp;
+
+	tmp = MLX5_ATOMIC_OPS_CMP_SWAP | MLX5_ATOMIC_OPS_FETCH_ADD;
+	if (((atom->atomic_ops & tmp) == tmp) && (atom->atomic_sizes_qp & 8)) {
+		if (atom->requestor_endianess)
+			props->atomic_cap = IB_ATOMIC_HCA;
+		else
+			props->atomic_cap = IB_ATOMIC_HCA_REPLY_BE;
+	} else {
+		props->atomic_cap = IB_ATOMIC_NONE;
+	}
+
+	tmp = MLX5_ATOMIC_OPS_MASKED_CMP_SWAP | MLX5_ATOMIC_OPS_MASKED_FETCH_ADD;
+	if (((atom->atomic_ops & tmp) == tmp)) {
+		if (atom->requestor_endianess)
+			props->masked_atomic_cap = IB_ATOMIC_HCA;
+		else
+			props->masked_atomic_cap = IB_ATOMIC_HCA_REPLY_BE;
+	} else {
+		props->masked_atomic_cap = IB_ATOMIC_NONE;
+	}
+	if ((props->atomic_cap != IB_ATOMIC_NONE) ||
+	    (props->masked_atomic_cap != IB_ATOMIC_NONE)) {
+		props->log_atomic_arg_sizes = caps->atom.atomic_sizes_qp;
+		props->max_fa_bit_boundary = 64;
+		arg = (unsigned long)props->log_atomic_arg_sizes;
+		last = find_last_bit(&arg, sizeof(arg));
+		props->log_max_atomic_inline = min_t(unsigned long, last, 6);
+	} else {
+		props->log_atomic_arg_sizes = 0;
+		props->max_fa_bit_boundary = 0;
+		props->log_max_atomic_inline = 0;
+	}
+}
+
 static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props)
 {
@@ -235,8 +276,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len = (unsigned int)-1;
 	props->local_ca_ack_delay  = gen->local_ca_ack_delay;
-	props->atomic_cap	   = IB_ATOMIC_NONE;
-	props->masked_atomic_cap   = IB_ATOMIC_NONE;
+	update_atomic_caps(&dev->mdev->caps, props);
 	props->max_pkeys	   = be16_to_cpup((__be16 *)(out_mad->data + 28));
 	props->max_mcast_grp	   = 1 << gen->log_max_mcg;
 	props->max_mcast_qp_attach = gen->max_qp_mcg;
@@ -1374,6 +1414,9 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
 	}
 
+	dev->ib_dev.uverbs_ex_cmd_mask  |=
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
+
 	err = init_node_data(dev);
 	if (err)
 		goto err_eqs;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9ca39ad68cb8..47ca93ce214f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1254,7 +1254,27 @@ int mlx5_ib_destroy_qp(struct ib_qp *qp)
 	return 0;
 }
 
-static __be32 to_mlx5_access_flags(struct mlx5_ib_qp *qp, const struct ib_qp_attr *attr,
+static u32 atomic_mode_qp(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_atomic_caps *acaps = &dev->mdev->caps.atom;
+	unsigned long mask;
+	unsigned long tmp;
+
+	mask = acaps->atomic_sizes_qp & acaps->atomic_sizes_dc;
+
+	tmp = find_last_bit(&mask, 8 * sizeof(mask));
+	if (tmp < 2 || tmp >= 16)
+		return MLX5_ATOMIC_MODE_NONE << 16;
+
+	if (tmp == 2)
+		return MLX5_ATOMIC_MODE_CX << 16;
+
+	return tmp << 16;
+}
+
+static __be32 to_mlx5_access_flags(struct mlx5_ib_dev *dev,
+				   struct mlx5_ib_qp *qp,
+				   const struct ib_qp_attr *attr,
 				   int attr_mask)
 {
 	u32 hw_access_flags = 0;
@@ -1277,7 +1297,7 @@ static __be32 to_mlx5_access_flags(struct mlx5_ib_qp *qp, const struct ib_qp_att
 	if (access_flags & IB_ACCESS_REMOTE_READ)
 		hw_access_flags |= MLX5_QP_BIT_RRE;
 	if (access_flags & IB_ACCESS_REMOTE_ATOMIC)
-		hw_access_flags |= (MLX5_QP_BIT_RAE | MLX5_ATOMIC_MODE_CX);
+		hw_access_flags |= (MLX5_QP_BIT_RAE | atomic_mode_qp(dev));
 	if (access_flags & IB_ACCESS_REMOTE_WRITE)
 		hw_access_flags |= MLX5_QP_BIT_RWE;
 
@@ -1620,7 +1640,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & (IB_QP_ACCESS_FLAGS | IB_QP_MAX_DEST_RD_ATOMIC))
-		context->params2 |= to_mlx5_access_flags(qp, attr, attr_mask);
+		context->params2 |= to_mlx5_access_flags(dev, qp, attr, attr_mask);
 
 	if (attr_mask & IB_QP_MIN_RNR_TIMER)
 		context->rnr_nextrecvpsn |= cpu_to_be32(attr->min_rnr_timer << 24);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 087c4c797deb..b1d2d7a44b6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -33,6 +33,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cmd.h>
 #include <linux/module.h>
+#include <linux/mlx5/mlx5_ifc.h>
 #include "mlx5_core.h"
 
 int mlx5_cmd_query_adapter(struct mlx5_core_dev *dev)
@@ -64,9 +65,57 @@ out_out:
 	return err;
 }
 
+static int handle_atomic_caps(struct mlx5_core_dev *dev,
+			      struct mlx5_caps *caps)
+{
+	u16 opmod = HCA_CAP_OPMOD_ATOMIC | HCA_CAP_OPMOD_GET_CUR;
+	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)];
+	int out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *cap_ptr;
+	void *out;
+	int err;
+
+	memset(in, 0, sizeof(in));
+	out = kzalloc(out_sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, out_sz);
+	if (err)
+		goto query_ex;
+
+	err = mlx5_cmd_status_to_err_v2(out);
+	if (err) {
+		mlx5_core_warn(dev, "query atomic caps failed, %d\n", err);
+		goto query_ex;
+	}
+	mlx5_core_dbg(dev, "%s\n", caps_opmod_str(opmod));
+	cap_ptr = MLX5_ADDR_OF(query_hca_cap_out, out, capability_struct);
+	caps->atom.requestor_endianess = MLX5_GET_PR(atomic_cap, cap_ptr, atomic_req_endianess);
+	caps->atom.atomic_ops = MLX5_GET_PR(atomic_cap, cap_ptr, atomic_operations);
+	caps->atom.atomic_sizes_qp = MLX5_GET_PR(atomic_cap, cap_ptr, atomic_size_qp);
+	caps->atom.atomic_sizes_dc = MLX5_GET_PR(atomic_cap, cap_ptr, atomic_size_dc);
+
+query_ex:
+	kfree(out);
+	return err;
+}
+
 int mlx5_cmd_query_hca_cap(struct mlx5_core_dev *dev, struct mlx5_caps *caps)
 {
-	return mlx5_core_get_caps(dev, caps, HCA_CAP_OPMOD_GET_CUR);
+	int err;
+
+	err = mlx5_core_get_caps(dev, caps,
+				 HCA_CAP_OPMOD_GET_CUR | HCA_CAP_OPMOD_GENERAL);
+	if (err)
+		return err;
+
+	if (caps->gen.flags & MLX5_DEV_CAP_FLAG_ATOMIC)
+		err = handle_atomic_caps(dev, caps);
+
+	return err;
 }
 
 int mlx5_cmd_init_hca(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 3d8e8e489b2d..88b2ffa0edfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -345,18 +345,6 @@ static void fw2drv_caps(struct mlx5_caps *caps, void *out)
 	gen->log_uar_page_sz = MLX5_GET_PR(cmd_hca_cap, out, log_uar_page_sz);
 }
 
-static const char *caps_opmod_str(u16 opmod)
-{
-	switch (opmod) {
-	case HCA_CAP_OPMOD_GET_MAX:
-		return "GET_MAX";
-	case HCA_CAP_OPMOD_GET_CUR:
-		return "GET_CUR";
-	default:
-		return "Invalid";
-	}
-}
-
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, struct mlx5_caps *caps,
 		       u16 opmod)
 {
@@ -377,7 +365,8 @@ int mlx5_core_get_caps(struct mlx5_core_dev *dev, struct mlx5_caps *caps,
 
 	err = mlx5_cmd_status_to_err_v2(out);
 	if (err) {
-		mlx5_core_warn(dev, "query max hca cap failed, %d\n", err);
+		mlx5_core_warn(dev, "query %s hca caps failed, %d\n",
+			       caps_opmod_str(opmod), err);
 		goto query_ex;
 	}
 	mlx5_core_dbg(dev, "%s\n", caps_opmod_str(opmod));
@@ -426,11 +415,13 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 	if (!cur_caps)
 		goto query_ex;
 
-	err = mlx5_core_get_caps(dev, max_caps, HCA_CAP_OPMOD_GET_MAX);
+	err = mlx5_core_get_caps(dev, max_caps,
+				 HCA_CAP_OPMOD_GET_MAX | HCA_CAP_OPMOD_GENERAL);
 	if (err)
 		goto query_ex;
 
-	err = mlx5_core_get_caps(dev, cur_caps, HCA_CAP_OPMOD_GET_CUR);
+	err = mlx5_core_get_caps(dev, cur_caps,
+				 HCA_CAP_OPMOD_GET_CUR | HCA_CAP_OPMOD_GENERAL);
 	if (err)
 		goto query_ex;
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1d67fd32e71c..6e9661105dfa 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -227,12 +227,12 @@ enum {
 	MLX5_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1LL <<  8,
 	MLX5_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1LL <<  9,
 	MLX5_DEV_CAP_FLAG_APM		= 1LL << 17,
-	MLX5_DEV_CAP_FLAG_ATOMIC	= 1LL << 18,
 	MLX5_DEV_CAP_FLAG_BLOCK_MCAST	= 1LL << 23,
 	MLX5_DEV_CAP_FLAG_ON_DMND_PG	= 1LL << 24,
 	MLX5_DEV_CAP_FLAG_CQ_MODER	= 1LL << 29,
 	MLX5_DEV_CAP_FLAG_RESIZE_CQ	= 1LL << 30,
 	MLX5_DEV_CAP_FLAG_RESIZE_SRQ	= 1LL << 32,
+	MLX5_DEV_CAP_FLAG_ATOMIC	= 1LL << 33,
 	MLX5_DEV_CAP_FLAG_DCT		= 1LL << 37,
 	MLX5_DEV_CAP_FLAG_REMOTE_FENCE	= 1LL << 38,
 	MLX5_DEV_CAP_FLAG_TLP_HINTS	= 1LL << 39,
@@ -298,6 +298,8 @@ enum {
 enum {
 	HCA_CAP_OPMOD_GET_MAX	= 0,
 	HCA_CAP_OPMOD_GET_CUR	= 1,
+	HCA_CAP_OPMOD_GENERAL	= 0 << 1,
+	HCA_CAP_OPMOD_ATOMIC	= 3 << 1,
 };
 
 struct mlx5_inbox_hdr {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 246310dc8bef..bdca5d94e6fc 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -89,14 +89,22 @@ enum {
 };
 
 enum {
-	MLX5_ATOMIC_MODE_IB_COMP	= 1 << 16,
-	MLX5_ATOMIC_MODE_CX		= 2 << 16,
-	MLX5_ATOMIC_MODE_8B		= 3 << 16,
-	MLX5_ATOMIC_MODE_16B		= 4 << 16,
-	MLX5_ATOMIC_MODE_32B		= 5 << 16,
-	MLX5_ATOMIC_MODE_64B		= 6 << 16,
-	MLX5_ATOMIC_MODE_128B		= 7 << 16,
-	MLX5_ATOMIC_MODE_256B		= 8 << 16,
+	MLX5_ATOMIC_MODE_NONE		= 0,
+	MLX5_ATOMIC_MODE_IB_COMP	= 1,
+	MLX5_ATOMIC_MODE_CX		= 2,
+	MLX5_ATOMIC_MODE_8B		= 3,
+	MLX5_ATOMIC_MODE_16B		= 4,
+	MLX5_ATOMIC_MODE_32B		= 5,
+	MLX5_ATOMIC_MODE_64B		= 6,
+	MLX5_ATOMIC_MODE_128B		= 7,
+	MLX5_ATOMIC_MODE_256B		= 8,
+};
+
+enum {
+	MLX5_ATOMIC_OPS_CMP_SWAP		= 1 << 0,
+	MLX5_ATOMIC_OPS_FETCH_ADD		= 1 << 1,
+	MLX5_ATOMIC_OPS_MASKED_CMP_SWAP		= 1 << 2,
+	MLX5_ATOMIC_OPS_MASKED_FETCH_ADD	= 1 << 3,
 };
 
 enum {
@@ -307,8 +315,16 @@ struct mlx5_general_caps {
 	u16	log_uar_page_sz;
 };
 
+struct mlx5_atomic_caps {
+	int	requestor_endianess;
+	u16	atomic_ops;
+	u16	atomic_sizes_qp;
+	u16	atomic_sizes_dc;
+};
+
 struct mlx5_caps {
 	struct mlx5_general_caps gen;
+	struct mlx5_atomic_caps atom;
 };
 
 struct mlx5_cmd_mailbox {
@@ -793,4 +809,27 @@ struct mlx5_profile {
 	} mr_cache[MAX_MR_CACHE_ENTRIES];
 };
 
+static inline const char *caps_opmod_str(u16 opmod)
+{
+	if (opmod & 1) {
+		switch (opmod & 0xfffe) {
+		case HCA_CAP_OPMOD_GENERAL:
+			return "CUR GENERAL";
+		case HCA_CAP_OPMOD_ATOMIC:
+			return "CUR ATOMIC";
+		default:
+			return "Invalid";
+		}
+	} else {
+		switch (opmod & 0xfffe) {
+		case HCA_CAP_OPMOD_GENERAL:
+			return "MAX GENERAL";
+		case HCA_CAP_OPMOD_ATOMIC:
+			return "MAX ATOMIC";
+		default:
+			return "Invalid";
+		}
+	}
+}
+
 #endif /* MLX5_DRIVER_H */
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5f48b8f592c5..a3e6148066ce 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -346,4 +346,24 @@ struct mlx5_ifc_set_hca_cap_out_bits {
 	u8         reserved_1[0x40];
 };
 
+struct mlx5_ifc_atomic_cap_bits {
+	u8         reserved_0[0x40];
+
+	u8         atomic_req_endianess[0x1];
+	u8         reserved_1[0x1f];
+
+	u8         reserved_2[0x20];
+
+	u8         reserved_3[0x10];
+	u8         atomic_operations[0x10];
+
+	u8         reserved_4[0x10];
+	u8         atomic_size_qp[0x10];
+
+	u8         reserved_5[0x10];
+	u8         atomic_size_dc[0x10];
+
+	u8         reserved_6[0x720];
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
