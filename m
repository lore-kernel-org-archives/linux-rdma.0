From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Support RoCE ICRC encapsulated error counter
Date: Thu, 21 Jun 2018 15:37:56 +0300
Message-ID: <20180621123756.32645-3-leon@kernel.org>
References: <20180621123756.32645-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180621123756.32645-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Talat Batheesh <talatb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb@mellanox.com>

This patch adds support to query the counter that counts the
RoCE packets with corrupted ICRC (Invariant Cyclic Redundancy Code).

This counter will be under
/sys/class/infiniband/<mlx5-dev>/ports/<port>/hw_counters/

rx_icrc_encapsulated - The number of RoCE packets with ICRC
error.

Signed-off-by: Talat Batheesh <talatb@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c     | 12 +++++++
 drivers/infiniband/hw/mlx5/cmd.h     |  1 +
 drivers/infiniband/hw/mlx5/main.c    | 62 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 4 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index ccc0b5d06a7d..c84fef9a8a08 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -185,3 +185,15 @@ int mlx5_cmd_dealloc_memic(struct mlx5_memic *memic, u64 addr, u64 length)
 
 	return err;
 }
+
+int mlx5_cmd_query_ext_ppcnt_counters(struct mlx5_core_dev *dev, void *out)
+{
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_ETHERNET_EXTENDED_COUNTERS_GROUP);
+	return  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPCNT,
+				     0, 0);
+}
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index 98ea4648c655..88cbb1c41703 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -41,6 +41,7 @@ int mlx5_cmd_dump_fill_mkey(struct mlx5_core_dev *dev, u32 *mkey);
 int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out, int out_size);
+int mlx5_cmd_query_ext_ppcnt_counters(struct mlx5_core_dev *dev, void *out);
 int mlx5_cmd_modify_cong_params(struct mlx5_core_dev *mdev,
 				void *in, int in_size);
 int mlx5_cmd_alloc_memic(struct mlx5_memic *memic, phys_addr_t *addr,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7c3956f8e0f3..32eae0d651cf 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4691,6 +4691,15 @@ static const struct mlx5_ib_counter extended_err_cnts[] = {
 	INIT_Q_COUNTER(req_cqe_flush_error),
 };
 
+#define INIT_EXT_PPCNT_COUNTER(_name)		\
+	{ .name = #_name, .offset =	\
+	MLX5_BYTE_OFF(ppcnt_reg, \
+		      counter_set.eth_extended_cntrs_grp_data_layout._name##_high)}
+
+static const struct mlx5_ib_counter ext_ppcnt_cnts[] = {
+	INIT_EXT_PPCNT_COUNTER(rx_icrc_encapsulated),
+};
+
 static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
 	int i;
@@ -4726,7 +4735,10 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 		cnts->num_cong_counters = ARRAY_SIZE(cong_cnts);
 		num_counters += ARRAY_SIZE(cong_cnts);
 	}
-
+	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
+		cnts->num_ext_ppcnt_counters = ARRAY_SIZE(ext_ppcnt_cnts);
+		num_counters += ARRAY_SIZE(ext_ppcnt_cnts);
+	}
 	cnts->names = kcalloc(num_counters, sizeof(cnts->names), GFP_KERNEL);
 	if (!cnts->names)
 		return -ENOMEM;
@@ -4783,6 +4795,13 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 			offsets[j] = cong_cnts[i].offset;
 		}
 	}
+
+	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
+		for (i = 0; i < ARRAY_SIZE(ext_ppcnt_cnts); i++, j++) {
+			names[j] = ext_ppcnt_cnts[i].name;
+			offsets[j] = ext_ppcnt_cnts[i].offset;
+		}
+	}
 }
 
 static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
@@ -4828,7 +4847,8 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 
 	return rdma_alloc_hw_stats_struct(port->cnts.names,
 					  port->cnts.num_q_counters +
-					  port->cnts.num_cong_counters,
+					  port->cnts.num_cong_counters +
+					  port->cnts.num_ext_ppcnt_counters,
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
 }
 
@@ -4861,6 +4881,34 @@ static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 	return ret;
 }
 
+static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,
+					  struct mlx5_ib_port *port,
+					  struct rdma_hw_stats *stats)
+{
+	int offset = port->cnts.num_q_counters + port->cnts.num_cong_counters;
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+	int ret, i;
+	void *out;
+
+	out = kvzalloc(sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	ret = mlx5_cmd_query_ext_ppcnt_counters(dev->mdev, out);
+	if (ret)
+		goto free;
+
+	for (i = 0; i < port->cnts.num_ext_ppcnt_counters; i++) {
+		stats->value[i + offset] =
+			be64_to_cpup((__be64 *)(out +
+				    port->cnts.offsets[i + offset]));
+	}
+
+free:
+	kvfree(out);
+	return ret;
+}
+
 static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 				struct rdma_hw_stats *stats,
 				u8 port_num, int index)
@@ -4874,13 +4922,21 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	if (!stats)
 		return -EINVAL;
 
-	num_counters = port->cnts.num_q_counters + port->cnts.num_cong_counters;
+	num_counters = port->cnts.num_q_counters +
+		       port->cnts.num_cong_counters +
+		       port->cnts.num_ext_ppcnt_counters;
 
 	/* q_counters are per IB device, query the master mdev */
 	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats);
 	if (ret)
 		return ret;
 
+	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
+		ret =  mlx5_ib_query_ext_ppcnt_counters(dev, port, stats);
+		if (ret)
+			return ret;
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
 		mdev = mlx5_ib_get_native_port_mdev(dev, port_num,
 						    &mdev_port_num);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 0f95453b11db..67e86c8304a2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -666,6 +666,7 @@ struct mlx5_ib_counters {
 	size_t *offsets;
 	u32 num_q_counters;
 	u32 num_cong_counters;
+	u32 num_ext_ppcnt_counters;
 	u16 set_id;
 	bool set_id_valid;
 };
-- 
2.14.4
