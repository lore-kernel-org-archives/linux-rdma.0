From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] RDMA: Move enum ib_cq_creation_flags to uapi headers
Date: Mon, 29 Jan 2018 13:00:04 -0700
Message-ID: <20180129200004.GB7599@ziepe.ca>
References: <20180126221646.GA5251@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180126221646.GA5251-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 26, 2018 at 03:16:46PM -0700, Jason Gunthorpe wrote:
> The flags field the enum is used with comes directly from the uapi
> so it belongs in the uapi headers for clarity and so userspace can
> use it.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  drivers/infiniband/hw/mlx4/cq.c      | 4 ++--
>  drivers/infiniband/hw/mlx5/cq.c      | 2 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 ++--
>  include/rdma/ib_verbs.h              | 5 -----
>  include/uapi/rdma/ib_user_verbs.h    | 7 ++++++-
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> This is the last copied enum in libibverbs's kern-abi.h

Applied to for-next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
