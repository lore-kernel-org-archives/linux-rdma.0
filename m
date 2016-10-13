From: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 08/32] iwpmd: use proper ANSI-C prototypes for
        functions without arguments
Date: Thu, 13 Oct 2016 20:25:17 +0200
Message-ID: <20161013182517.GA28384@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de> <1476381095-20041-9-git-send-email-hch@lst.de> <01c201d2257c$83313be0$8993b3a0$@opengridcomputing.com> <20161013180959.GA28057@lst.de> <20161013182420.GA18755@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161013182420.GA18755-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2016 at 12:24:20PM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 13, 2016 at 08:09:59PM +0200, 'Christoph Hellwig' wrote:
> > On Thu, Oct 13, 2016 at 01:06:25PM -0500, Steve Wise wrote:
> > > Is this fixing some warning?
> > 
> > Yes, this fixes warnings when running the code through sparse:
> > 
> > ../iwpmd/iwarp_pm_common.c:215:27: warning: non-ANSI function declaration of
> > function 'create_netlink_socket'
> 
> Once these are all fixed, lets turn on -Wstrict-prototypes for gcc?

Those are fixed with my full series.  Which you won't see for now
as the mail server crapped out after the first 15, so I'll let people
review and merge that batch before spamming the list again.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
