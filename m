From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/13] IB/mlx5: Use the new mlx5 core notifier API
Date: Mon, 26 Nov 2018 14:39:00 -0800
Message-ID: <20181126223908.15988-6-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the deprecated mlx5_interface->event mlx5_ib callback and use new
mlx5 notifier API to subscribe for mlx5 events.

For native mlx5_ib devices profiles pf_profile/nic_rep_profile register
the notifier callback mlx5_ib_handle_event which treats the notifier
context as mlx5_ib_dev.

For vport repesentors, don't register any notifier, same as before, they
didn't receive any mlx5 events.

For slave port (mlx5_ib_multiport_info) register a different notifier
callback mlx5_ib_event_slave_port, which knows that the event is coming
for mlx5_ib_multiport_info and prepares the event job accordingly.
Before this on the event handler work we had to ask mlx5_core if this is
a slave port mlx5_core_is_mp_slave(work->dev), now it is not needed
anymore.
mlx5_ib_multiport_info notifier registration is done on
mlx5_ib_bind_slave_port and de-registration is done on
mlx5_ib_unbind_slave_port.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 77 +++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  3 ++
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index fcf4a0328a90..549c766cf309 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -82,10 +82,13 @@ static char mlx5_version[] =
 
 struct mlx5_ib_event_work {
 	struct work_struct	work;
-	struct mlx5_core_dev	*dev;
-	void			*context;
+	union {
+		struct mlx5_ib_dev	      *dev;
+		struct mlx5_ib_multiport_info *mpi;
+	};
+	bool			is_slave;
 	enum mlx5_dev_event	event;
-	unsigned long		param;
+	void			*param;
 };
 
 enum {
@@ -4240,14 +4243,14 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	struct mlx5_ib_dev *ibdev;
 	struct ib_event ibev;
 	bool fatal = false;
-	u8 port = (u8)work->param;
+	u8 port = (u8)(unsigned long)work->param;
 
-	if (mlx5_core_is_mp_slave(work->dev)) {
-		ibdev = mlx5_ib_get_ibdev_from_mpi(work->context);
+	if (work->is_slave) {
+		ibdev = mlx5_ib_get_ibdev_from_mpi(work->mpi);
 		if (!ibdev)
 			goto out;
 	} else {
-		ibdev = work->context;
+		ibdev = work->dev;
 	}
 
 	switch (work->event) {
@@ -4256,7 +4259,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		mlx5_ib_handle_internal_error(ibdev);
 		fatal = true;
 		break;
-
 	case MLX5_DEV_EVENT_PORT_UP:
 	case MLX5_DEV_EVENT_PORT_DOWN:
 	case MLX5_DEV_EVENT_PORT_INITIALIZED:
@@ -4311,22 +4313,43 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	kfree(work);
 }
 
-static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
-			  enum mlx5_dev_event event, unsigned long param)
+static int mlx5_ib_event(struct notifier_block *nb,
+			 unsigned long event, void *param)
 {
 	struct mlx5_ib_event_work *work;
 
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
-		return;
+		return NOTIFY_DONE;
 
 	INIT_WORK(&work->work, mlx5_ib_handle_event);
-	work->dev = dev;
+	work->dev = container_of(nb, struct mlx5_ib_dev, mdev_events);
+	work->is_slave = false;
 	work->param = param;
-	work->context = context;
 	work->event = event;
 
 	queue_work(mlx5_ib_event_wq, &work->work);
+
+	return NOTIFY_OK;
+}
+
+static int mlx5_ib_event_slave_port(struct notifier_block *nb,
+				    unsigned long event, void *param)
+{
+	struct mlx5_ib_event_work *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return NOTIFY_DONE;
+
+	INIT_WORK(&work->work, mlx5_ib_handle_event);
+	work->mpi = container_of(nb, struct mlx5_ib_multiport_info, mdev_events);
+	work->is_slave = true;
+	work->param = param;
+	work->event = event;
+	queue_work(mlx5_ib_event_wq, &work->work);
+
+	return NOTIFY_OK;
 }
 
 static int set_has_smi_cap(struct mlx5_ib_dev *dev)
@@ -5357,6 +5380,11 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 		spin_unlock(&port->mp.mpi_lock);
 		return;
 	}
