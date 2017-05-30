From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/mlx5: Change logic for dispatching IB events for port state
Date: Tue, 30 May 2017 09:56:05 +0300
Message-ID: <20170530065605.5814-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The old logic ignored link state. This led to missing IB events like
when link goes down on the switch while admin state is up or to redundant
events like when admin state goes up while link is down.
To fix that, probe the port state on NETDEV events and compare to last
known state to decide if IB events needs to be dispatched.

FIxes: 5ec8c83e3ad3 ("IB/mlx5: Port events in RoCE now rely on netdev events")
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 33 +++++++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  1 +
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d45772da0963..5944b4a34a73 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -98,6 +98,20 @@ mlx5_ib_port_link_layer(struct ib_device *device, u8 port_num)
 	return mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 }

+static int get_port_state(struct ib_device *ibdev,
+			  u8 port_num,
+			  enum ib_port_state *state)
+{
+	struct ib_port_attr attr;
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	ret = mlx5_ib_query_port(ibdev, port_num, &attr);
+	if (!ret)
+		*state = attr.state;
+	return ret;
+}
+
 static int mlx5_netdev_event(struct notifier_block *this,
 			     unsigned long event, void *ptr)
 {
@@ -115,6 +129,7 @@ static int mlx5_netdev_event(struct notifier_block *this,
 		write_unlock(&ibdev->roce.netdev_lock);
 		break;

+	case NETDEV_CHANGE:
 	case NETDEV_UP:
 	case NETDEV_DOWN: {
 		struct net_device *lag_ndev = mlx5_lag_get_roce_netdev(ibdev->mdev);
@@ -128,10 +143,23 @@ static int mlx5_netdev_event(struct notifier_block *this,
 		if ((upper == ndev || (!upper && ndev == ibdev->roce.netdev))
 		    && ibdev->ib_active) {
 			struct ib_event ibev = { };
+			enum ib_port_state port_state;

+			if (get_port_state(&ibdev->ib_dev, 1, &port_state))
+				return NOTIFY_DONE;
+
+			if (ibdev->roce.last_port_state == port_state)
+				return NOTIFY_DONE;
+
+			ibdev->roce.last_port_state = port_state;
 			ibev.device = &ibdev->ib_dev;
-			ibev.event = (event == NETDEV_UP) ?
-				     IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
+			if (port_state == IB_PORT_DOWN)
+				ibev.event = IB_EVENT_PORT_ERR;
+			else if (port_state == IB_PORT_ACTIVE)
+				ibev.event = IB_EVENT_PORT_ACTIVE;
+			else
+				return NOTIFY_DONE;
+
 			ibev.element.port_num = 1;
 			ib_dispatch_event(&ibev);
 		}
@@ -3745,6 +3773,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		err = mlx5_enable_eth(dev);
 		if (err)
 			goto err_free_port;
+		dev->roce.last_port_state = IB_PORT_DOWN;
 	}

 	err = create_dev_resources(&dev->devr);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 38c877bc45e5..5b78b09b4a23 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -616,6 +616,7 @@ struct mlx5_roce {
 	struct net_device	*netdev;
 	struct notifier_block	nb;
 	atomic_t		next_port;
+	enum ib_port_state last_port_state;
 };

 struct mlx5_ib_dev {
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
