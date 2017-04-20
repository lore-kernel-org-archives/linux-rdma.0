From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/ipoib: add get_settings in ethtool
Date: Thu, 20 Apr 2017 13:54:29 +0300
Message-ID: <20170420105428.GH3338@yuval-lap>
References: <1492676141-19639-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492676141-19639-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 20, 2017 at 04:15:41AM -0400, Zhu Yanjun wrote:
> In order to let the bonding driver report the correct speed
> of the underlaying interfaces, when they are IPoIB, the ethtool
> function get_settings() in the IPoIB driver is implemented.
> 
> Run ethtool command, the result is as below:
> 
> [root@xxx ~]#ethtool ib0
> Settings for ib0:
>         Supported ports: [ ]
>         Supported link modes:   Not reported
>         Supported pause frame use: No
>         Supports auto-negotiation: No
>         Advertised link modes:  Not reported
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Speed: 40000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: off
>         MDI-X: Unknown
> 
> The speed of ipoib can be reached.
> 
> Cc: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 51 ++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> index bac455a..8c81566 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> @@ -155,7 +155,58 @@ static int ipoib_get_sset_count(struct net_device __always_unused *dev,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int ipoib_get_settings(struct net_device *netdev,
> +			       struct ethtool_cmd *ecmd)
> +{
> +	struct ipoib_dev_priv *priv = netdev_priv(netdev);
> +	struct ib_port_attr attr;
> +	u32 speed;
> +	int ret;
> +
> +	if (!netif_carrier_ok(netdev)) {
> +		ethtool_cmd_speed_set(ecmd, SPEED_UNKNOWN);
> +		ecmd->duplex = DUPLEX_UNKNOWN;
> +		return 0;
> +	}
> +
> +	ret = ib_query_port(priv->ca, priv->port, &attr);
> +	if (ret)
> +		return ret;
> +
> +	switch (attr.active_speed) {
> +	case IB_SPEED_DDR:
> +		speed = 5000; /* in deci-Mb/sec */
> +		break;
> +	case IB_SPEED_QDR:
> +		speed = 10000;
> +		break;
> +	case IB_SPEED_FDR10:
> +		speed = 10000;
> +		break;
> +	case IB_SPEED_FDR:
> +		speed = 14000;
> +		break;
> +	case IB_SPEED_EDR:
> +		speed = 25000;
> +		break;
> +	case IB_SPEED_SDR:
> +	default:
> +		speed = 2500;
> +		break;
> +	}
> +
> +	speed *= ib_width_enum_to_int(attr.active_width);
> +	if (speed < 0)
> +		return -EINVAL;

Can you try to combine this function with rate_show so we will not have
duplication of code?

> +
> +	ethtool_cmd_speed_set(ecmd, speed);
> +	ecmd->duplex = DUPLEX_FULL;
> +
> +	return 0;
> +}
> +
>  static const struct ethtool_ops ipoib_ethtool_ops = {
> +	.get_settings		= ipoib_get_settings,
>  	.get_drvinfo		= ipoib_get_drvinfo,
>  	.get_coalesce		= ipoib_get_coalesce,
>  	.set_coalesce		= ipoib_set_coalesce,
> -- 
> 2.7.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
