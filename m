From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/ipoib: Let lower driver handle get_stats64
 call
Date: Mon, 12 Jun 2017 11:06:26 +0300
Message-ID: <20170612080625.GA9915@yuvallap>
References: <20170612074521.15785-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612074521.15785-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 12, 2017 at 10:45:21AM +0300, Leon Romanovsky wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The driver checks if the lower level driver supports get_stats, and if
> so calls it to get the updated statistics, otherwise takes from the
> current netdevice stats object.
> 
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index a115c0b7a310..6ff924111d5a 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -261,6 +261,17 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
>  	return 0;
>  }
> 
> +static void ipoib_get_stats(struct net_device *dev,
> +			    struct rtnl_link_stats64 *stats)
> +{
> +	struct ipoib_dev_priv *priv = ipoib_priv(dev);
> +
> +	if (priv->rn_ops->ndo_get_stats64)
> +		priv->rn_ops->ndo_get_stats64(dev, stats);
> +	else
> +		netdev_stats_to_stats64(stats, &dev->stats);
> +}
> +
>  /* Called with an RCU read lock taken */
>  static bool ipoib_is_dev_match_addr_rcu(const struct sockaddr *addr,
>  					struct net_device *dev)
> @@ -1805,6 +1816,7 @@ static const struct net_device_ops ipoib_netdev_ops_pf = {
>  	.ndo_get_vf_stats	 = ipoib_get_vf_stats,
>  	.ndo_set_vf_guid	 = ipoib_set_vf_guid,
>  	.ndo_set_mac_address	 = ipoib_set_mac,
> +	.ndo_get_stats64	 = ipoib_get_stats,
>  };

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
>  static const struct net_device_ops ipoib_netdev_ops_vf = {
> --
> 2.12.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
