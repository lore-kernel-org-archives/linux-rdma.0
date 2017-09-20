From: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] rdma/core: Don't dereference device->get_link_layer
 directly
Date: Wed, 20 Sep 2017 12:33:39 +0000
Message-ID: <F3529576D8E232409F431C309E29399336CD902F@CRSMSX102.amr.corp.intel.com>
References: <1505908483-29641-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505908483-29641-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Patch for this issue was already posted about 3 weeks ago.
https://patchwork.kernel.org/patch/9932505/

Thanks,
Alex.

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
> Sent: Wednesday, September 20, 2017 7:55 AM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH v2] rdma/core: Don't dereference device->get_link_layer directly
> 
> We have rdma_port_get_link_layer that checks the callout
> is actually implemented.
> 
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
> Changes from v1:
> - fixed typo
> 
>  drivers/infiniband/core/verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index ee9e27dc799b..de57d6c11a25 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1646,7 +1646,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
>  	 */
>  	if (!ib_query_qp(qp, &attr, IB_QP_STATE | IB_QP_PORT, &init_attr)) {
>  		if (attr.qp_state >= IB_QPS_INIT) {
> -			if (qp->device->get_link_layer(qp->device, attr.port_num) !=
> +			if (rdma_port_get_link_layer(qp->device, attr.port_num) !=
>  			    IB_LINK_LAYER_INFINIBAND)
>  				return true;
>  			goto lid_check;
> @@ -1655,7 +1655,7 @@ static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
> 
>  	/* Can't get a quick answer, iterate over all ports */
>  	for (port = 0; port < qp->device->phys_port_cnt; port++)
> -		if (qp->device->get_link_layer(qp->device, port) !=
> +		if (rdma_port_get_link_layer(qp->device, port) !=
>  		    IB_LINK_LAYER_INFINIBAND)
>  			num_eth_ports++;
> 
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
