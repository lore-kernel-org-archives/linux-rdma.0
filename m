From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 12/12] IB/mlx4: Advertise RoCE v2 support
Date: Thu, 14 Jan 2016 17:50:43 +0200
Message-ID: <fa0539fa313b5f53c6d507b6b5b78e833cc60d5a.1452780851.git.monis@mellanox.com>
References: <cover.1452780849.git.monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1452780849.git.monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Advertise RoCE v2 support in port_immutable attributes according to
the hardware's capabilities. This enables the verbs stack to use
RoCE v2 mode.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 63f049f..3b40a4f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2185,6 +2185,7 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 			       struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
+	struct mlx4_ib_dev *mdev = to_mdev(ibdev);
 	int err;
 
 	err = mlx4_ib_query_port(ibdev, port_num, &attr);
@@ -2194,10 +2195,15 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
-	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND)
+	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND) {
 		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
-	else
-		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	} else {
+		if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
+			immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_ROCE_V1_V2)
+			immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE |
+				RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
+	}
 
 	immutable->max_mad_size = IB_MGMT_MAD_SIZE;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
