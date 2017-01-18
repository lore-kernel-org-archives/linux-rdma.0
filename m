From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/7] mlx5 fixes for 4.11
Date: Wed, 18 Jan 2017 14:10:29 +0200
Message-ID: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below seven fixes to mlx5 driver.

This patchset was generated against commit
f502d834950a ("net/mlx5: Activate support for 4K UARs") and it applies
cleanly on k.o/for-4.11 branch.

Available in the "topic/mlx5-fixes-4.11" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx5-fixes-4.11

Kamal Heib (1):
  IB/mlx5: Verify that Q counters are supported

Leon Romanovsky (3):
  IB/mlx5: Fix out-of-bound access
  IB/mlx5: Return error for unsupported signature type
  IB/mlx5: Remove deprecated module parameter

Majd Dibbiny (1):
  IB/mlx5: Assign DSCP for R-RoCE QPs Address Path

Maor Gottlieb (2):
  IB/mlx5: Add additional checks before processing MADs
  IB/mlx5: Avoid SMP MADs from VFs

 drivers/infiniband/hw/mlx5/mad.c     | 12 ++++++
 drivers/infiniband/hw/mlx5/main.c    | 75 ++++++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 +
 drivers/infiniband/hw/mlx5/qp.c      | 18 ++++++++-
 drivers/infiniband/hw/mlx5/srq.c     | 11 ++----
 include/linux/mlx5/driver.h          |  1 +
 6 files changed, 97 insertions(+), 22 deletions(-)

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
