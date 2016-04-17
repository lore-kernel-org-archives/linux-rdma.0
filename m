From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] IB/mlx5: Use tasklet to decrease completions processing time in interrupts
Date: Sun, 17 Apr 2016 17:08:39 +0300
Message-ID: <1460902121-5567-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

The mlx5 driver handles completion callbacks inside interrupts.
These callbacks could be lengthy and thus cause hard lockups.
In order to avoid these lockups, we introduce a tasklet mechanism.
The mlx5_ib driver uses this mechanism in order to defer its
completion callbacks processing to the tasklet.

This follows the same mechanism we implemented for mlx4 that
successfully decreased the processing time in interrupts.

Regards,
Matan

Matan Barak (2):
  net/mlx5_core: Use tasklet for user-space CQ completion events
  IB/mlx5: Fire the CQ completion handler from tasklet

 drivers/infiniband/hw/mlx5/cq.c                    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       | 59 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 12 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 17 +++++++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +
 include/linux/mlx5/cq.h                            |  5 ++
 include/linux/mlx5/driver.h                        | 10 ++++
 7 files changed, 108 insertions(+), 2 deletions(-)

-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
