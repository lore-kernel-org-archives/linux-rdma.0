From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 8/9] IB/ipoib: Replace list_del of the
 neigh->list with list_del_init
Date: Mon, 2 Jan 2017 14:29:18 +0200
Message-ID: <20170102122917.GB25669@yuval-lap.uk.oracle.com>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161228124728.26619-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 28, 2016 at 02:47:27PM +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Any reason why this patch, out of 3 in this patch set uses "Replace"
instead of "Change" in commit header?

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> In order to resolve a situation where a few process delete
> the same list element in sequence and cause panic, list_del
> is replaced with list_del_init. In this case if the first
> process that calls list_del releases the lock before acquiring
> it again, other processes who can acquire the lock will call
> list_del_init.
> 
> Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup")
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index b5e1e4d..d8af197 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1298,7 +1298,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
>  						   rcu_dereference_protected(neigh->hnext,
>  									     lockdep_is_held(&priv->lock)));
>  				/* remove from path/mc list */
> -				list_del(&neigh->list);
> +				list_del_init(&neigh->list);
>  				call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
>  			} else {
>  				np = &neigh->hnext;
> @@ -1462,7 +1462,7 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
>  					   rcu_dereference_protected(neigh->hnext,
>  								     lockdep_is_held(&priv->lock)));
>  			/* remove from parent list */
> -			list_del(&neigh->list);
> +			list_del_init(&neigh->list);
>  			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
>  			return;
>  		} else {
> @@ -1547,7 +1547,7 @@ void ipoib_del_neighs_by_gid(struct net_device *dev, u8 *gid)
>  						   rcu_dereference_protected(neigh->hnext,
>  									     lockdep_is_held(&priv->lock)));
>  				/* remove from parent list */
> -				list_del(&neigh->list);
> +				list_del_init(&neigh->list);
>  				call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
>  			} else {
>  				np = &neigh->hnext;
> @@ -1589,7 +1589,7 @@ static void ipoib_flush_neighs(struct ipoib_dev_priv *priv)
>  					   rcu_dereference_protected(neigh->hnext,
>  								     lockdep_is_held(&priv->lock)));
>  			/* remove from path/mc list */
> -			list_del(&neigh->list);
> +			list_del_init(&neigh->list);
>  			call_rcu(&neigh->rcu, ipoib_neigh_reclaim);
>  		}
>  	}
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
