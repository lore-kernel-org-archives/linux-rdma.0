From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Tue, 6 Sep 2016 17:03:14 -0400
Message-ID: <20160906210313.GA24527@phlsvsds.ph.intel.com>
References: <1471987907-6336-7-git-send-email-leon@kernel.org> <1472738739.16467.8.camel@intel.com> <20160901164624.GC6479@obsidianresearch.com> <20160901165552.GE21847@leon.nu> <20160901170742.GA20098@obsidianresearch.com> <1472749767.16467.25.camel@intel.com> <20160901171129.GB19982@obsidianresearch.com> <1472750241.16467.29.camel@intel.com> <20160901173320.GB20472@obsidianresearch.com> <20160901175222.GF21847@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160901175222.GF21847-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 08:52:22PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 01, 2016 at 11:33:20AM -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 01, 2016 at 05:17:26PM +0000, Dalessandro, Dennis wrote:
> > > On Thu, 2016-09-01 at 11:11 -0600, Jason Gunthorpe wrote:
> > > > On Thu, Sep 01, 2016 at 05:09:31PM +0000, Dalessandro, Dennis wrote:
> > > >
> > > > > > Dennis should use an internal definition in PSM if he wishes to
> > > > > > continue to support the staging kernel ABI.
> > > > >
> > > > > It's not just the backward compatibility. PSM uses these command
> > > > > definitions.So this breaks current support with current driver.
> > > >
> > > > How exactly? The HFI1_CMD_ASSIGN_CTXT constant is never used in the
> > > > kernel?
> > >
> > > This is used in PSM library. Agree it's not used in the kernel, so I
> > > can see the argument to get rid of it, or not care.
> >
> > Lets get rid of all the #defines. Leon you should just inline the
> > ioctl numbers into the ioctl definition like normal and get rid of
> > this extra layer of macros.
> 
> Ohh, it looks like you returned to us filled with positive energy :)
> 
> I tried to follow DRM subsystem [1] while converted these names with
> minimal impact on the current implementation.

I like the idea of borrowing from the DRM subsystem but that is not quite what
I see here.

That subsystem defines a constant command base and a common Command base
(defined as an "end" for vendor specific):


/**
 * Device specific ioctls should only be in their respective headers
 * The device specific ioctl range is from 0x40 to 0x9f.
 * Generic IOCTLS restart at 0xA0.
 *
 * \sa drmCommandNone(), drmCommandRead(), drmCommandWrite(), and
 * drmCommandReadWrite().
 **/
#define DRM_COMMAND_BASE                0x40
#define DRM_COMMAND_END                 0xA0


And then all the vendor specific commands are defined like:

#define DRM_AMDGPU_GEM_CREATE           0x00
...

#define DRM_I810_INIT           0x00
...

#define DRM_I915_INIT           0x00
...


These defines are _not_ used anywhere in the kernel but rather define a
device specific command _offset_ within the drm vendor ioctl range.


When we agreed that HFI1 would use an 0x80 offset I thought that was the
idea.[*]  That IB would have an upper range which was device specific and HFI1
would be the first users of that range.

Maybe it would be better to use:

#define RDMA_VENDOR_BASE 0x80

Rather than HFI1_CMD_BASE?


What I think is wrong is that your patch changes the HFI1_CMD_ASSIGN_CTXT
define from being an offset from the base (0x01) to a hard coded RDMA define
0x81.

This deviates from the idea that these defines are offsets from the common
base.  I can see the argument Jason presents.  But I think we should leave the
current defines for the following reasons:

	1) that was not the agreed upon interface when hfi1 came out of staging.
	2) This prevents other devices from utilizing this vendor range.
	3) This allows us to use this range in the future for other devices
	4) There is little reason to break userspace unnecessarily.



All that said:

I know that we are not heading down the path of vendor devices having the same
IOCTLs but I don't think it is an idea we should abandon.

The patch set from Matan has the following in ib_uverbs_ioctl:


	if (cmd == RDMA_DIRECT_IOCTL) {
                /* TODO? */
                err = -ENOSYS;
                goto out;
        } else {


Given that we already have a vendor ioctl range concept I think we should just
keep this range for potential use instead of the above code.  And keep the
defines the way they are: as an HFI1 specific offset into the vendor ioctl
range.


Finally, I have to disagree with Jason that any define in a uapi file is
required to be used in the kernel.  Looking through the drm code that is
clearly not the case.


Ira


[*] I can't find the email reference at this time...  :-(

> 
> 
> > This way Dennis will get a build failure when PSM is build with these
> > headers instead of subtle runtime breakage. He can import the required
> > definitions to support the staging compat ABI into PSM, where they
> > belong, and make a new release to build with new kernel headers. Lots
> > of time to do that before these headers hit the distros.
> >
> > Upstream is not the place to carry that stuff, and keeping strange
> > subtleness with __NUM is just going to risk future breakage.
> 
> I would love to go in this direction, to get rid of unused defines
> (especially in UAPIs).
> 
> Let's wait till Sunday, maybe we will see more discussions on the topic.
> 
> [1] http://lxr.free-electrons.com/source/include/uapi/drm/i915_drm.h
> 
> >
> > Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
