From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
 parameters
Date: Mon, 30 Jul 2012 18:18:43 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC0D4810A2@FMSMSX108.amr.corp.intel.com>
References: <20120719130356.4706.63775.stgit@kop-dev-sles11-04.qlogic.org>
	<20120719130411.4706.88736.stgit@kop-dev-sles11-04.qlogic.org>
	<CAL1RGDVb964pLxx=gvuvP5SWcXT2+g2pPssH6YRSq0LFhup7yA@mail.gmail.com>
	<CAJZOPZJaNiKqKWpT=Jj2fXKf-X+6wLXrqXGCc+d0oH8ZQsNsZA@mail.gmail.com>
	<32E1700B9017364D9B60AED9960492BC0D47D8D1@FMSMSX108.amr.corp.intel.com>
 <CAJZOPZ+uK3c69ThX-Apwdj9cR2=XwNO4e7CVbmXYT4PuSPVKPA@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC0D47DA6B@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D47DA6B-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Haralanov, Mitko" <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Unless I'm missing something, it looks to me like the only interface, is the dump() method.  There doesn't appear to be a doit()?

dump() seems to me that is only suitable for getting information from the kernel.

In our case, we need to get parameters from user space to the kernel.

There are other alternatives, like configfs that seem more suitable.

Again, the key requirement is that the more flexible configuration must be available at module load as does the current module parameter patch.   If we enlist a user space helper to assist in passing the more flexible parameter, the lack of the helper cannot prevent the load of a module.

Mike

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Marciniszyn, Mike
> Sent: Friday, July 20, 2012 12:11 PM
> To: Or Gerlitz
> Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH 3/5] IB/qib: Add support for per-device/per-port
> parameters
> 
> As I mentioned in my prior email, the issue is that the parameters need to
> be present to init each HCA/port differently when the driver loads.
> 
> That is the key requirement for any scheme.
> 
> Mike
> 
> > -----Original Message-----
> > From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Friday, July 20, 2012 12:00 PM
> > To: Marciniszyn, Mike
> > Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH 3/5] IB/qib: Add support for per-device/per-port
> > parameters
> >
> > On Fri, Jul 20, 2012 at 2:40 PM, Marciniszyn, Mike
> > <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > > If you could give me some code to look at?
> >
> > include/rdma/rdma_netlink.h
> > drivers/infiniband/core/netlink.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
