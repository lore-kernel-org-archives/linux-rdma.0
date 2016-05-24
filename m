From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 09/10] IB/hfi1: Do not free hfi1 cdev parent structure
 early
Date: Tue, 24 May 2016 15:51:05 -0600
Message-ID: <20160524215105.GD7950@obsidianresearch.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122642.22041.66203.stgit@scvm10.sc.intel.com>
 <20160519183100.GC26130@obsidianresearch.com>
 <20160524141756.GA17438@phlsvsds.ph.intel.com>
 <20160524172054.GC8037@obsidianresearch.com>
 <20160524193955.GA17130@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160524193955.GA17130-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 03:39:56PM -0400, Dennis Dalessandro wrote:

> >Yes, but there are clearly more problems.
> 
> We may need other fixes I'll give you that, but is there a reason not to
> apply this particular patch?

Nope, none at all, but my questions are all on the same topic - that
the cdev removal vs device removal is not robust.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
