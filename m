From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH net 2/2] IB/ipoib: Fix netlink support in IPoIB
Date: Sun, 31 Dec 2017 13:23:08 -0700
Message-ID: <20171231202308.GA10145@ziepe.ca>
References: <1514718983-466-1-git-send-email-denisd@mellanox.com>
 <1514718983-466-3-git-send-email-denisd@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514718983-466-3-git-send-email-denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 01:16:23PM +0200, Denis Drozdov wrote:
> IPoIB netlink support was broken by commit cd565b4b51e5
> ("IB/IPoIB: Support acceleration options callbacks"),
> that added flow which allocates netdev rdma structures
> after netlink object is already created. Such situation leads
> to crash in __ipoib_device_add, once trying to reuse netlink
> device.
> This commit restores the netlink support.
> 
> Fixes: cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks")
> Reviewed-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/ulp/ipoib/ipoib.h         |  2 ++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c    | 23 +++++++++--------
>  drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 38 +++++++++++++++++++++++++---
>  drivers/infiniband/ulp/ipoib/ipoib_vlan.c    | 20 ++++-----------
>  4 files changed, 54 insertions(+), 29 deletions(-)

I assume this is going through DaveM's tree? In which case for the
drivers/infiniband part:

Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

> @@ -131,11 +157,15 @@ static int ipoib_new_child_link(struct net *src_net, struct net_device *dev,
>  	 */
>  	child_pkey |= 0x8000;
>  
> -	err = __ipoib_vlan_add(ppriv, ipoib_priv(dev),
> -			       child_pkey, IPOIB_RTNL_CHILD);
> +	down_write(&ppriv->vlan_rwsem);
> +
> +	priv = ipoib_priv(dev);
> +	err = __ipoib_vlan_add(ppriv, priv, child_pkey, IPOIB_RTNL_CHILD);
> +	up_write(&ppriv->vlan_rwsem);

This looks like a necessary and correct change, but does it need to be
a seperate bug fix commit?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
