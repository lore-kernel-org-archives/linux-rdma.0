From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 14/15] IB/mlx5: Don't advertise RAW QP support in dual port mode
Date: Thu,  4 Jan 2018 11:06:44 +0200
Message-ID: <20180104090645.4901-15-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When operating in dual port RoCE mode FW doesn't support steering for
raw QPs on the slave port. They still work on the master port, but
the user has no way of knowing which port is the master. The
capability is reported per device, not per port.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 653b56377e69..5d6fba986fa5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -731,6 +731,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_rq_sg;
 	int max_sq_sg;
 	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	bool raw_support = !mlx5_core_mp_enabled(mdev);
 	struct mlx5_ib_query_device_resp resp = {};
 	size_t resp_len;
 	u64 max_tso;
@@ -794,7 +795,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
 		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
-	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads)) {
+	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) && raw_support) {
 		if (MLX5_CAP_ETH(mdev, csum_cap)) {
 			/* Legacy bit to support old userspace libraries */
 			props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
@@ -843,7 +844,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(dev->mdev, rq_delay_drop) &&
-	    MLX5_CAP_GEN(dev->mdev, general_notification_event))
+	    MLX5_CAP_GEN(dev->mdev, general_notification_event) &&
+	    raw_support)
 		props->raw_packet_caps |= IB_RAW_PACKET_CAP_DELAY_DROP;
 
 	if (MLX5_CAP_GEN(mdev, ipoib_enhanced_offloads) &&
@@ -851,7 +853,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
 
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-	    MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
+	    MLX5_CAP_ETH(dev->mdev, scatter_fcs) &&
+	    raw_support) {
 		/* Legacy bit to support old userspace libraries */
 		props->device_cap_flags |= IB_DEVICE_RAW_SCATTER_FCS;
 		props->raw_packet_caps |= IB_RAW_PACKET_CAP_SCATTER_FCS;
@@ -915,7 +918,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_VIRTUAL_FUNCTION;
 
 	if (mlx5_ib_port_link_layer(ibdev, 1) ==
-	    IB_LINK_LAYER_ETHERNET) {
+	    IB_LINK_LAYER_ETHERNET && raw_support) {
 		props->rss_caps.max_rwq_indirection_tables =
 			1 << MLX5_CAP_GEN(dev->mdev, log_max_rqt);
 		props->rss_caps.max_rwq_indirection_table_size =
@@ -952,7 +955,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		resp.response_length += sizeof(resp.cqe_comp_caps);
 	}
 
-	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen)) {
+	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen) &&
+	    raw_support) {
 		if (MLX5_CAP_QOS(mdev, packet_pacing) &&
 		    MLX5_CAP_GEN(mdev, qos)) {
 			resp.packet_pacing_caps.qp_rate_limit_max =
@@ -1011,7 +1015,8 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}
 
-	if (field_avail(typeof(resp), striding_rq_caps, uhw->outlen)) {
+	if (field_avail(typeof(resp), striding_rq_caps, uhw->outlen) &&
+	    raw_support) {
 		resp.response_length += sizeof(resp.striding_rq_caps);
 		if (MLX5_CAP_GEN(mdev, striding_rq)) {
 			resp.striding_rq_caps.min_single_stride_log_num_of_bytes =
@@ -3681,12 +3686,14 @@ static u32 get_core_cap_flags(struct ib_device *ibdev)
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(ibdev, 1);
 	u8 l3_type_cap = MLX5_CAP_ROCE(dev->mdev, l3_type);
 	u8 roce_version_cap = MLX5_CAP_ROCE(dev->mdev, roce_version);
+	bool raw_support = !mlx5_core_mp_enabled(dev->mdev);
 	u32 ret = 0;
 
 	if (ll == IB_LINK_LAYER_INFINIBAND)
 		return RDMA_CORE_PORT_IBA_IB;
 
-	ret = RDMA_CORE_PORT_RAW_PACKET;
+	if (raw_support)
+		ret = RDMA_CORE_PORT_RAW_PACKET;
 
 	if (!(l3_type_cap & MLX5_ROCE_L3_TYPE_IPV4_CAP))
 		return ret;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
