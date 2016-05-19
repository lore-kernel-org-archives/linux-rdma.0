From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 13:54:33 -0500
Message-ID: <065c01d1b1ff$e1e149f0$a5a3ddd0$@opengridcomputing.com>
References: <20160518220302.81260E09E9@smtp.ogc.us> <20160518222857.GB23835@obsidianresearch.com> <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com> <20160519180552.GA26130@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519180552.GA26130-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Thursday, May 19, 2016 1:06 PM
> To: Steve Wise
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
> 
> On Thu, May 19, 2016 at 11:02:36AM -0500, Steve Wise wrote:
> 
> > Looking at the documentation, it is not clear to me which parameter value
passed
> > to atomic_thread_fence() maps to each of the mb services.  Is it correct to
> > think that if I get it right, the resulting assembly should be what we
currently
> > have for the mb services?
> 
> You can review
> 
> https://www.cl.cam.ac.uk/~pes20/cpp/cpp0xmappings.html
> 
> Hurm.
> 
> So, I'd say libibverbs is kinda broken here, as it is using a model
> that is different from the kernel model. Sigh, it actually looks like
> kinda a mess because provider libraries are abusing the primitives for
> lots of different things. :(

How so?

> 
> This is the mapping that matches the definitions of the barriers:
> 
>  wmb can be memory_order_release
>  rmb can be memory_order_acquire

>From my compile experiments the above two turned out to be a no-op for x64.  Is
that correct (assuming system memory)?

>  mb can be memory_order_seq_cst
>

What about the wc_wmb?
 
> On x86 this is similar as what we have today, but slightly less
> explicit than the kernel model. Seems OK
> 
> On ARMv8 this would be DMB slightly weaker than the
> kernel's DSB (My read suggests this is OK for PCI vs system memory
> on coherent ARM?)
> 
> PPC will be lwsync not sync (not OK)
> 
> ia64 will both use mf for mb, but different otherwise (not OK)
> 
> No idea about the others.
> 
> C11 atomics are only specified for system memory to system memory,
> they are undefined when working with device MMIO memory - this is why
> some of the above are 'not OK'.
> 
> You could provide the above as the new default, maybe even use it on
> some of the archs, like armv8/x86 if you think the dmb is OK.
> 
> An even better suggestion is to try and clean up some of this mess by
> being more explicit:
> 
>  /* Guarentee all system memory writes are visible by the device
>     before value's write is seen at the device */
>  mmio_barrier_write32(void *ptr, uint32_t value);
> 

How would the above be implemented?

> Most everything else can then safely use C11 atomics as it is not
> working with device memory.
> 

One case I wonder about is the write-combining path.   Some devices provide a
per-QP "slot" of device memory that can be used to send down small work
requests.  The host copies the work request from host memory into that device
memory hoping the CPU will do write combining and make the entire, say 64B, work
request a single PCIE transaction/cmd.   HW triggers on this transaction and
thus no db write is needed and the hw doesn't need to fetch the WR from host
memory.  Currently we use wc_wmb() to fence this, but It seems that will need
some mmio_barrier() operation as well.

> But that is too hard with all our providers sprinkled around in so
> many git trees :(
>

Changing all this scares me. :)  The location of where the barriers are in the
provider libs have been very carefully placed, most likely has the result of
seeing barrier problems under load.   I would hate to break any of this in the
name of "cleaning it up".  Also, the code in question is in the data-transfer
fast paths, and adding unneeded barriers would be bad too...

I think adding support for arm7 should be orthogonal from this cleanup.  The
barriers I added in the RFC patch indeed resolved a data corruption issue and we
would like to see them in libibverbs soon.

Steve.
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
