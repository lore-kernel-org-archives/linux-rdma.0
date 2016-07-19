From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx4: Add diagnostic hardware counters
Date: Tue, 19 Jul 2016 20:54:58 +0300
Message-ID: <1468950898-9674-4-git-send-email-leon@kernel.org>
References: <1468950898-9674-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468950898-9674-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose IB diagnostic hardware counters.
The counters count IB events and are applicable for IB and RoCE.

The counters can be divided into two groups, per device and per port.
Device counters are always exposed.
Port counters are exposed only if the firmware supports per port counters.

rq_num_dup and sq_num_to are only exposed if we have firmware support
for them, if we do, we expose them per device and per port.
rq_num_udsdprd and num_cqovf are device only counters.

rq - denotes responder.
sq - denotes requester.

|-----------------------|---------------------------------------|
|	Name		|	Description			|
|-----------------------|---------------------------------------|
|rq_num_lle		| Number of local length errors		|
|-----------------------|---------------------------------------|
|sq_num_lle		| number of local length errors		|
|-----------------------|---------------------------------------|
|rq_num_lqpoe		| Number of local QP operation errors	|
|-----------------------|---------------------------------------|
|sq_num_lqpoe		| Number of local QP operation errors	|
|-----------------------|---------------------------------------|
|rq_num_lpe		| Number of local protection errors	|
|-----------------------|---------------------------------------|
|sq_num_lpe		| Number of local protection errors	|
|-----------------------|---------------------------------------|
|rq_num_wrfe		| Number of CQEs with error		|
|-----------------------|---------------------------------------|
|sq_num_wrfe		| Number of CQEs with error		|
|-----------------------|---------------------------------------|
|sq_num_mwbe		| Number of Memory Window bind errors	|
|-----------------------|---------------------------------------|
|sq_num_bre		| Number of bad response errors		|
|-----------------------|---------------------------------------|
|sq_num_rire		| Number of Remote Invalid request	|
|			| errors				|
|-----------------------|---------------------------------------|
|rq_num_rire		| Number of Remote Invalid request	|
|			| errors				|
|-----------------------|---------------------------------------|
|sq_num_rae		| Number of remote access errors	|
|-----------------------|---------------------------------------|
|rq_num_rae		| Number of remote access errors	|
|-----------------------|---------------------------------------|
|sq_num_roe		| Number of remote operation errors	|
|-----------------------|---------------------------------------|
|sq_num_tree		| Number of transport retries exceeded	|
|			| errors				|
|-----------------------|---------------------------------------|
|sq_num_rree		| Number of RNR NAK retries exceeded	|
|			| errors				|
|-----------------------|---------------------------------------|
|rq_num_rnr		| Number of RNR NAKs sent		|
|-----------------------|---------------------------------------|
|sq_num_rnr		| Number of RNR NAKs received		|
|-----------------------|---------------------------------------|
|rq_num_oos		| Number of Out of Sequence requests	|
|			| received				|
|-----------------------|---------------------------------------|
|sq_num_oos		| Number of Out of Sequence NAKs	|
|			| received				|
|-----------------------|---------------------------------------|
|rq_num_udsdprd		| Number of UD packets silently		|
|			| discarded on the Receive Queue due to	|
|			| lack of receive descriptor		|
|-----------------------|---------------------------------------|
|rq_num_dup		| Number of duplicate requests received	|
|-----------------------|---------------------------------------|
|sq_num_to		| Number of time out received		|
|-----------------------|---------------------------------------|
|num_cqovf		| Number of CQ overflows		|
|-----------------------|---------------------------------------|

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 198 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   9 ++
 include/linux/mlx4/device.h          |   3 +
 3 files changed, 209 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 42a4607..b89c4d9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2064,6 +2064,195 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
