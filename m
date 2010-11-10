From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] mlx4: add support for reading performance counters
Date: Wed, 10 Nov 2010 14:24:00 +0200
Message-ID: <20101110122400.GD12037@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch uses basic or extended counters which can be read by a command
interface, to report counters for all the QPs that work on an rdmaoe port. This
effectively allows to implement performance counter ala IB.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     |   87 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/main.c    |   16 ++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 drivers/infiniband/hw/mlx4/qp.c      |    7 ++-
 drivers/net/mlx4/main.c              |   22 +++++++--
 include/linux/mlx4/cmd.h             |    4 ++
 include/linux/mlx4/device.h          |   36 ++++++++++++++
 include/linux/mlx4/qp.h              |    3 +-
 8 files changed, 165 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index c9a8dd6..397bfb8 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -230,9 +230,9 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *ma
 	}
 }
 
-int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+			  struct ib_wc *in_wc, struct ib_grh *in_grh,
+			  struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	u16 slid, prev_lid = 0;
 	int err;
@@ -300,6 +300,87 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
 	return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
 }
 
+static __be32 be64_to_be32(__be64 b64)
+{
+	return cpu_to_be32(be64_to_cpu(b64) & 0xffffffff);
+}
+
+static void edit_counters(struct mlx4_counters *cnt, void *data)
+{
+	*(__be32 *)(data + 40 + 24) = be64_to_be32(cnt->tx_bytes);
+	*(__be32 *)(data + 40 + 28) = be64_to_be32(cnt->rx_bytes);
+	*(__be32 *)(data + 40 + 32) = be64_to_be32(cnt->tx_frames);
+	*(__be32 *)(data + 40 + 36) = be64_to_be32(cnt->rx_frames);
+}
+
+static void edit_ext_counters(struct mlx4_counters_ext *cnt, void *data)
+{
+	*(__be32 *)(data + 40 + 24) = be64_to_be32(cnt->tx_uni_bytes);
+	*(__be32 *)(data + 40 + 28) = be64_to_be32(cnt->rx_uni_bytes);
+	*(__be32 *)(data + 40 + 32) = be64_to_be32(cnt->tx_uni_frames);
+	*(__be32 *)(data + 40 + 36) = be64_to_be32(cnt->rx_uni_frames);
+	*(__be32 *)(data + 40 + 8) = be64_to_be32(cnt->rx_err_frames);
+}
+
+static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
+			    struct ib_wc *in_wc, struct ib_grh *in_grh,
+			    struct ib_mad *in_mad, struct ib_mad *out_mad)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	int err;
+	u32 inmod = dev->counters[port_num - 1] & 0xffff;
+	int mode;
+
+	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_PERF_MGMT)
+		return -EINVAL;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev->dev);
+	if (IS_ERR(mailbox))
+		return IB_MAD_RESULT_FAILURE;
+
+	err = mlx4_cmd_box(dev->dev, 0, mailbox->dma, inmod, 0,
+			   MLX4_CMD_QUERY_IF_STAT, MLX4_CMD_TIME_CLASS_C);
+	if (err)
+		err = IB_MAD_RESULT_FAILURE;
+	else {
+		memset(out_mad->data, 0, sizeof out_mad->data);
+		mode = be32_to_cpu(((struct mlx4_counters *)mailbox->buf)->counter_mode) & 0xf;
+		switch (mode) {
+		case 0:
+			edit_counters(mailbox->buf, out_mad->data);
+			err = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+			break;
+		case 1:
+			edit_ext_counters(mailbox->buf, out_mad->data);
+			err = IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY;
+			break;
+		default:
+			err = IB_MAD_RESULT_FAILURE;
+		}
+	}
+
+	mlx4_free_cmd_mailbox(dev->dev, mailbox);
+
+	return err;
+}
+
+int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
+			struct ib_wc *in_wc, struct ib_grh *in_grh,
+			struct ib_mad *in_mad, struct ib_mad *out_mad)
+{
+	switch (rdma_port_get_link_layer(ibdev, port_num)) {
+	case IB_LINK_LAYER_INFINIBAND:
+		return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
+				      in_grh, in_mad, out_mad);
+	case IB_LINK_LAYER_ETHERNET:
+		return iboe_process_mad(ibdev, mad_flags, port_num, in_wc,
+					  in_grh, in_mad, out_mad);
+	default:
+		return -EINVAL;
+	}
+}
+
 static void send_handler(struct ib_mad_agent *agent,
 			 struct ib_mad_send_wc *mad_send_wc)
 {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bf3e20c..a7879c0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -981,6 +981,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	int i;
 	int err;
 	struct mlx4_ib_iboe *iboe;
+	int k;
 
 	printk_once(KERN_INFO "%s", mlx4_ib_version);
 
@@ -1097,11 +1098,17 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (init_node_data(ibdev))
 		goto err_map;
 
+	for (k = 0; k < ibdev->num_ports; ++k) {
+		err = mlx4_counter_alloc(ibdev->dev, &ibdev->counters[k]);
+		if (err)
+			ibdev->counters[k] = -1;
+	}
+
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);
 
 	if (ib_register_device(&ibdev->ib_dev, NULL))
-		goto err_map;
+		goto err_counter;
 
 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
@@ -1131,6 +1138,10 @@ err_notif:
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);
 
