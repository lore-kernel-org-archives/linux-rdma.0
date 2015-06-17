From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Wed, 17 Jun 2015 10:31:40 -0600
Message-ID: <20150617163140.GA22242@obsidianresearch.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
 <20150615173423.GA528@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF5828@ORSMSX109.amr.corp.intel.com>
 <20150615181348.GC1089@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC2574E174@fmsmsx120.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC2575144C@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2575144C-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 17, 2015 at 12:05:08PM +0000, Marciniszyn, Mike wrote:

> Jason, what is your take on ioctl vs. write.

Well, I think the global view keeps changing, so I'm not sure what is
trendy now..

But personally, I hate seeing write() used to emulate ioctl() because
'ioctl is bad'. ie if you are 'writing' a struct that contains user
pointers and you expect the kernel to read/write to user memory, then
use ioctl. (and that is the 'badness' of ioctl, so pretending it is
write doesn't help anything)

If you can formulate your communication like netlink does, where it is
more like a network RPC, where *everything* is in the buffer passed
to write and you have to call read to get a reply, then use
read/write. This is generally considered preferable, and is what
people mean when they say write is preferred. As I understand
it.

netlink is a reasonable low speed format to use for this kind of
serialization, either via the common mux or via your own char device.

I also wonder about all those sysfs files. I think the over reliance
on sysfs in rdma may have been a mistake, sending the same information
over netlink would be more consistent with what netdev is doing. (eg
you can't view the netdev IP addresses via sysfs, but you can view
rdma guids via sysfs)

Overall, I'd be alot happier with your driver patchset if it was split
as 'core only, no UAPI changes' followed up by 'Add UAPI for X'.

If you can't make a verbs provider work under 'core only' then I think
something is very wrong...

UAPI stuff in drivers is often a red flag, and you guys should think
really carefully about what OPA elements should be buried in the
driver and what elements should be common to all OPA adapters.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
