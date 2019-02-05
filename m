From: Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH 12/12] net: Get rid of
	SWITCHDEV_ATTR_ID_PORT_PARENT_ID
Date: Tue, 5 Feb 2019 07:47:56 +0000
Message-ID: <20190205074753.GA9588@splinter>
References: <20190204233633.20421-1-f.fainelli@gmail.com>
	<20190204233633.20421-13-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20190204233633.20421-13-f.fainelli@gmail.com>
Content-Language: en-US
Content-ID: <F4A91D59FC94694C8C031C03687F90E8@eurprd05.prod.outlook.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, John Hurley <john.hurley@netronome.com>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Tyler Hicks <tyhicks@canonical.com>, Ivan Vecera <ivecera@redhat.com>, David Ahern <dsahern@gmail.com>, Ioana Radulescu <ruxandra.radulescu@nxp.com>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Amritha Nambiar <amritha.nambiar@intel.com>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Vivien Didelot <vivien.didelot@gmail.com>, Alexander Duyck <alexander.h.duyck@intel.com>open li
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 04, 2019 at 03:36:33PM -0800, Florian Fainelli wrote:
> Now that we have a dedicated NDO for getting a port's parent ID, get rid
> of SWITCHDEV_ATTR_ID_PORT_PARENT_ID and convert all callers to use the
> NDO exclusively. This is a preliminary change to getting rid of
> switchdev_ops eventually.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/net/switchdev.h   |  2 --
>  net/bridge/br_switchdev.c | 11 +++--------
>  net/core/net-sysfs.c      | 14 +++-----------
>  net/core/rtnetlink.c      | 16 ++++------------
>  net/ipv4/ipmr.c           | 14 ++++----------
>  net/switchdev/switchdev.c | 20 +++++++++-----------
>  6 files changed, 23 insertions(+), 54 deletions(-)
>=20
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index 63843ae5dc81..e1a5e8bc24b8 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -43,7 +43,6 @@ static inline bool switchdev_trans_ph_commit(struct swi=
tchdev_trans *trans)
> =20
>  enum switchdev_attr_id {
>  	SWITCHDEV_ATTR_ID_UNDEFINED,
> -	SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
>  	SWITCHDEV_ATTR_ID_PORT_STP_STATE,
>  	SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS,
>  	SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS_SUPPORT,
> @@ -61,7 +60,6 @@ struct switchdev_attr {
>  	void *complete_priv;
>  	void (*complete)(struct net_device *dev, int err, void *priv);
>  	union {
> -		struct netdev_phys_item_id ppid;	/* PORT_PARENT_ID */
>  		u8 stp_state;				/* PORT_STP_STATE */
>  		unsigned long brport_flags;		/* PORT_BRIDGE_FLAGS */
>  		unsigned long brport_flags_support;	/* PORT_BRIDGE_FLAGS_SUPPORT */
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 501a4221220a..620fd645f6f1 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -24,18 +24,13 @@ static int br_switchdev_mark_get(struct net_bridge *b=
r, struct net_device *dev)
>  int nbp_switchdev_mark_set(struct net_bridge_port *p)
>  {
>  	const struct net_device_ops *ops =3D p->dev->netdev_ops;
> -	struct switchdev_attr attr =3D {
> -		.orig_dev =3D p->dev,
> -		.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -	};
> -	int err;
> +	struct netdev_phys_item_id ppid =3D { };
> +	int err =3D -EOPNOTSUPP;
> =20
>  	ASSERT_RTNL();
> =20
>  	if (ops->ndo_get_port_parent_id)
> -		err =3D ops->ndo_get_port_parent_id(p->dev, &attr.u.ppid);
> -	else
> -		err =3D switchdev_port_attr_get(p->dev, &attr);
> +		err =3D ops->ndo_get_port_parent_id(p->dev, &ppid);
>  	if (err) {
>  		if (err =3D=3D -EOPNOTSUPP)
>  			return 0;
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index cc05e8b72657..1d2d76930afd 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -12,7 +12,6 @@
>  #include <linux/capability.h>
>  #include <linux/kernel.h>
>  #include <linux/netdevice.h>
> -#include <net/switchdev.h>
>  #include <linux/if_arp.h>
>  #include <linux/slab.h>
>  #include <linux/sched/signal.h>
> @@ -502,19 +501,12 @@ static ssize_t phys_switch_id_show(struct device *d=
ev,
>  		return restart_syscall();
> =20
>  	if (dev_isalive(netdev)) {
> -		struct switchdev_attr attr =3D {
> -			.orig_dev =3D netdev,
> -			.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -			.flags =3D SWITCHDEV_F_NO_RECURSE,

Florian, note this flag. We should not return the parent id in case this
is called for a stacked device. Maybe extend the ndo with a new
parameter called 'recurse' ? Or you can check here if device has lower
devices and bail.

> -		};
> +		struct netdev_phys_item_id ppid =3D { };
> =20
>  		if (ops->ndo_get_port_parent_id)
> -			ret =3D ops->ndo_get_port_parent_id(netdev, &attr.u.ppid);
> -		else
> -			ret =3D switchdev_port_attr_get(netdev, &attr);
> +			ret =3D ops->ndo_get_port_parent_id(netdev, &ppid);
>  		if (!ret)
> -			ret =3D sprintf(buf, "%*phN\n", attr.u.ppid.id_len,
> -				      attr.u.ppid.id);
> +			ret =3D sprintf(buf, "%*phN\n", ppid.id_len, ppid.id);
>  	}
>  	rtnl_unlock();
> =20
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index ed8564eb97c8..27bccf68538e 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -46,7 +46,6 @@
> =20
>  #include <linux/inet.h>
>  #include <linux/netdevice.h>
> -#include <net/switchdev.h>
>  #include <net/ip.h>
>  #include <net/protocol.h>
>  #include <net/arp.h>
> @@ -1147,25 +1146,18 @@ static int rtnl_phys_port_name_fill(struct sk_buf=
f *skb, struct net_device *dev)
>  static int rtnl_phys_switch_id_fill(struct sk_buff *skb, struct net_devi=
ce *dev)
>  {
>  	const struct net_device_ops *ops =3D dev->netdev_ops;
> -	int err;
> -	struct switchdev_attr attr =3D {
> -		.orig_dev =3D dev,
> -		.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -		.flags =3D SWITCHDEV_F_NO_RECURSE,

Same here.

> -	};
> +	struct netdev_phys_item_id ppid =3D { };
> +	int err =3D -EOPNOTSUPP;
> =20
>  	if (ops->ndo_get_port_parent_id)
> -		err =3D ops->ndo_get_port_parent_id(dev, &attr.u.ppid);
> -	else
> -		err =3D switchdev_port_attr_get(dev, &attr);
> +		err =3D ops->ndo_get_port_parent_id(dev, &ppid);
>  	if (err) {
>  		if (err =3D=3D -EOPNOTSUPP)
>  			return 0;
>  		return err;
>  	}
> =20
> -	if (nla_put(skb, IFLA_PHYS_SWITCH_ID, attr.u.ppid.id_len,
> -		    attr.u.ppid.id))
> +	if (nla_put(skb, IFLA_PHYS_SWITCH_ID, ppid.id_len, ppid.id))
>  		return -EMSGSIZE;
> =20
>  	return 0;
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index 9f67394b6691..ac592bd07be1 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -67,7 +67,6 @@
>  #include <net/fib_rules.h>
>  #include <linux/netconf.h>
>  #include <net/nexthop.h>
> -#include <net/switchdev.h>
> =20
>  #include <linux/nospec.h>
> =20
> @@ -837,11 +836,9 @@ static void ipmr_update_thresholds(struct mr_table *=
mrt, struct mr_mfc *cache,
>  static int vif_add(struct net *net, struct mr_table *mrt,
>  		   struct vifctl *vifc, int mrtsock)
>  {
> +	struct netdev_phys_item_id ppid =3D { };
>  	const struct net_device_ops *ops;
>  	int vifi =3D vifc->vifc_vifi;
> -	struct switchdev_attr attr =3D {
> -		.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -	};
>  	struct vif_device *v =3D &mrt->vif_table[vifi];
>  	struct net_device *dev;
>  	struct in_device *in_dev;
> @@ -923,12 +920,9 @@ static int vif_add(struct net *net, struct mr_table =
*mrt,
>  	attr.orig_dev =3D dev;
>  	ops =3D dev->netdev_ops;
>  	if (ops->ndo_get_port_parent_id &&
> -	    !ops->ndo_get_port_parent_id(dev, &attr.ppid)) {
> -		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
> -		v->dev_parent_id.id_len =3D attr.u.ppid.id_len;
> -	} else if (!switchdev_port_attr_get(dev, &attr)) {
> -		memcpy(v->dev_parent_id.id, attr.u.ppid.id, attr.u.ppid.id_len);
> -		v->dev_parent_id.id_len =3D attr.u.ppid.id_len;
> +	    !ops->ndo_get_port_parent_id(dev, &ppid)) {
> +		memcpy(v->dev_parent_id.id, ppid.id, ppid.id_len);
> +		v->dev_parent_id.id_len =3D ppid.id_len;
>  	} else {
>  		v->dev_parent_id.id_len =3D 0;
>  	}
> diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
> index cd78253de31d..57e0bfde67b4 100644
> --- a/net/switchdev/switchdev.c
> +++ b/net/switchdev/switchdev.c
> @@ -595,20 +595,18 @@ EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers=
);
>  bool switchdev_port_same_parent_id(struct net_device *a,
>  				   struct net_device *b)

I suggest to rename this function and move it to net/core/dev.c

>  {
> -	struct switchdev_attr a_attr =3D {
> -		.orig_dev =3D a,
> -		.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -	};
> -	struct switchdev_attr b_attr =3D {
> -		.orig_dev =3D b,
> -		.id =3D SWITCHDEV_ATTR_ID_PORT_PARENT_ID,
> -	};
> +	struct netdev_phys_item_id id_a =3D { };
> +	struct netdev_phys_item_id id_b =3D { };
> +
> +	if (!a->netdev_ops->ndo_get_port_parent_id ||
> +	    !b->netdev_ops->ndo_get_port_parent_id)
> +		return -EOPNOTSUPP;
> =20
> -	if (switchdev_port_attr_get(a, &a_attr) ||
> -	    switchdev_port_attr_get(b, &b_attr))
> +	if (a->netdev_ops->ndo_get_port_parent_id(a, &id_a) ||
> +	    b->netdev_ops->ndo_get_port_parent_id(b, &id_b))
>  		return false;
> =20
> -	return netdev_phys_item_id_same(&a_attr.u.ppid, &b_attr.u.ppid);
> +	return netdev_phys_item_id_same(&id_a, &id_b);
>  }
>  EXPORT_SYMBOL_GPL(switchdev_port_same_parent_id);
> =20
> --=20
> 2.17.1
>=20
