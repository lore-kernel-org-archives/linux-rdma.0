From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 09/12] RDMA/mlx5: Refactor netdev affinity code
Date: Thu, 28 Mar 2019 15:27:39 +0200
Message-ID: <20190328132742.12070-10-leon@kernel.org>
References: <20190328132742.12070-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190328132742.12070-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

The design of representors is such that once an IB representor is created,
the netdev of representor already exists, we can use that fact to simplify
the netdev affinity code.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c |  2 ++
 drivers/infiniband/hw/mlx5/main.c   | 47 +++++++++++++++++++++++------
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index d3988f6ae2ae..7946cf26421b 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -71,6 +71,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	ibdev->is_rep = true;
 	ibdev->port[0].rep = rep;
+	ibdev->port[0].roce.netdev =
+		mlx5_ib_get_rep_netdev(dev->priv.eswitch, rep->vport);
 	ibdev->mdev = dev;
 	ibdev->num_ports = num_ports;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d9dfc9975164..9ce8ae5565a3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -156,6 +156,34 @@ static int get_port_state(struct ib_device *ibdev,
 	return ret;
 }
 
+static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
+					   struct net_device *ndev,
+					   u8 *port_num)
+{
+	struct mlx5_eswitch *esw = dev->mdev->priv.eswitch;
+	struct net_device *rep_ndev;
+	struct mlx5_ib_port *port;
+	int i;
+
+	for (i = 0; i < dev->num_ports; i++) {
+		port  = &dev->port[i];
+		if (!port->rep)
+			continue;
+
+		read_lock(&port->roce.netdev_lock);
+		rep_ndev = mlx5_ib_get_rep_netdev(esw,
+						  port->rep->vport);
+		if (rep_ndev == ndev) {
+			read_unlock(&port->roce.netdev_lock);
+			*port_num = i + 1;
+			return &port->roce;
+		}
+		read_unlock(&port->roce.netdev_lock);
+	}
+
+	return NULL;
+}
+
 static int mlx5_netdev_event(struct notifier_block *this,
 			     unsigned long event, void *ptr)
 {
@@ -172,22 +200,17 @@ static int mlx5_netdev_event(struct notifier_block *this,
 
 	switch (event) {
 	case NETDEV_REGISTER:
+		/* Should already be registered during the load */
+		if (ibdev->is_rep)
+			break;
 		write_lock(&roce->netdev_lock);
-		if (ibdev->is_rep) {
-			struct mlx5_eswitch *esw = ibdev->mdev->priv.eswitch;
-			struct mlx5_eswitch_rep	*rep = ibdev->port[0].rep;
-			struct net_device *rep_ndev;
-
-			rep_ndev = mlx5_ib_get_rep_netdev(esw, rep->vport);
-			if (rep_ndev == ndev)
-				roce->netdev = ndev;
-		} else if (ndev->dev.parent == &mdev->pdev->dev) {
+		if (ndev->dev.parent == &mdev->pdev->dev)
 			roce->netdev = ndev;
-		}
 		write_unlock(&roce->netdev_lock);
 		break;
 
 	case NETDEV_UNREGISTER:
+		/* In case of reps, ib device goes away before the netdevs */
 		write_lock(&roce->netdev_lock);
 		if (roce->netdev == ndev)
 			roce->netdev = NULL;
@@ -205,6 +228,10 @@ static int mlx5_netdev_event(struct notifier_block *this,
 			dev_put(lag_ndev);
 		}
 
+		if (ibdev->is_rep)
+			roce = mlx5_get_rep_roce(ibdev, ndev, &port_num);
+		if (!roce)
+			return NOTIFY_DONE;
 		if ((upper == ndev || (!upper && ndev == roce->netdev))
 		    && ibdev->ib_active) {
 			struct ib_event ibev = { };
-- 
2.20.1
