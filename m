From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/CMA: Fix condition to search for InfiniBand route
Date: Mon, 8 Jun 2015 16:48:08 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE5B07@ORSMSX109.amr.corp.intel.com>
References: <1433770345-17354-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433770345-17354-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The flag RDMA_CORE_CAP_IB_SA is set when link layer is InfiniBand but
> also when link layer is Ethernet. Therefore, link layer is not implied by

This flag should NOT be set for Ethernet.  What is setting this?

> this flag.
> 
> ---
>  drivers/infiniband/core/cma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 3b943b7..f96d6fd 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1993,7 +1993,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int
> timeout_ms)
>  		return -EINVAL;
> 
>  	atomic_inc(&id_priv->refcount);
> -	if (rdma_cap_ib_sa(id->device, id->port_num))
> +	if (rdma_protocol_ib(id->device, id->port_num))

This change looks wrong.  The check here has nothing to do with the link layer.  It is stating that route resolution must be done using an SA.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
