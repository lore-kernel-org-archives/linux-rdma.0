From: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: Add readout of statistics using ethtool
Date: Thu, 21 Apr 2016 14:58:23 +0200
Message-ID: <5718CE6F.8080105@oracle.com>
References: <1460715468-16235-1-git-send-email-hans.westgaard.ry@oracle.com>
 <1461237201-25738-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461237201-25738-1-git-send-email-hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only difference between v2 and v3 of this patch is
"cosmetics"; When running checkpatch I got an error
  ERROR: code indent should use tabs where possible
#33: FILE: drivers/infiniband/ulp/ipoib/ipoib_ethtool.c:45:
+^I^I        .stat_string = #m, \$

So I decided to make yet another version ( I should of course have ran 
checkpatch before submitting v2)

Hans


On 04/21/2016 01:13 PM, Hans Westgaard Ry wrote:
> IPoIB collects statistics of traffic including number of packets
> sent/received, number of bytes transferred, and certain errors. This
> patch makes these statistics available to be queried by ethtool.
>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 67 ++++++++++++++++++++++++++++
>   1 file changed, 67 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> index a53fa5f..1502199 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> @@ -36,6 +36,27 @@
>   
>   #include "ipoib.h"
>   
> +struct ipoib_stats {
> +	char stat_string[ETH_GSTRING_LEN];
> +	int stat_offset;
> +};
> +
> +#define IPOIB_NETDEV_STAT(m) { \
> +		.stat_string = #m, \
> +		.stat_offset = offsetof(struct rtnl_link_stats64, m) }
> +
> +static const struct ipoib_stats ipoib_gstrings_stats[] = {
> +	IPOIB_NETDEV_STAT(rx_packets),
> +	IPOIB_NETDEV_STAT(tx_packets),
> +	IPOIB_NETDEV_STAT(rx_bytes),
> +	IPOIB_NETDEV_STAT(tx_bytes),
> +	IPOIB_NETDEV_STAT(tx_errors),
> +	IPOIB_NETDEV_STAT(rx_dropped),
> +	IPOIB_NETDEV_STAT(tx_dropped)
> +};
> +
> +#define IPOIB_GLOBAL_STATS_LEN	ARRAY_SIZE(ipoib_gstrings_stats)
> +
>   static void ipoib_get_drvinfo(struct net_device *netdev,
>   			      struct ethtool_drvinfo *drvinfo)
>   {
> @@ -92,11 +113,57 @@ static int ipoib_set_coalesce(struct net_device *dev,
>   
>   	return 0;
>   }
> +static void ipoib_get_ethtool_stats(struct net_device *dev,
> +				    struct ethtool_stats __always_unused *stats,
> +				    u64 *data)
> +{
> +	int i;
> +	struct net_device_stats *net_stats = &dev->stats;
> +	u8 *p = (u8 *)net_stats;
> +
> +	for (i = 0; i < IPOIB_GLOBAL_STATS_LEN; i++)
> +		data[i] = *(u64 *)(p + ipoib_gstrings_stats[i].stat_offset);
> +
> +}
> +static void ipoib_get_strings(struct net_device __always_unused *dev,
> +			      u32 stringset, u8 *data)
> +{
> +	u8 *p = data;
> +	int i;
> +
> +	switch (stringset) {
> +	case ETH_SS_STATS:
> +		for (i = 0; i < IPOIB_GLOBAL_STATS_LEN; i++) {
> +			memcpy(p, ipoib_gstrings_stats[i].stat_string,
> +				ETH_GSTRING_LEN);
> +			p += ETH_GSTRING_LEN;
> +		}
> +		break;
> +	case ETH_SS_TEST:
> +	default:
> +		break;
> +	}
> +}
> +static int ipoib_get_sset_count(struct net_device __always_unused *dev,
> +				 int sset)
> +{
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		return IPOIB_GLOBAL_STATS_LEN;
> +	case ETH_SS_TEST:
> +	default:
> +		break;
> +	}
> +	return -EOPNOTSUPP;
> +}
>   
>   static const struct ethtool_ops ipoib_ethtool_ops = {
>   	.get_drvinfo		= ipoib_get_drvinfo,
>   	.get_coalesce		= ipoib_get_coalesce,
>   	.set_coalesce		= ipoib_set_coalesce,
> +	.get_strings		= ipoib_get_strings,
> +	.get_ethtool_stats	= ipoib_get_ethtool_stats,
> +	.get_sset_count		= ipoib_get_sset_count,
>   };
>   
>   void ipoib_set_ethtool_ops(struct net_device *dev)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
