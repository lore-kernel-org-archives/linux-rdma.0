From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] RDMA: Do not used __packed in uapi headers
Date: Wed, 14 Feb 2018 16:53:58 -0700
Message-ID: <20180214235358.GC16962@ziepe.ca>
References: <20180207234551.GA14373@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180207234551.GA14373-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 07, 2018 at 04:45:51PM -0700, Jason Gunthorpe wrote:
> __packed is not available in linux/types.h, so we cannot use it in
> the uapi headers.
> 
> The construction struct ABC {} __packed; may still compile even if
> __packed is not defined, however it simply creates a variable called
> __packed, and doesn't set the alignment.
> 
> All these uses of packed are on structs that already have aligned
> members.
> 
> While use in hfi may indicate the struct itself is unaligned,
> the use in ocrdma is on a UHW struct which should never be unaligned,
> so just delete it there.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  include/uapi/rdma/hfi/hfi1_user.h | 6 +++---
>  include/uapi/rdma/ocrdma-abi.h    | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
