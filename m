From: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Fri, 12 Jan 2018 08:15:24 -0600
Message-ID: <20180112141524.GA16256@ctung-MOBL3.amr.corp.intel.com>
References: <20180112055842.23125-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> Hi,
> 
> There is small set of fixes targeted for rdma-rc.

For RC?  Are these fixing regressions?  We are already in RC7.

Doug/Jason,

What's your policy on taking fixes late in RC cycle that may/may not be fixing regressions?

Chien

> 
> Thanks
> 
> Bodong Wang (1):
>   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary
> 
> Jack Morgenstein (1):
>   IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH
>     ports
> 
> Leon Romanovsky (1):
>   RDMA/mlx5: Fix out-of-bound access while querying AH
> 
> Parav Pandit (1):
>   RDMA/core: Fix avoid decoding iWarp port as RoCE
> 
>  drivers/infiniband/hw/mlx4/main.c       | 13 +++++--------
>  drivers/infiniband/hw/mlx5/qp.c         |  7 +++----
>  drivers/net/ethernet/mellanox/mlx4/qp.c |  3 +++
>  include/rdma/ib_verbs.h                 |  5 ++---
>  4 files changed, 13 insertions(+), 15 deletions(-)
> 
> --
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
