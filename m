From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH -next v3] IB/ipath: use GFP_NOWAIT under spin lock
Date: Fri, 22 Feb 2013 14:44:51 -0800
Message-ID: <20130222144451.ed48f015.akpm@linux-foundation.org>
References: <CAPgLHd965-++Kj6HE-wjHqpZjortmmCAvApSSwiXaX6YwWncHQ@mail.gmail.com>
	<CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ@mail.gmail.com>
	<CAOS58YOHt7OaBHRwwqjLF8xZtVaj=BeFUXFAxW0owb4_BxC3Rg@mail.gmail.com>
	<CAPgLHd8_WyQiDpJwRWwNVPbSvVcpMj1bMu7h2QmfJpscd0LOFQ@mail.gmail.com>
	<20130222141642.247ee792.akpm@linux-foundation.org>
	<CAOS58YMrcCwh8RhnfRTsmbfa_K_h1=n2M6ws4=MHWDxpAAoXOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YMrcCwh8RhnfRTsmbfa_K_h1=n2M6ws4=MHWDxpAAoXOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Feb 2013 14:21:58 -0800
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello, Andrew.
> 
> On Fri, Feb 22, 2013 at 2:16 PM, Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > Given that this code is performing allocations under
> > spin_lock_irqsave(), it should be using idr_preload()/idr_preload_end()
> > (and perhaps even a repeat loop around those) to make the allocations
> > more reliable.
> 
> It's already using preload so GFP_NOWAIT is enough to guarantee
> GFP_KERNEL level allocation.
> 

Not "guarantee".

- idr_preload() might fail.  It is a design error that idr_preload()
  returns void - it should do what radix_tree_preload() does.

- even if idr_preload() completed the preload, an interrupt might
  come in and its handler might drain this cpu's preload pool.

This all sounds like crazy will-never-happen stuff.  That's what I
thought about the radix-tree code when used for pagecache.  But under
extreme worloads, the cant-happens kept on happening, which is how all
that funky preload/preempt-disable stuff occurred.

It would be more robust still if the per-cpu preload magazines were
per-radixtree and per-idr, rather than kernel-wide.  That would reduce
the risk of interrupt-time stealing.  Or make foo_preload() return with
interrupts disabled rather than jsut preempt_disable().

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
