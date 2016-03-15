From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] mlx4: Add support for protocol statistics
Date: Tue, 15 Mar 2016 10:54:43 -0500
Message-ID: <20160315155455.282397466@linux.com>
References: <20160315155441.222586021@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=mlx4_protocol_stats
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add support for basic Infiniband CQ statistics for the mlx4 driver.

This is based on an old approach posted years ago. Maybe Mellanox
can come up with a better one but this shows how it can be implemented
in the mlx4 driver and it works for our needs.

The old patch did only show how to retrieve the counter
values for the device as a whole not for each port. An improvement
would be to add proper support for port based counters.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- linux.orig/drivers/infiniband/hw/mlx4/main.c
+++ linux/drivers/infiniband/hw/mlx4/main.c
@@ -2210,6 +2210,106 @@ static int mlx4_port_immutable(struct ib
 	return 0;
 }
 
+enum mlx4_diagnostic_counters {
+	MLX4_RQ_NUM_LLE,
+	MLX4_SQ_NUM_LLE,
+	MLX4_RQ_NUM_LQPOE,
+	MLX4_SQ_NUM_LQPOE,
+	MLX4_RQ_NUM_LPE,
+	MLX4_SQ_NUM_LPE,
+	MLX4_RQ_NUM_WRFE,
+	MLX4_SQ_NUM_WRFE,
+	MLX4_SQ_NUM_MWBE,
+	MLX4_SQ_NUM_BRE,
+	MLX4_RQ_NUM_LAE,
+	MLX4_SQ_NUM_RIRE,
+	MLX4_RQ_NUM_RIRE,
+	MLX4_SQ_NUM_RAE,
+	MLX4_RQ_NUM_RAE,
+	MLX4_SQ_NUM_ROE,
+	MLX4_SQ_NUM_TREE,
+	MLX4_SQ_NUM_RREE,
+	MLX4_RQ_NUM_RNR,
+	MLX4_SQ_NUM_RNR,
+	MLX4_RQ_NUM_OOS,
+	MLX4_SQ_NUM_OOS,
+	MLX4_RQ_NUM_MCE,
+	MLX4_RQ_NUM_UDSDPRD,
+	MLX4_RQ_NUM_UCSDPRD,
+	MLX4_NUM_CQOVF,
+	MLX4_NUM_EQOVF,
+	MLX4_NUM_BADDB,
+	MLX4_COUNTERS_NUM,
+};
+
+
+static char *mlx4_counter_names[] = {
+	"rq_num_lle",
+	"sq_num_lle",
+	"rq_num_lqpoe",
+	"sq_num_lqpoe",
+	"rq_num_lpe",
+	"sq_num_lpe",
+	"rq_num_wrfe",
+	"sq_num_wrfe",
+	"sq_num_mwbe",
+	"sq_num_bre",
+	"rq_num_lae",
+	"sq_num_rire",
+	"rq_num_rire",
+	"sq_num_rae",
+	"rq_num_rae",
+	"sq_num_roe",
+	"sq_num_tree",
+	"sq_num_rree",
+	"rq_num_rnr",
+	"sq_num_rnr",
+	"rq_num_oos",
+	"sq_num_oos",
+	"rq_num_mce",
+	"rq_num_udsdprd",
+	"rq_num_ucsdprd",
+	"num_cqovf",
+	"num_eqovf",
+	"num_baddb",
+	NULL
+};
+
+static int offsets[MLX4_COUNTERS_NUM] = {
+	0x00, 0x04, 0x08, 0x0C, 0x18, 0x1C, 0x20, 0x24,
+	0x2C, 0x34, 0x38, 0x44, 0x48, 0x4C, 0x50, 0x54,
+	0x5C, 0x64, 0x68, 0x6C, 0x100, 0x104, 0x108, 0x118,
+	0x120, 0x1A0, 0x1A4, 0x1A8 };
+
+static int mlx4_ib_show_stats(struct ib_device *ibdev,
+		struct rdma_protocol_stats *stats, u8 port)
+{
+	struct mlx4_ib_dev *dev;
+	int ret;
+
+	stats->name = mlx4_counter_names;
+	stats->dirname = "ib_stats";
+
+	/*
+	 * We should be checking for the port here and obtain
+	 * port specific counters if possible
+	 *
+	 *	if (port)
+	 *		{ Do port specific things }
+	 *
+	 */
+
+	dev = to_mdev(ibdev);
+	ret = mlx4_query_diag_counters(dev->dev, 2, offsets, stats->value,
+				       MLX4_COUNTERS_NUM);
+	if (ret) {
+		pr_err("%s: failed to read ib counters\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2344,6 +2444,7 @@ static void *mlx4_ib_add(struct mlx4_dev
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
 	ibdev->ib_dev.get_port_immutable = mlx4_port_immutable;
 	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;
+	ibdev->ib_dev.get_protocol_stats = mlx4_ib_show_stats;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
 		ibdev->ib_dev.alloc_fmr		= mlx4_ib_fmr_alloc;
Index: linux/drivers/net/ethernet/mellanox/mlx4/fw.c
===================================================================
--- linux.orig/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ linux/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -2453,6 +2453,41 @@ int mlx4_NOP(struct mlx4_dev *dev)
 			MLX4_CMD_NATIVE);
 }
 
+int mlx4_query_diag_counters(struct mlx4_dev *dev, u8 op_modifier,
+			     int *offsets, u64 *values,
+			     size_t array_len)
+{
+	struct mlx4_cmd_mailbox *mailbox;
+	u32 *outbox;
+	int ret;
+	int i;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+	outbox = mailbox->buf;
+
+	ret = mlx4_cmd_box(dev, 0, mailbox->dma, 0, op_modifier,
+			   MLX4_CMD_DIAG_RPRT, MLX4_CMD_TIME_CLASS_A,
+			   MLX4_CMD_NATIVE);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < array_len; i++) {
+		if (offsets[i] > MLX4_MAILBOX_SIZE) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		MLX4_GET(values[i], outbox, offsets[i]);
+	}
+
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mlx4_query_diag_counters);
+
 int mlx4_get_phys_port_id(struct mlx4_dev *dev)
 {
 	u8 port;
Index: linux/include/linux/mlx4/device.h
===================================================================
--- linux.orig/include/linux/mlx4/device.h
+++ linux/include/linux/mlx4/device.h
@@ -1369,6 +1369,8 @@ void mlx4_fmr_unmap(struct mlx4_dev *dev
 		    u32 *lkey, u32 *rkey);
 int mlx4_fmr_free(struct mlx4_dev *dev, struct mlx4_fmr *fmr);
 int mlx4_SYNC_TPT(struct mlx4_dev *dev);
+int mlx4_query_diag_counters(struct mlx4_dev *dev, u8 op_modifier,
+			     int *offsets, u64 *values, size_t array_len);
 int mlx4_test_interrupts(struct mlx4_dev *dev);
 u32 mlx4_get_eqs_per_port(struct mlx4_dev *dev, u8 port);
 bool mlx4_is_eq_vector_valid(struct mlx4_dev *dev, u8 port, int vector);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
