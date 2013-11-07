From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/mlx4_ib: Add support for steer-able IB UD QPs
Date: Thu,  7 Nov 2013 15:25:17 +0200
Message-ID: <1383830717-17312-7-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds support for steer-able (NETIF) QPs creation.
When we create the device, we allocate a range of steer-able QPs.

Afterwards, when a QP is created with the NETIF flag, it's allocated
from this range. Allocation is managed by bitmap allocator.

Internal steering rule for those QPs is automatically-generated upon
their creation.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |  106 +++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   11 ++++
 drivers/infiniband/hw/mlx4/qp.c      |   53 +++++++++++++++--
 3 files changed, 163 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ecfd48b..5573eb4 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1858,8 +1858,35 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	spin_lock_init(&ibdev->sm_lock);
 	mutex_init(&ibdev->cap_mask_mutex);
 
+	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED) {
+		ibdev->steer_qpn_count = MLX4_IB_UC_MAX_NUM_QPS;
+		err = mlx4_qp_reserve_range(dev, ibdev->steer_qpn_count,
+					    MLX4_IB_UC_STEER_QPN_ALIGN,
+					    &ibdev->steer_qpn_base);
+		if (err)
+			goto err_counter;
+
+		ibdev->ib_uc_qpns_bitmap =
+			kmalloc(BITS_TO_LONGS(ibdev->steer_qpn_count) *
+				sizeof(long),
+				GFP_KERNEL);
+		if (!ibdev->ib_uc_qpns_bitmap) {
+			dev_err(&dev->pdev->dev, "bit map alloc failed\n");
+			goto err_steer_qp_release;
+		}
+
+		bitmap_zero(ibdev->ib_uc_qpns_bitmap, ibdev->steer_qpn_count);
+
+		err = mlx4_FLOW_STEERING_IB_UC_QP_RANGE(
+				dev, ibdev->steer_qpn_base,
+				ibdev->steer_qpn_base +
+				ibdev->steer_qpn_count - 1);
+		if (err)
+			goto err_steer_free_bitmap;
+	}
+
 	if (ib_register_device(&ibdev->ib_dev, NULL))
-		goto err_counter;
+		goto err_steer_free_bitmap;
 
 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
@@ -1910,6 +1937,13 @@ err_mad:
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);
 
+err_steer_free_bitmap:
+	kfree(ibdev->ib_uc_qpns_bitmap);
+
+err_steer_qp_release:
+	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED)
+		mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
+				      ibdev->steer_qpn_count);
 err_counter:
 	for (; i; --i)
 		if (ibdev->counters[i - 1] != -1)
@@ -1930,6 +1964,69 @@ err_dealloc:
 	return NULL;
 }
 
