From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Align ODP capability function with netdev coding style
Date: Mon, 11 Feb 2019 13:56:07 +0200
Message-ID: <20190211115608.22677-2-leon@kernel.org>
References: <20190211115608.22677-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211115608.22677-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Update newly introduced function to be aligned to netdev coding style.

Fixes: 46861e3e88be ("net/mlx5: Set ODP SRQ support in firmware")
Reported-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e38aa206ab6d..6d45518edbdc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -461,9 +461,9 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
 
 static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 {
-	void *set_ctx;
 	void *set_hca_cap;
-	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *set_ctx;
+	int set_sz;
 	int err;
 
 	if (!MLX5_CAP_GEN(dev, pg))
@@ -473,15 +473,12 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
-	/**
-	 * If all bits are cleared we shouldn't try to set it
-	 * or we might fail while trying to access a reserved bit.
-	 */
 	if (!(MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive) ||
 	      MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive) ||
 	      MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive)))
 		return 0;
 
+	set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	set_ctx = kzalloc(set_sz, GFP_KERNEL);
 	if (!set_ctx)
 		return -ENOMEM;
@@ -492,13 +489,13 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 
 	/* set ODP SRQ support for RC/UD and XRC transports */
 	MLX5_SET(odp_cap, set_hca_cap, ud_odp_caps.srq_receive,
-		 (MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive)));
+		 MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive));
 
 	MLX5_SET(odp_cap, set_hca_cap, rc_odp_caps.srq_receive,
-		 (MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive)));
+		 MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive));
 
 	MLX5_SET(odp_cap, set_hca_cap, xrc_odp_caps.srq_receive,
-		 (MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive)));
+		 MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive));
 
 	err = set_caps(dev, set_ctx, set_sz, MLX5_SET_HCA_CAP_OP_MOD_ODP);
 
-- 
2.19.1
