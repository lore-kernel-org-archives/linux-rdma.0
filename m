From: Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v3 11/12] net: dsa: Implement
 ndo_get_port_parent_id()
Date: Wed, 6 Feb 2019 13:21:18 -0500
Message-ID: <20190206132118.GD9278@t480s.localdomain>
References: <20190205235326.14600-1-f.fainelli@gmail.com>
 <20190205235326.14600-12-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205235326.14600-12-f.fainelli@gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>, "David S. Miller" <davem@davemloft.net>, Ido Schimmel <idosch@mellanox.com>, open list <linux-kernel@vger.kernel.org>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

Hi Florian,

On Tue,  5 Feb 2019 15:53:25 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> DSA implements SWITCHDEV_ATTR_ID_PORT_PARENT_ID and we want to get rid
> of switchdev_ops eventually, ease that migration by implementing a
> ndo_get_port_parent_id() function which returns what
> switchdev_port_attr_get() would do.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  net/dsa/slave.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 91de3a663226..70395a0ae52e 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -362,18 +362,23 @@ static int dsa_slave_port_obj_del(struct net_device *dev,
>  	return err;
>  }
>  
> -static int dsa_slave_port_attr_get(struct net_device *dev,
> -				   struct switchdev_attr *attr)
> +static int dsa_slave_get_port_parent_id(struct net_device *dev,
> +					struct netdev_phys_item_id *ppid)
>  {
>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>  	struct dsa_switch *ds = dp->ds;
>  	struct dsa_switch_tree *dst = ds->dst;
>  
> +	ppid->id_len = sizeof(dst->index);
> +	memcpy(&ppid->id, &dst->index, ppid->id_len);
> +
> +	return 0;
> +}

Finally this will give us a way to distinguish two ports with the same switch
and port IDs on a system with two disjoint switch trees, thanks!

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
