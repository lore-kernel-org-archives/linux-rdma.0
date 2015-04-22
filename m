From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 13/27] IB/Verbs: Reserve legacy transport type in 'dev_addr'
Date: Tue, 21 Apr 2015 20:08:05 -0400
Message-ID: <20150422000804.GM15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BAE8.9010805@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5534BAE8.9010805-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:38:00AM +0200, Michael Wang wrote:
> 
> Reserve the legacy transport type for the 'transport' member
> of 'struct rdma_dev_addr' until we make sure this is no
> longer needed.
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
>  drivers/infiniband/core/cma.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index ebac646..6195bf6 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -244,14 +244,35 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
>  	hdr->ip_version = (ip_ver << 4) | (hdr->ip_version & 0xF);
>  }
>  
> +static inline void cma_set_legacy_transport(struct rdma_cm_id *id)
> +{
> +	switch (id->device->node_type) {
> +	case RDMA_NODE_IB_CA:
> +	case RDMA_NODE_IB_SWITCH:
> +	case RDMA_NODE_IB_ROUTER:
> +		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_IB;
> +		break;
> +	case RDMA_NODE_RNIC:
> +		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_IWARP;
> +		break;
> +	case RDMA_NODE_USNIC:
> +		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_USNIC;
> +		break;
> +	case RDMA_NODE_USNIC_UDP:
> +		id->route.addr.dev_addr.transport = RDMA_TRANSPORT_USNIC_UDP;
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +
>  static void cma_attach_to_dev(struct rdma_id_private *id_priv,
>  			      struct cma_device *cma_dev)
>  {
>  	atomic_inc(&cma_dev->refcount);
>  	id_priv->cma_dev = cma_dev;
>  	id_priv->id.device = cma_dev->device;
> -	id_priv->id.route.addr.dev_addr.transport =
> -		rdma_node_get_transport(cma_dev->device->node_type);
> +	cma_set_legacy_transport(&id_priv->id);
>  	list_add_tail(&id_priv->list, &cma_dev->id_list);
>  }
>  
> -- 
> 2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
