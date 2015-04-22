From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 12/27] IB/Verbs: Reform mcast related part in IB-core cma
Date: Tue, 21 Apr 2015 20:07:34 -0400
Message-ID: <20150422000733.GL15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BACF.3080700@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5534BACF.3080700-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:37:35AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform mcast related part in IB-core cma.
> 
> Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/cma.c | 56 ++++++++++++++-----------------------------
>  1 file changed, 18 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index fa69f34..a89c246 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -997,17 +997,12 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
>  		mc = container_of(id_priv->mc_list.next,
>  				  struct cma_multicast, list);
>  		list_del(&mc->list);
> -		switch (rdma_port_get_link_layer(id_priv->cma_dev->device, id_priv->id.port_num)) {
> -		case IB_LINK_LAYER_INFINIBAND:
> +		if (rdma_tech_ib(id_priv->cma_dev->device,
> +				      id_priv->id.port_num)) {
>  			ib_sa_free_multicast(mc->multicast.ib);
>  			kfree(mc);
> -			break;
> -		case IB_LINK_LAYER_ETHERNET:
> +		} else
>  			kref_put(&mc->mcref, release_mc);
> -			break;
> -		default:
> -			break;
> -		}
>  	}
>  }
>  
> @@ -3314,24 +3309,13 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
>  	list_add(&mc->list, &id_priv->mc_list);
>  	spin_unlock(&id_priv->lock);
>  
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> -		switch (rdma_port_get_link_layer(id->device, id->port_num)) {
> -		case IB_LINK_LAYER_INFINIBAND:
> -			ret = cma_join_ib_multicast(id_priv, mc);
> -			break;
> -		case IB_LINK_LAYER_ETHERNET:
> -			kref_init(&mc->mcref);
> -			ret = cma_iboe_join_multicast(id_priv, mc);
> -			break;
> -		default:
> -			ret = -EINVAL;
> -		}
> -		break;
> -	default:
> +	if (rdma_tech_iboe(id->device, id->port_num)) {
> +		kref_init(&mc->mcref);
> +		ret = cma_iboe_join_multicast(id_priv, mc);
> +	} else if (rdma_tech_ib(id->device, id->port_num))
> +		ret = cma_join_ib_multicast(id_priv, mc);
> +	else
>  		ret = -ENOSYS;
> -		break;
> -	}
>  
>  	if (ret) {
>  		spin_lock_irq(&id_priv->lock);
> @@ -3359,19 +3343,15 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
>  				ib_detach_mcast(id->qp,
>  						&mc->multicast.ib->rec.mgid,
>  						be16_to_cpu(mc->multicast.ib->rec.mlid));
> -			if (rdma_node_get_transport(id_priv->cma_dev->device->node_type) == RDMA_TRANSPORT_IB) {
> -				switch (rdma_port_get_link_layer(id->device, id->port_num)) {
> -				case IB_LINK_LAYER_INFINIBAND:
> -					ib_sa_free_multicast(mc->multicast.ib);
> -					kfree(mc);
> -					break;
> -				case IB_LINK_LAYER_ETHERNET:
> -					kref_put(&mc->mcref, release_mc);
> -					break;
> -				default:
> -					break;
> -				}
> -			}
> +
> +			BUG_ON(id_priv->cma_dev->device != id->device);
> +
> +			if (rdma_tech_ib(id->device, id->port_num)) {
> +				ib_sa_free_multicast(mc->multicast.ib);
> +				kfree(mc);
> +			} else if (rdma_tech_iboe(id->device, id->port_num))
> +				kref_put(&mc->mcref, release_mc);
> +
>  			return;
>  		}
>  	}
> -- 
> 2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
