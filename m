From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/11] New Caching mechanism for ib_core
Date: Thu, 10 Nov 2011 09:50:29 +0530
Message-ID: <20111110042029.GA7713@shrek.cartoons>
References: <20111107084747.GA11297@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DDCE@ORSMSX101.amr.corp.intel.com>
 <20111109121907.GA6763@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DE44@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8DE44-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 09, 2011 at 03:12:04PM +0000, Hefty, Sean wrote:
> > > > 1. Greater degree of control by individual drivers. Drivers have a
> > > >    choice to use it or not.
> > >
> > > I believe that some callers need to know that specific query calls will not
> > sleep.  That capability should either be required or exposed through the API.
> > 
> > The new cache access functions do not sleep. This is the primary
> > objective of the exercise. See motviation 2 :)
> > Exceptions are the init functions which may sleep because of kzalloc().
> > Did you want me to mention this specifically in the comments?
> 
> Yes, but the use of the cache is hidden from the user.  

user who?

> Currently calls like ib_query_gid() are allowed to sleep.  If drivers are given the choice whether or not to use the cache, then there's no way for a user to know whether a query call will sleep or not.
> 

The cache calls do not sleep. Period.
AFAIK, the problem is with assuming calls do not sleep, when they
actually do and not vice versa.

What problems do you forsee if we declare that cache calls do not sleep?

Since the drivers would be users of cache calls, the behavior would be
as assumed for the query calls for the driver. Refer mthca
implementation (PATCH 11/11): If the entry is found in cache, it
will return immediately, and will not sleep. If the entry is not
found, it will query the device and may sleep. In essence we still
hold that the query functions may sleep, but if the data is available
in cache it will return faster.


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
