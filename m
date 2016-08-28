From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/9] RDMA fixes for 4.8
Date: Sun, 28 Aug 2016 10:58:29 +0300
Message-ID: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This is compilation of fixes to RDMA core, IPoIB, Mellanox mlx4
and mlx5 drivers all together. Most of the fixes are one liners and
for easy handling, I'm sending them in one patchset.

Thanks

Chuck Lever (1):
  IB/mlx5: Return EINVAL when caller specifies too many SGEs

Erez Shitrit (2):
  IB/core: Fix use after free in send_leave function
  IB/ipoib: Fix memory corruption during ipoib cm connection
    establishment

Leon Romanovsky (5):
  Revert "IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one"
  IB/mlx4: Don't return errors from poll_cq
  IB/mlx5: Simplify code by removing return variable
  IB/mlx5: Add VERBOSITY Kconfig option
  IB/mlx5: Don't return errors from poll_cq

Yishai Hadas (1):
  IB/mlx5: Use TIR number based on selector

 drivers/infiniband/core/multicast.c       | 13 ++-----------
 drivers/infiniband/hw/mlx4/cq.c           | 26 ++------------------------
 drivers/infiniband/hw/mlx5/Kconfig        |  6 ++++++
 drivers/infiniband/hw/mlx5/cq.c           | 22 ++--------------------
 drivers/infiniband/hw/mlx5/main.c         |  6 +++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
 drivers/infiniband/hw/mlx5/qp.c           | 15 ++++++---------
 drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 16 ++++++++++++++++
 drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
 10 files changed, 42 insertions(+), 66 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
