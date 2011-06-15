From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 8/9] ib/mlx4: use flow counters on IBoE ports
Date: Wed, 15 Jun 2011 17:49:57 +0300
Message-ID: <alpine.LRH.2.00.1106151749160.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allocate flow counter per Ethernet/IBoE port, and attach this
counter to all the QPs created on that port.  Based on patch
by Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |   20 ++++++++++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 drivers/infiniband/hw/mlx4/qp.c      |   10 +++++++++-
 include/linux/mlx4/qp.h              |    3 ++-
 4 files changed, 30 insertions(+), 4 deletions(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1098,11 +1098,22 @@ static void *mlx4_ib_add(struct mlx4_dev
 	if (init_node_data(ibdev))
 		goto err_map;

+	for (i = 0; i < ibdev->num_ports; ++i) {
+		if (mlx4_ib_port_link_layer(&ibdev->ib_dev, i + 1) ==
+						IB_LINK_LAYER_ETHERNET) {
+			err = mlx4_counter_alloc(ibdev->dev,
+							&ibdev->counters[i]);
+			if (err)
+				ibdev->counters[i] = -1;
+		} else
+				ibdev->counters[i] = -1;
+	}
+
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);

 	if (ib_register_device(&ibdev->ib_dev, NULL))
-		goto err_map;
+		goto err_counter;

 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
@@ -1132,6 +1143,10 @@ err_notif:
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);

+err_counter:
+	for (; i; --i)
+		mlx4_counter_free(ibdev->dev, ibdev->counters[i - 1]);
+
 err_map:
 	iounmap(ibdev->uar_map);

@@ -1160,7 +1175,8 @@ static void mlx4_ib_remove(struct mlx4_d
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
 	iounmap(ibdev->uar_map);
-
+	for (p = 0; p < ibdev->num_ports; ++p)
+		mlx4_counter_free(ibdev->dev, ibdev->counters[p]);
 	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);

Index: b/drivers/infiniband/hw/mlx4/mlx4_ib.h
===================================================================
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -193,6 +193,7 @@ struct mlx4_ib_dev {
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
 	struct mlx4_ib_iboe	iboe;
+	int			counters[MLX4_MAX_PORTS];
 };

 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
Index: b/drivers/infiniband/hw/mlx4/qp.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -893,7 +893,6 @@ static int mlx4_set_path(struct mlx4_ib_
 			--path->static_rate;
 	} else
 		path->static_rate = 0;
-	path->counter_index = 0xff;

 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >= dev->dev->caps.gid_table_len[port]) {
@@ -1034,6 +1033,15 @@ static int __mlx4_ib_modify_qp(struct ib
 		}
 	}

+	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
+		if (dev->counters[qp->port - 1] != -1) {
+			context->pri_path.counter_index =
+						dev->counters[qp->port - 1];
+			optpar |= MLX4_QP_OPTPAR_COUNTER_INDEX;
+		} else
+			context->pri_path.counter_index = 0xff;
+	}
+
 	if (attr_mask & IB_QP_PKEY_INDEX) {
 		context->pri_path.pkey_index = attr->pkey_index;
 		optpar |= MLX4_QP_OPTPAR_PKEY_INDEX;
Index: b/include/linux/mlx4/qp.h
===================================================================
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
