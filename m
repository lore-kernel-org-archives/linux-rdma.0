From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 12/12] net: Get rid of
 SWITCHDEV_ATTR_ID_PORT_PARENT_ID
Date: Wed, 6 Feb 2019 14:34:31 +0100
Message-ID: <20190206133431.GL2189@nanopsycho>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-13-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205235326.14600-13-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Feb 06, 2019 at 12:53:26AM CET, f.fainelli@gmail.com wrote:
>Now that we have a dedicated NDO for getting a port's parent ID, get rid
>of SWITCHDEV_ATTR_ID_PORT_PARENT_ID and convert all callers to use the
>NDO exclusively. This is a preliminary change to getting rid of
>switchdev_ops eventually.
>
>Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

[...]


>@@ -24,19 +23,12 @@ static int br_switchdev_mark_get(struct net_bridge *br, struct net_device *dev)
> 
> int nbp_switchdev_mark_set(struct net_bridge_port *p)
> {
>-	const struct net_device_ops *ops = p->dev->netdev_ops;
>-	struct switchdev_attr attr = {
>-		.orig_dev = p->dev,
>-		.id = SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
>-	};
>-	int err;
>+	struct netdev_phys_item_id ppid = { };
>+	int err = -EOPNOTSUPP;

Pointless init.


> 
> 	ASSERT_RTNL();
> 
>-	if (ops->ndo_get_port_parent_id)
>-		err = dev_get_port_parent_id(p->dev, &attr.u.ppid, true);
>-	else
>-		err = switchdev_port_attr_get(p->dev, &attr);
>+	err = dev_get_port_parent_id(p->dev, &ppid, true);
> 	if (err) {
> 		if (err == -EOPNOTSUPP)
> 			return 0;

[...]


>@@ -1146,26 +1145,17 @@ static int rtnl_phys_port_name_fill(struct sk_buff *skb, struct net_device *dev)
> 
> static int rtnl_phys_switch_id_fill(struct sk_buff *skb, struct net_device *dev)
> {
>-	const struct net_device_ops *ops = dev->netdev_ops;
>-	int err;
>-	struct switchdev_attr attr = {
>-		.orig_dev = dev,
>-		.id = SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
>-		.flags = SWITCHDEV_F_NO_RECURSE,
>-	};
>+	struct netdev_phys_item_id ppid = { };
>+	int err = -EOPNOTSUPP;

Pointless init.


> 
>-	if (ops->ndo_get_port_parent_id)
>-		err = dev_get_port_parent_id(dev, &attr.u.ppid, false);
>-	else
>-		err = switchdev_port_attr_get(dev, &attr);
>+	err = dev_get_port_parent_id(dev, &ppid, false);
> 	if (err) {
> 		if (err == -EOPNOTSUPP)
> 			return 0;
> 		return err;
> 	}
> 
>-	if (nla_put(skb, IFLA_PHYS_SWITCH_ID, attr.u.ppid.id_len,
>-		    attr.u.ppid.id))
>+	if (nla_put(skb, IFLA_PHYS_SWITCH_ID, ppid.id_len, ppid.id))
> 		return -EMSGSIZE;
> 
> 	return 0;

[...]

	
>@@ -920,15 +917,10 @@ static int vif_add(struct net *net, struct mr_table *mrt,
> 			vifc->vifc_flags | (!mrtsock ? VIFF_STATIC : 0),
> 			(VIFF_TUNNEL | VIFF_REGISTER));
> 
>-	attr.orig_dev = dev;
> 	ops = dev->netdev_ops;
>-	if (ops->ndo_get_port_parent_id &&
>-	    !dev_get_port_parent_id(dev, &attr.u.ppid, true)) {
>-		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
>-		v->dev_parent_id.id_len = attr.u.ppid.id_len;
>-	} else if (!switchdev_port_attr_get(dev, &attr)) {
>-		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
>-		v->dev_parent_id.id_len = attr.u.ppid.id_len;
>+	if (!dev_get_port_parent_id(dev, &ppid, true)) {

Please split this to:
	err = dev_get_port_parent_id(dev, &ppid, true);
	if (err) {


>+		memcpy(v->dev_parent_id.id, ppid.id, ppid.id_len);
>+		v->dev_parent_id.id_len = ppid.id_len;
> 	} else {
> 		v->dev_parent_id.id_len = 0;
> 	}

[...]
