From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 12 May 2016 11:34:45 -0600
Message-ID: <20160512173445.GA13553@obsidianresearch.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512171115.6198.77458.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 10:18:27AM -0700, Dennis Dalessandro wrote:

> There is also a driver software version being exported via a sysfs
> file. This is needed so that user space applications (psm) can
> determine if it needs to do ioctl() or write().

Why? Don't do this, just call ioctl() and if it fails then use write().

> This does not add anything for compat_ioctl() as it is my understanding that
> 32 bit applications that attempt to call the ioctl() will just fail. Which is
> the intended behavior.

qib works fine with a 64 bit kernel and 32 bit user space, don't
break it.

> There is also a question of if we need to set kobj.parent [1], I'm

It is needed, you need to audit this stuff, there might be more wrong
than that.

> not sure this is the case since the cdev in question lives
> in /dev, not /dev/infiniband.

Irrelevant. kobj.parent is needed because the cdev is embedded within
another reference counted structure. You need to consider how all this
works when the driver is removed while the cdev is still open (or
driver remove is racing with the cdev release).

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
