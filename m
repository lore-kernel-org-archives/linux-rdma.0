From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 10/13] IB/mlx5: Add counters create and destroy support
Date: Sun, 27 May 2018 13:23:43 +0300
Message-ID: <20180527102346.15149-11-leon@kernel.org>
References: <20180527102346.15149-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180527102346.15149-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch implements the device counters create and destroy APIs
and introducing some internal management structures.

Downstream patches in this series will add the functionality to
support flow counters binding and reading.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 23 +++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 ++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 59f86198eb3b..18bfee86fa52 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5124,6 +5124,27 @@ static void depopulate_specs_root(struct mlx5_ib_dev *dev)
 	uverbs_free_spec_tree(dev->ib_dev.specs_root);
 }
 
+static int mlx5_ib_destroy_counters(struct ib_counters *counters)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
+
+	kfree(mcounters);
+
+	return 0;
+}
+
+static struct ib_counters *mlx5_ib_create_counters(struct ib_device *device,
+						   struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_mcounters *mcounters;
+
+	mcounters = kzalloc(sizeof(*mcounters), GFP_KERNEL);
+	if (!mcounters)
+		return ERR_PTR(-ENOMEM);
+
+	return &mcounters->ibcntrs;
+}
+
 void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_cleanup_multiport_master(dev);
@@ -5367,6 +5388,8 @@ int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.destroy_flow_action = mlx5_ib_destroy_flow_action;
 	dev->ib_dev.modify_flow_action_esp = mlx5_ib_modify_flow_action_esp;
 	dev->ib_dev.driver_id = RDMA_DRIVER_MLX5;
+	dev->ib_dev.create_counters = mlx5_ib_create_counters;
+	dev->ib_dev.destroy_counters = mlx5_ib_destroy_counters;
 
 	err = init_node_data(dev);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 49a1aa0ff429..fd27ec1aed08 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -813,6 +813,16 @@ struct mlx5_memic {
 	DECLARE_BITMAP(memic_alloc_pages, MLX5_MAX_MEMIC_PAGES);
 };
 
+struct mlx5_ib_mcounters {
+	struct ib_counters ibcntrs;
+};
+
+static inline struct mlx5_ib_mcounters *
+to_mcounters(struct ib_counters *ibcntrs)
+{
+	return container_of(ibcntrs, struct mlx5_ib_mcounters, ibcntrs);
+}
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
-- 
2.14.3
