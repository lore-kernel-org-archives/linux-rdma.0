From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 12:08:43 -0600
Message-ID: <20160505180843.GA5957@obsidianresearch.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
 <20160504181509.GA20488@obsidianresearch.com>
 <20160505063834.GH29160@leon.nu>
 <20160505120033.GA23895@phlsvsds.ph.intel.com>
 <20160505123932.GK29160@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160505123932.GK29160-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 05, 2016 at 03:39:32PM +0300, Leon Romanovsky wrote:

> > I think the message really should be that if your driver contains uAPI
> > changes those should be in separate patches that are clearly identified. So
> > if you have a driver that is developed off-list initially, instead of just
> > breaking it up into chunks for submission add another step.
> > 
> > Something like this:
> > 1) Submit patch series which break-ups internally developed code
> > 2) Submit patch series with separated out uAPI code
> > 3) Submit patch that makes the build go-live

Yes. Perhaps even submit #2 after getting #1 mainlined.

Make it easy to find the important/controversial things and the review
process will work much better for everyone. Buring stuff in a monster
patch is just going to stretch it out.

> > These can all be submitted together, but with the patches broken up like
> > this reviewers can target uAPI code more easily.
 
> At the end, there is no point of accepting (1) without finished review
> of (2 and 3). Right now all patch series already have such internal separation
> in a slightly different order.

Eh?

Drivers should be able to stand alone without dedicated uapis
(excluding the udata stuff).

For instance, the HFI1 driver is as functional as any other RDMA
driver without it's cdev, eeprom, debug and sysfs uAPIs. Those are all
value add features that do not impact the driver's ability to operate
as an RDMA device.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
