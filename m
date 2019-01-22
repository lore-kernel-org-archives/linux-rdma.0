From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 12/12] net/mlx5: Set ODP SRQ support in firmware
Date: Tue, 22 Jan 2019 08:48:51 +0200
Message-ID: <20190122064851.6032-13-leon@kernel.org>
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

To avoid compatibility issue with older kernels the firmware doesn't
allow SRQ to work with ODP unless kernel asks for it.

Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 53 +++++++++++++++++++
 include/linux/mlx5/device.h                   |  3 ++
 include/linux/mlx5/mlx5_ifc.h                 |  1 +
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index be81b319b0dc..b3a76df0cf6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -459,6 +459,53 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
 	return err;
 }
 
+static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
+{
+	void *set_ctx;
+	void *set_hca_cap;
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, pg))
+		return 0;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_ODP);
+	if (err)
+		return err;
+
+	/**
+	 * If all bits are cleared we shouldn't try to set it
+	 * or we might fail while trying to access a reserved bit.
+	 */
+	if (!(MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive) ||
+	      MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive) ||
+	      MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive)))
+		return 0;
+
+	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ODP],
+	       MLX5_ST_SZ_BYTES(odp_cap));
+
+	/* set ODP SRQ support for RC/UD and XRC transports */
+	MLX5_SET(odp_cap, set_hca_cap, ud_odp_caps.srq_receive,
+		 (MLX5_CAP_ODP_MAX(dev, ud_odp_caps.srq_receive)));
+
+	MLX5_SET(odp_cap, set_hca_cap, rc_odp_caps.srq_receive,
+		 (MLX5_CAP_ODP_MAX(dev, rc_odp_caps.srq_receive)));
+
+	MLX5_SET(odp_cap, set_hca_cap, xrc_odp_caps.srq_receive,
+		 (MLX5_CAP_ODP_MAX(dev, xrc_odp_caps.srq_receive)));
+
+	err = set_caps(dev, set_ctx, set_sz, MLX5_SET_HCA_CAP_OP_MOD_ODP);
+
+	kfree(set_ctx);
+	return err;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev)
 {
 	void *set_ctx = NULL;
@@ -926,6 +973,12 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto reclaim_boot_pages;
 	}
 
+	err = handle_hca_cap_odp(dev);
+	if (err) {
+		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
+		goto reclaim_boot_pages;
+	}
+
 	err = mlx5_satisfy_startup_pages(dev, 0);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate init pages\n");
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8c4a820bd4c1..0845a227a7b2 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1201,6 +1201,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_ODP(mdev, cap)\
 	MLX5_GET(odp_cap, mdev->caps.hca_cur[MLX5_CAP_ODP], cap)
 
+#define MLX5_CAP_ODP_MAX(mdev, cap)\
+	MLX5_GET(odp_cap, mdev->caps.hca_max[MLX5_CAP_ODP], cap)
+
 #define MLX5_CAP_VECTOR_CALC(mdev, cap) \
 	MLX5_GET(vector_calc_cap, \
 		 mdev->caps.hca_cur[MLX5_CAP_VECTOR_CALC], cap)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5407db8ba8e1..c5c679390fbd 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -72,6 +72,7 @@ enum {
 
 enum {
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
+	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 };
 
-- 
2.19.1
