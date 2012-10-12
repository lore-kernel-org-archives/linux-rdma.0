From: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Subject: Re: (R)DMA in userspace
Date: Fri, 12 Oct 2012 10:54:35 +0200
Message-ID: <OF8F225351.D64DFAF0-ONC1257A95.002D2340-C1257A95.0030F501@ch.ibm.com>
References: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>	<CAL1RGDUOMz7Qf8bX7hZpJgARGepLQRwY25f6Q1utYBZ0taMs9A@mail.gmail.com> <CAJZOPZJiEj7rMjF1ouukCPAGCXaNBhHoG1-YuDfEikvM-LLrXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJiEj7rMjF1ouukCPAGCXaNBhHoG1-YuDfEikvM-LLrXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On x86 hardware manages the cache coherency. As far as I understood, DMA
sync
operations are no-ops on x86. But the confusion arose when I realised that
there are
no arch specific userlibs. So essentially as Roland pointed out, on a non
cache
coherent architecture userspace applications will break. This will happen
for IB as
well.

Can PCIe root complex can read dirty data from CPU caches? I am seeing
almost
100% LLC misses (L3 on Nehalem, which are inclusive for L1, and L2) for
memcpy on
RDMA buffers after transmission. Depending upon your CPU, LLC miss penalty
could
be very high, and shadow performance gains.

Has anyone ever tried using RDMA on non cache-coherent systems? I think,
cache
line flushing is not a privileged instruction and can be called without
going to kernel for
memory-cache synchronization.

Thought?

Thanks,
--
Animesh

Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 10/11/2012 11:04:02 PM:
>
> On Thu, Oct 11, 2012 at 10:44 PM, Roland Dreier
> <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
>
> > No one has really ever tried to deal with the issue of userspace RDMA
on
> > a cache-incoherent architecture.  Basically if you try the
currentstack, the
> > in-kernel users (IPoIB etc) should be OK but libibverbs etc. will
> be completely broken.
>
> I think the question might refer even to cache-coherent systems, e.g
> in the kernel IB core and ULPs all buffers are dma mapped to/from the
> device before/after they are touched by the CPU and vise versa, wheres
> in user space, after the buffers are registered once, they are
> repeatedly touched by the CPUs and provided to the HW for DMA, e.g all
> user space buffers are treated like kernel DMA coherent ones.
>
> Or.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
