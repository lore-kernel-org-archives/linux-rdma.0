From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Thu, 5 May 2016 16:06:16 +0200
Message-ID: <20160505140616.GA15000@lst.de>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com> <20160503093307.GL19931@lst.de> <572A8975.9060606@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <572A8975.9060606-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 04:44:53PM -0700, Bart Van Assche wrote:
> > FYI, even with this patch I see tons of errors like:
> > 
> > [ 2237.161106] scsi host7: ib_srp: Failed to map data (-12)
> 
> Hello Christoph,
> 
> The patch below makes these messages disappear on my setup. Are
> you OK with including this change in patch 11/11?

Looks fine to me.

Btw, while we're at it - any chance you could move the fixes before
the cleanups in the series so that they are more easily backportabke to
-stable?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
