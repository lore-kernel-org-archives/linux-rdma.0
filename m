From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary
 compatibility
Date: Mon, 14 Dec 2009 10:41:11 +0200
Message-ID: <20091214084111.GA10744@mtls03>
References: <20091210170536.GA3229@mtls03>
 <20091210173353.GW1966@obsidianresearch.com>
 <20091210211455.GA5166@mtls03>
 <20091210214945.GP6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091210214945.GP6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 02:49:45PM -0700, Jason Gunthorpe wrote:
> 
> - Change the library API for ibv_port_attr to include a link_layer
> - Change the kernel API to retrieve link_layer
> - Add ibv_cmd_get_mac and other stuff to support RDMAoE
> - Update verbs examples to support RDMAoE
> - Update man pages (you missed these)
> 

Will be addressed in the next patch set.
> >--- a/include/infiniband/kern-abi.h
> >+++ b/include/infiniband/kern-abi.h
> >@@ -46,7 +46,7 @@
> >  * The minimum and maximum kernel ABI that we can handle.
> >  */
> >  #define IB_USER_VERBS_MIN_ABI_VERSION  1
> > -#define IB_USER_VERBS_MAX_ABI_VERSION  6
> > +#define IB_USER_VERBS_MAX_ABI_VERSION  7
>  
> Whats this about? That seems like it needs a much bigger review,
> changing the kernel ABI version instantly breaks every existing
> libibverbs, shouldn't be done without alot of discussion!!
I think we can do without chagning the ABI version so I am going to
ommit it in the next patch set.

> 
> Extra include?

Yes, thanks.


> 
> >@@ -86,6 +86,7 @@ default_symver(__ibv_query_device, ibv_query_device);
> > int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
> >                     struct ibv_port_attr *port_attr)
> > {
> >+       port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
> >        return context->ops.query_port(context, port_num, port_attr);
> > }
> 
> Seems like this should be just
>  return ___ibv_query_port(context,port_num,port_attr);
> 

A leftover, thanks.

> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index 012aadf..d592bd2 100644
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -452,7 +452,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
> >  	resp.active_width    = attr.active_width;
> >  	resp.active_speed    = attr.active_speed;
> >  	resp.phys_state      = attr.phys_state;
> > -	resp.transport	     = attr.transport;
> > +	resp.transport	     = attr.transport == RDMA_TRANSPORT_RDMAOE ?
> > +		IB_LINK_LAYER_ETHERNET : IB_LINK_LAYER_INFINIBAND;
> 
> Are you going to change the kernel patches to use the new link_layer
> name?
> 

Yes, in the next patch set.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
