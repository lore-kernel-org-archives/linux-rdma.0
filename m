From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx5: Add per port counters
Date: Fri, 17 Jun 2016 15:10:55 +0300
Message-ID: <1466165456-31857-2-git-send-email-leon@kernel.org>
References: <1466165456-31857-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466165456-31857-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to support statistics for ports, we attach
each QP to a counter set which is dedicate to this port.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 56 ++++++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++++
 drivers/infiniband/hw/mlx5/qp.c      |  9 ++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c72797c..e525891 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2293,6 +2293,41 @@ static void mlx5_disable_roce(struct mlx5_ib_dev *dev)
 	unregister_netdevice_notifier(&dev->roce.nb);
 }
 
+static void mlx5_ib_dealloc_q_counters(struct mlx5_ib_dev *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->num_ports; i++)
+		mlx5_core_dealloc_q_counter(dev->mdev,
+					    dev->port[i].q_cnt_id);
+}
+
+static int mlx5_ib_alloc_q_counters(struct mlx5_ib_dev *dev)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < dev->num_ports; i++) {
+		ret = mlx5_core_alloc_q_counter(dev->mdev,
+						&dev->port[i].q_cnt_id);
+		if (ret) {
+			mlx5_ib_warn(dev,
+				     "couldn't allocate queue counter for port %d, err %d\n",
+				     i + 1, ret);
+			goto dealloc_counters;
+		}
+	}
+
+	return 0;
+
+dealloc_counters:
+	while (--i >= 0)
+		mlx5_core_dealloc_q_counter(dev->mdev,
+					    dev->port[i].q_cnt_id);
+
+	return ret;
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -2315,10 +2350,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	dev->mdev = mdev;
 
+	dev->port = kcalloc(MLX5_CAP_GEN(mdev, num_ports), sizeof(*dev->port),
+			    GFP_KERNEL);
+	if (!dev->port)
+		goto err_dealloc;
+
 	rwlock_init(&dev->roce.netdev_lock);
 	err = get_port_caps(dev);
 	if (err)
-		goto err_dealloc;
+		goto err_free_port;
 
 	if (mlx5_use_mad_ifc(dev))
 		get_ext_port_caps(dev);
@@ -2467,10 +2507,14 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_rsrc;
 
-	err = ib_register_device(&dev->ib_dev, NULL);
+	err = mlx5_ib_alloc_q_counters(dev);
 	if (err)
 		goto err_odp;
 
+	err = ib_register_device(&dev->ib_dev, NULL);
+	if (err)
+		goto err_q_cnt;
+
 	err = create_umr_res(dev);
 	if (err)
 		goto err_dev;
@@ -2492,6 +2536,9 @@ err_umrc:
 err_dev:
 	ib_unregister_device(&dev->ib_dev);
 
+err_q_cnt:
+	mlx5_ib_dealloc_q_counters(dev);
+
 err_odp:
 	mlx5_ib_odp_remove_one(dev);
 
@@ -2502,6 +2549,9 @@ err_disable_roce:
 	if (ll == IB_LINK_LAYER_ETHERNET)
 		mlx5_disable_roce(dev);
 
+err_free_port:
+	kfree(dev->port);
+
 err_dealloc:
 	ib_dealloc_device((struct ib_device *)dev);
 
@@ -2514,11 +2564,13 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev, 1);
 
 	ib_unregister_device(&dev->ib_dev);
+	mlx5_ib_dealloc_q_counters(dev);
 	destroy_umrc_res(dev);
 	mlx5_ib_odp_remove_one(dev);
 	destroy_dev_resources(&dev->devr);
 	if (ll == IB_LINK_LAYER_ETHERNET)
 		mlx5_disable_roce(dev);
+	kfree(dev->port);
 	ib_dealloc_device(&dev->ib_dev);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c4a9825..930a9a8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -546,6 +546,10 @@ struct mlx5_ib_resources {
 	struct mutex	mutex;
 };
 
+struct mlx5_ib_port {
+	u16 q_cnt_id;
+};
+
 struct mlx5_roce {
 	/* Protect mlx5_ib_get_netdev from invoking dev_hold() with a NULL
 	 * netdev pointer
@@ -581,6 +585,8 @@ struct mlx5_ib_dev {
 	struct srcu_struct      mr_srcu;
 #endif
 	struct mlx5_ib_flow_db	flow_db;
+	/* Array with num_ports elements */
+	struct mlx5_ib_port	*port;
 };
 
 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5041176..c770d00 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2343,6 +2343,15 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	else
 		sqd_event = 0;
 
+	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
+		u8 port_num = (attr_mask & IB_QP_PORT ? attr->port_num :
+			       qp->port) - 1;
+		struct mlx5_ib_port *mibport = &dev->port[port_num];
+
+		context->qp_counter_set_usr_page |=
+			cpu_to_be32(mibport->q_cnt_id << 16);
+	}
+
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->sq_crq_size |= cpu_to_be16(1 << 4);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
