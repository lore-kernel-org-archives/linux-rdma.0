From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next] IB/core: Fix for core panic
Date: Thu, 31 Aug 2017 11:09:44 +0300
Message-ID: <20170831080943.GA4133@yuvallap>
References: <20170830191409.4386.45635.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170830191409.4386.45635.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 30, 2017 at 12:14:10PM -0700, Dennis Dalessandro wrote:
> From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Rdma device driver may not have implemented (*get_link_layer)()
> so it can not be called directly. Should use appropriate helper function.
> 
> Fixes: 523633359224 ("IB/core: Fix the validations of a multicast LID in attach or detach operations")
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> ---
>  drivers/infiniband/core/verbs.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index ee9e27d..123084a 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1646,8 +1646,9 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>  	 */
>  	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
>  		if (attr.qp_state >= IB_QPS_INIT) {
> -			if (qp->device->get_link_layer(qp->device, attr.port_num) !=
> -			    IB_LINK_LAYER_INFINIBAND)
> +			enum rdma_link_layer ll =
> +			rdma_port_get_link_layer(qp->device, attr.port_num);
> +			if (ll != IB_LINK_LAYER_INFINIBAND)
>  				return true;
>  			goto lid_check;
>  		}
> @@ -1655,7 +1656,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>  
>  	/* Can't get a quick answer, iterate over all ports */
>  	for (port = 0; port < qp->device->phys_port_cnt; port++)
> -		if (qp->device->get_link_layer(qp->device, port) !=
> +		if (rdma_port_get_link_layer(qp->device, port) !=
>  		    IB_LINK_LAYER_INFINIBAND)
>  			num_eth_ports++;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
