From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Fri, 12 Oct 2012 17:10:28 -0600
Message-ID: <20121012231028.GC25541@obsidianresearch.com>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
 <CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A@mail.gmail.com>
 <CAJZOPZJiEj7rMjF1ouukCPAGCXaNBhHoG1-YuDfEikvM-LLrXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZJiEj7rMjF1ouukCPAGCXaNBhHoG1-YuDfEikvM-LLrXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 11, 2012 at 11:04:02PM +0200, Or Gerlitz wrote:
> On Thu, Oct 11, 2012 at 10:44 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> 
> > No one has really ever tried to deal with the issue of userspace
> > RDMA on a cache-incoherent architecture.  Basically if you try the
> > current stack, the in-kernel users (IPoIB etc) should be OK but
> > libibverbs etc. will be completely broken.
> 
> I think the question might refer even to cache-coherent systems, e.g
> in the kernel IB core and ULPs all buffers are dma mapped to/from the
> device before/after they are touched by the CPU and vise versa, wheres
> in user space, after the buffers are registered once, they are
> repeatedly touched by the CPUs and provided to the HW for DMA, e.g all
> user space buffers are treated like kernel DMA coherent ones.

The answer is the same, userspace is designed to rely on a DMA cache
coherent platform where the only requirement is to issue barrier
instructions, which is done in the providers.

I'm not sure supporting non-DMA-coherent is even possible with the
verbs API, yes we could add the cache ops to the providers, the
information is mostly there. However non-DMA-coherent system all
require that once you start a DMA WRITE into a cache line *that line
is never dirtied by the CPU* - which requires application support that
is not even contemplated by verbs. Indeed, I wonder if all the kernel
ULPs meet that restriction?

Hopefully the forthcoming server grade ARMs are fully DMA coherent..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
