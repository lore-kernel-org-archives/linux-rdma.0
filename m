From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/15] IB/mlx5: Update counter implementation for dual port RoCE
Date: Sun, 24 Dec 2017 14:57:36 +0200
Message-ID: <20171224125741.25464-11-leon@kernel.org>
References: <20171224125741.25464-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125741.25464-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
 drivers/infiniband/hw/mlx5/main.c    | 75 +++++++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d2fd7695fbe0..e61c0b2f29ba 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3765,11 +3765,12 @@ static const struct mlx5_ib_counter extended_err_cnts[] = {
 
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
@@ -3811,6 +3812,7 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 
 err_names:
 	kfree(cnts->names);
+	cnts->names = NULL;
 	return -ENOMEM;
 }
 
@@ -3857,37 +3859,33 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 
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
@@ -3906,7 +3904,7 @@ static struct rdma_hw_stats *mlx5_ib_alloc_hw_stats(struct ib_device *ibdev,
 					  RDMA_HW_STATS_DEFAULT_LIFESPAN);
 }
 
-static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
+static int mlx5_ib_query_q_counters(struct mlx5_core_dev *mdev,
 				    struct mlx5_ib_port *port,
 				    struct rdma_hw_stats *stats)
 {
@@ -3919,7 +3917,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_core_query_q_counter(dev->mdev,
+	ret = mlx5_core_query_q_counter(mdev,
 					port->cnts.set_id, 0,
 					out, outlen);
 	if (ret)
@@ -3935,7 +3933,7 @@ static int mlx5_ib_query_q_counters(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int mlx5_ib_query_cong_counters(struct mlx5_ib_dev *dev,
+static int mlx5_ib_query_cong_counters(struct mlx5_core_dev *mdev,
 				       struct mlx5_ib_port *port,
 				       struct rdma_hw_stats *stats)
 {
@@ -3948,7 +3946,7 @@ static int mlx5_ib_query_cong_counters(struct mlx5_ib_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_cmd_query_cong_counter(dev->mdev, false, out, outlen);
+	ret = mlx5_cmd_query_cong_counter(mdev, false, out, outlen);
 	if (ret)
 		goto free;
 
@@ -3969,23 +3967,38 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
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
-		ret = mlx5_ib_query_cong_counters(dev, port, stats);
+		mdev = mlx5_ib_get_native_port_mdev(dev, port_num,
+						    &mdev_port_num);
+		if (!mdev) {
+			/* If port is not affiliated yet, its in down state
+			 * which doesn't have any counters yet, so it would be
+			 * zero. So no need to read from the HCA.
+			 */
+			goto done;
+		}
+
+		ret = mlx5_ib_query_cong_counters(mdev, port, stats);
+		mlx5_ib_put_native_port_mdev(dev, port_num);
 		if (ret)
 			return ret;
-		num_counters += port->cnts.num_cong_counters;
 	}
 
+done:
 	return num_counters;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 518bfba88b2b..196b55b90c60 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -632,6 +632,7 @@ struct mlx5_ib_counters {
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