+struct diag_counter {
+	const char *name;
+	u32 offset;
+};
+
+#define DIAG_COUNTER(_name, _offset)			\
+	{ .name = #_name, .offset = _offset }
+
+static const struct diag_counter diag_basic[] = {
+	DIAG_COUNTER(rq_num_lle, 0x00),
+	DIAG_COUNTER(sq_num_lle, 0x04),
+	DIAG_COUNTER(rq_num_lqpoe, 0x08),
+	DIAG_COUNTER(sq_num_lqpoe, 0x0C),
+	DIAG_COUNTER(rq_num_lpe, 0x18),
+	DIAG_COUNTER(sq_num_lpe, 0x1C),
+	DIAG_COUNTER(rq_num_wrfe, 0x20),
+	DIAG_COUNTER(sq_num_wrfe, 0x24),
+	DIAG_COUNTER(sq_num_mwbe, 0x2C),
+	DIAG_COUNTER(sq_num_bre, 0x34),
+	DIAG_COUNTER(sq_num_rire, 0x44),
+	DIAG_COUNTER(rq_num_rire, 0x48),
+	DIAG_COUNTER(sq_num_rae, 0x4C),
+	DIAG_COUNTER(rq_num_rae, 0x50),
+	DIAG_COUNTER(sq_num_roe, 0x54),
+	DIAG_COUNTER(sq_num_tree, 0x5C),
+	DIAG_COUNTER(sq_num_rree, 0x64),
+	DIAG_COUNTER(rq_num_rnr, 0x68),
+	DIAG_COUNTER(sq_num_rnr, 0x6C),
+	DIAG_COUNTER(rq_num_oos, 0x100),
+	DIAG_COUNTER(sq_num_oos, 0x104),
+};
+
+static const struct diag_counter diag_ext[] = {
+	DIAG_COUNTER(rq_num_dup, 0x130),
+	DIAG_COUNTER(sq_num_to, 0x134),
+};
+
+static const struct diag_counter diag_device_only[] = {
+	DIAG_COUNTER(num_cqovf, 0x1A0),
+	DIAG_COUNTER(rq_num_udsdprd, 0x118),
+};
+
+static struct rdma_hw_stats *mlx4_ib_alloc_hw_stats(struct ib_device *ibdev,
+						    u8 port_num)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct mlx4_ib_diag_counters *diag = dev->diag_counters;
+
+	if (!diag[!!port_num].name)
+		return NULL;
+
+	return rdma_alloc_hw_stats_struct(diag[!!port_num].name,
+					  diag[!!port_num].num_counters,
+					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
+}
+
+static int mlx4_ib_get_hw_stats(struct ib_device *ibdev,
+				struct rdma_hw_stats *stats,
+				u8 port, int index)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct mlx4_ib_diag_counters *diag = dev->diag_counters;
+	u32 hw_value[ARRAY_SIZE(diag_device_only) +
+		ARRAY_SIZE(diag_ext) + ARRAY_SIZE(diag_basic)] = {};
+	int ret;
+	int i;
+
+	ret = mlx4_query_diag_counters(dev->dev,
+				       MLX4_OP_MOD_QUERY_TRANSPORT_CI_ERRORS,
+				       diag[!!port].offset, hw_value,
+				       diag[!!port].num_counters, port);
+
+	if (ret)
+		return ret;
+
+	for (i = 0; i < diag[!!port].num_counters; i++)
+		stats->value[i] = hw_value[i];
+
+	return diag[!!port].num_counters;
+}
+
+static int __mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev,
+					 const char ***name,
+					 u32 **offset,
+					 u32 *num,
+					 bool port)
+{
+	u32 num_counters;
+
+	num_counters = ARRAY_SIZE(diag_basic);
+
+	if (ibdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT)
+		num_counters += ARRAY_SIZE(diag_ext);
+
+	if (!port)
+		num_counters += ARRAY_SIZE(diag_device_only);
+
+	*name = kcalloc(num_counters, sizeof(**name), GFP_KERNEL);
+	if (!*name)
+		return -ENOMEM;
+
+	*offset = kcalloc(num_counters, sizeof(**offset), GFP_KERNEL);
+	if (!*offset)
+		goto err_name;
+
+	*num = num_counters;
+
+	return 0;
+
+err_name:
+	kfree(*name);
+	return -ENOMEM;
+}
+
+static void mlx4_ib_fill_diag_counters(struct mlx4_ib_dev *ibdev,
+				       const char **name,
+				       u32 *offset,
+				       bool port)
+{
+	int i;
+	int j;
+
+	for (i = 0, j = 0; i < ARRAY_SIZE(diag_basic); i++, j++) {
+		name[i] = diag_basic[i].name;
+		offset[i] = diag_basic[i].offset;
+	}
+
+	if (ibdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT) {
+		for (i = 0; i < ARRAY_SIZE(diag_ext); i++, j++) {
+			name[j] = diag_ext[i].name;
+			offset[j] = diag_ext[i].offset;
+		}
+	}
+
+	if (!port) {
+		for (i = 0; i < ARRAY_SIZE(diag_device_only); i++, j++) {
+			name[j] = diag_device_only[i].name;
+			offset[j] = diag_device_only[i].offset;
+		}
+	}
+}
+
+static int mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev)
+{
+	struct mlx4_ib_diag_counters *diag = ibdev->diag_counters;
+	int i;
+	int ret;
+	bool per_port = !!(ibdev->dev->caps.flags2 &
+		MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT);
+
+	for (i = 0; i < MLX4_DIAG_COUNTERS_TYPES; i++) {
+		/* i == 1 means we are building port counters */
+		if (i && !per_port)
+			continue;
+
+		ret = __mlx4_ib_alloc_diag_counters(ibdev, &diag[i].name,
+						    &diag[i].offset,
+						    &diag[i].num_counters, i);
+		if (ret)
+			goto err_alloc;
+
+		mlx4_ib_fill_diag_counters(ibdev, diag[i].name,
+					   diag[i].offset, i);
+	}
+
+	ibdev->ib_dev.get_hw_stats	= mlx4_ib_get_hw_stats;
+	ibdev->ib_dev.alloc_hw_stats	= mlx4_ib_alloc_hw_stats;
+
+	return 0;
+
+err_alloc:
+	if (i) {
+		kfree(diag[i - 1].name);
+		kfree(diag[i - 1].offset);
+	}
+
+	return ret;
+}
+
+static void mlx4_ib_diag_cleanup(struct mlx4_ib_dev *ibdev)
+{
+	int i;
+
+	for (i = 0; i < MLX4_DIAG_COUNTERS_TYPES; i++) {
+		kfree(ibdev->diag_counters[i].offset);
+		kfree(ibdev->diag_counters[i].name);
+	}
+}
+
 #define MLX4_IB_INVALID_MAC	((u64)-1)
 static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 			       struct net_device *dev,
