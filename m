From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v3] IB/ipath: use GFP_NOWAIT under spin lock
Date: Fri, 22 Feb 2013 14:58:16 -0800
Message-ID: <20130222225816.GQ3570@htj.dyndns.org>
References: <CAPgLHd965-++Kj6HE-wjHqpZjortmmCAvApSSwiXaX6YwWncHQ@mail.gmail.com>
 <CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ@mail.gmail.com>
 <CAOS58YOHt7OaBHRwwqjLF8xZtVaj=BeFUXFAxW0owb4_BxC3Rg@mail.gmail.com>
 <CAPgLHd8_WyQiDpJwRWwNVPbSvVcpMj1bMu7h2QmfJpscd0LOFQ@mail.gmail.com>
 <20130222141642.247ee792.akpm@linux-foundation.org>
 <CAOS58YMrcCwh8RhnfRTsmbfa_K_h1=n2M6ws4=MHWDxpAAoXOw@mail.gmail.com>
 <20130222144451.ed48f015.akpm@linux-foundation.org>
 <CAOS58YMo3rABCLpKYRr7pRqeMo+rmGbbUJDj5xxE08pb-SyBqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YMo3rABCLpKYRr7pRqeMo+rmGbbUJDj5xxE08pb-SyBqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 22, 2013 at 02:51:30PM -0800, Tejun Heo wrote:
> Non-process context doesn't dip into preload pool, so the first
> allocation after idr_preload() is *guaranteed* to fail iff the
> previous idr_preload(GFP_KERNEL) failed and there just isn't much we
> can do other than failing if GFP_KERNEL allocation fails.

If it still is confusing, a good way to think about it is that
idr_preload() upgrades the immediately following idr_preload()
allocation flag to the stronger of the two used in idr_preload() and
idr_alloc().  In practice, this means there's no reason to use
anything other than GFP_NOWAIT inside preloaded section.

IMO, this is a better or rather more evolved design of preloading in
radix_tree.  It's a lot more convenient and I'm thinking about
updating radix_tree preloading to about the same scheme.  It's a bit
cumbersome at the moment requiring determination of whether preloading
will be used or not at initialization time.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
