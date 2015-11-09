From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/4] IB/mlx5: Add support querying timestamp related fields in query_device
Date: Mon,  9 Nov 2015 18:30:56 +0200
Message-ID: <1447086657-15358-4-git-send-email-matanb@mellanox.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447086657-15358-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for querying hca_core_lock, timestmap_mask and
hca_core_clock_offset in query device verb. This is necessary
in order to support completion timestamp and querying the
HCA's core clock.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 42 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 18 ++++++++++++++++
 include/linux/mlx5/device.h          | 10 ++++-----
 include/linux/mlx5/mlx5_ifc.h        |  9 +++++---
 4 files changed, 69 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 05f00da..b8be3ad 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -213,10 +213,33 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_rq_sg;
 	int max_sq_sg;
 	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	struct mlx5_uverbs_ex_query_device cmd = {};
+	struct mlx5_uverbs_ex_query_device_resp resp = {};
 
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
+	if (uhw->inlen) {
+		if (uhw->inlen < offsetof(struct mlx5_uverbs_ex_query_device,
+					  comp_mask) +
+				 sizeof(cmd.comp_mask))
+			return -EINVAL;
+
+		err = ib_copy_from_udata(&cmd, uhw, min(sizeof(cmd),
+							uhw->inlen));
+		if (err)
+			return err;
+
+		if (cmd.comp_mask)
+			return -EINVAL;
+
+		if (cmd.reserved)
+			return -EINVAL;
 
+		if (!ib_is_udata_cleared(uhw, '\0', sizeof(cmd),
+					 sizeof(cmd) - uhw->inlen))
+			return -EINVAL;
+	}
+
+	resp.response_length = offsetof(typeof(resp), response_length) +
+		sizeof(resp.response_length);
 	memset(props, 0, sizeof(*props));
 	err = mlx5_query_system_image_guid(ibdev,
 					   &props->sys_image_guid);
@@ -293,6 +316,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
+	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
+	props->timestamp_mask = 0xFFFFFFFFFFFFFFULL;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (MLX5_CAP_GEN(mdev, pg))
@@ -300,6 +325,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->odp_caps = dev->odp_caps;
 #endif
 
+	if (field_avail(typeof(resp), hca_core_clock_offset, uhw->outlen)) {
+		resp.response_length += sizeof(resp.hca_core_clock_offset);
+		resp.comp_mask |= QUERY_DEVICE_RESP_MASK_TIMESTAMP;
+		resp.hca_core_clock_offset =
+			offsetof(struct mlx5_init_seg, internal_timer_h) % PAGE_SIZE;
+	}
+
+	if (uhw->outlen) {
+		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 22123b7..c33cf8f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -55,6 +55,9 @@ pr_err("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 pr_warn("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
 	__LINE__, current->pid, ##arg)
 
+#define field_avail(type, fld, sz) (offsetof(type, fld) +		\
+				    sizeof(((type *)0)->fld) <= (sz))
+
 enum {
 	MLX5_IB_MMAP_CMD_SHIFT	= 8,
 	MLX5_IB_MMAP_CMD_MASK	= 0xff,
@@ -441,6 +444,21 @@ struct mlx5_ib_dev {
 #endif
 };
 
+struct mlx5_uverbs_ex_query_device {
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
+enum query_device_resp_mask {
+	QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
+};
+
+struct mlx5_uverbs_ex_query_device_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u64 hca_core_clock_offset;
+};
+
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
 {
 	return container_of(mcq, struct mlx5_ib_cq, mcq);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 250b1ff..b7d7471 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -441,12 +441,12 @@ struct mlx5_init_seg {
 	__be32			cmd_dbell;
 	__be32			rsvd1[121];
 	struct health_buffer	health;
-	__be32			rsvd2[884];
+	__be32			rsvd2[880];
+	__be32			internal_timer_h;
+	__be32			internal_timer_l;
+	__be32			rsvd3[2];
 	__be32			health_counter;
-	__be32			rsvd3[1019];
-	__be64			ieee1588_clk;
-	__be32			ieee1588_clk_type;
-	__be32			clr_intx;
+	__be32			rsvd4[1019];
 };
 
 struct mlx5_eqe_comp {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dd20974..4172db6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -792,15 +792,18 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_63[0x8];
 	u8         log_uar_page_sz[0x10];
 
-	u8         reserved_64[0x100];
+	u8	   reserved_64[0x20];
+	u8	   device_frequency_mhz[0x20];
+	u8	   device_frequency_khz[0x20];
+	u8         reserved_65[0xa0];
 
-	u8         reserved_65[0x1f];
+	u8         reserved_66[0x1f];
 	u8         cqe_zip[0x1];
 
 	u8         cqe_zip_timeout[0x10];
 	u8         cqe_zip_max_num[0x10];
 
-	u8         reserved_66[0x220];
+	u8         reserved_67[0x220];
 };
 
 enum {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
