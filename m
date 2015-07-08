From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Wed, 8 Jul 2015 21:42:39 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2575DA43@fmsmsx120.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
 <20150615173423.GA528@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF5828@ORSMSX109.amr.corp.intel.com>
 <20150615181348.GC1089@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC2574E174@fmsmsx120.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC2575144C@fmsmsx120.amr.corp.intel.com>
 <20150617163140.GA22242@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617163140.GA22242-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> netlink is a reasonable low speed format to use for this kind of serialization,
> either via the common mux or via your own char device.
> 

A couple of follow-up netlink questions.

1.  I assume you are talking about generic netlink vs. say the RDMA netlink.

The generic netlink handles dynamic id assignment which would seem to make it a better choice.

2.  Can you clarify "via your own char device"?

I think netlink is char device independent.   For PSM2, the mmap() overload is required for setting up direct hardware access, so we need the device.

The difference here is that PSM[12] also uses aio/iter overload for bulk SDMA traffic.  The use of write() as a control is consistent with the core.

> I also wonder about all those sysfs files. I think the over reliance on sysfs in
> rdma may have been a mistake, sending the same information over netlink
> would be more consistent with what netdev is doing. (eg you can't view the
> netdev IP addresses via sysfs, but you can view rdma guids via sysfs)
> 

The current sysfs usage is consistent with PSM1/qib use with updates for OPA differences.   I will update the sysfs docs for both qib and wfr as part of the patch set.

> Overall, I'd be alot happier with your driver patchset if it was split as 'core
> only, no UAPI changes' followed up by 'Add UAPI for X'.
> 
> If you can't make a verbs provider work under 'core only' then I think
> something is very wrong...
> 
> UAPI stuff in drivers is often a red flag, and you guys should think really
> carefully about what OPA elements should be buried in the driver and what
> elements should be common to all OPA adapters.
> 

By UAPI, do you mean the file in the include/uapi, the sysfs additions, the PSM side of the driver, or all these?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
