From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 7/8] IB/mlx5: Allow posting multi packet send WQEs if hardware supports
Date: Thu, 17 Aug 2017 15:52:34 +0300
Message-ID: <20170817125235.5107-8-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Set the field to allow posting multi packet send WQEs if hardware
supports this feature. This doesn't mean the send WQEs will be for
multi packet unless the send WQE was prepared according to multi
packet send WQE format.

User space shall use flag MLX5_IB_ALLOW_MPW to check if hardware
supports MPW and allows MPW in SQ context.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +++--
 drivers/infiniband/hw/mlx5/qp.c   | 2 ++
 include/linux/mlx5/mlx5_ifc.h     | 2 +-
 include/uapi/rdma/mlx5-abi.h      | 5 +++++
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 438663356982..aef1d8a0f4e4 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -812,8 +812,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 
 	if (field_avail(typeof(resp), mlx5_ib_support_multi_pkt_send_wqes,
 			uhw->outlen)) {
-		resp.mlx5_ib_support_multi_pkt_send_wqes =
-			MLX5_CAP_ETH(mdev, multi_pkt_send_wqe);
+		if (MLX5_CAP_ETH(mdev, multi_pkt_send_wqe))
+			resp.mlx5_ib_support_multi_pkt_send_wqes =
+				MLX5_IB_ALLOW_MPW;
 		resp.response_length +=
 			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
 	}
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e58cc42a77a2..ecfa27920554 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1078,6 +1078,8 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 
 	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 	MLX5_SET(sqc, sqc, flush_in_error_en, 1);
+	if (MLX5_CAP_ETH(dev->mdev, multi_pkt_send_wqe))
+		MLX5_SET(sqc, sqc, allow_multi_pkt_send_wqe, 1);
 	MLX5_SET(sqc, sqc, state, MLX5_SQC_STATE_RST);
 	MLX5_SET(sqc, sqc, user_index, MLX5_GET(qpc, qpc, user_index));
 	MLX5_SET(sqc, sqc, cqn, MLX5_GET(qpc, qpc, cqn_snd));
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 640313da25c7..4334ce9fc803 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2448,7 +2448,7 @@ struct mlx5_ifc_sqc_bits {
 	u8         cd_master[0x1];
 	u8         fre[0x1];
 	u8         flush_in_error_en[0x1];
-	u8         reserved_at_4[0x1];
+	u8         allow_multi_pkt_send_wqe[0x1];
 	u8	   min_wqe_inline_mode[0x3];
 	u8         state[0x4];
 	u8         reg_umr[0x1];
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 64d398e662cd..a61a512e5747 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -168,6 +168,11 @@ struct mlx5_packet_pacing_caps {
 	__u32 reserved;
 };
 
+enum mlx5_ib_mpw_caps {
+	MPW_RESERVED		= 1 << 0,
+	MLX5_IB_ALLOW_MPW	= 1 << 1,
+};
+
 enum mlx5_ib_sw_parsing_offloads {
 	MLX5_IB_SW_PARSING = 1 << 0,
 	MLX5_IB_SW_PARSING_CSUM = 1 << 1,
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
