From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next] net/mlx5: Separate ODP capabilities
Date: Tue, 19 Feb 2019 15:06:37 +0200
Message-ID: <20190219130638.21981-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Moni Shoua <monis@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

ODP support for XRC transport is not enabled by default in FW,
so we need separate ODP checks to enable/disable it.

While that, rewrite the set of ODP SRQ support capabilities in way
that tests each field separately for clearness, which is not needed
for current FW, but better to have it separated.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 29 ++++++++++---------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 025dfaf3466b..5cf557a77f0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -474,11 +474,6 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
-	if (!(MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive) ||
-	      MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive) ||
-	      MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive)))
-		return 0;
-
 	set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	set_ctx = kzalloc(set_sz, GFP_KERNEL);
 	if (!set_ctx)
@@ -488,15 +483,21 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ODP],
 	       MLX5_ST_SZ_BYTES(odp_cap));
 
-	/* set ODP SRQ support for RC/UD and XRC transports */
-	MLX5_SET(odp_cap, set_hca_cap, ud_odp_caps.srq_receive,
-		 MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive));
-
-	MLX5_SET(odp_cap, set_hca_cap, rc_odp_caps.srq_receive,
-		 MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive));
-
-	MLX5_SET(odp_cap, set_hca_cap, xrc_odp_caps.srq_receive,
-		 MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive));
+#define ODP_CAP_SET_MAX(dev, field)                                            \
+	do {                                                                   \
+		u32 _res = MLX5_CAP_ODP_MAX(dev, field);                       \
+		if (_res)                                                      \
+			MLX5_SET(odp_cap, set_hca_cap, field, _res);           \
+	} while (0)
+
+	ODP_CAP_SET_MAX(dev, ud_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, rc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.srq_receive);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.send);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.receive);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.write);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.read);
+	ODP_CAP_SET_MAX(dev, xrc_odp_caps.atomic);
 
 	err = set_caps(dev, set_ctx, set_sz, MLX5_SET_HCA_CAP_OP_MOD_ODP);
 
-- 
2.19.1
