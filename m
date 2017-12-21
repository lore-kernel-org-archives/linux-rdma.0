From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/2] IB/mlx5: Fix congestion counters in LAG mode
Date: Thu, 21 Dec 2017 17:38:26 +0200
Message-ID: <20171221153827.16793-2-leon@kernel.org>
References: <20171221153827.16793-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171221153827.16793-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Congestion counters are counted and queried per physical function.
When working in LAG mode, CNP packets can be sent or received on both
of the functions, thus congestion counters should be aggregated from
the two physical functions.

Fixes: e1f24a79f424 ("IB/mlx5: Support congestion related counters")
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Aviv Heller <avivh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cmd.c              | 11 ------
 drivers/infiniband/hw/mlx5/cmd.h              |  2 -
 drivers/infiniband/hw/mlx5/main.c             | 35 +++--------------
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 56 +++++++++++++++++++++++++++
 include/linux/mlx5/driver.h                   |  4 ++
 5 files changed, 66 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 470995fa38d2..6f6712f87a73 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -47,17 +47,6 @@ int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey)
 	return err;
 }
 
-int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
-				bool reset, void *out, int out_size)
-{
-	u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = { };
-
-	MLX5_SET(query_cong_statistics_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_CONG_STATISTICS);
-	MLX5_SET(query_cong_statistics_in, in, clear, reset);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size);
-}
-
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out, int out_size)
 {
diff --git a/drivers/infiniband/hw/mlx5/cmd.h b/drivers/infiniband/hw/mlx5/cmd.h
index af4c24596274..78ffded7cc2c 100644
--- a/drivers/infiniband/hw/mlx5/cmd.h
+++ b/drivers/infiniband/hw/mlx5/cmd.h
@@ -37,8 +37,6 @@
 #include <linux/mlx5/driver.h>
 
 int mlx5_cmd_null_mkey(struct mlx5_core_dev *dev, u32 *null_mkey);
-int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
-				bool reset, void *out, int out_size);
 int mlx5_cmd_query_cong_params(struct mlx5_core_dev *dev, int cong_point,
 			       void *out, int out_size);
 int mlx5_cmd_modify_cong_params(struct mlx5_core_dev *mdev,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 543d0a4c8bf3..b4ef4d9b6ce5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3737,34 +3737,6 @@ static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int mlx5_ib_query_cong_counters(struct mlx5_ib_dev *dev,
-				       struct mlx5_ib_port *port,
-				       struct rdma_hw_stats *stats)
-{
-	int outlen = MLX5_ST_SZ_BYTES(query_cong_statistics_out);
-	void *out;
-	int ret, i;
-	int offset = port->cnts.num_q_counters;
-
-	out = kvzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return -ENOMEM;
-
-	ret = mlx5_cmd_query_cong_counter(dev->mdev, false, out, outlen);
-	if (ret)
-		goto free;
-
-	for (i = 0; i < port->cnts.num_cong_counters; i++) {
-		stats->value[i + offset] =
-			be64_to_cpup((__be64 *)(out +
-				     port->cnts.offsets[i + offset]));
-	}
-
-free:
-	kvfree(out);
-	return ret;
-}
-
 static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 				struct rdma_hw_stats *stats,
 				u8 port_num, int index)
@@ -3782,7 +3754,12 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	num_counters = port->cnts.num_q_counters;
 
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
-		ret = mlx5_ib_query_cong_counters(dev, port, stats);
+		ret = mlx5_lag_query_cong_counters(dev->mdev,
+						   stats->value +
+						   port->cnts.num_q_counters,
+						   port->cnts.num_cong_counters,
+						   port->cnts.offsets +
+						   port->cnts.num_q_counters);
 		if (ret)
 			return ret;
 		num_counters += port->cnts.num_cong_counters;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index f26f97fe4666..582b2f18010a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -137,6 +137,17 @@ int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_cmd_destroy_vport_lag);
 
+static int mlx5_cmd_query_cong_counter(struct mlx5_core_dev *dev,
+				       bool reset, void *out, int out_size)
+{
+	u32 in[MLX5_ST_SZ_DW(query_cong_statistics_in)] = { };
+
+	MLX5_SET(query_cong_statistics_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_CONG_STATISTICS);
+	MLX5_SET(query_cong_statistics_in, in, clear, reset);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, out_size);
+}
+
 static struct mlx5_lag *mlx5_lag_dev_get(struct mlx5_core_dev *dev)
 {
 	return dev->priv.lag;
@@ -633,3 +644,48 @@ bool mlx5_lag_intf_add(struct mlx5_interface *intf, struct mlx5_priv *priv)
 	/* If bonded, we do not add an IB device for PF1. */
 	return false;
 }
+
+int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
+				 u64 *values,
+				 int num_counters,
+				 size_t *offsets)
+{
+	int outlen = MLX5_ST_SZ_BYTES(query_cong_statistics_out);
+	struct mlx5_core_dev *mdev[MLX5_MAX_PORTS];
+	struct mlx5_lag *ldev;
+	int num_ports;
+	int ret, i, j;
+	void *out;
+
+	out = kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	memset(values, 0, sizeof(*values) * num_counters);
+
+	mutex_lock(&lag_mutex);
+	ldev = mlx5_lag_dev_get(dev);
+	if (ldev && mlx5_lag_is_bonded(ldev)) {
+		num_ports = MLX5_MAX_PORTS;
+		mdev[0] = ldev->pf[0].dev;
+		mdev[1] = ldev->pf[1].dev;
+	} else {
+		num_ports = 1;
+		mdev[0] = dev;
+	}
+
+	for (i = 0; i < num_ports; ++i) {
+		ret = mlx5_cmd_query_cong_counter(mdev[i], false, out, outlen);
+		if (ret)
+			goto unlock;
+
+		for (j = 0; j < num_counters; ++j)
+			values[j] += be64_to_cpup((__be64 *)(out + offsets[j]));
+	}
+
+unlock:
+	mutex_unlock(&lag_mutex);
+	kvfree(out);
+	return ret;
+}
+EXPORT_SYMBOL(mlx5_lag_query_cong_counters);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a886b51511ab..8846919356ca 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1164,6 +1164,10 @@ int mlx5_cmd_create_vport_lag(struct mlx5_core_dev *dev);
 int mlx5_cmd_destroy_vport_lag(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
+int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
+				 u64 *values,
+				 int num_counters,
+				 size_t *offsets);
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
