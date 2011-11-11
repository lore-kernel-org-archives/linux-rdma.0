From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/11] New Caching mechanism for ib_core
Date: Fri, 11 Nov 2011 09:45:24 +0530
Message-ID: <20111111041523.GA6773@shrek.cartoons>
References: <20111107084747.GA11297@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DDCE@ORSMSX101.amr.corp.intel.com>
 <20111109121907.GA6763@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DE44@ORSMSX101.amr.corp.intel.com>
 <20111110042029.GA7713@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E95317@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E95317-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

On Thu, Nov 10, 2011 at 07:03:40AM +0000, Hefty, Sean wrote:
> > > Yes, but the use of the cache is hidden from the user.
> > 
> > user who?
> 
> ib_cm, rdma_cm, ib_mad, ib_ipoib, etc.  You would need to trace the use up to all ULPs.
> 
> > Since the drivers would be users of cache calls, the behavior would be
> > as assumed for the query calls for the driver. Refer mthca
> > implementation (PATCH 11/11): If the entry is found in cache, it
> > will return immediately, and will not sleep.
> 
> > If the entry is not found, it will query the device and may sleep.
> 
> This is the issue.  You changed calls from ib_find_cached_pkey() and ib_find_cached_gid() to ib_query_pkey() and ib_query_gid().  The latter calls may sleep, but I don't believe that we can sleep in all places where the new functions are used.  Changing from ib_find_cached_gid to ib_query_gid changes the locking restrictions up through the stack.  It doesn't matter if the cache doesn't block, the exposed calls may.

Thanks for explaining. I see your point now. This had been in the
orignal discussion, but I missed on this point while working
on this. I will redo the patches after reviewing the function usage.

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