@@ -2555,9 +2744,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	for (j = 1; j <= ibdev->dev->caps.num_ports; j++)
 		atomic64_set(&iboe->mac[j - 1], ibdev->dev->caps.def_mac[j]);
 
-	if (ib_register_device(&ibdev->ib_dev, NULL))
+	if (mlx4_ib_alloc_diag_counters(ibdev))
 		goto err_steer_free_bitmap;
 
+	if (ib_register_device(&ibdev->ib_dev, NULL))
+		goto err_diag_counters;
+
 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
 
@@ -2623,6 +2815,9 @@ err_mad:
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);
 
+err_diag_counters:
+	mlx4_ib_diag_cleanup(ibdev);
+
 err_steer_free_bitmap:
 	kfree(ibdev->ib_uc_qpns_bitmap);
 
@@ -2726,6 +2921,7 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 	mlx4_ib_close_sriov(ibdev);
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
+	mlx4_ib_diag_cleanup(ibdev);
 	if (ibdev->iboe.nb.notifier_call) {
 		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
 			pr_warn("failure unregistering notifier\n");
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 29acda2..7c5832e 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -549,6 +549,14 @@ struct mlx4_ib_counters {
 	u32			default_counter;
 };
 
+#define MLX4_DIAG_COUNTERS_TYPES 2
+
+struct mlx4_ib_diag_counters {
+	const char **name;
+	u32 *offset;
+	u32 num_counters;
+};
+
 struct mlx4_ib_dev {
 	struct ib_device	ib_dev;
 	struct mlx4_dev	       *dev;
@@ -585,6 +593,7 @@ struct mlx4_ib_dev {
 	/* protect resources needed as part of reset flow */
 	spinlock_t		reset_flow_resource_lock;
 	struct list_head		qp_list;
+	struct mlx4_ib_diag_counters diag_counters[MLX4_DIAG_COUNTERS_TYPES];
 };
 
 struct ib_event_work {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index d70cfbe..815869f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1342,6 +1342,9 @@ enum {
 	VXLAN_STEER_BY_INNER_VLAN	= 1 << 4,
 };
 
+enum {
+	MLX4_OP_MOD_QUERY_TRANSPORT_CI_ERRORS = 0x2,
+};
 
 int mlx4_flow_steer_promisc_add(struct mlx4_dev *dev, u8 port, u32 qpn,
 				enum mlx4_net_trans_promisc_mode mode);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
