From: Jon Mason <jon-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: erroneous CONFIG variable in infiniband code?
Date: Mon, 28 Dec 2009 15:38:28 -0600
Message-ID: <20091228213826.GA7042@opengridcomputing.com>
References: <alpine.LFD.2.00.0912281157340.12771@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912281157340.12771@localhost>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 28, 2009 at 11:58:29AM -0500, Robert P. J. Day wrote:
> 
> drivers/infiniband/core/cma.c:2086:#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
> 
>   notice the difference in case there, "IPv6" versus "IPV6".  someone
> want to check that out?

Yup, looks like a bug introduced in commit d14714df61681cfecf945a58436edf197327e87f
Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Thu Nov 19 16:46:25 2009 -0800

    IB/addr: Fix IPv6 routing lookup
    
    Include link scope as part of address resolution.  Combine local
    and remote address resolution into a single, simpler code path.
    Fix error checking in the IPv6 routing lookups.
    
    Based on work from:
    David Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
    
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    
    [ Fix up cma_check_linklocal() for !IPV6 case.  - Roland ]
    
    Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

Before the change, they were
-#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)

Good catch.  Submit a patch and Cc lkml.

Thanks,
Jon

> 
> rday
> --
> 
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
> 
>             Linux Consulting, Training and Kernel Pedantry.
> 
> Web page:                                          http://crashcourse.ca
> Twitter:                                       http://twitter.com/rpjday
> ========================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
