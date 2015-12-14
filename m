From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v1 2/2] IB/mlx5: Advertise atomic capabilities in query device
Date: Mon, 14 Dec 2015 16:34:10 +0200
Message-ID: <1450103650-16857-3-git-send-email-eranbe@mellanox.com>
References: <1450103650-16857-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450103650-16857-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to ensure IB spec atomic correctness in atomic operations, if
HW is configured to host endianness, advertise IB_ATOMIC_HCA.  if not,
advertise IB_ATOMIC_NONE.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 28 +++++++++++++++++++++++++++-
 include/linux/mlx5/driver.h       |  5 +++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bdd60a6..1139b67 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -63,6 +63,10 @@ static char mlx5_version[] =
 	DRIVER_NAME ": Mellanox Connect-IB Infiniband driver v"
 	DRIVER_VERSION " (" DRIVER_RELDATE ")\n";
 
+enum {
+	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
+};
+
 static enum rdma_link_layer
 mlx5_ib_port_link_layer(struct ib_device *device)
 {
@@ -101,6 +105,28 @@ static int mlx5_get_vport_access_method(struct ib_device *ibdev)
 	return MLX5_VPORT_ACCESS_METHOD_HCA;
 }
 
+static void get_atomic_caps(struct mlx5_ib_dev *dev,
+			    struct ib_device_attr *props)
+{
+	u8 tmp;
+	u8 atomic_operations = MLX5_CAP_ATOMIC(dev->mdev, atomic_operations);
+	u8 atomic_size_qp = MLX5_CAP_ATOMIC(dev->mdev, atomic_size_qp);
+	u8 atomic_req_8B_endianness_mode =
+		MLX5_CAP_ATOMIC(dev->mdev, atomic_req_8B_endianess_mode);
+
+	/* Check if HW supports 8 bytes standard atomic operations and capable
+	 * of host endianness respond
+	 */
+	tmp = MLX5_ATOMIC_OPS_CMP_SWAP | MLX5_ATOMIC_OPS_FETCH_ADD;
+	if (((atomic_operations & tmp) == tmp) &&
+	    (atomic_size_qp & MLX5_ATOMIC_SIZE_QP_8BYTES) &&
+	    (atomic_req_8B_endianness_mode)) {
+		props->atomic_cap = IB_ATOMIC_HCA;
+	} else {
+		props->atomic_cap = IB_ATOMIC_NONE;
+	}
+}
+
 static int mlx5_query_system_image_guid(struct ib_device *ibdev,
 					__be64 *sys_image_guid)
 {
@@ -286,7 +312,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_res_rd_atom	   = props->max_qp_rd_atom * props->max_qp;
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len = (unsigned int)-1;
-	props->atomic_cap	   = IB_ATOMIC_NONE;
+	get_atomic_caps(dev, props);
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
 	props->max_mcast_grp	   = 1 << MLX5_CAP_GEN(mdev, log_max_mcg);
 	props->max_mcast_qp_attach = MLX5_CAP_GEN(mdev, max_qp_mcg);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8b6d6f2..4c5a7e6 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -115,6 +115,11 @@ enum {
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
 };
 
+enum {
+	MLX5_ATOMIC_OPS_CMP_SWAP	= 1 << 0,
+	MLX5_ATOMIC_OPS_FETCH_ADD	= 1 << 1,
+};
+
 enum mlx5_page_fault_resume_flags {
 	MLX5_PAGE_FAULT_RESUME_REQUESTOR = 1 << 0,
 	MLX5_PAGE_FAULT_RESUME_WRITE	 = 1 << 1,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