+int mlx4_ib_steer_qp_alloc(struct mlx4_ib_dev *dev, int count, int *qpn)
+{
+	int offset;
+
+	WARN_ON(!dev->ib_uc_qpns_bitmap);
+
+	offset = bitmap_find_free_region(dev->ib_uc_qpns_bitmap,
+					 dev->steer_qpn_count,
+					 get_count_order(count));
+	if (offset < 0)
+		return offset;
+
+	*qpn = dev->steer_qpn_base + offset;
+	return 0;
+}
+
+void mlx4_ib_steer_qp_free(struct mlx4_ib_dev *dev, u32 qpn, int count)
+{
+	if (!qpn ||
+	    dev->steering_support != MLX4_STEERING_MODE_DEVICE_MANAGED)
+		return;
+
+	BUG_ON(qpn < dev->steer_qpn_base);
+
+	bitmap_release_region(dev->ib_uc_qpns_bitmap,
+			      qpn - dev->steer_qpn_base,
+			      get_count_order(count));
+}
+
+int mlx4_ib_steer_qp_reg(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
+			 int is_attach)
+{
+	int err;
+	size_t flow_size;
+	struct ib_flow_attr *flow = NULL;
+	struct ib_flow_spec_ib *ib_spec;
+
+	if (is_attach) {
+		flow_size = sizeof(struct ib_flow_attr) +
+			    sizeof(struct ib_flow_spec_ib);
+		flow = kzalloc(flow_size, GFP_KERNEL);
+		if (!flow)
+			return -ENOMEM;
+		flow->port = mqp->port;
+		flow->num_of_specs = 1;
+		flow->size = flow_size;
+		ib_spec = (struct ib_flow_spec_ib *)(flow + 1);
+		ib_spec->type = IB_FLOW_SPEC_IB;
+		ib_spec->size = sizeof(struct ib_flow_spec_ib);
+		/* Add an empty rule for IB L2 */
+		memset(&ib_spec->mask, 0, sizeof(ib_spec->mask));
+
+		err = __mlx4_ib_create_flow(&mqp->ibqp, flow,
+					    IB_FLOW_DOMAIN_NIC,
+					    MLX4_FS_REGULAR,
+					    &mqp->reg_id);
+	} else {
+		err = __mlx4_ib_destroy_flow(mdev->dev, mqp->reg_id);
+	}
+	kfree(flow);
+	return err;
+}
+
 static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 {
 	struct mlx4_ib_dev *ibdev = ibdev_ptr;
@@ -1943,6 +2040,13 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 			pr_warn("failure unregistering notifier\n");
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
+
+	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED) {
+		mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
+				      ibdev->steer_qpn_count);
+		kfree(ibdev->ib_uc_qpns_bitmap);
+	}
+
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
 		if (ibdev->counters[p] != -1)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index e9fb396..837f9aa 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -68,6 +68,8 @@ enum {
 /*module param to indicate if SM assigns the alias_GUID*/
 extern int mlx4_ib_sm_guid_assign;
 
+#define MLX4_IB_UC_STEER_QPN_ALIGN 1
+#define MLX4_IB_UC_MAX_NUM_QPS     256
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
@@ -153,6 +155,7 @@ struct mlx4_ib_wq {
 enum mlx4_ib_qp_flags {
 	MLX4_IB_QP_LSO = IB_QP_CREATE_IPOIB_UD_LSO,
 	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK = IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
+	MLX4_IB_QP_NETIF = IB_QP_CREATE_NETIF_QP,
 	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
 	MLX4_IB_SRIOV_SQP = 1 << 31,
 };
@@ -270,6 +273,7 @@ struct mlx4_ib_qp {
 	struct list_head	gid_list;
 	struct list_head	steering_rules;
 	struct mlx4_ib_buf	*sqp_proxy_rcv;
+	u64			reg_id;
 
 };
 
@@ -494,6 +498,9 @@ struct mlx4_ib_dev {
 	struct kobject	       *dev_ports_parent[MLX4_MFUNC_MAX];
 	struct mlx4_ib_iov_port	iov_ports[MLX4_MAX_PORTS];
 	struct pkey_mgt		pkeys;
+	unsigned long *ib_uc_qpns_bitmap;
+	int steer_qpn_count;
+	int steer_qpn_base;
 	int steering_support;
 };
 
@@ -753,5 +760,9 @@ void mlx4_ib_device_unregister_sysfs(struct mlx4_ib_dev *device);
 
 __be64 mlx4_ib_gen_node_guid(void);
 
+int mlx4_ib_steer_qp_alloc(struct mlx4_ib_dev *dev, int count, int *qpn);
+void mlx4_ib_steer_qp_free(struct mlx4_ib_dev *dev, u32 qpn, int count);
+int mlx4_ib_steer_qp_reg(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
+			 int is_attach);
 
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4f10af2..387fbf2 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -716,6 +716,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (init_attr->create_flags & IB_QP_CREATE_IPOIB_UD_LSO)
 			qp->flags |= MLX4_IB_QP_LSO;
 
+		if (init_attr->create_flags & IB_QP_CREATE_NETIF_QP) {
+			if (dev->steering_support ==
+			    MLX4_STEERING_MODE_DEVICE_MANAGED)
+				qp->flags |= MLX4_IB_QP_NETIF;
+			else
+				goto err;
+		}
+
 		err = set_kernel_sq_size(dev, &init_attr->cap, qp_type, qp);
 		if (err)
 			goto err;
@@ -765,7 +773,11 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (init_attr->qp_type == IB_QPT_RAW_PACKET)
 			err = mlx4_qp_reserve_range(dev->dev, 1, 1 << 8, &qpn);
 		else
-			err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
+			if (qp->flags & MLX4_IB_QP_NETIF)
+				err = mlx4_ib_steer_qp_alloc(dev, 1, &qpn);
+			else
+				err = mlx4_qp_reserve_range(dev->dev, 1, 1,
+							    &qpn);
 		if (err)
 			goto err_proxy;
 	}
@@ -790,8 +802,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	return 0;
 
 err_qpn:
-	if (!sqpn)
-		mlx4_qp_release_range(dev->dev, qpn, 1);
+	if (!sqpn) {
+		if (qp->flags & MLX4_IB_QP_NETIF)
+			mlx4_ib_steer_qp_free(dev, qpn, 1);
+		else
+			mlx4_qp_release_range(dev->dev, qpn, 1);
+	}
 err_proxy:
 	if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
 		free_proxy_bufs(pd->device, qp);
@@ -932,8 +948,12 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 
 	mlx4_qp_free(dev->dev, &qp->mqp);
 
-	if (!is_sqp(dev, qp) && !is_tunnel_qp(dev, qp))
-		mlx4_qp_release_range(dev->dev, qp->mqp.qpn, 1);
+	if (!is_sqp(dev, qp) && !is_tunnel_qp(dev, qp)) {
+		if (qp->flags & MLX4_IB_QP_NETIF)
+			mlx4_ib_steer_qp_free(dev, qp->mqp.qpn, 1);
+		else
+			mlx4_qp_release_range(dev->dev, qp->mqp.qpn, 1);
+	}
 
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
 
@@ -987,9 +1007,16 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	 */
 	if (init_attr->create_flags & ~(MLX4_IB_QP_LSO |
 					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK |
-					MLX4_IB_SRIOV_TUNNEL_QP | MLX4_IB_SRIOV_SQP))
+					MLX4_IB_SRIOV_TUNNEL_QP |
+					MLX4_IB_SRIOV_SQP |
+					MLX4_IB_QP_NETIF))
 		return ERR_PTR(-EINVAL);
 
