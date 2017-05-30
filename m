From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/mlx5: Add support to dropless RQ
Date: Tue, 30 May 2017 10:29:13 +0300
Message-ID: <20170530072914.9709-5-leon@kernel.org>
References: <20170530072914.9709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530072914.9709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RQs that were configured for "delay drop" will prevent packet drops
when their WQEs are depleted.
Marking an RQ to be drop-less is done by setting delay_drop_en in RQ
context using CREATE_RQ command.

Since this feature is globally activated/deactivated by using the
SET_DELAY_DROP command on all the marked RQs, we activated/deactivated
it according to the number of RQs with 'delay_drop' enabled.

When timeout is expired, then the feature is deactivated. Therefore
the driver handles the delay drop timeout event and reactivate it.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 60 +++++++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 19 ++++++++++++
 drivers/infiniband/hw/mlx5/qp.c      | 37 ++++++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h        |  2 +-
 4 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 42defaa0d6c6..e76891a2a3b9 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -692,6 +692,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
 	}

+	if (MLX5_CAP_GEN(dev->mdev, rq_delay_drop) &&
+	    MLX5_CAP_GEN(dev->mdev, general_notification_event))
+		props->raw_packet_caps |= IB_RAW_PACKET_CAP_DELAY_DROP;
+
 	if (MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
 	    MLX5_CAP_ETH(dev->mdev, scatter_fcs)) {
 		/* Legacy bit to support old userspace libraries */
@@ -2698,6 +2702,24 @@ static void mlx5_ib_handle_internal_error(struct mlx5_ib_dev *ibdev)
 	spin_unlock_irqrestore(&ibdev->reset_flow_resource_lock, flags);
 }

+static void delay_drop_handler(struct work_struct *work)
+{
+	int err;
+	struct mlx5_ib_delay_drop *delay_drop =
+		container_of(work, struct mlx5_ib_delay_drop,
+			     delay_drop_work);
+
+	mutex_lock(&delay_drop->lock);
+	err = mlx5_core_set_delay_drop(delay_drop->dev->mdev,
+				       delay_drop->timeout);
+	if (err) {
+		mlx5_ib_warn(delay_drop->dev, "Failed to set delay drop, timeout=%u\n",
+			     delay_drop->timeout);
+		delay_drop->activate = false;
+	}
+	mutex_unlock(&delay_drop->lock);
+}
+
 static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 			  enum mlx5_dev_event event, unsigned long param)
 {
@@ -2750,8 +2772,11 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 		ibev.event = IB_EVENT_CLIENT_REREGISTER;
 		port = (u8)param;
 		break;
+	case MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT:
+		schedule_work(&ibdev->delay_drop.delay_drop_work);
+		goto out;
 	default:
-		return;
+		goto out;
 	}

 	ibev.device	      = &ibdev->ib_dev;
@@ -2759,7 +2784,7 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,

 	if (port < 1 || port > ibdev->num_ports) {
 		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
-		return;
+		goto out;
 	}

 	if (ibdev->ib_active)
@@ -2767,6 +2792,9 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,

 	if (fatal)
 		ibdev->ib_active = false;
+
+out:
+	return;
 }

 static int set_has_smi_cap(struct mlx5_ib_dev *dev)
@@ -3549,6 +3577,26 @@ static void mlx5_ib_free_rdma_netdev(struct net_device *netdev)
 	return mlx5_rdma_netdev_free(netdev);
 }

+static void cancel_delay_drop(struct mlx5_ib_dev *dev)
+{
+	if (!(dev->ib_dev.attrs.raw_packet_caps & IB_RAW_PACKET_CAP_DELAY_DROP))
+		return;
+
+	cancel_work_sync(&dev->delay_drop.delay_drop_work);
+}
+
+static void init_delay_drop(struct mlx5_ib_dev *dev)
+{
+	if (!(dev->ib_dev.attrs.raw_packet_caps & IB_RAW_PACKET_CAP_DELAY_DROP))
+		return;
+
+	mutex_init(&dev->delay_drop.lock);
+	dev->delay_drop.dev = dev;
+	dev->delay_drop.activate = false;
+	dev->delay_drop.timeout = MLX5_MAX_DELAY_DROP_TIMEOUT_MS * 1000;
+	INIT_WORK(&dev->delay_drop.delay_drop_work, delay_drop_handler);
+}
+
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -3780,18 +3828,21 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_dev;

+	init_delay_drop(dev);
+
 	for (i = 0; i < ARRAY_SIZE(mlx5_class_attributes); i++) {
 		err = device_create_file(&dev->ib_dev.dev,
 					 mlx5_class_attributes[i]);
 		if (err)
-			goto err_umrc;
+			goto err_delay_drop;
 	}

 	dev->ib_active = true;

 	return dev;

