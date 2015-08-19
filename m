From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Wed, 19 Aug 2015 11:54:25 -0600
Message-ID: <20150819175425.GE22646@obsidianresearch.com>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-2-git-send-email-hch@lst.de>
 <20150819174614.GC22646@obsidianresearch.com>
 <20150819174802.GA13875@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150819174802.GA13875-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 07:48:02PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 19, 2015 at 11:46:14AM -0600, Jason Gunthorpe wrote:
> > Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > 
> > AFAIK, this path is rarely (never?) actually used. I think all the
> > drivers we have can post directly from userspace.
> 
> Oh, interesting.  Is there any chance to deprecate it?  Not having
> to care for the uvers command would really help with some of the
> upcoming changes I have in my mind.

Hmm, we'd need a survey of the userspace side to see if it is rarely
or never...

And we'd have to talk to the soft XXX guys to see if they plan to use
it..

I always like to see cruft go away, especially if it is broken cruft..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
