From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/CMA: Fix condition to search for InfiniBand route
Date: Mon, 8 Jun 2015 11:44:13 -0400
Message-ID: <20150608154412.GA23803@phlsvsds.ph.intel.com>
References: <1433770345-17354-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433770345-17354-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 08, 2015 at 04:32:25PM +0300, Moni Shoua wrote:
> The flag RDMA_CORE_CAP_IB_SA is set when link layer is InfiniBand but
> also when link layer is Ethernet.

Why?  Ethernet does not have an SA nor need one.

>
> Therefore, link layer is not implied by
> this flag.

Of course not.  This flag is explicitly saying this port needs to use the IB
SA to resolve the route information.

cma_resolve_ib_route finds the route information by issuing an SA query.
Therefore it should only be called on ports which require an SA.

Was this change inspired by a bug being found?  If so it seems the underlying
device needs to be fixed to not set the RDMA_CORE_CAP_IB_SA flag when the link
layer is ethernet.

Ira

> 
> ---
>  drivers/infiniband/core/cma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 3b943b7..f96d6fd 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1993,7 +1993,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
>  		return -EINVAL;
>  
>  	atomic_inc(&id_priv->refcount);
> -	if (rdma_cap_ib_sa(id->device, id->port_num))
> +	if (rdma_protocol_ib(id->device, id->port_num))
>  		ret = cma_resolve_ib_route(id_priv, timeout_ms);
>  	else if (rdma_protocol_roce(id->device, id->port_num))
>  		ret = cma_resolve_iboe_route(id_priv);
> -- 
> 1.7.1
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
