From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 for-next 5/7] IB/mlx4: Add IB counters table
Date: Thu, 20 Aug 2015 17:34:33 +0300
Message-ID: <1440081275-15864-6-git-send-email-eranbe@mellanox.com>
References: <1440081275-15864-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440081275-15864-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an infrastructure step for allocating and attaching more than
one counter to QPs on the same port. Allocate a counters table and
manage the insertion and removals of the counters in load and unload of
mlx4 IB.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c     | 25 ++++++++++----
 drivers/infiniband/hw/mlx4/main.c    | 63 ++++++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  9 +++++-
 drivers/infiniband/hw/mlx4/qp.c      |  8 +++--
 4 files changed, 81 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1cd75ff..68f2567 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -824,18 +824,29 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 {
 	struct mlx4_counter counter_stats;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
-	int err;
+	struct counter_index *tmp_counter;
+	int err = IB_MAD_RESULT_FAILURE, stats_avail = 0;
 
 	if (in_mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_PERF_MGMT)
 		return -EINVAL;
 
 	memset(&counter_stats, 0, sizeof(counter_stats));
-	err = mlx4_get_counter_stats(dev->dev,
-				     dev->counters[port_num - 1].index,
-				     &counter_stats, 0);
-	if (err)
-		err = IB_MAD_RESULT_FAILURE;
-	else {
+	mutex_lock(&dev->counters_table[port_num - 1].mutex);
+	list_for_each_entry(tmp_counter,
+			    &dev->counters_table[port_num - 1].counters_list,
+			    list) {
+		err = mlx4_get_counter_stats(dev->dev,
+					     tmp_counter->index,
+					     &counter_stats, 0);
+		if (err) {
+			err = IB_MAD_RESULT_FAILURE;
+			stats_avail = 0;
+			break;
+		}
+		stats_avail = 1;
+	}
+	mutex_unlock(&dev->counters_table[port_num - 1].mutex);
+	if (stats_avail) {
 		memset(out_mad->data, 0, sizeof out_mad->data);
 		switch (counter_stats.counter_mode & 0xf) {
 		case 0:
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index efecdf0..26a96b8 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1247,6 +1247,22 @@ static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
 	return 0;
 }
 
+static void mlx4_ib_delete_counters_table(struct mlx4_ib_dev *ibdev,
+					  struct mlx4_ib_counters *ctr_table)
+{
+	struct counter_index *counter, *tmp_count;
+
+	mutex_lock(&ctr_table->mutex);
+	list_for_each_entry_safe(counter, tmp_count, &ctr_table->counters_list,
+				 list) {
+		if (counter->allocated)
+			mlx4_counter_free(ibdev->dev, counter->index);
+		list_del(&counter->list);
+		kfree(counter);
+	}
+	mutex_unlock(&ctr_table->mutex);
+}
+
 int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
 		   union ib_gid *gid)
 {
@@ -2131,6 +2147,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	int num_req_counters;
 	int allocated;
 	u32 counter_index;
+	struct counter_index *new_counter_index = NULL;
 
 	pr_info_once("%s", mlx4_ib_version);
 
@@ -2302,6 +2319,11 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (init_node_data(ibdev))
 		goto err_map;
 
+	for (i = 0; i < ibdev->num_ports; ++i) {
+		mutex_init(&ibdev->counters_table[i].mutex);
+		INIT_LIST_HEAD(&ibdev->counters_table[i].counters_list);
+	}
+
 	num_req_counters = mlx4_is_bonded(dev) ? 1 : ibdev->num_ports;
 	for (i = 0; i < num_req_counters; ++i) {
 		mutex_init(&ibdev->qp1_proxy_lock[i]);
@@ -2320,15 +2342,34 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			counter_index = mlx4_get_default_counter_index(dev,
 								       i + 1);
 		}
-		ibdev->counters[i].index = counter_index;
-		ibdev->counters[i].allocated = allocated;
+		new_counter_index = kmalloc(sizeof(*new_counter_index),
+					    GFP_KERNEL);
+		if (!new_counter_index) {
+			if (allocated)
+				mlx4_counter_free(ibdev->dev, counter_index);
+			goto err_counter;
+		}
+		new_counter_index->index = counter_index;
+		new_counter_index->allocated = allocated;
+		list_add_tail(&new_counter_index->list,
+			      &ibdev->counters_table[i].counters_list);
+		ibdev->counters_table[i].default_counter = counter_index;
 		pr_info("counter index %d for port %d allocated %d\n",
 			counter_index, i + 1, allocated);
 	}
 	if (mlx4_is_bonded(dev))
 		for (i = 1; i < ibdev->num_ports ; ++i) {
-			ibdev->counters[i].index = ibdev->counters[0].index;
-			ibdev->counters[i].allocated = 0;
+			new_counter_index =
+					kmalloc(sizeof(struct counter_index),
+						GFP_KERNEL);
+			if (!new_counter_index)
+				goto err_counter;
+			new_counter_index->index = counter_index;
+			new_counter_index->allocated = 0;
+			list_add_tail(&new_counter_index->list,
+				      &ibdev->counters_table[i].counters_list);
+			ibdev->counters_table[i].default_counter =
+								counter_index;
 		}
 
 	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
@@ -2437,12 +2478,9 @@ err_steer_qp_release:
 		mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
 				      ibdev->steer_qpn_count);
 err_counter:
-	for (i = 0; i < ibdev->num_ports; ++i) {
-		if (ibdev->counters[i].index != -1 &&
-		    ibdev->counters[i].allocated)
-			mlx4_counter_free(ibdev->dev,
-					  ibdev->counters[i].index);
-	}
+	for (i = 0; i < ibdev->num_ports; ++i)
+		mlx4_ib_delete_counters_table(ibdev, &ibdev->counters_table[i]);
+
 err_map:
 	iounmap(ibdev->uar_map);
 
@@ -2546,9 +2584,8 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
-		if (ibdev->counters[p].index != -1 &&
-		    ibdev->counters[p].allocated)
-			mlx4_counter_free(ibdev->dev, ibdev->counters[p].index);
+		mlx4_ib_delete_counters_table(ibdev, &ibdev->counters_table[p]);
+
 	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 1e7b23b..4056dc1 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -528,10 +528,17 @@ struct mlx4_ib_iov_port {
 };
 
 struct counter_index {
+	struct  list_head       list;
 	u32		index;
 	u8		allocated;
 };
 
+struct mlx4_ib_counters {
+	struct list_head        counters_list;
+	struct mutex            mutex; /* mutex for accessing counters list */
+	u32			default_counter;
+};
+
 struct mlx4_ib_dev {
 	struct ib_device	ib_dev;
 	struct mlx4_dev	       *dev;
@@ -550,7 +557,7 @@ struct mlx4_ib_dev {
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
 	struct mlx4_ib_iboe	iboe;
-	struct counter_index    counters[MLX4_MAX_PORTS];
+	struct mlx4_ib_counters counters_table[MLX4_MAX_PORTS];
 	int		       *eq_table;
 	struct kobject	       *iov_parent;
 	struct kobject	       *ports_parent;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4ad9be3..382913e 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1460,6 +1460,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	int sqd_event;
 	int steer_qp = 0;
 	int err = -EINVAL;
+	int counter_index;
 
 	/* APM is not supported under RoCE */
 	if (attr_mask & IB_QP_ALT_PATH &&
@@ -1543,9 +1544,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
-		if (dev->counters[qp->port - 1].index != -1) {
-			context->pri_path.counter_index =
-					dev->counters[qp->port - 1].index;
+		counter_index =
+			dev->counters_table[qp->port - 1].default_counter;
+		if (counter_index != -1) {
+			context->pri_path.counter_index = counter_index;
 			optpar |= MLX4_QP_OPTPAR_COUNTER_INDEX;
 		} else
 			context->pri_path.counter_index =
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
