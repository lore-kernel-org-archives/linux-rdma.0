From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Wed, 4 May 2016 12:15:09 -0600
Message-ID: <20160504181509.GA20488@obsidianresearch.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
 <20160503184218.GC29160@leon.nu>
 <20160504044107.GE29160@leon.nu>
 <20160504123621.GC10916@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504123621.GC10916-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 08:36:21AM -0400, Dennis Dalessandro wrote:

> I think it's slightly more complicated than that. There are three options
> really: core, driver, or get it out of the kernel.

>From a core maintenance perspective, I think it is very simple, if
someone wishes to add code to their driver to manipulate the EEPROM,
then at this point the work to make a common uAPI falls on to their
shoulders.

I'd also make a very clear message to driver submitters: Do not
include uAPIs in your initial driver patch set. Those should follow on
as dedicated well identified patches so that they attracted the proper
review.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
