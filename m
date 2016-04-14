From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 12:46:53 -0600
Message-ID: <20160414184653.GA12997@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414175243.GA9310@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160414175243.GA9310-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 01:52:44PM -0400, Dennis Dalessandro wrote:
> On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> >On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> >>This patch series removes the write() interface for user access in favor of an
> >>ioctl() based approach. This is in response to the complaint that we had
> >>different handlers for write() and writev() doing different things and expecting
> >>different types of data. See:
> >
> >I think we should wait on applying these patches until we globally sort out
> >what to do with the rdma uapi.
> 
> Perhaps there is a broader change to make to the rdma subsystem, but until
> that is fleshed out this patch set achieves our goal of fixing the
> write()/writev() problem and should be sufficient to let the driver come out
> of staging for 4.7?

No. Al and Linus have clearly put the kibosh on the idea that a driver
gets a pass on whatever uAPI stuff they want just because it is in a
driver.

If anything adding uAPIs to drivers should be *harder* than adding
them to the core kernel. You nedd a lot more justification why the
core code shouldn't have a well designed version of the function.

You guys need to integrate with the rest of the kernel in some way,
this is just not OK. We catch so much flack from the rest of the
kernel community for our shitty uAPIs, we need to grow up.

I accept the argument that you need special high speed hardware
specific uAPIs for PSM - fine, but that doesn't give hfi1 a free pass
to add whatever other kooky things you find convenient. No to eeprom,
no to snoop.

If you want to migrate out of staging quickly then drop the uAPI from
the driver and submit a sane uAPI later as patches.

IMHO, it was a mistake for Roland to accept ipath with all this uAPI
stuff, and a double mistake to give qib an equal pass. hfi1 is adding
*even more* stuff, with flimsy justification. Enough is enough.

> >A second char dev for the eeprom? How is that OK? Why aren't you using
> >the I2C layer for this?
> 
> I moved it because it is totally different in terms of
> functionality. The

Nobody else is doing something like this. It is crazy.

Add a common RDMA API for eeprom. net has one under ethtool, it is
about time we grow something too, all the vendors seem to have various
hacks in this department. Maybe it fits under RDMA's growing netlink
footprint.

> >Why is there a snoop interface in here? How is that not something that
> >belongs in a the core code?
> 
> The snoop interface is a low level diagnostic for the hfi. The intent is to
> grab packets before they are handed up to the verbs layer. It also lets us
> send all sorts of debug/diagnostic packets for testing.

So? Why is that unique to hfi1? Packet capture is a well understood
multi-vendor thing.

Nobody else is getting a pass on uAPI design. Thing is, I don't think
it is actually hard to do a good job with the uAPI here, you just
actually have to try. :P

I told John I'd give you guys some design advice. I suggest you give
it a good think, make your wishlist and lets do something sane.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
