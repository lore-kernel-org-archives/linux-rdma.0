From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 13/13] IB/mlx5: Add counters read support
Date: Tue, 29 May 2018 16:09:17 +0300
Message-ID: <20180529130917.13592-14-leon@kernel.org>
References: <20180529130917.13592-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch implements the uverbs counters read API, it will use the
specific read counters function to the given type to accomplish its
task.

Tested-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f4da59e39c9e..d775fac9a1ef 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5327,6 +5327,48 @@ static void depopulate_specs_root(struct mlx5_ib_dev *dev)
 	uverbs_free_spec_tree(dev->ib_dev.specs_root);
 }

+static int mlx5_ib_read_counters(struct ib_counters *counters,
+				 struct ib_counters_read_attr *read_attr,
+				 struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
+	struct mlx5_read_counters_attr mread_attr = {};
+	u32 *desc;
+	int ret, i;
+
+	mutex_lock(&mcounters->mcntrs_mutex);
+	if (mcounters->cntrs_max_index > read_attr->ncounters) {
+		ret = -EINVAL;
+		goto err_bound;
+	}
+
+	mread_attr.out = kcalloc(mcounters->counters_num, sizeof(u64),
+				 GFP_KERNEL);
+	if (!mread_attr.out) {
+		ret = -ENOMEM;
+		goto err_bound;
+	}
+
+	mread_attr.hw_cntrs_hndl = mcounters->hw_cntrs_hndl;
+	mread_attr.flags = read_attr->flags;
+	ret = mcounters->read_counters(counters->device, &mread_attr);
+	if (ret)
+		goto err_read;
+
+	/* do the pass over the counters data array to assign according to the
+	 * descriptions and indexing pairs
+	 */
+	desc = mcounters->counters_data;
+	for (i = 0; i < mcounters->ncounters * 2; i += 2)
+		read_attr->counters_buff[desc[i + 1]] += mread_attr.out[desc[i]];
+
+err_read:
+	kfree(mread_attr.out);
+err_bound:
+	mutex_unlock(&mcounters->mcntrs_mutex);
+	return ret;
+}
+
 static int mlx5_ib_destroy_counters(struct ib_counters *counters)
 {
 	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
@@ -5600,6 +5642,7 @@ int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.driver_id = RDMA_DRIVER_MLX5;
 	dev->ib_dev.create_counters = mlx5_ib_create_counters;
 	dev->ib_dev.destroy_counters = mlx5_ib_destroy_counters;
+	dev->ib_dev.read_counters = mlx5_ib_read_counters;

 	err = init_node_data(dev);
 	if (err)
