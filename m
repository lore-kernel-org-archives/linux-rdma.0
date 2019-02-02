From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC net-next 01/13] switchdev: Add SWITCHDEV_PORT_ATTR_SET,
 SWITCHDEV_PORT_ATTR_GET
Date: Sat, 2 Feb 2019 16:48:32 +0100
Message-ID: <20190202154832.GC2778@nanopsycho>
References: <20190201220657.30170-1-f.fainelli@gmail.com>
 <20190201220657.30170-2-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201220657.30170-2-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>, "David S. Miller" <davem@davemloft.net>, Derek Chickles <dchickles@marvell.com>, Satanand Burla <sburla@marvell.com>, Felix Manlunas <fmanlunas@marvell.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Vivien Didelot <vivien.didelot@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Fri, Feb 01, 2019 at 11:06:45PM CET, f.fainelli@gmail.com wrote:
>In preparation for allowing switchdev enabled drivers to veto specific
>attribute settings from within the context of the caller, introduce a
>new switchdev notifier type for port attributes.
>
>Suggested-by: Ido Schimmel <idosch@mellanox.com>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>---
> include/net/switchdev.h | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>index 63843ae5dc81..e62fb2693e00 100644
>--- a/include/net/switchdev.h
>+++ b/include/net/switchdev.h
>@@ -145,6 +145,9 @@ enum switchdev_notifier_type {
> 	SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE,
> 	SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE,
> 	SWITCHDEV_VXLAN_FDB_OFFLOADED,
>+
>+	SWITCHDEV_PORT_ATTR_SET, /* Blocking. */
>+	SWITCHDEV_PORT_ATTR_GET, /* Blocking. */

Not an UAPI, so you can put this right next to PORT_OBJ_* if needed.


> };
> 
> struct switchdev_notifier_info {
>@@ -167,6 +170,13 @@ struct switchdev_notifier_port_obj_info {
> 	bool handled;
> };
> 
>+struct switchdev_notifier_port_attr_info {
>+	struct switchdev_notifier_info info; /* must be first */
>+	struct switchdev_attr *attr;
>+	struct switchdev_trans *trans;
>+	bool handled;
>+};
>+
> static inline struct net_device *
> switchdev_notifier_info_to_dev(const struct switchdev_notifier_info *info)
> {
>-- 
>2.17.1
>
