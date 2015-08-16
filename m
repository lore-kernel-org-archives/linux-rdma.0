From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/7] IB/mlx4: Add counter based implementation for QP multicast loopback block
Date: Sun, 16 Aug 2015 19:05:32 +0300
Message-ID: <1439741133-30145-7-git-send-email-eranbe@mellanox.com>
References: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439741133-30145-1-git-send-email-eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Current implementation for MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK is not
supported when link layer is Ethernet.

This patch will add counter based implementation for multicast loopback
prevention. HW can drop multicast loopback packets if sender QP counter
index is equal to receiver QP counter index. If qp flag
MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK is set and link layer is Ethernet,
create a new counter and attach it to the QP so it will continue
receiving multicast loopback traffic but it's own.

The decision if to create a new counter is being made at the qp
modification to RTR after the QP's port is set. When QP is destroyed or
moved back to reset state, delete the counter.

Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  1 +
 drivers/infiniband/hw/mlx4/qp.c      | 67 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 2b98459..af8ae51 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -307,6 +307,7 @@ struct mlx4_ib_qp {
 	struct list_head	qps_list;
 	struct list_head	cq_recv_list;
 	struct list_head	cq_send_list;
+	struct counter_index	*counter_index;
 };
 
 struct mlx4_ib_srq {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 382913e..2871949 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -617,6 +617,18 @@ static int qp0_enabled_vf(struct mlx4_dev *dev, int qpn)
 	return 0;
 }
 
+static void mlx4_ib_free_qp_counter(struct mlx4_ib_dev *dev,
+				    struct mlx4_ib_qp *qp)
+{
+	mutex_lock(&dev->counters_table[qp->port - 1].mutex);
+	mlx4_counter_free(dev->dev, qp->counter_index->index);
+	list_del(&qp->counter_index->list);
+	mutex_unlock(&dev->counters_table[qp->port - 1].mutex);
+
+	kfree(qp->counter_index);
+	qp->counter_index = NULL;
+}
+
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp **caller_qp,
@@ -1189,6 +1201,9 @@ int mlx4_ib_destroy_qp(struct ib_qp *qp)
 		mutex_unlock(&dev->qp1_proxy_lock[mqp->port - 1]);
 	}
 
+	if (mqp->counter_index)
+		mlx4_ib_free_qp_counter(dev, mqp);
+
 	pd = get_pd(mqp);
 	destroy_qp_common(dev, mqp, !!pd->ibpd.uobject);
 
@@ -1447,6 +1462,40 @@ static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *
 	return 0;
 }
 
+static int create_qp_lb_counter(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	struct counter_index *new_counter_index;
+	int err;
+	u32 tmp_idx;
+
+	if (rdma_port_get_link_layer(&dev->ib_dev, qp->port) !=
+	    IB_LINK_LAYER_ETHERNET ||
+	    !(qp->flags & MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK) ||
+	    !(dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_LB_SRC_CHK))
+		return 0;
+
+	err = mlx4_counter_alloc(dev->dev, &tmp_idx);
+	if (err)
+		return err;
+
+	new_counter_index = kmalloc(sizeof(*new_counter_index), GFP_KERNEL);
+	if (!new_counter_index) {
+		mlx4_counter_free(dev->dev, tmp_idx);
+		return -ENOMEM;
+	}
+
+	new_counter_index->index = tmp_idx;
+	new_counter_index->allocated = 1;
+	qp->counter_index = new_counter_index;
+
+	mutex_lock(&dev->counters_table[qp->port - 1].mutex);
+	list_add_tail(&new_counter_index->list,
+		      &dev->counters_table[qp->port - 1].counters_list);
+	mutex_unlock(&dev->counters_table[qp->port - 1].mutex);
+
+	return 0;
+}
+
 static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
@@ -1520,6 +1569,9 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		context->sq_size_stride = ilog2(qp->sq.wqe_cnt) << 3;
 	context->sq_size_stride |= qp->sq.wqe_shift - 4;
 
+	if (new_state == IB_QPS_RESET && qp->counter_index)
+		mlx4_ib_free_qp_counter(dev, qp);
+
 	if (cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT) {
 		context->sq_size_stride |= !!qp->sq_no_prefetch << 7;
 		context->xrcd = cpu_to_be32((u32) qp->xrcdn);
@@ -1544,11 +1596,24 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
+		err = create_qp_lb_counter(dev, qp);
+		if (err)
+			goto out;
+
 		counter_index =
 			dev->counters_table[qp->port - 1].default_counter;
+		if (qp->counter_index)
+			counter_index = qp->counter_index->index;
+
 		if (counter_index != -1) {
 			context->pri_path.counter_index = counter_index;
 			optpar |= MLX4_QP_OPTPAR_COUNTER_INDEX;
+			if (qp->counter_index) {
+				context->pri_path.fl |=
+					MLX4_FL_ETH_SRC_CHECK_MC_LB;
+				context->pri_path.vlan_control |=
+					MLX4_CTRL_ETH_SRC_CHECK_IF_COUNTER;
+			}
 		} else
 			context->pri_path.counter_index =
 				MLX4_SINK_COUNTER_INDEX(dev->dev);
@@ -1850,6 +1915,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		}
 	}
 out:
+	if (err && qp->counter_index)
+		mlx4_ib_free_qp_counter(dev, qp);
 	if (err && steer_qp)
 		mlx4_ib_steer_qp_reg(dev, qp, 0);
 	kfree(context);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
