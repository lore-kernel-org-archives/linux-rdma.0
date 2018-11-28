From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 07/11] RDMA/mlx5: Use stages for callback to setup and release DEVX
Date: Wed, 28 Nov 2018 20:53:39 +0200
Message-ID: <20181128185343.21669-8-leon@kernel.org>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Reuse existing infrastructure to initialize and release DEVX uid.
The DevX interface is intended for user space access, so it is supposed
to be initialized before ib_register_device(). Also it isn't supported
in switchdev mode and don't need to initialize it in that mode.

Fixes: 76dc5a8406bf ("IB/mlx5: Manage device uid for DEVX white list commands")
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 26 +++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b3d9af0cafc2..b15f1a70d33b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6218,6 +6218,22 @@ static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_notifier_unregister(dev->mdev, &dev->mdev_events);
 }

+static int mlx5_ib_stage_devx_init(struct mlx5_ib_dev *dev)
+{
+	int uid;
+
+	uid = mlx5_ib_devx_create(dev);
+	if (uid > 0)
+		dev->devx_whitelist_uid = uid;
+
+	return 0;
+}
+static void mlx5_ib_stage_devx_cleanup(struct mlx5_ib_dev *dev)
+{
+	if (dev->devx_whitelist_uid)
+		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
+}
+
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage)
@@ -6229,8 +6245,6 @@ void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 			profile->stage[stage].cleanup(dev);
 	}

-	if (dev->devx_whitelist_uid)
-		mlx5_ib_devx_destroy(dev, dev->devx_whitelist_uid);
 	ib_dealloc_device((struct ib_device *)dev);
 }

@@ -6239,7 +6253,6 @@ void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
 {
 	int err;
 	int i;
-	int uid;

 	for (i = 0; i < MLX5_IB_STAGE_MAX; i++) {
 		if (profile->stage[i].init) {
@@ -6249,10 +6262,6 @@ void *__mlx5_ib_add(struct mlx5_ib_dev *dev,
 		}
 	}

-	uid = mlx5_ib_devx_create(dev);
-	if (uid > 0)
-		dev->devx_whitelist_uid = uid;
-
 	dev->profile = profile;
 	dev->ib_active = true;

@@ -6304,6 +6313,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_PRE_IB_REG_UMR,
 		     NULL,
 		     mlx5_ib_stage_pre_ib_reg_umr_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_WHITELIST_UID,
+		     mlx5_ib_stage_devx_init,
+		     mlx5_ib_stage_devx_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_IB_REG,
 		     mlx5_ib_stage_ib_reg_init,
 		     mlx5_ib_stage_ib_reg_cleanup),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 24af6fbb43e7..fe34129bb780 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -782,6 +782,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_UAR,
 	MLX5_IB_STAGE_BFREG,
 	MLX5_IB_STAGE_PRE_IB_REG_UMR,
+	MLX5_IB_STAGE_WHITELIST_UID,
 	MLX5_IB_STAGE_IB_REG,
 	MLX5_IB_STAGE_POST_IB_REG_UMR,
 	MLX5_IB_STAGE_DELAY_DROP,
