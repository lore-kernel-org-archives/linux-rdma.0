From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Wed, 20 Apr 2016 14:36:16 -0600
Message-ID: <20160420203616.GA28991@obsidianresearch.com>
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
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 14, 2016 at 01:52:44PM -0400, Dennis Dalessandro wrote:
> The eprom device is for low level programming of the eprom on the
> chip. We do not use i2c for this because the eprom is directly
> attached to the chip and not accessible via i2c, requires register
> access.

Okay, but the twsi.c is still not acceptable in a driver, use the i2c
subsystem to talk to the qsfps. Open coding i2c is not OK.

The char dev(s) are also done wrong, there is no set to 'kobj.parent'
and there are empty release functions. There are certainly
use-after-free bugs between close and device removal, someone needs to
audit all of this carefully.

The patch forgets compat_ioctl.

Stuff like this should be a build bug:
 /* NOTE: assumes unsigned long is 8 bytes */

The 'goto on success' in hfi1_cdev_init is an anti-pattern, don't do it.

Even if the char dev stays, creating two whole sysfs classes seems
really unnecessary. Surely there is a better place to attach the cdev.

And this is just outrageous:

        if (atomic_inc_return(&user_count) == 1) {
                ret = hfi1_cdev_init(0, class_name(), &hfi1_file_ops,
                                     &wildcard_cdev, &wildcard_device,
                                     true);
                if (ret)

I can see an argument for a per-device char dev (as Christoph says,
that is not entirely uncommon) but this is a multi-device char dev????

It is not OK to create your own private subsystem in a driver! I count
*three* char devs before this series!?!?! One of them marked 0666 even!

I stopped looking at the code.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
