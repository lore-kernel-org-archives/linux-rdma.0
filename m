From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Mon, 7 Dec 2009 19:25:11 +0200
Message-ID: <20091207172511.GA13496@mtls03>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>
 <20091125001136.GP6188@obsidianresearch.com>
 <20091130133406.GA32123@mtls03>
 <adaiqcrx2xx.fsf@roland-alpha.cisco.com>
 <20091130190345.GV6188@obsidianresearch.com>
 <ada1vjaukx8.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada1vjaukx8.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 04, 2009 at 08:03:31PM -0800, Roland Dreier wrote:
> 
>  > Yes, every Linux arch aligns structs to the min alignment for the
>  > members, so at least 32 in this case.
>  > 
>  > However, it doesn't really matter, look at ibv_cmd_query_port, it
>  > doesn't zero the padding. So there must be an ABI bump to ensure that
>  > new code links to a library that doesn't fill the new member with
>  > garbage.
>  > 
>  > This is a messy one, the low level libraries have to be reved somehow too..
>  > ops.query_port2() I guess.
> 
> Actually I think we can fix this in libibverbs without having to break
> anything.  It's a little bit devious, but if we do something like:
> 
> // ... add link_layer member in padding of struct ibv_port_attr
> 
> enum {
> 	IBV_LINK_LAYER_UNSPECIFIED,
> 	IBV_LINK_LAYER_INFINIBAND,
> 	IBV_LINK_LAYER_ETHERNET,
> };
> 
> static inline int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
> 				   struct ibv_port_attr *port_attr)
> {
> 	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
> 	return ibv_query_port(context, port_num, port_attr);
> }
> 
> // ... rest of file...
> 
> #define ibv_query_port(context, port_num, port_attr) \
> 	__ibv_query_port(context, port_num, port_attr)
> 
> then I think legacy apps should be OK (port_attr size doesn't change,
> binary compat is still there), and new apps that do check link_layer
> should also be OK ... if they use an old library and/or old driver,
> they'll see LINK_LAYER_UNSPECIFIED, which means that IBoE is not supported.
> 
> What do you think, does this work?
> 
>  - R.

It looks good to me. Thanks, I will take it for RDMAoE.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
