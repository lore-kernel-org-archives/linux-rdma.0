From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 15/27] IB/Verbs: Reform rest part in IB-core cma
Date: Tue, 21 Apr 2015 20:08:45 -0400
Message-ID: <20150422000844.GO15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BB19.9000003@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5534BB19.9000003-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:38:49AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform rest part in IB-core cma.
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
>  drivers/infiniband/core/cma.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 44e7bb9..ec64b97 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -468,10 +468,10 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
>  	pkey = ntohs(addr->sib_pkey);
>  
>  	list_for_each_entry(cur_dev, &dev_list, list) {
> -		if (rdma_node_get_transport(cur_dev->device->node_type) != RDMA_TRANSPORT_IB)
> -			continue;
> -
>  		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
> +			if (!rdma_ib_or_iboe(cur_dev->device, p))
> +				continue;
> +
>  			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
>  				continue;
>  
> @@ -666,10 +666,9 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
>  	if (ret)
>  		goto out;
>  
> -	if (rdma_node_get_transport(id_priv->cma_dev->device->node_type)
> -	    == RDMA_TRANSPORT_IB &&
> -	    rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)
> -	    == IB_LINK_LAYER_ETHERNET) {
> +	BUG_ON(id_priv->cma_dev->device != id_priv->id.device);
> +
> +	if (rdma_tech_iboe(id_priv->id.device, id_priv->id.port_num)) {
>  		ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr.smac, NULL);
>  
>  		if (ret)
> @@ -733,11 +732,10 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
>  	int ret;
>  	u16 pkey;
>  
> -	if (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num) ==
> -	    IB_LINK_LAYER_INFINIBAND)
> -		pkey = ib_addr_get_pkey(dev_addr);
> -	else
> +	if (rdma_tech_iboe(id_priv->id.device, id_priv->id.port_num))
>  		pkey = 0xffff;
> +	else
> +		pkey = ib_addr_get_pkey(dev_addr);
>  
>  	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
>  				  pkey, &qp_attr->pkey_index);
> -- 
> 2.1.0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
