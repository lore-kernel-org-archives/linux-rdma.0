From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/mlx5: Report mlx5 packet pacing capabilities when querying device
Date: Mon, 31 Oct 2016 12:21:34 +0200
Message-ID: <1477909297-14491-2-git-send-email-leon@kernel.org>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477909297-14491-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable mlx5 based hardware to report packet pacing capabilities
from kernel to user space. Packet pacing allows to limit the rate to any
number between the maximum and minimum, based on user settings.

The capabilities are exposed to user space through query_device by uhw.
The following capabilities are reported:

1. The maximum and minimum rate limit in kbps supported by packet pacing.
2. Bitmap showing which QP types are supported by packet pacing operation.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 +++++++++++++
 include/uapi/rdma/mlx5-abi.h      | 13 +++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2217477..ed9d327 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -669,6 +669,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rq);
 	}
 
+	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen)) {
+		if (MLX5_CAP_QOS(mdev, packet_pacing) &&
+		    MLX5_CAP_GEN(mdev, qos)) {
+			resp.packet_pacing_caps.qp_rate_limit_max =
+				MLX5_CAP_QOS(mdev, packet_pacing_max_rate);
+			resp.packet_pacing_caps.qp_rate_limit_min =
+				MLX5_CAP_QOS(mdev, packet_pacing_min_rate);
+			resp.packet_pacing_caps.supported_qpts |=
+				1 << IB_QPT_RAW_PACKET;
+		}
+		resp.response_length += sizeof(resp.packet_pacing_caps);
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index f5d0f4e..4e9338d 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -124,11 +124,24 @@ struct mlx5_ib_rss_caps {
 	__u8 reserved[7];
 };
 
+struct mlx5_packet_pacing_caps {
+	__u32 qp_rate_limit_min;
+	__u32 qp_rate_limit_max; /* In kpbs */
+
+	/* Corresponding bit will be set if qp type from
+	 * 'enum ib_qp_type' is supported, e.g.
+	 * supported_qpts |= 1 << IB_QPT_RAW_PACKET
+	 */
+	__u32 supported_qpts;
+	__u32 reserved;
+};
+
 struct mlx5_ib_query_device_resp {
 	__u32	comp_mask;
 	__u32	response_length;
 	struct	mlx5_ib_tso_caps tso_caps;
 	struct	mlx5_ib_rss_caps rss_caps;
+	struct	mlx5_packet_pacing_caps packet_pacing_caps;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
