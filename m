From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH fixes-3.12 00/15] Mellanox mlx5 driver fixes
Date: Mon, 30 Sep 2013 21:36:59 +0300
Message-ID: <CAJZOPZ+cGd_7DyOghyYfNtsF0UGBumCEYxfJ4-VqtW1n1WOiXw@mail.gmail.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 11, 2013 at 4:35 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> This series from Eli and Co contains batch of bug fixes to mlx5 issues we've stumbled
> on during various regression tests. Few other fixes which are more of cleanups and
> enhancements will be sent for-next/3.13 once this series gets into 3.12

> One or two patches need to go into -stable to for 3.11.y, lets do that after
> they spend some time in the 3.12 cycle.

Hi Roland,

So this series has been in the air for whole 20 days && still marked
as new in your patchworks && RC3 is out by now. Can we get at least a
one word comment if this gonna land via your tree into 3.12?

Or.

>
> Eli Cohen (12):
>   IB/mlx5: Fix send work queue size calculation
>   mlx5: Remove checksum on command interface commands
>   IB/mlx5: Decrease memory consumption of mr caches
>   IB/mlx5: Avoid async events on invalid port number
>   mlx5: Keep polling to reclaim pages while any returned
>   mlx5: Fix layout of struct mlx5_init_seg
>   IB/mlx5: Disable atomic operations
>   mlx5: Fix opt param mask for sq err to rts transition
>   IB/mlx5: Fix opt param mask according to firmware spec
>   mlx5: Fix error code translation from firmware to driver
>   IB/mlx5: Fix alignment of reg umr gather buffers
>   IB/mlx5: Ensure proper synchronization accessing memory
>
> Moshe Lazer (2):
>   IB/mlx5: Flush cache workqueue before destroying it
>   IB/mlx5: Fix memory leak in mlx5_ib_create_srq
>
> Sagi Grimberg (1):
>   IB/mlx5: Fix eq names to display nicely in /proc/interrupts
>
>  drivers/infiniband/hw/mlx5/main.c                  |   16 +++--
>  drivers/infiniband/hw/mlx5/mr.c                    |   71 ++++++++---------
>  drivers/infiniband/hw/mlx5/qp.c                    |   80 +++++++------------
>  drivers/infiniband/hw/mlx5/srq.c                   |    4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   28 ++++---
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     |   21 +----
>  .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   16 ++++-
>  include/linux/mlx5/device.h                        |    4 +-
>  include/linux/mlx5/driver.h                        |    6 +-
>  10 files changed, 118 insertions(+), 132 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