+err_counter:
+	for (; k; --k)
+		mlx4_counter_free(ibdev->dev, ibdev->counters[k - 1]);
+
 err_map:
 	iounmap(ibdev->uar_map);
 
@@ -1150,6 +1161,7 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 {
 	struct mlx4_ib_dev *ibdev = ibdev_ptr;
 	int p;
+	int k;
 
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
@@ -1157,6 +1169,8 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
 			printk(KERN_WARNING "failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
+		for (k = 0; k < ibdev->num_ports; ++k)
+			mlx4_counter_free(ibdev->dev, ibdev->counters[k]);
 	}
 	iounmap(ibdev->uar_map);
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 2a322f2..e4bf2cf 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -193,6 +193,7 @@ struct mlx4_ib_dev {
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
 	struct mlx4_ib_iboe	iboe;
+	int			counters[MLX4_MAX_PORTS];
 };
 
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 9a7794a..115e106 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -893,7 +893,6 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 			--path->static_rate;
 	} else
 		path->static_rate = 0;
-	path->counter_index = 0xff;
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
@@ -1034,6 +1033,12 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 
+	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR &&
+	    dev->counters[qp->port - 1] != -1) {
+		context->pri_path.counter_index = dev->counters[qp->port - 1];
+		optpar |= MLX4_QP_OPTPAR_COUNTER_INDEX;
+	}
+
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		context->pri_path.pkey_index = attr->pkey_index;
 		optpar |= MLX4_QP_OPTPAR_PKEY_INDEX;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 70985d8..0126ea2 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -865,17 +865,29 @@ int mlx4_counter_alloc(struct mlx4_dev *dev, u32 *idx)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 
-	*idx = mlx4_bitmap_alloc(&priv->counters_bitmap);
-	if (*idx == -1)
+	switch (dev->caps.counters_mode) {
+	case MLX4_COUNTERS_BASIC:
+	case MLX4_COUNTERS_EXT:
+		*idx = mlx4_bitmap_alloc(&priv->counters_bitmap);
+		if (*idx == -1)
+			return -ENOMEM;
+		return 0;
+	default:
 		return -ENOMEM;
-
-	return 0;
+	}
 }
 EXPORT_SYMBOL_GPL(mlx4_counter_alloc);
 
 void mlx4_counter_free(struct mlx4_dev *dev, u32 idx)
 {
-	mlx4_bitmap_free(&mlx4_priv(dev)->counters_bitmap, idx);
+	switch (dev->caps.counters_mode) {
+	case MLX4_COUNTERS_BASIC:
+	case MLX4_COUNTERS_EXT:
+		mlx4_bitmap_free(&mlx4_priv(dev)->counters_bitmap, idx);
+		return;
+	default:
+		return;
+	}
 }
 EXPORT_SYMBOL_GPL(mlx4_counter_free);
 
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 9a18667..60d3036 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -123,6 +123,10 @@ enum {
 	/* debug commands */
 	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
 	MLX4_CMD_SET_DEBUG_MSG	 = 0x2b,
+
+	/* statistics commands */
+	MLX4_CMD_QUERY_IF_STAT	 = 0X54,
+	MLX4_CMD_SET_IF_STAT	 = 0X55,
 };
 
 enum {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 0992434..95d39eb 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -414,6 +414,42 @@ union mlx4_ext_av {
 	struct mlx4_eth_av	eth;
 };
 
+struct mlx4_counters {
+	__be32	counter_mode;
+	__be32	num_ifc;
+	u32	reserved[2];
+	__be64	rx_frames;
+	__be64	rx_bytes;
+	__be64	tx_frames;
+	__be64	tx_bytes;
+};
+
+struct mlx4_counters_ext {
+	__be32	counter_mode;
+	__be32	num_ifc;
+	u32	reserved[2];
+	__be64	rx_uni_frames;
+	__be64	rx_uni_bytes;
+	__be64	rx_mcast_frames;
+	__be64	rx_mcast_bytes;
+	__be64	rx_bcast_frames;
+	__be64	rx_bcast_bytes;
+	__be64	rx_nobuf_frames;
+	__be64	rx_nobuf_bytes;
+	__be64	rx_err_frames;
+	__be64	rx_err_bytes;
+	__be64	tx_uni_frames;
+	__be64	tx_uni_bytes;
+	__be64	tx_mcast_frames;
+	__be64	tx_mcast_bytes;
+	__be64	tx_bcast_frames;
+	__be64	tx_bcast_bytes;
+	__be64	tx_nobuf_frames;
+	__be64	tx_nobuf_bytes;
+	__be64	tx_err_frames;
+	__be64	tx_err_bytes;
+};
+
 struct mlx4_dev {
 	struct pci_dev	       *pdev;
 	unsigned long		flags;
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 0eeb2a1..22fc0a4 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -54,7 +54,8 @@ enum mlx4_qp_optpar {
 	MLX4_QP_OPTPAR_RETRY_COUNT		= 1 << 12,
 	MLX4_QP_OPTPAR_RNR_RETRY		= 1 << 13,
 	MLX4_QP_OPTPAR_ACK_TIMEOUT		= 1 << 14,
-	MLX4_QP_OPTPAR_SCHED_QUEUE		= 1 << 16
+	MLX4_QP_OPTPAR_SCHED_QUEUE		= 1 << 16,
+	MLX4_QP_OPTPAR_COUNTER_INDEX		= 1 << 20
 };
 
 enum mlx4_qp_state {
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
