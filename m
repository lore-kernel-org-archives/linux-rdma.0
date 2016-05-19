From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 13:28:05 -0600
Message-ID: <20160519192805.GA32668@obsidianresearch.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
 <20160518222857.GB23835@obsidianresearch.com>
 <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
 <20160519180552.GA26130@obsidianresearch.com>
 <065c01d1b1ff$e1e149f0$a5a3ddd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <065c01d1b1ff$e1e149f0$a5a3ddd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 01:54:33PM -0500, Steve Wise wrote:
> > So, I'd say libibverbs is kinda broken here, as it is using a model
> > that is different from the kernel model. Sigh, it actually looks like
> > kinda a mess because provider libraries are abusing the primitives for
> > lots of different things. :(
> 
> How so?

The kernel model uses very heavy weight barriers for wmb,rmb,mb and
then provides a host of weaker barrier options.

verbs is the opposite on x86, wmb is weak and wc_wmb is the stronger
version.

> >  wmb can be memory_order_release
> >  rmb can be memory_order_acquire
> 
> From my compile experiments the above two turned out to be a no-op for x64.  Is
> that correct (assuming system memory)?

Certainly yes for system memory.

For system mem vs device mmio? No. C11 does not contemplate that case.
On x86 these are the same things (eg libibverbs uses nop for
barriers), on other arches they are not.

It isn't clear to me if the much stronger kernel barries are needed
for system vs device. On x86 those might only be needed for really old
CPUs, or maybe libibverbs is just totally wrong here.. I don't know.

Same question for arm on dsb vs dsm.

> >  mb can be memory_order_seq_cst
 
> What about the wc_wmb?

wc_wmb seesm to be used as some kind of flushing operation to get data
out of the write combining write buffer promptly. Terrible name.

> >  /* Guarentee all system memory writes are visible by the device
> >     before value's write is seen at the device */
> >  mmio_barrier_write32(void *ptr, uint32_t value);

> How would the above be implemented?

It would have to use the correct asm for each arch. But at least we
can now speak clearly about what the expected behavior is and identify
the correct asm for each arch instead of this crazy catch all that wmb
has become for verbs.

> > Most everything else can then safely use C11 atomics as it is not
> > working with device memory.
> 
> One case I wonder about is the write-combining path.   Some devices provide a
> per-QP "slot" of device memory that can be used to send down small work
> requests.  The host copies the work request from host memory into that device
> memory hoping the CPU will do write combining and make the entire, say 64B, work
> request a single PCIE transaction/cmd.

Yes, we probably should have had a 'memcpy to wc' verbs helper that
did the best possible wc copy and prompt flush rather than the mess
with wc_wmb and open coded memcpy. IIRC there is some way to do this
with xmm non temporal cache line stores that is even better???

> thus no db write is needed and the hw doesn't need to fetch the WR from host
> memory.  Currently we use wc_wmb() to fence this, but It seems that will need
> some mmio_barrier() operation as well.

This isn't a fence, it is a flush. It is needed to get the data out of
the write buffer promptly - intel is always strongly ordered so no
fencing is needed here.

> Changing all this scares me. :)  The location of where the barriers are in the
> provider libs have been very carefully placed, most likely has the
> result of

You should probably just go ahead with your patch, it is a bigger mess
than I imagined at first :(

> seeing barrier problems under load.   I would hate to break any of this in the
> name of "cleaning it up".  Also, the code in question is in the data-transfer
> fast paths, and adding unneeded barriers would be bad too...

Well, therein is the problem.

It isn't clear what wmb is supposed to do, and it isn't the same as
the kernel wmb. So what should you implement for ARMv8? The kernel
version will work, but it is overkill in many places.

The truth is, none of these wmbs really do anything on x86 except
cause a compiler fence. Other arches are different, particularly ARM &
PPC tend to need correct fencing or it just doesn't work (as you
noticed).

Due to the mess this is in, I'd have a healthy skepticism about this.
x86 tests none of this!

If you want to optimize ARM then you need to use the correct, weaker
barriers when appropriate and not just use wmb as a big hammer.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
