From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 12:56:59 -0600
Message-ID: <20160414185659.GB12997@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160414184200.GA10416-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 02:42:01PM -0400, Dennis Dalessandro wrote:
> >It certainly can't be years.
> 
> Does fixing the current write()/writev() problem have any real
> impact on how we proceed for the "1 char dev to rule them all" idea?

We aren't going to take a bad uAPI into mainline. So how many times do
you want to redo the userspace? I have no objection to the patch
landing, just as long as it stays in staging until we have the uAPI
discussion as a community.

As for the 'one char device', I actually think it would be really
simple.

Add a new uverbs ioctl:

 int hfi1_fd = ioctl(uverbs_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");

 ioctl(hfi1_fd, HFI1_IOCTL_ASSIGN_CTXT, ...);
 write(hfi1_fd, ...);

At least that gives us far better options for discovery and versioning
of this stuff than a driver-specific char device.

[eg this would use anon_inode_getfile, like event fds, completion
channels, etc]

You guys need this the most, propose something already.

* driver specific ioctls might be nicer, but people argue that is not
  performant enough for what you want... Unclear to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