+
+	if (mpi->mdev_events.notifier_call)
+		mlx5_notifier_unregister(mpi->mdev, &mpi->mdev_events);
+	mpi->mdev_events.notifier_call = NULL;
+
 	mpi->ibdev = NULL;
 
 	spin_unlock(&port->mp.mpi_lock);
@@ -5412,6 +5440,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 
 	ibdev->port[port_num].mp.mpi = mpi;
 	mpi->ibdev = ibdev;
+	mpi->mdev_events.notifier_call = NULL;
 	spin_unlock(&ibdev->port[port_num].mp.mpi_lock);
 
 	err = mlx5_nic_vport_affiliate_multiport(ibdev->mdev, mpi->mdev);
@@ -5429,6 +5458,9 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 		goto unbind;
 	}
 
+	mpi->mdev_events.notifier_call = mlx5_ib_event_slave_port;
+	mlx5_notifier_register(mpi->mdev, &mpi->mdev_events);
+
 	err = mlx5_ib_init_cong_debugfs(ibdev, port_num);
 	if (err)
 		goto unbind;
@@ -6163,6 +6195,18 @@ static void mlx5_ib_stage_rep_reg_cleanup(struct mlx5_ib_dev *dev)
 	mlx5_ib_unregister_vport_reps(dev);
 }
 
+static int mlx5_ib_stage_dev_notifier_init(struct mlx5_ib_dev *dev)
+{
+	dev->mdev_events.notifier_call = mlx5_ib_event;
+	mlx5_notifier_register(dev->mdev, &dev->mdev_events);
+	return 0;
+}
+
+static void mlx5_ib_stage_dev_notifier_cleanup(struct mlx5_ib_dev *dev)
+{
+	mlx5_notifier_unregister(dev->mdev, &dev->mdev_events);
+}
+
 void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
 		      const struct mlx5_ib_profile *profile,
 		      int stage)
@@ -6228,6 +6272,9 @@ static const struct mlx5_ib_profile pf_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_stage_dev_res_init,
 		     mlx5_ib_stage_dev_res_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
+		     mlx5_ib_stage_dev_notifier_init,
+		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_ODP,
 		     mlx5_ib_stage_odp_init,
 		     mlx5_ib_stage_odp_cleanup),
@@ -6279,6 +6326,9 @@ static const struct mlx5_ib_profile nic_rep_profile = {
 	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_RESOURCES,
 		     mlx5_ib_stage_dev_res_init,
 		     mlx5_ib_stage_dev_res_cleanup),
+	STAGE_CREATE(MLX5_IB_STAGE_DEVICE_NOTIFIER,
+		     mlx5_ib_stage_dev_notifier_init,
+		     mlx5_ib_stage_dev_notifier_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_COUNTERS,
 		     mlx5_ib_stage_counters_init,
 		     mlx5_ib_stage_counters_cleanup),
@@ -6399,7 +6449,6 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 static struct mlx5_interface mlx5_ib_interface = {
 	.add            = mlx5_ib_add,
 	.remove         = mlx5_ib_remove,
-	.event          = mlx5_ib_event,
 	.protocol	= MLX5_INTERFACE_PROTOCOL_IB,
 };
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 27999fd32356..7326fb8710e0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -775,6 +775,7 @@ enum mlx5_ib_stages {
 	MLX5_IB_STAGE_NON_DEFAULT_CB,
 	MLX5_IB_STAGE_ROCE,
 	MLX5_IB_STAGE_DEVICE_RESOURCES,
+	MLX5_IB_STAGE_DEVICE_NOTIFIER,
 	MLX5_IB_STAGE_ODP,
 	MLX5_IB_STAGE_COUNTERS,
 	MLX5_IB_STAGE_CONG_DEBUGFS,
@@ -806,6 +807,7 @@ struct mlx5_ib_multiport_info {
 	struct list_head list;
 	struct mlx5_ib_dev *ibdev;
 	struct mlx5_core_dev *mdev;
+	struct notifier_block mdev_events;
 	struct completion unref_comp;
 	u64 sys_image_guid;
 	u32 mdev_refcnt;
@@ -893,6 +895,7 @@ struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	const struct uverbs_object_tree_def *driver_trees[7];
 	struct mlx5_core_dev		*mdev;
+	struct notifier_block		mdev_events;
 	struct mlx5_roce		roce[MLX5_MAX_PORTS];
 	int				num_ports;
 	/* serialize update of capability mask
-- 
2.19.1
