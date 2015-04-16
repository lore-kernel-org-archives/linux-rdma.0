From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 20/27] IB/Verbs: Use management helper cap_ib_sa()
Date: Thu, 16 Apr 2015 09:36:07 -0400
Message-ID: <552FBAC7.3020304@dev.mellanox.co.il>
References: <552F6CF2.4000606@profitbricks.com> <552F6EFE.70500@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552F6EFE.70500-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 4:12 AM, Michael Wang wrote:
> 
> Introduce helper cap_ib_sa() to help us check if the port of an
> IB device support Infiniband Subnet Administrator.

Nit: Administrator -> Administration

> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c      |  4 ++--
>  drivers/infiniband/core/sa_query.c | 10 +++++-----
>  drivers/infiniband/core/ucma.c     |  2 +-
>  include/rdma/ib_verbs.h            | 15 +++++++++++++++
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index a6f1526..094816f 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -955,7 +955,7 @@ static inline int cma_user_data_offset(struct rdma_id_private *id_priv)
>  
>  static void cma_cancel_route(struct rdma_id_private *id_priv)
>  {
> -	if (rdma_tech_ib(id_priv->id.device, id_priv->id.port_num)) {
> +	if (cap_ib_sa(id_priv->id.device, id_priv->id.port_num)) {
>  		if (id_priv->query)
>  			ib_sa_cancel_query(id_priv->query_id, id_priv->query);
>  	}
> @@ -1979,7 +1979,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
>  		return -EINVAL;
>  
>  	atomic_inc(&id_priv->refcount);
> -	if (rdma_tech_ib(id->device, id->port_num))
> +	if (cap_ib_sa(id->device, id->port_num))
>  		ret = cma_resolve_ib_route(id_priv, timeout_ms);
>  	else if (rdma_tech_iboe(id->device, id->port_num))
>  		ret = cma_resolve_iboe_route(id_priv);
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index 803ccf7..fc7e161 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -450,7 +450,7 @@ static void ib_sa_event(struct ib_event_handler *handler, struct ib_event *event
>  		struct ib_sa_port *port =
>  			&sa_dev->port[event->element.port_num - sa_dev->start_port];
>  
> -		if (WARN_ON(!rdma_tech_ib(handler->device, port->port_num)))
> +		if (WARN_ON(!cap_ib_sa(handler->device, port->port_num)))
>  			return;
>  
>  		spin_lock_irqsave(&port->ah_lock, flags);
> @@ -1173,7 +1173,7 @@ static void ib_sa_add_one(struct ib_device *device)
>  
>  	for (i = 0; i <= e - s; ++i) {
>  		spin_lock_init(&sa_dev->port[i].ah_lock);
> -		if (!rdma_tech_ib(device, i + 1))
> +		if (!cap_ib_sa(device, i + 1))
>  			continue;
>  
>  		sa_dev->port[i].sm_ah    = NULL;
> @@ -1210,7 +1210,7 @@ static void ib_sa_add_one(struct ib_device *device)
>  		goto err;
>  
>  	for (i = 0; i <= e - s; ++i) {
> -		if (rdma_tech_ib(device, i + 1))
> +		if (cap_ib_sa(device, i + 1))
>  			update_sm_ah(&sa_dev->port[i].update_task);
>  	}
>  
> @@ -1218,7 +1218,7 @@ static void ib_sa_add_one(struct ib_device *device)
>  
>  err:
>  	while (--i >= 0) {
> -		if (rdma_tech_ib(device, i + 1))
> +		if (cap_ib_sa(device, i + 1))
>  			ib_unregister_mad_agent(sa_dev->port[i].agent);
>  	}
>  
> @@ -1240,7 +1240,7 @@ static void ib_sa_remove_one(struct ib_device *device)
>  	flush_workqueue(ib_wq);
>  
>  	for (i = 0; i <= sa_dev->end_port - sa_dev->start_port; ++i) {
> -		if (rdma_tech_ib(device, i + 1)) {
> +		if (cap_ib_sa(device, i + 1)) {
>  			ib_unregister_mad_agent(sa_dev->port[i].agent);
>  			if (sa_dev->port[i].sm_ah)
>  				kref_put(&sa_dev->port[i].sm_ah->ref, free_sm_ah);
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 7331c6c..bed7957 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -723,7 +723,7 @@ static ssize_t ucma_query_route(struct ucma_file *file,
>  	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
>  	resp.port_num = ctx->cm_id->port_num;
>  
> -	if (rdma_tech_ib(ctx->cm_id->device, ctx->cm_id->port_num))
> +	if (cap_ib_sa(ctx->cm_id->device, ctx->cm_id->port_num))
>  		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
>  	else if (rdma_tech_iboe(ctx->cm_id->device, ctx->cm_id->port_num))
>  		ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index e4999f6..3bfdf81 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1833,6 +1833,21 @@ static inline int cap_iw_cm(struct ib_device *device, u8 port_num)
>  	return rdma_tech_iwarp(device, port_num);
>  }
>  
> +/**
> + * cap_ib_sa - Check if the port of device has the capability Infiniband
> + * Subnet Administrator.

Nit: Administrator -> Administration

> + *
> + * @device: Device to be checked
> + * @port_num: Port number of the device
> + *
> + * Return 0 when port of the device don't support Infiniband
> + * Subnet Administrator.

Nit: Administrator -> Administration

> + */
> +static inline int cap_ib_sa(struct ib_device *device, u8 port_num)
> +{
> +	return rdma_tech_ib(device, port_num);
> +}
> +
>  int ib_query_gid(struct ib_device *device,
>  		 u8 port_num, int index, union ib_gid *gid);
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
