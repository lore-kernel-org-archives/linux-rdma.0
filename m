From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 12/13] IB/mlx5: Add flow counters read support
Date: Sun, 27 May 2018 13:23:45 +0300
Message-ID: <20180527102346.15149-13-leon@kernel.org>
References: <20180527102346.15149-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180527102346.15149-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Implements the flow counters read wrapper.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 16 ++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 11 +++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f1e957946e6..2044d9f69a83 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3150,7 +3150,21 @@ static void set_underlay_qp(struct mlx5_ib_dev *dev,
 	}
 }
 
+static int read_flow_counters(struct ib_device *ibdev,
+			       struct mlx5_read_counters_attr *read_attr)
+{
+	struct mlx5_fc *fc = (struct mlx5_fc *)(read_attr->hw_cntrs_hndl);
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+
+	return mlx5_fc_query(dev->mdev, fc->id,
+			     &read_attr->out[IB_COUNTER_PACKETS],
+			     &read_attr->out[IB_COUNTER_BYTES]);
+}
+
 #define MAX_COUNTERS_NUM (USHRT_MAX / (sizeof(u32) * 2))
+/* flow counters currently expose two counters packets and bytes */
+#define FLOW_COUNTERS_NUM 2
+
 static int counters_set_description(struct ib_counters *counters,
 				    enum mlx5_ib_counters_type counters_type,
 				    const void __user *cntrs_data,
@@ -3182,6 +3196,8 @@ static int counters_set_description(struct ib_counters *counters,
 
 	/* init the fields for the object */
 	mcounters->type = counters_type;
+	mcounters->read_counters = read_flow_counters;
+	mcounters->counters_num = FLOW_COUNTERS_NUM;
 	mcounters->ncounters = ncounters;
 	desc = mcounters->counters_data;
 	for (i = 0; i < ncounters * 2; i += 2) {
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7313d3cd04f0..1baee579d84b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -814,6 +814,12 @@ struct mlx5_memic {
 	DECLARE_BITMAP(memic_alloc_pages, MLX5_MAX_MEMIC_PAGES);
 };
 
+struct mlx5_read_counters_attr {
+	void *hw_cntrs_hndl;
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
+	/* number of counters supported for this counters type */
+	u32 counters_num;
 	void *hw_cntrs_hndl;
+	/* read function for this counters type */
+	int (*read_counters)(struct ib_device *ibdev,
+			     struct mlx5_read_counters_attr *read_attr);
 	/* max index set as part of create_flow */
 	u32 cntrs_max_index;
 	/* number of counters data entries (<description,index> pair) */
-- 
2.14.3
