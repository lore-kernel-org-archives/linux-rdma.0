From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] mlx5: Implement new counter infrastructure
Date: Tue, 15 Mar 2016 10:54:44 -0500
Message-ID: <20160315155455.397561811@linux.com>
References: <20160315155441.222586021@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=mlx5_sample_stats
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This provides the proper infrastructure to add counters to mlx5 and
shows some constant integer values in sysfs. It lacks the actual
access to the hardware counters. This is a vendor specific issue
so I hope that Mellanox can add that.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/hw/mlx5/main.c
===================================================================
--- linux.orig/drivers/infiniband/hw/mlx5/main.c
+++ linux/drivers/infiniband/hw/mlx5/main.c
@@ -2122,6 +2122,76 @@ static int mlx5_port_immutable(struct ib
 	return 0;
 }
 
+#define MLX5_NUM_COUNTERS 28
+
+static char *mlx5_counter_names[MLX5_NUM_COUNTERS + 1] = {
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
+	NULL };
+
+#define MLX5_NUM_PORT_COUNTERS 1
+static char *mlx5_port_counter_names[MLX5_NUM_PORT_COUNTERS + 1] = {
+	"p1",
+	NULL
+};
+
+static int mlx5_get_protocol_stats(struct ib_device *ibdev,
+				   struct rdma_protocol_stats *stats,
+				   u8 port)
+{
+	if (port != 0) {
+		/* Port Counters */
+		stats->name = mlx5_port_counter_names;
+		stats->dirname = "stats";
+		/*
+		 * Just one value for testing. Insert the right
+		 * way to retrieve all the counters here
+		 */
+		stats->value[0] = 1;
+		return 0;
+	}
+
+
+	/* Device Counters */
+
+	/* No idea how to retrieve the actual counters. Just some values */
+	stats->value[0] = 1;
+	stats->value[1] = 2;
+	stats->value[2] = 3;
+	stats->value[3] = 4;
+
+	stats->name = mlx5_counter_names;
+	stats->dirname = "ib_stats";
+
+	return 0;
+}
+
 static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 {
 	int err;
@@ -2266,6 +2336,7 @@ static void *mlx5_ib_add(struct mlx5_cor
 	dev->ib_dev.map_mr_sg		= mlx5_ib_map_mr_sg;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
+	dev->ib_dev.get_protocol_stats	= mlx5_get_protocol_stats;
 
 	mlx5_ib_internal_fill_odp_caps(dev);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
