From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next] IB/hfi1: Convert kzalloc_node and kcalloc to
 use kcalloc_node
Date: Thu, 1 Feb 2018 15:52:59 -0700
Message-ID: <20180201225259.GJ8590@ziepe.ca>
References: <20180201203727.13590.84553.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201203727.13590.84553.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 12:37:30PM -0800, Dennis Dalessandro wrote:
> From: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Kzalloc_node API doesn't check for overflows in size multiplication.
> While kcalloc API check for overflows in size multiplication
> but these implementations are not NUMA-aware.
> 
> This conversion allowed for correcting an allocation used in the hot
> path to be on the local NUMA and ensure us overflow free multiplication
> for the size of a memory allocation.
> 
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kamenee Arumugam <kamenee.arumugam-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  drivers/infiniband/hw/hfi1/init.c |   17 +++++++++--------
>  drivers/infiniband/hw/hfi1/pio.c  |   15 ++++++++-------
>  drivers/infiniband/hw/hfi1/sdma.c |    3 ++-
>  3 files changed, 19 insertions(+), 16 deletions(-)

Applied to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
