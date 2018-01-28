From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Sun, 28 Jan 2018 14:05:20 -0700
Message-ID: <20180128210520.GK23869@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180128091725.13103-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 11:17:17AM +0200, Leon Romanovsky wrote:

> The original goal of this series was to allow ability to view connection
> (QP) information about running processes, however I used this opportunity and
> created common infrastructure to track and report various resources. The report
> part is implemented in netlink (nldev), but smart ULPs can now create
> advanced usage models based on device utilization.
> 
> The current implementation relies on one lock per-object per-device, so
> creation/destroying of various objects (CQ, PD, e.t.c) on various or the
> same devices doesn't interfere each with another.
> 
> The data protection is performed with SRCU and its reader-writer model
> ensures that resource won't be destroyed till readers will finish their
> work.

Well, this cover letter isn't quite right anymore.. but no matter.

My small comments aside it looks OK to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
