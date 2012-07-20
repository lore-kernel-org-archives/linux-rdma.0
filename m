From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
 parameters
Date: Fri, 20 Jul 2012 16:11:04 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D47DA6B@FMSMSX108.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
	<20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
	<CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
	<CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA@mail.gmail.com>
	<32E1700B9017364D9B60AED9960492BC0D47D8D1@FMSMSX108.amr.corp.intel.com>
 <CAJZOPZ+uK3c69ThX-Apwdj9cR2=XwNO4e7CVbmXYT4PuSPVKPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+uK3c69ThX-Apwdj9cR2=XwNO4e7CVbmXYT4PuSPVKPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As I mentioned in my prior email, the issue is that the parameters need to be present to init each HCA/port differently when the driver loads.

That is the key requirement for any scheme.

Mike

> -----Original Message-----
> From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Friday, July 20, 2012 12:00 PM
> To: Marciniszyn, Mike
> Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port
> parameters
> 
> On Fri, Jul 20, 2012 at 2:40 PM, Marciniszyn, Mike
> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> > If you could give me some code to look at?
> 
> include/rdma/rdma_netlink.h
> drivers/infiniband/core/netlink.c
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
