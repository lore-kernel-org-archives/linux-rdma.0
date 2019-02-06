From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 07/12] nfp: Implement ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 14:23:02 +0100
Message-ID: <20190206132302.GH2189@nanopsycho>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-8-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205235326.14600-8-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Feb 06, 2019 at 12:53:21AM CET, f.fainelli@gmail.com wrote:
>NFP only supports SWITCHDEV_ATTR_ID_PORT_PARENT_ID, which makes it a
>great candidate to be converted to use the ndo_get_port_parent_id() NDO
>instead of implementing switchdev_port_attr_get().
>
>Since NFP uses switchdev_port_same_parent_id() convert it to use
>netdev_port_same_parent_id().
>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

[...]

>@@ -31,34 +31,23 @@ struct nfp_port *nfp_port_from_netdev(struct net_device *netdev)
> 	return NULL;
> }
> 
>-static int
>-nfp_port_attr_get(struct net_device *netdev, struct switchdev_attr *attr)
>+int nfp_port_get_port_parent_id(struct net_device *netdev,
>+				struct netdev_phys_item_id *ppid)
> {
> 	struct nfp_port *port;
>+	const u8 *serial;
> 
> 	port = nfp_port_from_netdev(netdev);
> 	if (!port)
> 		return -EOPNOTSUPP;
> 
>-	switch (attr->id) {
>-	case SWITCHDEV_ATTR_ID_PORT_PARENT_ID: {
>-		const u8 *serial;
>-		/* N.B: attr->u.ppid.id is binary data */
>-		attr->u.ppid.id_len = nfp_cpp_serial(port->app->cpp, &serial);
>-		memcpy(&attr->u.ppid.id, serial, attr->u.ppid.id_len);
>-		break;
>-	}
>-	default:
>-		return -EOPNOTSUPP;
>-	}
>+	/* N.B: attr->u.ppid.id is binary data */

Comment is not updated. But I wonder if we really need it...

Otherwise this looks fine.
Acked-by: Jiri Pirko <jiri@mellanox.com>


>+	ppid->id_len = nfp_cpp_serial(port->app->cpp, &serial);
>+	memcpy(&ppid->id, serial, ppid->id_len);
> 
> 	return 0;
> }
> 
>-const struct switchdev_ops nfp_port_switchdev_ops = {
>-	.switchdev_port_attr_get	= nfp_port_attr_get,
>-};
>-
> int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
> 		      void *type_data)
> {

[...]
