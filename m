From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 14 Apr 2016 21:08:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB041C90@ORSMSX109.amr.corp.intel.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160414180540.GA12554@obsidianresearch.com>
 <20160414184200.GA10416@phlsvsds.ph.intel.com>
 <20160414185659.GB12997@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414185659.GB12997-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Add a new uverbs ioctl:
> 
>  int hfi1_fd = ioctl(uverbs_fd, RDMA_GET_DRIVER_OPS_FD, "psm2.intel.com");
> 
>  ioctl(hfi1_fd, HFI1_IOCTL_ASSIGN_CTXT, ...);
>  write(hfi1_fd, ...);
> 
> At least that gives us far better options for discovery and versioning
> of this stuff than a driver-specific char device.
> 
> [eg this would use anon_inode_getfile, like event fds, completion
> channels, etc]
> 
> You guys need this the most, propose something already.
> 
> * driver specific ioctls might be nicer, but people argue that is not
>   performant enough for what you want... Unclear to me.

FWIW, I found this in the ioctl documentation:

http://lxr.free-electrons.com/source/Documentation/ioctl/botching-up-ioctls.txt

"One clear insight kernel graphics hackers gained in the past few years is that
 trying to come up with a unified interface to manage the execution units and
 memory on completely different GPUs is a futile effort. So nowadays every
 driver has its own set of ioctls to allocate memory and submit work to the GPU."

I haven't found much else related to uABI design yet.  Anyway, that document describes the drivers/gpu/drm devices.  Looking into their ioctl implementation, they do this:

long drm_ioctl(struct file *filp,
0683           unsigned int cmd, unsigned long arg)
0684 {
...
0701     is_driver_ioctl = nr >= DRM_COMMAND_BASE && nr < DRM_COMMAND_END;
0702 
0703     if (is_driver_ioctl) {
0704         /* driver ioctl */
...
0707         ioctl = &dev->driver->ioctls[nr - DRM_COMMAND_BASE];
0708     } else {
0709         /* core ioctl */
...
0712         ioctl = &drm_ioctls[nr];
0713     }
...
0726     func = ioctl->func;
...
0766         retcode = func(dev, kdata, file_priv);

FWIW, this ioctl design aligns with Jason's proposal.  However, nothing discussed so far really attempts to address whether we continue to pursue a "unified interface" as mentioned above, or if that is broken up.

For the work that Dennis is doing, I think it could be handled as driver specific ioctl's going through a common core.  But beyond implementing a call like drm_ioctl, the definition of driver ioctl's and core ioctl's can be done independently.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
