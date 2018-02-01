From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 0/6] IB/hfi1: Performance improvements for 4.16
Date: Thu, 1 Feb 2018 15:50:56 -0700
Message-ID: <20180201225056.GE8590@ziepe.ca>
References: <20180201184446.5918.46068.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201184446.5918.46068.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 10:45:58AM -0800, Dennis Dalessandro wrote:
> Hi Jason and Doug,
> 
> Here are a few patches that provide performance optimizations in our driver.
> 
> This is a resubmit of my previous patch set [1] broken up into smaller logically
> grouped patch sets.
> 
> As always my GitHub had these in-tree for context:
> https://github.com/ddalessa/kernel/tree/for-4.16
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg60011.html
> 
> 
> Mitko Haralanov (1):
>       IB/hfi1: Remove dependence on qp->s_hdrwords
> 
> Sebastian Sanchez (5):
>       IB/hfi1: Compute BTH only for RDMA_WRITE_LAST/SEND_LAST packet
>       IB/hfi1: Optimize packet type comparison using 9B and bypass code paths
>       IB/hfi1: Look up ibport using a pointer in receive path
>       IB/hfi1: Remove unnecessary fecn and becn fields
>       IB/hfi1: Optimize process_receive_ib()

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
