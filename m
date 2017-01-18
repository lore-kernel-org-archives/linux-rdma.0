From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] IB/mlx5: Expose Q counters groups only when they are supported by FW
Date: Wed, 18 Jan 2017 15:25:09 +0200
Message-ID: <20170118132510.4586-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch modify the Q counters implementation, so each one of the
three Q counters groups will be exposed by the driver only if they are
supported by the firmware.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 158 ++++++++++++++++++++++++++---------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   9 +-
 drivers/infiniband/hw/mlx5/qp.c      |   4 +-
 3 files changed, 128 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a191b93..b200431 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3002,13 +3002,102 @@ static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 		mlx5_nic_vport_disable_roce(dev->mdev);
 }
 
+struct mlx5_ib_q_counter {
+	const char *name;
+	size_t offset;
+};
+
+#define INIT_Q_COUNTER(_name)		\
+	{ .name = #_name, .offset = MLX5_BYTE_OFF(query_q_counter_out, _name)}
+
+static const struct mlx5_ib_q_counter basic_q_cnts[] = {
+	INIT_Q_COUNTER(rx_write_requests),
+	INIT_Q_COUNTER(rx_read_requests),
+	INIT_Q_COUNTER(rx_atomic_requests),
+	INIT_Q_COUNTER(out_of_buffer),
+};
+
+static const struct mlx5_ib_q_counter out_of_seq_q_cnts[] = {
+	INIT_Q_COUNTER(out_of_sequence),
+};
+
+static const struct mlx5_ib_q_counter retrans_q_cnts[] = {
+	INIT_Q_COUNTER(duplicate_request),
+	INIT_Q_COUNTER(rnr_nak_retry_err),
+	INIT_Q_COUNTER(packet_seq_err),
+	INIT_Q_COUNTER(implied_nak_seq_err),
+	INIT_Q_COUNTER(local_ack_timeout_err),
+};
+
 static void mlx5_ib_dealloc_q_counters(struct mlx5_ib_dev *dev)
 {
 	unsigned int i;
 
-	for (i = 0; i < dev->num_ports; i++)
+	for (i = 0; i < dev->num_ports; i++) {
 		mlx5_core_dealloc_q_counter(dev->mdev,
-					    dev->port[i].q_cnt_id);
+					    dev->port[i].q_cnts.set_id);
+		kfree(dev->port[i].q_cnts.names);
+		kfree(dev->port[i].q_cnts.offsets);
+	}
+}
+
+static int __mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev,
+				      const char ***names,
+				      size_t **offsets,
+				      u32 *num)
+{
+	u32 num_counters;
+
+	num_counters = ARRAY_SIZE(basic_q_cnts);
+
+	if (MLX5_CAP_GEN(dev->mdev, out_of_seq_cnt))
+		num_counters += ARRAY_SIZE(out_of_seq_q_cnts);
+
+	if (MLX5_CAP_GEN(dev->mdev, retransmission_q_counters))
+		num_counters += ARRAY_SIZE(retrans_q_cnts);
+
+	*names = kcalloc(num_counters, sizeof(**names), GFP_KERNEL);
+	if (!*names)
+		return -ENOMEM;
+
+	*offsets = kcalloc(num_counters, sizeof(**offsets), GFP_KERNEL);
+	if (!*offsets)
+		goto err_names;
+
+	*num = num_counters;
+
+	return 0;
+
+err_names:
+	kfree(*names);
+	return -ENOMEM;
+}
+
+static void mlx5_ib_fill_q_counters(struct mlx5_ib_dev *dev,
+				    const char **names,
+				    size_t *offsets)
+{
+	int i;
+	int j = 0;
+
+	for (i = 0; i < ARRAY_SIZE(basic_q_cnts); i++, j++) {
+		names[j] = basic_q_cnts[i].name;
+		offsets[j] = basic_q_cnts[i].offset;
+	}
+
+	if (MLX5_CAP_GEN(dev->mdev, out_of_seq_cnt)) {
+		for (i = 0; i < ARRAY_SIZE(out_of_seq_q_cnts); i++, j++) {
+			names[j] = out_of_seq_q_cnts[i].name;
+			offsets[j] = out_of_seq_q_cnts[i].offset;
+		}
+	}
+
+	if (MLX5_CAP_GEN(dev->mdev, retransmission_q_counters)) {
+		for (i = 0; i < ARRAY_SIZE(retrans_q_cnts); i++, j++) {
+			names[j] = retrans_q_cnts[i].name;
+			offsets[j] = retrans_q_cnts[i].offset;
+		}
+	}
 }
 
 static int mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
@@ -3017,14 +3106,26 @@ static int mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
 	int ret;
 
 	for (i = 0; i < dev->num_ports; i++) {
+		struct mlx5_ib_port *port = &dev->port[i];
+
 		ret = mlx5_core_alloc_q_counter(dev->mdev,
-						&dev->port[i].q_cnt_id);
+						&port->q_cnts.set_id);
 		if (ret) {
 			mlx5_ib_warn(dev,
 				     "couldn't allocate queue counter for port %d, err %d\n",
 				     i + 1, ret);
 			goto dealloc_counters;
 		}
+
+		ret = __mlx5_ib_alloc_q_counters(dev,
+						 &port->q_cnts.names,
+						 &port->q_cnts.offsets,
+						 &port->q_cnts.num_counters);
+		if (ret)
+			goto dealloc_counters;
+
+		mlx5_ib_fill_q_counters(dev, port->q_cnts.names,
+					port->q_cnts.offsets);
 	}
 
 	return 0;
