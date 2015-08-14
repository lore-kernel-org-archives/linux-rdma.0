From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] pull request: linux-firmware: Add Intel OPA hfi1 firmware
Date: Fri, 14 Aug 2015 18:23:22 -0400
Message-ID: <20150814222321.GB12943@phlsvsds.ph.intel.com>
References: <20150811213205.GA28613@phlsvsds.ph.intel.com> <20150811222557.GA6293@obsidianresearch.com> <9010F06FA27E5745AF23866A8C9A2B3D2E9B136C@FMSMSX106.amr.corp.intel.com> <20150811233553.GA3553@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150811233553.GA3553-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vogel, Steve" <steve.vogel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <linux-firmware-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Sowa, David" <david.sowa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 11, 2015 at 05:35:53PM -0600, Jason Gunthorpe wrote:
> On Tue, Aug 11, 2015 at 10:47:03PM +0000, Vogel, Steve wrote:
> > The license terms allow anyone to distribute (but not sell) the firmware but
> > only for use on Intel products. 
> 
> Redistribution alone may be enough to be included in linux-firmware

I believe redistribution is sufficient as our legal team is well aware that
this was to be released to linux-firmware and the distros.

I submitted with the license which was approved by our legal team after having
been assured it allowed for redistribution by linux-firmware and the distros.

> 
> However, most of the additional terms (and there are lots of them)
> this imposes beyond the usual likely make it impossible to include in a
> distro, so pragmatically, there is no reason to push for inclusion in
> linux-firmware.
> 
> This is going to be a hard road for you guys. Falling in line with
> every other Intel firmware blob's (i915, ibt, iwlwifi, SST2) license
> would be much easier on you and the distros.

We are working with Legal to come up with a license which is more in line with
what already exists in linux-firmware.

Ira

> 
> Frankly, I think the onus is on you to get statements from the
> licensing teams at Fedora, Debian, RH and SuSE on if they can include
> work under this license or not.
> 
> I suspect Fedora and Debian will both say they can't, just based on
> their public policies and the additional restrictions in this
> license.. But hey, I'm not a licensing lawyer..
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
