From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Mon, 18 Apr 2016 11:40:47 -0600
Message-ID: <20160418174047.GB13865@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418130909.GD11508-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 18, 2016 at 06:09:09AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 14, 2016 at 10:45:50AM -0600, Jason Gunthorpe wrote:
> > On Thu, Apr 14, 2016 at 08:41:35AM -0700, Dennis Dalessandro wrote:
> > > This patch series removes the write() interface for user access in favor of an
> > > ioctl() based approach. This is in response to the complaint that we had
> > > different handlers for write() and writev() doing different things and expecting
> > > different types of data. See:
> > 
> > I think we should wait on applying these patches until we globally sort out
> > what to do with the rdma uapi.
> > 
> > It just doesn't make alot of sense for drivers to have their own personal
> > char devices. :(
> 
> I looked through the patches I tend to disagree - while we should wait
> for a global UAPI for anything that's actually RDMA/verbs related these
> seem to be misc little bits specific to the driver that have no business
> in any sort of generic RDMA API.

I wasn't arguing this should integrate into verbs in some way, only
that the way to access the driver-specific uAPI of a RDMA device should
be through the RDMA common uAPI and not through a random char dev.

.. and of course that the driver-specific API be subject to a sane
review and use of the normal standards, not just written off as
driver-garbage nobody cares about. :(

For instance, if we had a driver specific channel, it casts this
endless stream of uAPI verbs patches in a different light: maybe they
should go down the driver-specific channel instead.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
