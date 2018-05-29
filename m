From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 12/13] IB/mlx5: Add flow counters read support
Date: Tue, 29 May 2018 16:09:16 +0300
Message-ID: <20180529130917.13592-13-leon@kernel.org>
References: <20180529130917.13592-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Implements the flow counters read wrapper.

Tested-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 15 +++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 13 ++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f846956833e5..f4da59e39c9e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3149,6 +3149,19 @@ static void set_underlay_qp(struct mlx5_ib_dev *dev,
 	}
 }

+static int read_flow_counters(struct ib_device *ibdev,
+			      struct mlx5_read_counters_attr *read_attr)
+{
+	struct mlx5_fc *fc = read_attr->hw_cntrs_hndl;
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+
+	return mlx5_fc_query(dev->mdev, fc->id,
+			     &read_attr->out[IB_COUNTER_PACKETS],
+			     &read_attr->out[IB_COUNTER_BYTES]);
+}
+
+/* flow counters currently expose two counters packets and bytes */
+#define FLOW_COUNTERS_NUM 2
 static int counters_set_description(struct ib_counters *counters,
 				    enum mlx5_ib_counters_type counters_type,
 				    u32 *desc_data,
@@ -3163,6 +3176,8 @@ static int counters_set_description(struct ib_counters *counters,

 	/* init the fields for the object */
 	mcounters->type = counters_type;
+	mcounters->read_counters = read_flow_counters;
+	mcounters->counters_num = FLOW_COUNTERS_NUM;
 	mcounters->ncounters = ncounters;
 	/* each counter entry have both description and index pair */
 	for (i = 0; i < ncounters * 2; i += 2) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7313d3cd04f0..810557b5a5c1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -814,6 +814,12 @@ struct mlx5_memic {
 	DECLARE_BITMAP(memic_alloc_pages, MLX5_MAX_MEMIC_PAGES);
 };

+struct mlx5_read_counters_attr {
+	struct mlx5_fc *hw_cntrs_hndl;
+	u64 *out;
+	u32 flags;
+};
+
 enum mlx5_ib_counters_type {
 	MLX5_IB_COUNTERS_FLOW,
 };
@@ -821,7 +827,12 @@ enum mlx5_ib_counters_type {
 struct mlx5_ib_mcounters {
 	struct ib_counters ibcntrs;
 	enum mlx5_ib_counters_type type;
-	void *hw_cntrs_hndl;
+	/* number of counters supported for this counters type */
+	u32 counters_num;
+	struct mlx5_fc *hw_cntrs_hndl;
+	/* read function for this counters type */
+	int (*read_counters)(struct ib_device *ibdev,
+			     struct mlx5_read_counters_attr *read_attr);
 	/* max index set as part of create_flow */
 	u32 cntrs_max_index;
 	/* number of counters data entries (<description,index> pair) */
