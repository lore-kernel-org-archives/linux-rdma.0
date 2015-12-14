From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v1 1/2] net/mlx5_core: Configure HW to support atomic request in host endianness
Date: Mon, 14 Dec 2015 16:34:09 +0200
Message-ID: <1450103650-16857-2-git-send-email-eranbe@mellanox.com>
References: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450103650-16857-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

HW is capable of 2 requestor endianness modes for standard 8 Bytes
atomic: BE (0x0) and host endianness (0x1). Read the supported modes
from hca atomic capabilities and configure HW to host endianness mode if
supported.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 57 +++++++++++++++++++++++++-
 include/linux/mlx5/mlx5_ifc.h                  | 22 ++++++----
 2 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 03aabdd..682a4c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -73,6 +73,11 @@ struct mlx5_device_context {
 	void		       *context;
 };
 
+enum {
+	MLX5_ATOMIC_REQ_MODE_BE = 0x0,
+	MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS = 0x1,
+};
+
 static struct mlx5_profile profile[] = {
 	[0] = {
 		.mask           = 0,
@@ -335,7 +340,7 @@ query_ex:
 	return err;
 }
 
-static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz)
+static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz, int opmod)
 {
 	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)];
 	int err;
@@ -343,6 +348,7 @@ static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz)
 	memset(out, 0, sizeof(out));
 
 	MLX5_SET(set_hca_cap_in, in, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, in, op_mod, opmod << 1);
 	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
 	if (err)
 		return err;
@@ -352,6 +358,46 @@ static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz)
 	return err;
 }
 
+static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
+{
+	void *set_ctx;
+	void *set_hca_cap;
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	int req_endianness;
+	int err;
+
+	if (MLX5_CAP_GEN(dev, atomic)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ATOMIC,
+					 HCA_CAP_OPMOD_GET_CUR);
+		if (err)
+			return err;
+	} else {
+		return 0;
+	}
+
+	req_endianness =
+		MLX5_CAP_ATOMIC(dev,
+				supported_atomic_req_8B_endianess_mode_1);
+
+	if (req_endianness != MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS)
+		return 0;
+
+	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+
+	/* Set requestor to host endianness */
+	MLX5_SET(atomic_caps, set_hca_cap, atomic_req_8B_endianess_mode,
+		 MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS);
+
+	err = set_caps(dev, set_ctx, set_sz, MLX5_SET_HCA_CAP_OP_MOD_ATOMIC);
+
+	kfree(set_ctx);
+	return err;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev)
 {
 	void *set_ctx = NULL;
@@ -393,7 +439,8 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 
 	MLX5_SET(cmd_hca_cap, set_hca_cap, log_uar_page_sz, PAGE_SHIFT - 12);
 
-	err = set_caps(dev, set_ctx, set_sz);
+	err = set_caps(dev, set_ctx, set_sz,
+		       MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 
 query_ex:
 	kfree(set_ctx);
@@ -764,6 +811,12 @@ static int mlx5_dev_init(struct mlx5_core_dev *dev, struct pci_dev *pdev)
 		goto reclaim_boot_pages;
 	}
 
+	err = handle_hca_cap_atomic(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
+		goto reclaim_boot_pages;
+	}
+
 	err = mlx5_satisfy_startup_pages(dev, 0);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate init pages\n");
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dd20974..3da1951 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -67,6 +67,11 @@ enum {
 };
 
 enum {
+	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
+	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
+};
+
+enum {
 	MLX5_CMD_OP_QUERY_HCA_CAP                 = 0x100,
 	MLX5_CMD_OP_QUERY_ADAPTER                 = 0x101,
 	MLX5_CMD_OP_INIT_HCA                      = 0x102,
@@ -525,21 +530,24 @@ enum {
 struct mlx5_ifc_atomic_caps_bits {
 	u8         reserved_0[0x40];
 
-	u8         atomic_req_endianness[0x1];
-	u8         reserved_1[0x1f];
+	u8         atomic_req_8B_endianess_mode[0x2];
+	u8         reserved_1[0x4];
+	u8         supported_atomic_req_8B_endianess_mode_1[0x1];
 
-	u8         reserved_2[0x20];
+	u8         reserved_2[0x19];
 
-	u8         reserved_3[0x10];
-	u8         atomic_operations[0x10];
+	u8         reserved_3[0x20];
 
 	u8         reserved_4[0x10];
-	u8         atomic_size_qp[0x10];
+	u8         atomic_operations[0x10];
 
 	u8         reserved_5[0x10];
+	u8         atomic_size_qp[0x10];
+
+	u8         reserved_6[0x10];
 	u8         atomic_size_dc[0x10];
 
-	u8         reserved_6[0x720];
+	u8         reserved_7[0x720];
 };
 
 struct mlx5_ifc_odp_cap_bits {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
