From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v2 09/12] netdevsim: Implement ndo_get_port_parent_id()
Date: Tue,  5 Feb 2019 14:13:08 -0800
Message-ID: <20190205221311.18476-10-f.fainelli@gmail.com>
References: <20190205221311.18476-1-f.fainelli@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205221311.18476-1-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

netdevsim only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
great candidate to be converted to use the ndo_get_port_parent_id() NDO
instead of implementing switchdev_port_attr_get().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/netdevsim/netdev.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 8d8e2b3f263e..84de37478624 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -148,26 +148,16 @@ static struct device_type nsim_dev_type = {
 	.release = nsim_dev_release,
 };
 
-static int
-nsim_port_attr_get(struct net_device *dev, struct switchdev_attr *attr)
+static int nsim_get_port_parent_id(struct net_device *dev,
+				   struct netdev_phys_item_id *ppid)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID:
-		attr->u.ppid.id_len = sizeof(ns->sdev->switch_id);
-		memcpy(&attr->u.ppid.id, &ns->sdev->switch_id,
-		       attr->u.ppid.id_len);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
+	ppid->id_len = sizeof(ns->sdev->switch_id);
+	memcpy(&ppid->id, &ns->sdev->switch_id, ppid->id_len);
+	return 0;
 }
 
-static const struct switchdev_ops nsim_switchdev_ops = {
-	.switchdev_port_attr_get	= nsim_port_attr_get,
-};
-
 static int nsim_init(struct net_device *dev)
 {
 	char sdev_ddir_name[10], sdev_link_name[32];
@@ -214,7 +204,6 @@ static int nsim_init(struct net_device *dev)
 		goto err_bpf_uninit;
 
 	SET_NETDEV_DEV(dev, &ns->dev);
-	SWITCHDEV_SET_OPS(dev, &nsim_switchdev_ops);
 
 	err = nsim_devlink_setup(ns);
 	if (err)
@@ -493,6 +482,7 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
+	.ndo_get_port_parent_id	= nsim_get_port_parent_id,
 };
 
 static void nsim_setup(struct net_device *dev)
-- 
2.17.1
