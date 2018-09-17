From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/4] RDMA/mlx5: Refactor transport domain bookkeeping logic
Date: Mon, 17 Sep 2018 13:30:47 +0300
Message-ID: <20180917103049.18235-3-leon@kernel.org>
References: <20180917103049.18235-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917103049.18235-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

In preparation to enable loopback on a single user context move the logic
that enables/disables loopback to separate functions and group variables
under a single struct.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 45 +++++++++++++++++++++++-------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 +++++---
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 659af370a961..b64861ba2c42 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1571,6 +1571,32 @@ static void deallocate_uars(struct mlx5_ib_dev *dev,
 			mlx5_cmd_free_uar(dev->mdev, bfregi->sys_pages[i]);
 }
 
+static int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev)
+{
+	int err = 0;
+
+	mutex_lock(&dev->lb.mutex);
+	dev->lb.user_td++;
+
+	if (dev->lb.user_td == 2)
+		err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+
+	mutex_unlock(&dev->lb.mutex);
+
+	return err;
+}
+
+static void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev)
+{
+	mutex_lock(&dev->lb.mutex);
+	dev->lb.user_td--;
+
+	if (dev->lb.user_td < 2)
+		mlx5_nic_vport_update_local_lb(dev->mdev, false);
+
+	mutex_unlock(&dev->lb.mutex);
+}
+
 static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn)
 {
 	int err;
@@ -1587,14 +1613,7 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn)
 	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
 		return err;
 
-	mutex_lock(&dev->lb_mutex);
-	dev->user_td++;
-
-	if (dev->user_td == 2)
-		err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
-
-	mutex_unlock(&dev->lb_mutex);
-	return err;
+	return mlx5_ib_enable_lb(dev);
 }
 
 static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn)
@@ -1609,13 +1628,7 @@ static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn)
 	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
 		return;
 
-	mutex_lock(&dev->lb_mutex);
-	dev->user_td--;
-
-	if (dev->user_td < 2)
-		mlx5_nic_vport_update_local_lb(dev->mdev, false);
-
-	mutex_unlock(&dev->lb_mutex);
+	mlx5_ib_disable_lb(dev);
 }
 
 static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
@@ -5970,7 +5983,7 @@ int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
 	    (MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) ||
 	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		mutex_init(&dev->lb_mutex);
+		mutex_init(&dev->lb.mutex);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6c57872fdc4e..7b2af7e719c4 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -878,6 +878,12 @@ to_mcounters(struct ib_counters *ibcntrs)
 int parse_flow_flow_action(struct mlx5_ib_flow_action *maction,
 			   bool is_egress,
 			   struct mlx5_flow_act *action);
+struct mlx5_ib_lb_state {
+	/* protect the user_td */
+	struct mutex		mutex;
+	u32			user_td;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	const struct uverbs_object_tree_def *driver_trees[7];
@@ -919,9 +925,7 @@ struct mlx5_ib_dev {
 	const struct mlx5_ib_profile	*profile;
 	struct mlx5_eswitch_rep		*rep;
 
-	/* protect the user_td */
-	struct mutex		lb_mutex;
-	u32			user_td;
+	struct mlx5_ib_lb_state		lb;
 	u8			umr_fence;
 	struct list_head	ib_dev_list;
 	u64			sys_image_guid;
-- 
2.14.4
