From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Thu, 9 Jul 2015 11:53:20 -0600
Message-ID: <20150709175320.GC21921@obsidianresearch.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
 <20150615173423.GA528@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF5828@ORSMSX109.amr.corp.intel.com>
 <20150615181348.GC1089@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC2574E174@fmsmsx120.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC2575144C@fmsmsx120.amr.corp.intel.com>
 <20150617163140.GA22242@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC2575DA43@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2575DA43-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 08, 2015 at 09:42:39PM +0000, Marciniszyn, Mike wrote:
> > netlink is a reasonable low speed format to use for this kind of serialization,
> > either via the common mux or via your own char device.
> > 
> 
> A couple of follow-up netlink questions.
> 
> 1.  I assume you are talking about generic netlink vs. say the RDMA netlink.

No, 'common mux' means socket(AF_NETLINK)

Your own char device, means stuffing netlink messages over your own
read/write scheme on /dev/infiniband/whatever, just to re-use the
netlink message processing infrastructure.

Where this stuff would live in the common mux space, I don't
know. Probably under RDMA, like iWarp does. Depends what it is, I
guess.

> I think netlink is char device independent.  For PSM2, the mmap()
> overload is required for setting up direct hardware access, so we
> need the device.

Right, this is why you might want to run netlink messages over a char
device so you have mmap.

> The difference here is that PSM[12] also uses aio/iter overload for
> bulk SDMA traffic.  The use of write() as a control is consistent
> with the core.

Which is what Al said no to, so it has to go.

I would not use the core code as an example of modern tastes on how to
best build a UAPI. My feeling is ioctl considered better than abusing
write() with hidden pointers as the core does. read/write is prefered
to ioctl() if it works in a self contained stream basis (ie no
pointers)

> > I also wonder about all those sysfs files. I think the over reliance on sysfs in
> > rdma may have been a mistake, sending the same information over netlink
> > would be more consistent with what netdev is doing. (eg you can't view the
> > netdev IP addresses via sysfs, but you can view rdma guids via sysfs)
> 
> The current sysfs usage is consistent with PSM1/qib use with updates
> for OPA differences.  I will update the sysfs docs for both qib and
> wfr as part of the patch set.

But it keeps growing, and more new sysfs files are being added for OPA
stuff. If we were going to move into a netlink direction then doing
that at the moment we introduce a whole new protocol like OPA makes
sense to me.

> > UAPI stuff in drivers is often a red flag, and you guys should
> > think really carefully about what OPA elements should be buried in
> > the driver and what elements should be common to all OPA adapters.
> 
> By UAPI, do you mean the file in the include/uapi, the sysfs
> additions, the PSM side of the driver, or all these?

All of these.

Drivers should not be designing UAPIs. It is unfortunate that RDMA
requires it, but that isn't an excuse to go hog wild and cram gigantic
UAPIs into drivers. Particularly the common OPA stuff living in the
driver is unsettling.

Especially in your case where there is now a history of 50kloc, highly
duplicative, driver submissions every couple of years. Two
implementations of the PSM userspace stuff is obnoxious. Buring OPA
specific stuff and sysfs files in the driver probably means when hfi2
rolls around there will be two copies of all of that. More obnoxious.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
