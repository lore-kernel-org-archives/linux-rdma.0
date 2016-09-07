From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Wed, 7 Sep 2016 19:06:09 -0400
Message-ID: <20160907230608.GA4515@phlsvsds.ph.intel.com>
References: <20160901164624.GC6479@obsidianresearch.com> <20160901165552.GE21847@leon.nu> <20160901170742.GA20098@obsidianresearch.com> <1472749767.16467.25.camel@intel.com> <20160901171129.GB19982@obsidianresearch.com> <1472750241.16467.29.camel@intel.com> <20160901173320.GB20472@obsidianresearch.com> <20160901175222.GF21847@leon.nu> <20160906210313.GA24527@phlsvsds.ph.intel.com> <20160906211959.GA27106@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160906211959.GA27106-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 06, 2016 at 03:19:59PM -0600, Jason Gunthorpe wrote:
> On Tue, Sep 06, 2016 at 05:03:14PM -0400, ira.weiny wrote:
> 
> > These defines are _not_ used anywhere in the kernel but rather define a
> > device specific command _offset_ within the drm vendor ioctl range.
> 
> That is not completely true, the defines are used when setting up the
> kernel ioctl #. I have no idea why they did this, to me it is
> polluting a uapi header with unneeded defines which is a big no-no.

Well...  That is the same for the HFI1 defines as the __NUM macro expanded to
those defines...

#define __NUM(cmd) (HFI1_CMD_##cmd + 0xe0)

But really aren't we just nit picking now?

> 
> Userspace should certainly *NEVER* use these constants, removing them
> is the best way to achieve that.

I assume the DRM user space uses them to help distinguish between 

#define DRM_AMDGPU_GEM_CREATE           0x00

And

#define DRM_I810_INIT           0x00


I'm not at all familiar with the drm user space code but I could see some sort
of "provider" architecture where the providers pass these constants and some
"core" layer adds the vendor offset automatically???

> 
> > When we agreed that HFI1 would use an 0x80 offset I thought that was the
> > idea.[*]  That IB would have an upper range which was device specific and HFI1
> > would be the first users of that range.
> 
> I'd rather not have non-unique ioctls if we can avoid it......

I'm still mulling over the plan for this.

> 
> But even if we do, removing these indirection constants does nothing to
> change that - other drivers can still alias 0x80.

Yes but having walked through the drm headers it is nice in how explicit they
are.

> 
> That is doable, particularly if the struct is a different size, then
> we still have unique ioctl numbers. With some care other vendors can
> probably manage...

Yes, I am sure we can manage.  There are always different ways to do things.
In the end if Doug accepts this series we will manage in PSM.  However, I
really don't think what was done was "wrong".

Ira


> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
