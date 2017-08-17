From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 1/8] IB/mlx5: Expose software parsing for Raw Ethernet QP
Date: Thu, 17 Aug 2017 15:52:28 +0300
Message-ID: <20170817125235.5107-2-leon@kernel.org>
References: <20170817125235.5107-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Software parsing (SWP) is a feature that can be used to instruct the
device to stop using its internal parser and to parse packets on the
transmit path according to offsets set for each packets.

Through this feature, the device allows the handling of checksum and
LSO by the hardware according to the location of IP and TCP/UDP
headers.

Enable SW parsing on Raw Ethernet send queue by default if firmware
supports it and report these capabilities to user space.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 21 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c   |  3 +++
 include/uapi/rdma/mlx5-abi.h      | 17 +++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 894aec4a7c9d..544b0ae5d8dc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -821,6 +821,27 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (field_avail(typeof(resp), reserved, uhw->outlen))
 		resp.response_length += sizeof(resp.reserved);
 
+	if (field_avail(typeof(resp), sw_parsing_caps,
+			uhw->outlen)) {
+		resp.response_length += sizeof(resp.sw_parsing_caps);
+		if (MLX5_CAP_ETH(mdev, swp)) {
+			resp.sw_parsing_caps.sw_parsing_offloads |=
+				MLX5_IB_SW_PARSING;
+
+			if (MLX5_CAP_ETH(mdev, swp_csum))
+				resp.sw_parsing_caps.sw_parsing_offloads |=
+					MLX5_IB_SW_PARSING_CSUM;
+
+			if (MLX5_CAP_ETH(mdev, swp_lso))
+				resp.sw_parsing_caps.sw_parsing_offloads |=
+					MLX5_IB_SW_PARSING_LSO;
+
+			if (resp.sw_parsing_caps.sw_parsing_offloads)
+				resp.sw_parsing_caps.supported_qpts =
+					BIT(IB_QPT_RAW_PACKET);
+		}
+	}
+
 	if (uhw->outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ebbfd721661d..e58cc42a77a2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1083,6 +1083,9 @@ static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
 	MLX5_SET(sqc, sqc, cqn, MLX5_GET(qpc, qpc, cqn_snd));
 	MLX5_SET(sqc, sqc, tis_lst_sz, 1);
 	MLX5_SET(sqc, sqc, tis_num_0, sq->tisn);
+	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
+	    MLX5_CAP_ETH(dev->mdev, swp))
+		MLX5_SET(sqc, sqc, allow_swp, 1);
 
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
 	MLX5_SET(wq, wq, wq_type, MLX5_WQ_TYPE_CYCLIC);
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 0b3d30837a9f..64d398e662cd 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -168,6 +168,22 @@ struct mlx5_packet_pacing_caps {
 	__u32 reserved;
 };
 
+enum mlx5_ib_sw_parsing_offloads {
+	MLX5_IB_SW_PARSING = 1 << 0,
+	MLX5_IB_SW_PARSING_CSUM = 1 << 1,
+	MLX5_IB_SW_PARSING_LSO = 1 << 2,
+};
+
+struct mlx5_ib_sw_parsing_caps {
+	__u32 sw_parsing_offloads; /* enum mlx5_ib_sw_parsing_offloads */
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
@@ -177,6 +193,7 @@ struct mlx5_ib_query_device_resp {
 	struct	mlx5_packet_pacing_caps packet_pacing_caps;
 	__u32	mlx5_ib_support_multi_pkt_send_wqes;
 	__u32	reserved;
+	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
 };
 
 struct mlx5_ib_create_cq {
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
