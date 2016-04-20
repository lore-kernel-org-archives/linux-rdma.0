From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1] IB/ipoib: Add readout of statistics using ethtool
Date: Wed, 20 Apr 2016 00:58:42 -0700
Message-ID: <1461139122.1917.52.camel@perches.com>
References: <1460715468-16235-1-git-send-email-hans.westgaard.ry@oracle.com>
	 <1461138630-15158-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461138630-15158-1-git-send-email-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Or Gerlitz <ogerlitz@mellanox.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2016-04-20 at 09:50 +0200, Hans Westgaard Ry wrote:
> IPoIB collects statistics of traffic including number of packets
> sent/received, number of bytes transferred, and certain errors. This
> patch makes these statistics available to be queried by ethtool.

trivial notes:

> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/i=
nfiniband/ulp/ipoib/ipoib_ethtool.c
[]
> @@ -36,6 +36,31 @@
> =A0
> =A0#include "ipoib.h"
> =A0
> +struct ipoib_stats {
> +	char stat_string[ETH_GSTRING_LEN];
> +	int stat_offset;
> +};
> +
> +
> +#define IPOIB_NETDEV_STAT(str, m) { \
> +		.stat_string =3D str, \
> +		.stat_offset =3D offsetof(struct rtnl_link_stats64, m) }
> +
> +
> +

A few unnecessary extra blank lines

> +static const struct ipoib_stats ipoib_gstrings_stats[] =3D {
> +	IPOIB_NETDEV_STAT("rx_packets", rx_packets),
> +	IPOIB_NETDEV_STAT("tx_packets", tx_packets),
> +	IPOIB_NETDEV_STAT("rx_bytes",=A0=A0=A0rx_bytes),
> +	IPOIB_NETDEV_STAT("tx_bytes",=A0=A0=A0tx_bytes),
> +	IPOIB_NETDEV_STAT("tx_errors",=A0=A0tx_errors),
> +	IPOIB_NETDEV_STAT("rx_dropped", rx_dropped),
> +	IPOIB_NETDEV_STAT("tx_dropped", tx_dropped)
> +};

Couldn't the macro could be simplified by using # and
a single argument?


> +static int ipoib_get_sset_count(struct net_device __always_unused *d=
ev,
> +				=A0int sset)
> +{
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		return IPOIB_GLOBAL_STATS_LEN;
> +	case ETH_SS_TEST:
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}

Didn't some old versions of gcc complain about reaching
the end of a non-void function?
