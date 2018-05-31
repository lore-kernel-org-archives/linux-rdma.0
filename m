From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v3 14/14] IB/mlx5: Add counters read support
Date: Thu, 31 May 2018 16:43:41 +0300
Message-ID: <20180531134341.18441-15-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch implements the uverbs counters read API, it will use the
specific read counters function to the given type to accomplish its
task.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e7c90c151165..d0c94c2b49de 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5335,6 +5335,48 @@ static void depopulate_specs_root(struct mlx5_ib_dev *dev)
 	uverbs_free_spec_tree(dev->ib_dev.specs_root);
 }
 
+static int mlx5_ib_read_counters(struct ib_counters *counters,
+				 struct ib_counters_read_attr *read_attr,
+				 struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_mcounters *mcounters = to_mcounters(counters);
+	struct mlx5_read_counters_attr mread_attr = {};
+	struct mlx5_ib_flow_counters_desc *desc;
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
+	for (i = 0; i < mcounters->ncounters; i++)
+		read_attr->counters_buff[desc[i].index] += mread_attr.out[desc[i].description];
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
@@ -5608,6 +5650,7 @@ int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.driver_id = RDMA_DRIVER_MLX5;
 	dev->ib_dev.create_counters = mlx5_ib_create_counters;
 	dev->ib_dev.destroy_counters = mlx5_ib_destroy_counters;
+	dev->ib_dev.read_counters = mlx5_ib_read_counters;
 
 	err = init_node_data(dev);
 	if (err)
-- 
2.14.3
