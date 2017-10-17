From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Expose multi-packet RQ capabilities
Date: Tue, 17 Oct 2017 18:01:12 +0300
Message-ID: <20171017150113.8544-2-leon@kernel.org>
References: <20171017150113.8544-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017150113.8544-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch reports the device's striding RQ capabilities to
the user-space:
- min/max_single_stride_log_num_of_bytes: Log of min/max number of
  bytes in a single stride.
- min/max_single_wqe_log_num_of_strides: Log of min/max number of
  strides in a single WQE.
- supported_qpts: A bit mask to know which QP types support multi-
  packet RQ, for now only Raw Packet QPs.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 16 ++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +++++
 include/uapi/rdma/mlx5-abi.h         | 14 ++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 552f7bd4ecc3..02da3f58f296 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -848,6 +848,22 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
+	if (field_avail(typeof(resp), striding_rq_caps, uhw->outlen)) {
+		resp.response_length += sizeof(resp.striding_rq_caps);
+		if (MLX5_CAP_GEN(mdev, striding_rq)) {
+			resp.striding_rq_caps.min_single_stride_log_num_of_bytes =
+				MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES;
+			resp.striding_rq_caps.max_single_stride_log_num_of_bytes =
+				MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES;
+			resp.striding_rq_caps.min_single_wqe_log_num_of_strides =
+				MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES;
+			resp.striding_rq_caps.max_single_wqe_log_num_of_strides =
+				MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES;
+			resp.striding_rq_caps.supported_qpts =
+				BIT(IB_QPT_RAW_PACKET);
+		}
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 189e80cd6b2f..8de40852818b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -256,6 +256,11 @@ enum mlx5_ib_wq_flags {
 	MLX5_IB_WQ_FLAGS_DELAY_DROP = 0x1,
 };
 
+#define MLX5_MIN_SINGLE_WQE_LOG_NUM_STRIDES 9
+#define MLX5_MAX_SINGLE_WQE_LOG_NUM_STRIDES 16
+#define MLX5_MIN_SINGLE_STRIDE_LOG_NUM_BYTES 6
+#define MLX5_MAX_SINGLE_STRIDE_LOG_NUM_BYTES 13
+
 struct mlx5_ib_rwq {
 	struct ib_wq		ibwq;
 	struct mlx5_core_qp	core_qp;
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 1791bf123ba9..0832d9502200 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -190,6 +190,19 @@ struct mlx5_ib_sw_parsing_caps {
 	__u32 supported_qpts;
 };
 
+struct mlx5_ib_striding_rq_caps {
+	__u32 min_single_stride_log_num_of_bytes;
+	__u32 max_single_stride_log_num_of_bytes;
+	__u32 min_single_wqe_log_num_of_strides;
+	__u32 max_single_wqe_log_num_of_strides;
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
@@ -200,6 +213,7 @@ struct mlx5_ib_query_device_resp {
 	__u32	mlx5_ib_support_multi_pkt_send_wqes;
 	__u32	reserved;
 	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
+	struct mlx5_ib_striding_rq_caps striding_rq_caps;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
