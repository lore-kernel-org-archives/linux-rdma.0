From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 10/13] net/mlx5e: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:54 -0800
Message-ID: <20190201220657.30170-11-f.fainelli@gmail.com>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190201220657.30170-1-f.fainelli@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: netdev@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, "Francois H. Theron" <francois.theron@netronome.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Ivan Vecera <ivecera@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Vivien Didelot <vivien.didelot@gmail.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Daniel Borkmann <daniel@iogearbox.net>, Simon Horman <simon.horman@netronome.com>, Satanand Burla <sburla@marvell.com>, Ido Schimmel <idosch@mellanox.com>, Jiri Pirko <jiri@>
List-Id: linux-rdma@vger.kernel.org

Following patches will change the way we communicate getting or setting
a port's attribute and use a blocking notifier to perform those tasks.

Prepare mlx5e/en_rep.c to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
switchdev_ops::switchdev_port_attr_get operation.

We register a single blocking switchdev notifier for the entire set of
representors given that mlx5e_rep_register_vport_reps() gets called for
an Ethernet device.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 45 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +-
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dee0c8f3d4e9..fcfe1c9d3575 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5036,7 +5036,9 @@ static void *mlx5e_add(struct mlx5_core_dev *mdev)
 #ifdef CONFIG_MLX5_ESWITCH
 	if (MLX5_ESWITCH_MANAGER(mdev) &&
 	    mlx5_eswitch_mode(mdev->priv.eswitch) == SRIOV_OFFLOADS) {
-		mlx5e_rep_register_vport_reps(mdev);
+		err = mlx5e_rep_register_vport_reps(mdev);
+		if (err)
+			return NULL;
 		return mdev;
 	}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 04736212a21c..9bac78e111c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1289,6 +1289,21 @@ static const struct switchdev_ops mlx5e_rep_switchdev_ops = {
 	.switchdev_port_attr_get	= mlx5e_attr_get,
 };
 
+static int mlx5e_rep_swdev_port_attr_event(unsigned long event,
+		struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = mlx5e_attr_get(dev, port_attr_info->attr);
+	port_attr_info->handled = true;
+
+	return notifier_from_errno(rc);
+}
+
 static const struct net_device_ops mlx5e_netdev_ops_vf_rep = {
 	.ndo_open                = mlx5e_vf_rep_open,
 	.ndo_stop                = mlx5e_vf_rep_close,
@@ -1321,6 +1336,22 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
 };
 
+static int mlx5e_rep_swdev_blocking_event(struct notifier_block *nb,
+					  unsigned long event, void *ptr)
+{
+	struct net_device *netdev = switchdev_notifier_info_to_dev(ptr);
+
+	if (netdev->netdev_ops != &mlx5e_netdev_ops_vf_rep)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return mlx5e_rep_swdev_port_attr_event(event, netdev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
 bool mlx5e_eswitch_rep(struct net_device *netdev)
 {
 	if (netdev->netdev_ops == &mlx5e_netdev_ops_vf_rep ||
@@ -1798,11 +1829,20 @@ static void *mlx5e_vport_rep_get_proto_dev(struct mlx5_eswitch_rep *rep)
 	return rpriv->netdev;
 }
 
-void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev)
+static struct notifier_block mlx5e_rep_swdev_nb = {
+	.notifier_call = mlx5e_rep_swdev_blocking_event,
+};
+
+int mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 	int total_vfs = MLX5_TOTAL_VPORTS(mdev);
 	int vport;
+	int rc;
+
+	rc = register_switchdev_blocking_notifier(&mlx5e_rep_swdev_nb);
+	if (rc)
+		return rc;
 
 	for (vport = 0; vport < total_vfs; vport++) {
 		struct mlx5_eswitch_rep_if rep_if = {};
@@ -1812,6 +1852,8 @@ void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev)
 		rep_if.get_proto_dev = mlx5e_vport_rep_get_proto_dev;
 		mlx5_eswitch_register_vport_rep(esw, vport, &rep_if, REP_ETH);
 	}
+
+	return rc;
 }
 
 void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev)
@@ -1822,4 +1864,5 @@ void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev)
 
 	for (vport = total_vfs - 1; vport >= 0; vport--)
 		mlx5_eswitch_unregister_vport_rep(esw, vport, REP_ETH);
+	unregister_switchdev_blocking_notifier(&mlx5e_rep_swdev_nb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index edd722824697..b9e0507f6100 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -162,7 +162,7 @@ struct mlx5e_rep_sq {
 };
 
 void *mlx5e_alloc_nic_rep_priv(struct mlx5_core_dev *mdev);
-void mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev);
+int mlx5e_rep_register_vport_reps(struct mlx5_core_dev *mdev);
 void mlx5e_rep_unregister_vport_reps(struct mlx5_core_dev *mdev);
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
-- 
2.17.1
