From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Add support for active width and speed
 for RoCE
Date: Mon, 24 Apr 2017 12:30:19 -0400
Message-ID: <1493051419.3041.49.camel@redhat.com>
References: <20170420175333.7082-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175333.7082-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-20 at 20:53 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> This series from Noa replaces the current hard-coded active speed
> and width reported for RoCE in the mlx5 driver.
> 
> Two preliminary commits were needed for this change:
> 1. As a part of proper translation of the ib_port_spped enum,
>    the IB_SPEED_HDR enum entry was added.
> 2. Set mlx5_query_roce_port's return value to void, since in case of
>    an error, the properties reported back to the user are zeroed.
> 
> It is based on k.o/for-4.12 branch.
> 
> Thanks,
>   Noa and Leon.
> 
> Noa Osherovich (3):
>   IB/core: Add HDR speed enum
>   IB/mlx5: Set mlx5_query_roce_port's return value to void
>   IB/mlx5: Add support for active_width and active_speed in RoCE
> 
>  drivers/infiniband/core/sysfs.c   |  4 ++
>  drivers/infiniband/hw/mlx5/main.c | 89
> +++++++++++++++++++++++++++++++++------
>  include/rdma/ib_verbs.h           |  3 +-
>  3 files changed, 82 insertions(+), 14 deletions(-)

I fixed up the second patch so it wouldn't break things any more, then
series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
