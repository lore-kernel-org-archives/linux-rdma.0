From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v3 20/24] IB/ipoib: Add get statistics support to
 SRIOV VF
Date: Thu, 24 Aug 2017 16:44:40 -0400
Message-ID: <1503607480.78641.51.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
         <20170817125055.31424-21-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125055.31424-21-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add SRIOV VF support to get traffic statistics.
> 
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

This one was already in my tree and so I had to skip it:

eb54714ddcb2 IB/ipoib: Add get statistics support to SRIOV VF

git tag --contains eb54714ddcb2
for-linus
for-next
v4.13-rc5

So this was in what you submitted for -rc5 in the IPoIB fixes.  It
shouldn't have made it into this patch series again.

> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 627ff8fb59b0..9e8dce6e9fc2 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1846,6 +1846,7 @@ static const struct net_device_ops
> ipoib_netdev_ops_vf = {
>  	.ndo_tx_timeout		 = ipoib_timeout,
>  	.ndo_set_rx_mode	 = ipoib_set_mcast_list,
>  	.ndo_get_iflink		 = ipoib_get_iflink,
> +	.ndo_get_stats64	 = ipoib_get_stats,
>  };
>  
>  void ipoib_setup_common(struct net_device *dev)
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
