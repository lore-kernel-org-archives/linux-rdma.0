From: Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC net-next 02/13] rocker: Handle SWITCHDEV_PORT_ATTR_GET/SET
Date: Fri,  1 Feb 2019 14:06:46 -0800
Message-ID: <20190201220657.30170-3-f.fainelli@gmail.com>
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

Prepare rocker to support receiving notifier events targeting
SWITCHDEV_PORT_ATTR_GET/SET and simply translate that into the existing
rocker_port_attr_{set,get} calls.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/rocker/rocker_main.c | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 62a205eba9f7..f25f7b4345b8 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2827,6 +2827,27 @@ rocker_switchdev_port_obj_event(unsigned long event, struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
+static int
+rocker_switchdev_port_attr_event(unsigned long event, struct net_device *netdev,
+				 struct switchdev_notifier_port_attr_info
+				 *port_attr_info)
+{
+	int err = -EOPNOTSUPP;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = rocker_port_attr_set(netdev, port_attr_info->attr,
+					   port_attr_info->trans);
+		break;
+	case SWITCHDEV_PORT_ATTR_GET:
+		err = rocker_port_attr_get(netdev, port_attr_info->attr);
+		break;
+	}
+
+	port_attr_info->handled = true;
+	return notifier_from_errno(err);
+}
+
 static int rocker_switchdev_blocking_event(struct notifier_block *unused,
 					   unsigned long event, void *ptr)
 {
@@ -2839,6 +2860,9 @@ static int rocker_switchdev_blocking_event(struct notifier_block *unused,
 	case SWITCHDEV_PORT_OBJ_ADD:
 	case SWITCHDEV_PORT_OBJ_DEL:
 		return rocker_switchdev_port_obj_event(event, dev, ptr);
+	case SWITCHDEV_PORT_ATTR_SET:
+	case SWITCHDEV_PORT_ATTR_GET:
+		return rocker_switchdev_port_attr_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
-- 
2.17.1
