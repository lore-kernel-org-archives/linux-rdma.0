From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary
	compatibility
Date: Thu, 10 Dec 2009 14:49:45 -0700
Message-ID: <20091210214945.GP6188@obsidianresearch.com>
References: <20091210170536.GA3229@mtls03> <20091210173353.GW1966@obsidianresearch.com> <20091210211455.GA5166@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091210211455.GA5166@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 11:14:55PM +0200, Eli Cohen wrote:
> On Thu, Dec 10, 2009 at 10:33:53AM -0700, Jason Gunthorpe wrote:
> > Could you prepare this based on Roland's tree? This patch won't apply.
> > 
> 
> I quote two patches, one for libibverbs based on 74638ac, and the
> other for libmlx4 based on 444f634. I changed the padding handling as
> you requested for libibverbs. You also need to apply a patch to the
> kernel driver to match the new values for link_layer. I put it here
> too.

Seems like this will work to me. I think you need to split this patch
if you want Roland to apply it. I'd suggest

- Change the library API for ibv_port_attr to include a link_layer
- Change the kernel API to retrieve link_layer
- Add ibv_cmd_get_mac and other stuff to support RDMAoE
- Update verbs examples to support RDMAoE
- Update man pages (you missed these)

>--- a/include/infiniband/kern-abi.h
>+++ b/include/infiniband/kern-abi.h
>@@ -46,7 +46,7 @@
>  * The minimum and maximum kernel ABI that we can handle.
>  */
>  #define IB_USER_VERBS_MIN_ABI_VERSION  1
> -#define IB_USER_VERBS_MAX_ABI_VERSION  6
> +#define IB_USER_VERBS_MAX_ABI_VERSION  7
 
Whats this about? That seems like it needs a much bigger review,
changing the kernel ABI version instantly breaks every existing
libibverbs, shouldn't be done without alot of discussion!!

> +enum {
> +	IBV_LINK_LAYER_UNSPECIFIED,
> +	IBV_LINK_LAYER_INFINIBAND,
> +	IBV_LINK_LAYER_ETHERNET,
> +};

Why do you have IBV_LINK_LAYER_UNSPECIFIED ? That seems pointless. Why
should existing kernels return UNSPECIFIED when we know they are
always IB. I'd say drop IBV_LINK_LAYER_UNSPECIFIED and set
IBV_LINK_LAYER_INFINIBAND to 0.

What are iWarp devices going to return? Seems like the verbs library
should probably force link_layer to ethernet for iwarp devices, for
compatability.

> diff --git a/src/cmd.c b/src/cmd.c
> index cbd5288..5183d59 100644
> +++ b/src/cmd.c
> @@ -162,6 +162,7 @@ int ibv_cmd_query_device(struct ibv_context *context,
>  	return 0;
>  }
>  
> +#include <stdio.h>
>  int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
>  		       struct ibv_port_attr *port_attr,
>  		       struct ibv_query_port *cmd, size_t cmd_size)

Extra include?

>@@ -86,6 +86,7 @@ default_symver(__ibv_query_device, ibv_query_device);
> int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
>                     struct ibv_port_attr *port_attr)
> {
>+       port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
>        return context->ops.query_port(context, port_num, port_attr);
> }

Seems like this should be just
 return ___ibv_query_port(context,port_num,port_attr);

> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 012aadf..d592bd2 100644
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -452,7 +452,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
>  	resp.active_width    = attr.active_width;
>  	resp.active_speed    = attr.active_speed;
>  	resp.phys_state      = attr.phys_state;
> -	resp.transport	     = attr.transport;
> +	resp.transport	     = attr.transport == RDMA_TRANSPORT_RDMAOE ?
> +		IB_LINK_LAYER_ETHERNET : IB_LINK_LAYER_INFINIBAND;

Are you going to change the kernel patches to use the new link_layer
name?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
