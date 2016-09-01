From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL commands
Date: Thu, 1 Sep 2016 11:33:20 -0600
Message-ID: <20160901173320.GB20472@obsidianresearch.com>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <1471987907-6336-7-git-send-email-leon@kernel.org>
 <1472738739.16467.8.camel@intel.com>
 <20160901164624.GC6479@obsidianresearch.com>
 <20160901165552.GE21847@leon.nu>
 <20160901170742.GA20098@obsidianresearch.com>
 <1472749767.16467.25.camel@intel.com>
 <20160901171129.GB19982@obsidianresearch.com>
 <1472750241.16467.29.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472750241.16467.29.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 01, 2016 at 05:17:26PM +0000, Dalessandro, Dennis wrote:
> On Thu, 2016-09-01 at 11:11 -0600, Jason Gunthorpe wrote:
> > On Thu, Sep 01, 2016 at 05:09:31PM +0000, Dalessandro, Dennis wrote:
> > 
> > > > Dennis should use an internal definition in PSM if he wishes to
> > > > continue to support the staging kernel ABI.
> > > 
> > > It's not just the backward compatibility. PSM uses these command
> > > definitions.So this breaks current support with current driver.
> > 
> > How exactly? The HFI1_CMD_ASSIGN_CTXT constant is never used in the
> > kernel?
> 
> This is used in PSM library. Agree it's not used in the kernel, so I
> can see the argument to get rid of it, or not care.

Lets get rid of all the #defines. Leon you should just inline the
ioctl numbers into the ioctl definition like normal and get rid of
this extra layer of macros.

This way Dennis will get a build failure when PSM is build with these
headers instead of subtle runtime breakage. He can import the required
definitions to support the staging compat ABI into PSM, where they
belong, and make a new release to build with new kernel headers. Lots
of time to do that before these headers hit the distros.

Upstream is not the place to carry that stuff, and keeping strange
subtleness with __NUM is just going to risk future breakage.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
