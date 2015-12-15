From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 6/6] IB/mlx5: Add Raw Packet Queue Pair (QP)
 support
Date: Tue, 15 Dec 2015 16:37:17 +0200
Message-ID: <5670259D.3080801@mellanox.com>
References: <1449778184-10618-1-git-send-email-majd@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449778184-10618-1-git-send-email-majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/10/2015 10:09 PM, Majd Dibbiny wrote:
> This patchs adds support for Raw Packet QP for the mlx5 device.
>
> Raw Packet QP, unlike other QP types, has no matching mlx5_core_qp
> object but rather it is built of RQ/SQ/TIR/TIS/TD mlx5_core object.
>
> The Raw Packet QP state changes are implemented by changing the
> state of the sub-objects.
>
> Since the SQ and RQ work-queue (WQ) buffers are not contiguous like
> other QPs, we allocate separate buffers in the user-space and pass
> the address of each one of them separately to the kernel.
>
> Signed-off-by: Majd Dibbiny<majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/hw/mlx5/main.c                  |  15 +-
>   drivers/infiniband/hw/mlx5/mlx5_ib.h               |  52 +-
>   drivers/infiniband/hw/mlx5/qp.c                    | 894 ++++++++++++++++++---
>   drivers/infiniband/hw/mlx5/user.h                  |   1 +
>   drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  48 +-
>   drivers/net/ethernet/mellanox/mlx5/core/transobj.c |  39 +
>   include/linux/mlx5/mlx5_ifc.h                      |  11 +-
>   include/linux/mlx5/qp.h                            |   3 +-
>   include/linux/mlx5/transobj.h                      |   4 +
>   9 files changed, 913 insertions(+), 154 deletions(-)

Seems way too big for single patch, seek how to split to 2-3 patches

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
