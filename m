From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 00/11] New Caching mechanism for ib_core
Date: Wed, 9 Nov 2011 17:49:08 +0530
Message-ID: <20111109121907.GA6763@shrek.cartoons>
References: <20111107084747.GA11297@shrek.cartoons>
 <1828884A29C6694DAF28B7E6B8A8237316E8DDCE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8DDCE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Sean for the review.

On Tue, Nov 08, 2011 at 11:46:50PM +0000, Hefty, Sean wrote:
> > The main motivations are:
> > 
> > 1. Greater degree of control by individual drivers. Drivers have a
> >    choice to use it or not.
> 
> I believe that some callers need to know that specific query calls will not sleep.  That capability should either be required or exposed through the API.

The new cache access functions do not sleep. This is the primary
objective of the exercise. See motviation 2 :) 
Exceptions are the init functions which may sleep because of kzalloc().
Did you want me to mention this specifically in the comments?

> 
> > 2. The library functions do not sleep, and can be called from any context.
> > 
> > In the bargain we lose the lmc cache. However, if we move it to the device
> > structure like the pkey_tbl_len, it can be accessed directly (TODO).
> > Let me know what you think about it.
> 
> The LMC cache is accessed by the MAD layer.  I know that MADs aren't considered a performance path, but we don't want to query the device for every MAD.
> 

I understand. I will try to incorporate the lmc cache in the device
structure while I wait for the rest of the comments.

Regards,

-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
