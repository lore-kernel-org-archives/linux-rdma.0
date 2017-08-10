From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Add L2 MAC resolution for UD QPs
Date: Thu, 10 Aug 2017 14:26:53 +0300
Message-ID: <20170810112653.GC3500@yuvallap>
References: <1502345099-6534-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502345099-6534-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 09, 2017 at 11:04:59PM -0700, Adit Ranadive wrote:
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> 
> Use a libibverbs function to resolve the destination MAC address

s/libibverbs/ibverbs

> for a non-default GID in UD QPs.
> 
> Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/vmw_pvrdma/verbs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/providers/vmw_pvrdma/verbs.c b/providers/vmw_pvrdma/verbs.c
> index 1bb1634..852aced 100644
> --- a/providers/vmw_pvrdma/verbs.c
> +++ b/providers/vmw_pvrdma/verbs.c
> @@ -186,6 +186,7 @@ struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
>  	struct pvrdma_ah *ah;
>  	struct pvrdma_av *av;
>  	struct ibv_port_attr port_attr;
> +	uint16_t vlan_id;
>  
>  	if (!attr->is_global)
>  		return NULL;
> @@ -216,7 +217,14 @@ struct ibv_ah *pvrdma_create_ah(struct ibv_pd *pd,
>  	av->sl_tclass_flowlabel = (attr->grh.traffic_class << 20) |
>  				   attr->grh.flow_label;
>  	memcpy(av->dgid, attr->grh.dgid.raw, 16);
> -	set_mac_from_gid(&attr->grh.dgid, av->dmac);
> +
> +	if (ibv_resolve_eth_l2_from_gid(pd->context, attr,
> +					av->dmac, &vlan_id)) {
> +		free(ah);
> +		return NULL;
> +	} else {
> +		set_mac_from_gid(&attr->grh.dgid, av->dmac);
> +	}
>  
>  	return &ah->ibv_ah;
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
