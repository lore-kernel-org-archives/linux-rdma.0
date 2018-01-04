From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 10/15] IB/mlx5: Update counter implementation for dual port RoCE
Date: Thu,  4 Jan 2018 11:06:40 +0200
Message-ID: <20180104090645.4901-11-leon@kernel.org>
References: <20180104090645.4901-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104090645.4901-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update the counter interface for multiple ports. Some counter sets
always comes from the primary device.

Port specific counters should be accessed per mlx5_core_dev not always
through the IB master mdev.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 69 +++++++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 2ced365e8247..4791d747cc57 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3885,11 +3885,12 @@ static const struct mlx5_ib_counter extended_err_cnts[] = {
 
 static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 {
-	unsigned int i;
+	int i;
 
 	for (i = 0; i < dev->num_ports; i++) {
-		mlx5_core_dealloc_q_counter(dev->mdev,
-					    dev->port[i].cnts.set_id);
+		if (dev->port[i].cnts.set_id)
+			mlx5_core_dealloc_q_counter(dev->mdev,
+						    dev->port[i].cnts.set_id);
 		kfree(dev->port[i].cnts.names);
 		kfree(dev->port[i].cnts.offsets);
 	}
@@ -3931,6 +3932,7 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 
 err_names:
 	kfree(cnts->names);
+	cnts->names = NULL;
 	return -ENOMEM;
 }
 
@@ -3977,37 +3979,33 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 
 static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
 {
+	int err = 0;
 	int i;
-	int ret;
 
 	for (i = 0; i < dev->num_ports; i++) {
-		struct mlx5_ib_port *port = &dev->port[i];
+		err = __mlx5_ib_alloc_counters(dev, &dev->port[i].cnts);
+		if (err)
+			goto err_alloc;
+
+		mlx5_ib_fill_counters(dev, dev->port[i].cnts.names,
+				      dev->port[i].cnts.offsets);
 
-		ret = mlx5_core_alloc_q_counter(dev->mdev,
-						&port->cnts.set_id);
-		if (ret) {
+		err = mlx5_core_alloc_q_counter(dev->mdev,
+						&dev->port[i].cnts.set_id);
+		if (err) {
 			mlx5_ib_warn(dev,
 				     "couldn't allocate queue counter for port %d, err %d\n",
-				     i + 1, ret);
-			goto dealloc_counters;
+				     i + 1, err);
+			goto err_alloc;
 		}
-
-		ret = __mlx5_ib_alloc_counters(dev, &port->cnts);
-		if (ret)
-			goto dealloc_counters;
-
-		mlx5_ib_fill_counters(dev, port->cnts.names,
-				      port->cnts.offsets);
+		dev->port[i].cnts.set_id_valid = true;
 	}
 
 	return 0;
 
-dealloc_counters:
-	while (--i >= 0)
-		mlx5_core_dealloc_q_counter(dev->mdev,
-					    dev->port[i].cnts.set_id);
-
-	return ret;
+err_alloc:
+	mlx5_ib_dealloc_counters(dev);
+	return err;
 }
 
 static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
@@ -4026,7 +4024,7 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
 }
 
-static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
+static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct mlx5_ib_port *port,
 				    struct rdma_hw_stats *stats)
 {
@@ -4039,7 +4037,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_core_query_q_counter(dev->mdev,
+	ret = mlx5_core_query_q_counter(mdev,
 					port->cnts.set_id, 0,
 					out, outlen);
 	if (ret)
@@ -4061,28 +4059,43 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_port *port = &dev->port[port_num - 1];
+	struct mlx5_core_dev *mdev;
 	int ret, num_counters;
+	u8 mdev_port_num;
 
 	if (!stats)
 		return -EINVAL;
 
-	ret = mlx5_ib_query_q_counters(dev, port, stats);
+	num_counters = port->cnts.num_q_counters + port->cnts.num_cong_counters;
+
+	/* q_counters are per IB device, query the master mdev */
+	ret = mlx5_ib_query_q_counters(dev->mdev, port, stats);
 	if (ret)
 		return ret;
-	num_counters = port->cnts.num_q_counters;
 
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
+		mdev = mlx5_ib_get_native_port_mdev(dev, port_num,
+						    &mdev_port_num);
+		if (!mdev) {
+			/* If port is not affiliated yet, its in down state
+			 * which doesn't have any counters yet, so it would be
+			 * zero. So no need to read from the HCA.
+			 */
+			goto done;
+		}
 		ret = mlx5_lag_query_cong_counters(dev->mdev,
 						   stats->value +
 						   port->cnts.num_q_counters,
 						   port->cnts.num_cong_counters,
 						   port->cnts.offsets +
 						   port->cnts.num_q_counters);
+
+		mlx5_ib_put_native_port_mdev(dev, port_num);
 		if (ret)
 			return ret;
-		num_counters += port->cnts.num_cong_counters;
 	}
 
+done:
 	return num_counters;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 637fdc95f1ee..283b5f94898e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -652,6 +652,7 @@ struct mlx5_ib_counters {
 	u32 num_q_counters;
 	u32 num_cong_counters;
 	u16 set_id;
+	bool set_id_valid;
 };
 
 struct mlx5_ib_multiport_info;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
