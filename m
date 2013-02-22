From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v3] IB/ipath: use GFP_NOWAIT under spin lock
Date: Fri, 22 Feb 2013 14:51:30 -0800
Message-ID: <CAOS58YMo3rABCLpKYRr7pRqeMo+rmGbbUJDj5xxE08pb-SyBqw@mail.gmail.com>
References: <CAPgLHd965-++Kj6HE-wjHqpZjortmmCAvApSSwiXaX6YwWncHQ@mail.gmail.com>
	<CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ@mail.gmail.com>
	<CAOS58YOHt7OaBHRwwqjLF8xZtVaj=BeFUXFAxW0owb4_BxC3Rg@mail.gmail.com>
	<CAPgLHd8_WyQiDpJwRWwNVPbSvVcpMj1bMu7h2QmfJpscd0LOFQ@mail.gmail.com>
	<20130222141642.247ee792.akpm@linux-foundation.org>
	<CAOS58YMrcCwh8RhnfRTsmbfa_K_h1=n2M6ws4=MHWDxpAAoXOw@mail.gmail.com>
	<20130222144451.ed48f015.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222144451.ed48f015.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello, Andrew.

On Fri, Feb 22, 2013 at 2:44 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> Not "guarantee".
>
> - idr_preload() might fail.  It is a design error that idr_preload()
>   returns void - it should do what radix_tree_preload() does.

That would equal to GFP_KERNEL allocation failing. The error isn't
ignored. It gets propagated to the actual idr_alloc() allocation.
You're just collecting the error later.

> - even if idr_preload() completed the preload, an interrupt might
>   come in and its handler might drain this cpu's preload pool.

Non-process context doesn't dip into preload pool, so the first
allocation after idr_preload() is *guaranteed* to fail iff the
previous idr_preload(GFP_KERNEL) failed and there just isn't much we
can do other than failing if GFP_KERNEL allocation fails.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
