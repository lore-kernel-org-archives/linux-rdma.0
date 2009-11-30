From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Mon, 30 Nov 2009 12:03:45 -0700
Message-ID: <20091130190345.GV6188@obsidianresearch.com>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com> <20091125001136.GP6188@obsidianresearch.com> <20091130133406.GA32123@mtls03> <adaiqcrx2xx.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiqcrx2xx.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 30, 2009 at 10:50:02AM -0800, Roland Dreier wrote:
> 
>  > If we change struct ibv_port_attr transport field from enum to uint8,
>  > we eliminate binary compatibility problems. That's because the previous
>  > filed is aligned to 16 bits address so that leaves us 16 bits more.
>  > 
>  > diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>  > index 07d4395..f7fe68d 100644
>  > +++ b/include/infiniband/verbs.h
>  > @@ -192,7 +192,7 @@ struct ibv_port_attr {
>  >         uint8_t                 active_width;
>  >         uint8_t                 active_speed;
>  >         uint8_t                 phys_state;
>  > -       enum rdma_transport_type transport;
>  > +       uint8_t                 transport;
>  >  };
> 
> Do all architectures round up the structure size?  ie is this always
> going to preserve ABI?

Yes, every Linux arch aligns structs to the min alignment for the
members, so at least 32 in this case.

However, it doesn't really matter, look at ibv_cmd_query_port, it
doesn't zero the padding. So there must be an ABI bump to ensure that
new code links to a library that doesn't fill the new member with
garbage.

This is a messy one, the low level libraries have to be reved somehow too..
ops.query_port2() I guess.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