-err_umrc:
+err_delay_drop:
+	cancel_delay_drop(dev);
 	destroy_umrc_res(dev);

 err_dev:
@@ -3836,6 +3887,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 	struct mlx5_ib_dev *dev = context;
 	enum rdma_link_layer ll = mlx5_ib_port_link_layer(&dev->ib_dev, 1);

+	cancel_delay_drop(dev);
 	mlx5_remove_netdev_notifier(dev);
 	ib_unregister_device(&dev->ib_dev);
 	mlx5_free_bfreg(dev->mdev, &dev->fp_bfreg);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 38c877bc45e5..dd44624de56a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -247,6 +247,10 @@ struct mlx5_ib_wq {
 	void		       *qend;
 };

+enum mlx5_ib_wq_flags {
+	MLX5_IB_WQ_FLAGS_DELAY_DROP = 0x1,
+};
+
 struct mlx5_ib_rwq {
 	struct ib_wq		ibwq;
 	struct mlx5_core_qp	core_qp;
@@ -264,6 +268,7 @@ struct mlx5_ib_rwq {
 	u32			wqe_count;
 	u32			wqe_shift;
 	int			wq_sig;
+	u32			create_flags; /* Use enum mlx5_ib_wq_flags */
 };

 enum {
@@ -618,6 +623,19 @@ struct mlx5_roce {
 	atomic_t		next_port;
 };

+enum {
+	MLX5_MAX_DELAY_DROP_TIMEOUT_MS = 100,
+};
+
+struct mlx5_ib_delay_drop {
+	struct mlx5_ib_dev     *dev;
+	struct work_struct	delay_drop_work;
+	/* serialize setting of delay drop */
+	struct mutex		lock;
+	u32			timeout;
+	bool			activate;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -654,6 +672,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_port	*port;
 	struct mlx5_sq_bfreg     bfreg;
 	struct mlx5_sq_bfreg     fp_bfreg;
+	struct mlx5_ib_delay_drop delay_drop;
 };

 static inline struct mlx5_ib_cq *to_mibcq(struct mlx5_core_cq *mcq)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d17aad0f54c0..fe519487461e 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4610,6 +4610,24 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 	}
 }

+static int set_delay_drop(struct mlx5_ib_dev *dev)
+{
+	int err = 0;
+
+	mutex_lock(&dev->delay_drop.lock);
+	if (dev->delay_drop.activate)
+		goto out;
+
+	err = mlx5_core_set_delay_drop(dev->mdev, dev->delay_drop.timeout);
+	if (err)
+		goto out;
+
+	dev->delay_drop.activate = true;
+out:
+	mutex_unlock(&dev->delay_drop.lock);
+	return err;
+}
+
 static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		      struct ib_wq_init_attr *init_attr)
 {
@@ -4664,9 +4682,28 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 		}
 		MLX5_SET(rqc, rqc, scatter_fcs, 1);
 	}
+	if (init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP) {
+		if (!(dev->ib_dev.attrs.raw_packet_caps &
+		      IB_RAW_PACKET_CAP_DELAY_DROP)) {
+			mlx5_ib_dbg(dev, "Delay drop is not supported\n");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+		MLX5_SET(rqc, rqc, delay_drop_en, 1);
+	}
 	rq_pas0 = (__be64 *)MLX5_ADDR_OF(wq, wq, pas);
 	mlx5_ib_populate_pas(dev, rwq->umem, rwq->page_shift, rq_pas0, 0);
 	err = mlx5_core_create_rq_tracked(dev->mdev, in, inlen, &rwq->core_qp);
+	if (!err && init_attr->create_flags & IB_WQ_FLAGS_DELAY_DROP) {
+		err = set_delay_drop(dev);
+		if (err) {
+			mlx5_ib_warn(dev, "Failed to enable delay drop err=%d\n",
+				     err);
+			mlx5_core_destroy_rq_tracked(dev->mdev, &rwq->core_qp);
+		} else {
+			rwq->create_flags |= MLX5_IB_WQ_FLAGS_DELAY_DROP;
+		}
+	}
 out:
 	kvfree(in);
 	return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1e107d474802..b0578e46ed6d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2498,7 +2498,7 @@ enum {

 struct mlx5_ifc_rqc_bits {
 	u8         rlky[0x1];
-	u8         reserved_at_1[0x1];
+	u8	   delay_drop_en[0x1];
 	u8         scatter_fcs[0x1];
 	u8         vsd[0x1];
 	u8         mem_rq_type[0x4];
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
