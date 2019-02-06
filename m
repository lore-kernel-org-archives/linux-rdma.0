From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v3 01/12] net: Introduce ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 13:54:50 +0100
Message-ID: <20190206125450.GB2189@nanopsycho>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-2-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205235326.14600-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Wed, Feb 06, 2019 at 12:53:15AM CET, f.fainelli@gmail.com wrote:
>In preparation for getting rid of switchdev_ops, create a dedicated NDO
>operation for getting the port's parent identifier. There are
>essentially two classes of drivers that need to implement getting the
>port's parent ID which are VF/PF drivers with a built-in switch, and
>pure switchdev drivers such as mlxsw, ocelot, dsa etc.
>
>We introduce a helper function: dev_get_port_parent_id() which supports
>recursing into the lower devices to obtain the first port's parent ID.
>
>Convert the bridge, core and ipv4 multicast routing code to check for
>such ndo_get_port_parent_id() and call the helper functino when valid

s/functino/function/


>before falling back to switchdev_port_attr_get(). This will allow us to
>convert all relevant drivers in one go instead of having to implement
>both switchdev_port_attr_get() and ndo_get_port_parent_id() operations,
>then get rid of switchdev_port_attr_get().

[...]


>@@ -3651,6 +3657,9 @@ int dev_get_phys_port_id(struct net_device *dev,
> 			 struct netdev_phys_item_id *ppid);
> int dev_get_phys_port_name(struct net_device *dev,
> 			   char *name, size_t len);
>+int dev_get_port_parent_id(struct net_device *dev,
>+			   struct netdev_phys_item_id *ppid, bool recurse);
>+bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);

One is "dev_" and the second is "netdev_". I see there is this
disconnect all over the code, but I wonder if we should not be
consistent for new things. But I don't insist. I see why both are named
differently (netdev_phys_item_id_same())

Acked-by: Jiri Pirko <jiri@mellanox.com>
