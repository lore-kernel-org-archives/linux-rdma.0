From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx4: Add report for RSS capabilities by vendor channel
Date: Wed, 25 Oct 2017 22:39:34 +0300
Message-ID: <20171025193935.1075-2-leon@kernel.org>
References: <20171025193935.1075-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025193935.1075-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4's RSS patches submission missed a report of RSS capabilities
which should be reported by the vendor channel in query_device.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 17 +++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 16 +++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c6420e26f2d8..8c8a16791a3f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -584,6 +584,23 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 			sizeof(struct mlx4_wqe_data_seg);
 	}
 
+	if (uhw->outlen >= resp.response_length + sizeof(resp.rss_caps)) {
+		resp.response_length += sizeof(resp.rss_caps);
+		if (props->rss_caps.supported_qpts) {
+			resp.rss_caps.rx_hash_function =
+				MLX4_IB_RX_HASH_FUNC_TOEPLITZ;
+			resp.rss_caps.rx_hash_fields_mask =
+				MLX4_IB_RX_HASH_SRC_IPV4 |
+				MLX4_IB_RX_HASH_DST_IPV4 |
+				MLX4_IB_RX_HASH_SRC_IPV6 |
+				MLX4_IB_RX_HASH_DST_IPV6 |
+				MLX4_IB_RX_HASH_SRC_PORT_TCP |
+				MLX4_IB_RX_HASH_DST_PORT_TCP |
+				MLX4_IB_RX_HASH_SRC_PORT_UDP |
+				MLX4_IB_RX_HASH_DST_PORT_UDP;
+		}
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 		if (err)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 9a55064ed69a..65c66dbff754 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -645,12 +645,18 @@ enum query_device_resp_mask {
 	QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
 };
 
+struct mlx4_ib_rss_caps {
+	__u64 rx_hash_fields_mask; /* enum mlx4_rx_hash_fields */
+	__u8 rx_hash_function; /* enum mlx4_rx_hash_function_flags */
+	__u8 reserved[7];
+};
+
 struct mlx4_uverbs_ex_query_device_resp {
-	__u32 comp_mask;
-	__u32 response_length;
-	__u64 hca_core_clock_offset;
-	__u32 max_inl_recv_sz;
-	__u32 reserved;
+	__u32			comp_mask;
+	__u32			response_length;
+	__u64			hca_core_clock_offset;
+	__u32			max_inl_recv_sz;
+	struct mlx4_ib_rss_caps	rss_caps;
 };
 
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
