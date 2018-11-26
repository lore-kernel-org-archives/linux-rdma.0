From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 07/13] IB/mlx5: Handle raw port change event rather than the software version
Date: Mon, 26 Nov 2018 14:39:02 -0800
Message-ID: <20181126223908.15988-8-saeedm@mellanox.com>
References: <20181126223908.15988-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126223908.15988-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use the FW version of the port change event as forwarded via new mlx5
notifiers API.

After this patch, processed software version of the port change event
will become deprecated and will be totally removed in downstream
patches.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 86 +++++++++++++++++++------------
 1 file changed, 52 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 549c766cf309..a0668b923f78 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -87,7 +87,7 @@ struct mlx5_ib_event_work {
 		struct mlx5_ib_multiport_info *mpi;
 	};
 	bool			is_slave;
-	enum mlx5_dev_event	event;
+	unsigned int		event;
 	void			*param;
 };
 
@@ -4236,6 +4236,51 @@ static void delay_drop_handler(struct work_struct *work)
 	mutex_unlock(&delay_drop->lock);
 }
 
+static int handle_port_change(struct mlx5_ib_dev *ibdev, struct mlx5_eqe *eqe,
+			      struct ib_event *ibev)
+{
+	u8 port = (eqe->data.port.port >> 4) & 0xf;
+
+	ibev->element.port_num = port;
+
+	switch (eqe->sub_type) {
+	case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+	case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+	case MLX5_PORT_CHANGE_SUBTYPE_INITIALIZED:
+		/* In RoCE, port up/down events are handled in
+		 * mlx5_netdev_event().
+		 */
+		if (mlx5_ib_port_link_layer(&ibdev->ib_dev, port) ==
+					    IB_LINK_LAYER_ETHERNET)
+			return -EINVAL;
+
+		ibev->event = (eqe->sub_type == MLX5_PORT_CHANGE_SUBTYPE_ACTIVE) ?
+				IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
+		break;
+
+	case MLX5_PORT_CHANGE_SUBTYPE_LID:
+		ibev->event = IB_EVENT_LID_CHANGE;
+		break;
+
+	case MLX5_PORT_CHANGE_SUBTYPE_PKEY:
+		ibev->event = IB_EVENT_PKEY_CHANGE;
+		schedule_work(&ibdev->devr.ports[port - 1].pkey_change_work);
+		break;
+
+	case MLX5_PORT_CHANGE_SUBTYPE_GUID:
+		ibev->event = IB_EVENT_GID_CHANGE;
+		break;
+
+	case MLX5_PORT_CHANGE_SUBTYPE_CLIENT_REREG:
+		ibev->event = IB_EVENT_CLIENT_REREGISTER;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static void mlx5_ib_handle_event(struct work_struct *_work)
 {
 	struct mlx5_ib_event_work *work =
@@ -4243,7 +4288,6 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	struct mlx5_ib_dev *ibdev;
 	struct ib_event ibev;
 	bool fatal = false;
-	u8 port = (u8)(unsigned long)work->param;
 
 	if (work->is_slave) {
 		ibdev = mlx5_ib_get_ibdev_from_mpi(work->mpi);
@@ -4257,37 +4301,12 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 	case MLX5_DEV_EVENT_SYS_ERROR:
 		ibev.event = IB_EVENT_DEVICE_FATAL;
 		mlx5_ib_handle_internal_error(ibdev);
+		ibev.element.port_num  = (u8)(unsigned long)work->param;
 		fatal = true;
 		break;
-	case MLX5_DEV_EVENT_PORT_UP:
-	case MLX5_DEV_EVENT_PORT_DOWN:
-	case MLX5_DEV_EVENT_PORT_INITIALIZED:
-		/* In RoCE, port up/down events are handled in
-		 * mlx5_netdev_event().
-		 */
-		if (mlx5_ib_port_link_layer(&ibdev->ib_dev, port) ==
-			IB_LINK_LAYER_ETHERNET)
+	case MLX5_EVENT_TYPE_PORT_CHANGE:
+		if (handle_port_change(ibdev, work->param, &ibev))
 			goto out;
-
-		ibev.event = (work->event == MLX5_DEV_EVENT_PORT_UP) ?
-			     IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
-		break;
-
-	case MLX5_DEV_EVENT_LID_CHANGE:
-		ibev.event = IB_EVENT_LID_CHANGE;
-		break;
-
-	case MLX5_DEV_EVENT_PKEY_CHANGE:
-		ibev.event = IB_EVENT_PKEY_CHANGE;
-		schedule_work(&ibdev->devr.ports[port - 1].pkey_change_work);
-		break;
-
-	case MLX5_DEV_EVENT_GUID_CHANGE:
-		ibev.event = IB_EVENT_GID_CHANGE;
-		break;
-
-	case MLX5_DEV_EVENT_CLIENT_REREG:
-		ibev.event = IB_EVENT_CLIENT_REREGISTER;
 		break;
 	case MLX5_DEV_EVENT_DELAY_DROP_TIMEOUT:
 		schedule_work(&ibdev->delay_drop.delay_drop_work);
@@ -4296,11 +4315,10 @@ static void mlx5_ib_handle_event(struct work_struct *_work)
 		goto out;
 	}
 
-	ibev.device	      = &ibdev->ib_dev;
-	ibev.element.port_num = port;
+	ibev.device = &ibdev->ib_dev;
 
-	if (!rdma_is_port_valid(&ibdev->ib_dev, port)) {
-		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
+	if (!rdma_is_port_valid(&ibdev->ib_dev, ibev.element.port_num)) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n",  ibev.element.port_num);
 		goto out;
 	}
 
-- 
2.19.1
