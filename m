From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 01/37] IB/rdmavt: Create module framework and handle
 driver registration
Date: Tue, 8 Dec 2015 23:10:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE7B57@ORSMSX109.amr.corp.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204300.8144.20089.stgit@phlsvslse11.ph.intel.com>
 <20151208055545.GC7313@leon.nu>
 <20151208230612.GB14221@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208230612.GB14221-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> +#define RDMAVT_DRIVER_VERSION "0.1"
> >Do we really need driver version?
> 
> Based on these patches thus far. Probably not. We do still have a bit more
> development to go here, I added it more as a just in case but am not
> steadfast in keeping it.
> 
> What's the general rule here? Should we not assign a version if we aren't
> explicitly doing anything with it yet, but may at some point?

A driver version doesn't make sense.  Use the kernel version. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