+	if (init_attr->create_flags & IB_QP_CREATE_NETIF_QP) {
+		if (init_attr->qp_type != IB_QPT_UD)
+			return ERR_PTR(-EINVAL);
+	}
+
 	if (init_attr->create_flags &&
 	    (udata ||
 	     ((init_attr->create_flags & ~MLX4_IB_SRIOV_SQP) &&
@@ -1235,6 +1262,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	struct mlx4_qp_context *context;
 	enum mlx4_qp_optpar optpar = 0;
 	int sqd_event;
+	int steer_qp = 0;
 	int err = -EINVAL;
 
 	context = kzalloc(sizeof *context, GFP_KERNEL);
@@ -1319,6 +1347,11 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			optpar |= MLX4_QP_OPTPAR_COUNTER_INDEX;
 		} else
 			context->pri_path.counter_index = 0xff;
+
+		if (qp->flags & MLX4_IB_QP_NETIF) {
+			mlx4_ib_steer_qp_reg(dev, qp, 1);
+			steer_qp = 1;
+		}
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
@@ -1547,9 +1580,14 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		qp->sq_next_wqe = 0;
 		if (qp->rq.wqe_cnt)
 			*qp->db.db  = 0;
+
+		if (qp->flags & MLX4_IB_QP_NETIF)
+			mlx4_ib_steer_qp_reg(dev, qp, 0);
 	}
 
 out:
+	if (err && steer_qp)
+		mlx4_ib_steer_qp_reg(dev, qp, 0);
 	kfree(context);
 	return err;
 }
@@ -2762,6 +2800,9 @@ done:
 	if (qp->flags & MLX4_IB_QP_LSO)
 		qp_init_attr->create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
 
+	if (qp->flags & MLX4_IB_QP_NETIF)
+		qp_init_attr->create_flags |= IB_QP_CREATE_NETIF_QP;
+
 	qp_init_attr->sq_sig_type =
 		qp->sq_signal_bits == cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE) ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
