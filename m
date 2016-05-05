From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 12:46:57 -0600
Message-ID: <20160505184657.GA16525@obsidianresearch.com>
References: <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
 <20160505063834.GH29160@leon.nu>
 <20160505120033.GA23895@phlsvsds.ph.intel.com>
 <20160505123932.GK29160@leon.nu>
 <20160505180843.GA5957@obsidianresearch.com>
 <b7f1735c-5362-514e-268a-49a09b316a88@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b7f1735c-5362-514e-268a-49a09b316a88-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 02:36:16PM -0400, Doug Ledford wrote:
> > For instance, the HFI1 driver is as functional as any other RDMA
> > driver without it's cdev, eeprom, debug and sysfs uAPIs. Those are all
> > value add features that do not impact the driver's ability to operate
> > as an RDMA device.
> 
> In this case though, not so much.  The qib and hfi1 devices have always
> been PSM devices first, verbs devices merely as a compat layer.
> It's

The driver can do both interfaces, and the hardware was clearly
designed to accelerate the typical verbs operations as well as support
the psm style of operation.

> easier to provides a verbs interface for kernel ULPs than it is to write
> PSM in the kernel.  But their hardware is designed around the way PSM
> uses it, and how verbs makes use of it is decidedly sub-optimal.  They
> could do without the eeprom, debug, and sysfs stuff, but the cdev and
> PSM not so much.

I didn't say the cdev shouldn't exist, only that the core driver should
have been submitted first and then patched to add in the other stuff,
maybe in the same series, but certainly split up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
