From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 12/13] netdevsim: Handle SWITCHDEV_PORT_ATTR_GET event
Date: Fri,  1 Feb 2019 14:06:56 -0800
Message-ID: <20190201220657.30170-13-f.fainelli@gmail.com>
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

Prepare netdevsim to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET and simply translate that into the existing
switchdev_ops::switchdev_port_attr_get operation.

We register a single blocking switchdev notifier for the entire driver
instance.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/netdevsim/netdev.c | 43 +++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 8d8e2b3f263e..817d94cec90f 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -168,6 +168,20 @@ static const struct switchdev_ops nsim_switchdev_ops = {
 	.switchdev_port_attr_get	= nsim_port_attr_get,
 };
 
+static int nsim_switchdev_port_attr_event(unsigned long event,
+		struct net_device *dev,
+		struct switchdev_notifier_port_attr_info *port_attr_info)
+{
+	int rc;
+
+	if (event != SWITCHDEV_PORT_ATTR_GET)
+		return NOTIFY_DONE;
+
+	rc = nsim_port_attr_get(dev, port_attr_info->attr);
+	port_attr_info->handled = true;
+	return notifier_from_errno(rc);
+}
+
 static int nsim_init(struct net_device *dev)
 {
 	char sdev_ddir_name[10], sdev_link_name[32];
@@ -495,6 +509,26 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_bpf		= nsim_bpf,
 };
 
+static int nsim_swdev_blocking_event(struct notifier_block *nb,
+				     unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+
+	if (dev->netdev_ops != &nsim_netdev_ops)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_GET:
+		return nsim_switchdev_port_attr_event(event, dev, ptr);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nsim_swdev_blocking_nb = {
+	.notifier_call = nsim_swdev_blocking_event,
+};
+
 static void nsim_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -583,10 +617,14 @@ static int __init nsim_module_init(void)
 		goto err_debugfs_destroy;
 	}
 
-	err = bus_register(&nsim_bus);
+	err = register_switchdev_blocking_notifier(&nsim_swdev_blocking_nb);
 	if (err)
 		goto err_sdir_destroy;
 
+	err = bus_register(&nsim_bus);
+	if (err)
+		goto err_unreg_notifier;
+
 	err = nsim_devlink_init();
 	if (err)
 		goto err_unreg_bus;
@@ -601,6 +639,8 @@ static int __init nsim_module_init(void)
 	nsim_devlink_exit();
 err_unreg_bus:
 	bus_unregister(&nsim_bus);
+err_unreg_notifier:
+	unregister_switchdev_blocking_notifier(&nsim_swdev_blocking_nb);
 err_sdir_destroy:
 	debugfs_remove_recursive(nsim_sdev_ddir);
 err_debugfs_destroy:
@@ -613,6 +653,7 @@ static void __exit nsim_module_exit(void)
 	rtnl_link_unregister(&nsim_link_ops);
 	nsim_devlink_exit();
 	bus_unregister(&nsim_bus);
+	unregister_switchdev_blocking_notifier(&nsim_swdev_blocking_nb);
 	debugfs_remove_recursive(nsim_sdev_ddir);
 	debugfs_remove_recursive(nsim_ddir);
 }
-- 
2.17.1
