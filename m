From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 03/12] RDMA/mlx5: Move netdev info into the port struct
Date: Thu, 28 Mar 2019 15:27:33 +0200
Message-ID: <20190328132742.12070-4-leon@kernel.org>
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

Netdev info is stored in a separate array and holds data relevant on a
per port basis, move it to be part of the port struct.

Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 30 ++++++++++++++--------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 ++++++-------
 drivers/infiniband/hw/mlx5/qp.c      |  2 +-
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e58ba0851983..a8522a0dedae 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -257,11 +257,11 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 
 	/* Ensure ndev does not disappear before we invoke dev_hold()
 	 */
-	read_lock(&ibdev->roce[port_num - 1].netdev_lock);
-	ndev = ibdev->roce[port_num - 1].netdev;
+	read_lock(&ibdev->port[port_num - 1].roce.netdev_lock);
+	ndev = ibdev->port[port_num - 1].roce.netdev;
 	if (ndev)
 		dev_hold(ndev);
-	read_unlock(&ibdev->roce[port_num - 1].netdev_lock);
+	read_unlock(&ibdev->port[port_num - 1].roce.netdev_lock);
 
 out:
 	mlx5_ib_put_native_port_mdev(ibdev, port_num);
@@ -1956,7 +1956,7 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 
 		atomic_set(&context->tx_port_affinity,
 			   atomic_add_return(
-				   1, &dev->roce[port].tx_port_affinity));
+				   1, &dev->port[port].roce.tx_port_affinity));
 	}
 
 	return 0;
@@ -5020,10 +5020,10 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	int err;
 
-	dev->roce[port_num].nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->roce[port_num].nb);
+	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
+	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
 	if (err) {
-		dev->roce[port_num].nb.notifier_call = NULL;
+		dev->port[port_num].roce.nb.notifier_call = NULL;
 		return err;
 	}
 
@@ -5032,9 +5032,9 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
-	if (dev->roce[port_num].nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->roce[port_num].nb);
-		dev->roce[port_num].nb.notifier_call = NULL;
+	if (dev->port[port_num].roce.nb.notifier_call) {
+		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
+		dev->port[port_num].roce.nb.notifier_call = NULL;
 	}
 }
 
@@ -5657,7 +5657,7 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 		mlx5_ib_err(ibdev, "Failed to unaffiliate port %u\n",
 			    port_num + 1);
 
-	ibdev->roce[port_num].last_port_state = IB_PORT_DOWN;
+	ibdev->port[port_num].roce.last_port_state = IB_PORT_DOWN;
 }
 
 /* The mlx5_ib_multiport_mutex should be held when calling this function */
@@ -5930,7 +5930,7 @@ int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 
 	for (i = 0; i < dev->num_ports; i++) {
 		spin_lock_init(&dev->port[i].mp.mpi_lock);
-		rwlock_init(&dev->roce[i].netdev_lock);
+		rwlock_init(&dev->port[i].roce.netdev_lock);
 	}
 
 	err = mlx5_ib_init_multiport_master(dev);
@@ -6233,9 +6233,9 @@ static int mlx5_ib_stage_common_roce_init(struct mlx5_ib_dev *dev)
 	int i;
 
 	for (i = 0; i < dev->num_ports; i++) {
-		dev->roce[i].dev = dev;
-		dev->roce[i].native_port_num = i + 1;
-		dev->roce[i].last_port_state = IB_PORT_DOWN;
+		dev->port[i].roce.dev = dev;
+		dev->port[i].roce.native_port_num = i + 1;
+		dev->port[i].roce.last_port_state = IB_PORT_DOWN;
 	}
 
 	dev->ib_dev.uverbs_ex_cmd_mask |=
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 16311cb05cae..662cc73b7b6b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -706,12 +706,6 @@ struct mlx5_ib_multiport {
 	spinlock_t mpi_lock;
 };
 
-struct mlx5_ib_port {
-	struct mlx5_ib_counters cnts;
-	struct mlx5_ib_multiport mp;
-	struct mlx5_ib_dbg_cc_params	*dbg_cc_params;
-};
-
 struct mlx5_roce {
 	/* Protect mlx5_ib_get_netdev from invoking dev_hold() with a NULL
 	 * netdev pointer
@@ -725,6 +719,13 @@ struct mlx5_roce {
 	u8			native_port_num;
 };
 
+struct mlx5_ib_port {
+	struct mlx5_ib_counters cnts;
+	struct mlx5_ib_multiport mp;
+	struct mlx5_ib_dbg_cc_params *dbg_cc_params;
+	struct mlx5_roce roce;
+};
+
 struct mlx5_ib_dbg_param {
 	int			offset;
 	struct mlx5_ib_dev	*dev;
@@ -909,7 +910,6 @@ struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
 	struct notifier_block		mdev_events;
-	struct mlx5_roce		roce[MLX5_MAX_PORTS];
 	int				num_ports;
 	/* serialize update of capability mask
 	 */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9a4fca35875c..d84c7f478513 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3296,7 +3296,7 @@ static unsigned int get_tx_affinity(struct mlx5_ib_dev *dev,
 	} else {
 		tx_port_affinity =
 			(unsigned int)atomic_add_return(
-				1, &dev->roce[port_num].tx_port_affinity) %
+				1, &dev->port[port_num].roce.tx_port_affinity) %
 				MLX5_MAX_PORTS +
 			1;
 		mlx5_ib_dbg(dev, "Set tx affinity 0x%x to qpn 0x%x\n",
-- 
2.20.1
