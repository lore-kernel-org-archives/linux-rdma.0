From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH v5 11/27] IB/Verbs: Reform route related part in IB-core cma
Date: Tue, 21 Apr 2015 20:07:19 -0400
Message-ID: <20150422000719.GK15893@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <5534BAB9.1000600@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5534BAB9.1000600@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 20, 2015 at 10:37:13AM +0200, Michael Wang wrote:
> 
> Use raw management helpers to reform route related part in IB-core cma.
> 
> Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/infiniband/core/cma.c  | 31 ++++++++-----------------------
>  drivers/infiniband/core/ucma.c | 25 ++++++-------------------
>  2 files changed, 14 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 815e41b..fa69f34 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -923,13 +923,9 @@ static inline int cma_user_data_offset(struct rdma_id_private *id_priv)
>  
>  static void cma_cancel_route(struct rdma_id_private *id_priv)
>  {
> -	switch (rdma_port_get_link_layer(id_priv->id.device, id_priv->id.port_num)) {
> -	case IB_LINK_LAYER_INFINIBAND:
> +	if (rdma_tech_ib(id_priv->id.device, id_priv->id.port_num)) {
>  		if (id_priv->query)
>  			ib_sa_cancel_query(id_priv->query_id, id_priv->query);
> -		break;
> -	default:
> -		break;
>  	}
>  }
>  
> @@ -1957,26 +1953,15 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
>  		return -EINVAL;
>  
>  	atomic_inc(&id_priv->refcount);
> -	switch (rdma_node_get_transport(id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> -		switch (rdma_port_get_link_layer(id->device, id->port_num)) {
> -		case IB_LINK_LAYER_INFINIBAND:
> -			ret = cma_resolve_ib_route(id_priv, timeout_ms);
> -			break;
> -		case IB_LINK_LAYER_ETHERNET:
> -			ret = cma_resolve_iboe_route(id_priv);
> -			break;
> -		default:
> -			ret = -ENOSYS;
> -		}
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +	if (rdma_tech_ib(id->device, id->port_num))
> +		ret = cma_resolve_ib_route(id_priv, timeout_ms);
> +	else if (rdma_tech_iboe(id->device, id->port_num))
> +		ret = cma_resolve_iboe_route(id_priv);
> +	else if (rdma_tech_iwarp(id->device, id->port_num))
>  		ret = cma_resolve_iw_route(id_priv, timeout_ms);
> -		break;
> -	default:
> +	else
>  		ret = -ENOSYS;
> -		break;
> -	}
> +
>  	if (ret)
>  		goto err;
>  
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 45d67e9..7331c6c 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -722,26 +722,13 @@ static ssize_t ucma_query_route(struct ucma_file *file,
>  
>  	resp.node_guid = (__force __u64) ctx->cm_id->device->node_guid;
>  	resp.port_num = ctx->cm_id->port_num;
> -	switch (rdma_node_get_transport(ctx->cm_id->device->node_type)) {
> -	case RDMA_TRANSPORT_IB:
> -		switch (rdma_port_get_link_layer(ctx->cm_id->device,
> -			ctx->cm_id->port_num)) {
> -		case IB_LINK_LAYER_INFINIBAND:
> -			ucma_copy_ib_route(&resp, &ctx->cm_id->route);
> -			break;
> -		case IB_LINK_LAYER_ETHERNET:
> -			ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
> -			break;
> -		default:
> -			break;
> -		}
> -		break;
> -	case RDMA_TRANSPORT_IWARP:
> +
> +	if (rdma_tech_ib(ctx->cm_id->device, ctx->cm_id->port_num))
> +		ucma_copy_ib_route(&resp, &ctx->cm_id->route);
> +	else if (rdma_tech_iboe(ctx->cm_id->device, ctx->cm_id->port_num))
> +		ucma_copy_iboe_route(&resp, &ctx->cm_id->route);
> +	else if (rdma_tech_iwarp(ctx->cm_id->device, ctx->cm_id->port_num))
>  		ucma_copy_iw_route(&resp, &ctx->cm_id->route);
> -		break;
> -	default:
> -		break;
> -	}
>  
>  out:
>  	if (copy_to_user((void __user *)(unsigned long)cmd.response,
> -- 
> 2.1.0
