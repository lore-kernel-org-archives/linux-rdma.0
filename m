From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 11/12] IB/mlx5: Advertise XRC ODP support
Date: Tue, 22 Jan 2019 08:48:50 +0200
Message-ID: <20190122064851.6032-12-leon@kernel.org>
References: <20190122064851.6032-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190122064851.6032-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

Query all per transport caps for XRC and set the appropriate bits in the
per transport field of the advertised struct.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 6d2ed8c6ed17..d3fdc0853b4b 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -336,6 +336,24 @@ void mlx5_ib_internal_fill_odp_caps(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_ODP(dev->mdev, rc_odp_caps.srq_receive))
 		caps->per_transport_caps.rc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
 
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.send))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_SEND;
+
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.receive))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_RECV;
+
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.write))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_WRITE;
+
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.read))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_READ;
+
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.atomic))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_ATOMIC;
+
+	if (MLX5_CAP_ODP(dev->mdev, xrc_odp_caps.srq_receive))
+		caps->per_transport_caps.xrc_odp_caps |= IB_ODP_SUPPORT_SRQ_RECV;
+
 	if (MLX5_CAP_GEN(dev->mdev, fixed_buffer_size) &&
 	    MLX5_CAP_GEN(dev->mdev, null_mkey) &&
 	    MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-- 
2.19.1
