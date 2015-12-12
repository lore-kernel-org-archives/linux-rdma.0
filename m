From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Fri, 11 Dec 2015 17:47:15 -0700
Message-ID: <20151212004715.GA10790@obsidianresearch.com>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <20151212002313.GH7855@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151212002313.GH7855-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 11, 2015 at 07:23:13PM -0500, ira.weiny wrote:
> On Fri, Dec 11, 2015 at 05:00:47PM -0700, Jason Gunthorpe wrote:
> > 
> > FWIW, I also hate the sysfs counters that reflect the PMA, these would
> > be much better are free running, wrapping, non-resetting counters
> > unrelated to the PMA. Something that doesn't zero after the SM samples
> > it. Sounds like qib, hif, rdmavt can trivially fix this, and should, IMHO.
> 
> To be fair with a 64bit counter these are not going to get reset very often.

It resets when ever the SM sends a reset packet, so 'whenever'

> Furthermore, I don't think we can change the behavior now.

Sure we can, the restting is really a bug, to the point that nothing
can actually use the sysfs counters reliably.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
