From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [rdma-rc 03/14] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Mon, 31 Jul 2017 08:01:51 -0400
Message-ID: <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af@dev.mellanox.co.il>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-4-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> There is no need to carry code, which is not implemented in any
> underlying hardware. 

AFAIK there are Linux based IB switch implementations and there may be
IB router implementation(s) whose drivers have not been pushed upstream
so it would be better to leave at least those 2 node types in.

-- Hal

> This patch removes unimplemented node_types and
> their respective node transport layers.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c |  3 ---
>  drivers/infiniband/core/verbs.c |  5 -----
>  include/rdma/ib_verbs.h         | 16 ++++++----------
>  3 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index 7ebe1ef23652..d455d00219a1 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -1146,10 +1146,7 @@ static ssize_t show_node_type(struct device *device,
>  	switch (dev->node_type) {
>  	case RDMA_NODE_IB_CA:	  return sprintf(buf, "%d: CA\n", dev->node_type);
>  	case RDMA_NODE_RNIC:	  return sprintf(buf, "%d: RNIC\n", dev->node_type);
> -	case RDMA_NODE_USNIC:	  return sprintf(buf, "%d: usNIC\n", dev->node_type);
>  	case RDMA_NODE_USNIC_UDP: return sprintf(buf, "%d: usNIC UDP\n", dev->node_type);
> -	case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_type);
> -	case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_type);
>  	default:		  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
>  	}
>  }
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 7f8fe443df46..1d57c60d8aeb 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -182,13 +182,9 @@ rdma_node_get_transport(enum rdma_node_type node_type)
>  {
>  	switch (node_type) {
>  	case RDMA_NODE_IB_CA:
> -	case RDMA_NODE_IB_SWITCH:
> -	case RDMA_NODE_IB_ROUTER:
>  		return RDMA_TRANSPORT_IB;
>  	case RDMA_NODE_RNIC:
>  		return RDMA_TRANSPORT_IWARP;
> -	case RDMA_NODE_USNIC:
> -		return RDMA_TRANSPORT_USNIC;
>  	case RDMA_NODE_USNIC_UDP:
>  		return RDMA_TRANSPORT_USNIC_UDP;
>  	default:
> @@ -207,7 +203,6 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
>  	case RDMA_TRANSPORT_IB:
>  		return IB_LINK_LAYER_INFINIBAND;
>  	case RDMA_TRANSPORT_IWARP:
> -	case RDMA_TRANSPORT_USNIC:
>  	case RDMA_TRANSPORT_USNIC_UDP:
>  		return IB_LINK_LAYER_ETHERNET;
>  	default:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index ca7ed9769d72..39b789276d13 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -93,12 +93,9 @@ struct ib_gid_attr {
> 
>  enum rdma_node_type {
>  	/* IB values map to NodeInfo:NodeType. */
> -	RDMA_NODE_IB_CA 	= 1,
> -	RDMA_NODE_IB_SWITCH,
> -	RDMA_NODE_IB_ROUTER,
> -	RDMA_NODE_RNIC,
> -	RDMA_NODE_USNIC,
> -	RDMA_NODE_USNIC_UDP,
> +	RDMA_NODE_IB_CA		= 1,
> +	RDMA_NODE_RNIC		= 4,
> +	RDMA_NODE_USNIC_UDP	= 6,
>  };
> 
>  enum {
> @@ -107,10 +104,9 @@ enum {
>  };
> 
>  enum rdma_transport_type {
> -	RDMA_TRANSPORT_IB,
> -	RDMA_TRANSPORT_IWARP,
> -	RDMA_TRANSPORT_USNIC,
> -	RDMA_TRANSPORT_USNIC_UDP
> +	RDMA_TRANSPORT_IB		= 0,
> +	RDMA_TRANSPORT_IWARP		= 1,
> +	RDMA_TRANSPORT_USNIC_UDP	= 3,
>  };
> 
>  enum rdma_protocol_type {
> --
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
