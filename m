From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 05/28] IB/Verbs: Reform IB-core sa_query
Date: Mon, 13 Apr 2015 14:14:04 -0400
Message-ID: <20150413181403.GB2464@phlsvsds.ph.intel.com>
References: <552BB470.4090407@profitbricks.com> <552BB572.4040300@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552BB572.4040300-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 13, 2015 at 02:24:18PM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform IB-core sa_query.
> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/sa_query.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index c38f030..803ccf7 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
>  		struct ib_sa_port *port =
>  			&sa_dev->port[event->element.port_num - sa_dev->start_port];
>  
> -		if (rdma_port_get_link_layer(handler->device, port->port_num) != IB_LINK_LAYER_INFINIBAND)
> +		if (WARN_ON(!rdma_tech_ib(handler->device, port->port_num)))
>  			return;
>  
>  		spin_lock_irqsave(&port->ah_lock, flags);
> @@ -540,7 +540,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
>  	ah_attr->port_num = port_num;
>  	ah_attr->static_rate = rec->rate;
>  
> -	force_grh = rdma_port_get_link_layer(device, port_num) == IB_LINK_LAYER_ETHERNET;
> +	force_grh = rdma_tech_iboe(device, port_num);
>  
>  	if (rec->hop_limit > 1 || force_grh) {
>  		ah_attr->ah_flags = IB_AH_GRH;
> @@ -1153,9 +1153,7 @@ static void ib_sa_add_one(struct ib_device *device)
>  {
>  	struct ib_sa_device *sa_dev;
>  	int s, e, i;
> -
> -	if (rdma_node_get_transport(device->node_type) != RDMA_TRANSPORT_IB)
> -		return;
> +	int count = 0;

Same comment here as for the user_mad.c change.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
