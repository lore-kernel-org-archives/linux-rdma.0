From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/hfi1: Fix race conditions and memory
 leaks
Date: Thu, 1 Feb 2018 15:50:41 -0700
Message-ID: <20180201225041.GD8590@ziepe.ca>
References: <20180201184229.5205.6194.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201184229.5205.6194.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Patel Jay P <jay.p.patel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 10:43:32AM -0800, Dennis Dalessandro wrote:
> Hi Jason and Doug,
> 
> Here are some fixes for race conditions and memory leaks including the fix for
> the interrupt race [1].
> 
> This is a resubmit of my previous patch set [2] broken up into smaller logically
> grouped patch sets.
> 
> As always my GitHub had these in-tree for context:
> https://github.com/ddalessa/kernel/tree/for-4.16
> 
> [1] https://marc.info/?l=linux-rdma&m=151394843919393&w=2
> 
> [2] https://www.spinics.net/lists/linux-rdma/msg60011.html
> 
> 
> Alex Estrin (2):
>       IB/hfi1: Fix for early release of sdma context
>       IB/hfi1: Fix for potential refcount leak in hfi1_open_file()
> 
> Michael J. Ruhl (1):
>       IB/hfi1: Re-order IRQ cleanup to address driver cleanup race

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
