From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx5: Advertise atomic capabilities in query device
Date: Tue,  8 Dec 2015 18:54:16 +0200
Message-ID: <1449593656-8437-3-git-send-email-eranbe@mellanox.com>
References: <1449593656-8437-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449593656-8437-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In addition, check if qp support atomic operations when asking QP access
flags with IB_ACCESS_REMOTE_ATOMIC in modify QP.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 40 +++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 drivers/infiniband/hw/mlx5/qp.c      |  8 ++++++++
 include/linux/mlx5/driver.h          |  5 +++++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bdd60a6..431ba16 100644
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
@@ -1011,6 +1037,16 @@ static void get_ext_port_caps(struct mlx5_ib_dev *dev)
 		mlx5_query_ext_port_caps(dev, port);
 }
 
+static void config_atomic_responder(struct mlx5_ib_dev *dev,
+				    struct ib_device_attr *props)
+{
+	enum ib_atomic_cap cap = props->atomic_cap;
+
+	if (cap == IB_ATOMIC_HCA ||
+	    cap == IB_ATOMIC_GLOB)
+		dev->enable_atomic_resp = 1;
+}
+
 static int get_port_caps(struct mlx5_ib_dev *dev)
 {
 	struct ib_device_attr *dprops = NULL;
@@ -1033,6 +1069,8 @@ static int get_port_caps(struct mlx5_ib_dev *dev)
 		goto out;
 	}
 
+	config_atomic_responder(dev, dprops);
+
 	for (port = 1; port <= MLX5_CAP_GEN(dev->mdev, num_ports); port++) {
 		err = mlx5_ib_query_port(&dev->ib_dev, port, pprops);
 		if (err) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6333472..80664fe 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -423,6 +423,7 @@ struct mlx5_ib_dev {
 	struct mlx5_mr_cache		cache;
 	struct timer_list		delay_timer;
 	int				fill_delay;
+	int				enable_atomic_resp;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct ib_odp_caps	odp_caps;
 	/*
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 307bdbc..e65703e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1669,6 +1669,14 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 				cpu_to_be32(fls(attr->max_dest_rd_atomic - 1) << 21);
 	}
 
+	if ((attr_mask & IB_QP_ACCESS_FLAGS) &&
+	    (attr->qp_access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
+	    !dev->enable_atomic_resp) {
+		mlx5_ib_warn(dev, "atomic responder is not supported\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (attr_mask & (IB_QP_ACCESS_FLAGS | IB_QP_MAX_DEST_RD_ATOMIC))
 		context->params2 |= to_mlx5_access_flags(qp, attr, attr_mask);
 
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
