From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 2/2] IB/mlx5: Report mlx5 LSO capabilities when querying device
Date: Wed, 27 Apr 2016 17:04:52 +0300
Message-ID: <1461765892-1285-3-git-send-email-matanb@mellanox.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461765892-1285-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

mlx5 based hardware supports LSO for Raw Ethernet QPs.
LSO (large segment offload) applied here is mainly used
for TCP (also known as TSO).

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5acf346..3716001e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -454,6 +454,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	int max_rq_sg;
 	int max_sq_sg;
 	u64 min_page_size = 1ull << MLX5_CAP_GEN(mdev, log_pg_sz);
+	u64 max_lso;
 
 	if (uhw->inlen || uhw->outlen)
 		return -EINVAL;
@@ -508,10 +509,18 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (MLX5_CAP_GEN(mdev, block_lb_mc))
 		props->device_cap_flags |= IB_DEVICE_BLOCK_MULTICAST_LOOPBACK;
 
-	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
-	    (MLX5_CAP_ETH(dev->mdev, csum_cap)))
+	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads)) {
+		if (MLX5_CAP_ETH(mdev, csum_cap))
 			props->device_cap_flags |= IB_DEVICE_RAW_IP_CSUM;
 
+		max_lso = MLX5_CAP_ETH(mdev, max_lso_cap);
+		if (max_lso) {
+			props->lso_caps.max_lso = 1 << max_lso;
+			props->lso_caps.supported_qpts |=
+				1 << IB_QPT_RAW_PACKET;
+		}
+	}
+
 	if (MLX5_CAP_GEN(mdev, ipoib_basic_offloads)) {
 		props->device_cap_flags |= IB_DEVICE_UD_IP_CSUM;
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