@@ -3032,62 +3133,39 @@ static int mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
 dealloc_counters:
 	while (--i >= 0)
 		mlx5_core_dealloc_q_counter(dev->mdev,
-					    dev->port[i].q_cnt_id);
+					    dev->port[i].q_cnts.set_id);
 
 	return ret;
 }
 
-static const char * const names[] = {
-	"rx_write_requests",
-	"rx_read_requests",
-	"rx_atomic_requests",
-	"out_of_buffer",
-	"out_of_sequence",
-	"duplicate_request",
-	"rnr_nak_retry_err",
-	"packet_seq_err",
-	"implied_nak_seq_err",
-	"local_ack_timeout_err",
-};
-
-static const size_t stats_offsets[] = {
-	MLX5_BYTE_OFF(query_q_counter_out, rx_write_requests),
-	MLX5_BYTE_OFF(query_q_counter_out, rx_read_requests),
-	MLX5_BYTE_OFF(query_q_counter_out, rx_atomic_requests),
-	MLX5_BYTE_OFF(query_q_counter_out, out_of_buffer),
-	MLX5_BYTE_OFF(query_q_counter_out, out_of_sequence),
-	MLX5_BYTE_OFF(query_q_counter_out, duplicate_request),
-	MLX5_BYTE_OFF(query_q_counter_out, rnr_nak_retry_err),
-	MLX5_BYTE_OFF(query_q_counter_out, packet_seq_err),
-	MLX5_BYTE_OFF(query_q_counter_out, implied_nak_seq_err),
-	MLX5_BYTE_OFF(query_q_counter_out, local_ack_timeout_err),
-};
-
 static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 						    u8 port_num)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(names) != ARRAY_SIZE(stats_offsets));
+	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_port *port = &dev->port[port_num - 1];
 
 	/* We support only per port stats */
 	if (port_num == 0)
 		return NULL;
 
-	return rdma_alloc_hw_stats_struct(names, ARRAY_SIZE(names),
+	return rdma_alloc_hw_stats_struct(port->q_cnts.names,
+					  port->q_cnts.num_counters,
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
 }
 
 static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 				struct rdma_hw_stats *stats,
-				u8 port, int index)
+				u8 port_num, int index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
+	struct mlx5_ib_port *port = &dev->port[port_num - 1];
 	int outlen = MLX5_ST_SZ_BYTES(query_q_counter_out);
 	void *out;
 	__be32 val;
 	int ret;
 	int i;
 
-	if (!port || !stats)
+	if (!stats)
 		return -ENOSYS;
 
 	out = mlx5_vzalloc(outlen);
@@ -3095,18 +3173,19 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 		return -ENOMEM;
 
 	ret = mlx5_core_query_q_counter(dev->mdev,
-					dev->port[port - 1].q_cnt_id, 0,
+					port->q_cnts.set_id, 0,
 					out, outlen);
 	if (ret)
 		goto free;
 
-	for (i = 0; i < ARRAY_SIZE(names); i++) {
-		val = *(__be32 *)(out + stats_offsets[i]);
+	for (i = 0; i < port->q_cnts.num_counters; i++) {
+		val = *(__be32 *)(out + port->q_cnts.offsets[i]);
 		stats->value[i] = (u64)be32_to_cpu(val);
 	}
+
 free:
 	kvfree(out);
-	return ARRAY_SIZE(names);
+	return port->q_cnts.num_counters;
 }
 
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
@@ -3258,8 +3337,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 			(1ull << IB_USER_VERBS_CMD_DEALLOC_MW);
 	}
 
-	if (MLX5_CAP_GEN(dev->mdev, out_of_seq_cnt) &&
-	    MLX5_CAP_GEN(dev->mdev, retransmission_q_counters)) {
+	if (MLX5_CAP_GEN(dev->mdev, max_qp_cnt)) {
 		dev->ib_dev.get_hw_stats	= mlx5_ib_get_hw_stats;
 		dev->ib_dev.alloc_hw_stats	= mlx5_ib_alloc_hw_stats;
 	}
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e1a4b93d..8263249 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -579,8 +579,15 @@ struct mlx5_ib_resources {
 	struct mutex	mutex;
 };
 
+struct mlx5_ib_q_counters {
+	const char **names;
+	size_t *offsets;
+	u32 num_counters;
+	u16 set_id;
+};
+
 struct mlx5_ib_port {
-	u16 q_cnt_id;
+	struct mlx5_ib_q_counters q_cnts;
 };
 
 struct mlx5_roce {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6a83fb3..aebd808 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2777,7 +2777,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 			       qp->port) - 1;
 		mibport = &dev->port[port_num];
 		context->qp_counter_set_usr_page |=
-			cpu_to_be32((u32)(mibport->q_cnt_id) << 24);
+			cpu_to_be32((u32)(mibport->q_cnts.set_id) << 24);
 	}
 
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
@@ -2805,7 +2805,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 
 		raw_qp_param.operation = op;
 		if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
-			raw_qp_param.rq_q_ctr_id = mibport->q_cnt_id;
+			raw_qp_param.rq_q_ctr_id = mibport->q_cnts.set_id;
 			raw_qp_param.set_mask |= MLX5_RAW_QP_MOD_SET_RQ_Q_CTR_ID;
 		}
 
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
