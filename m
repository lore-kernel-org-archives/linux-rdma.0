From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 00/12] First round of mlx5 fixes for 4.9
Date: Thu, 27 Oct 2016 16:36:35 +0300
Message-ID: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find below first round of fixes and improvements to ConnectX-4/Connect-IB device driver.

This patchset was generated against v4.9-rc1.

Available in the "topic/mlx5-fixes-4.9" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/mlx5-fixes-4.9

Thanks

Daniel Jurgens (1):
  IB/mlx5: Use cache line size to select CQE stride

Eli Cohen (4):
  IB/mlx5: Wait for all async command completions to complete
  IB/mlx5: Fix fatal error dispatching
  IB/mlx5: Fix reported max SGE calculation
  IB/mlx5: Fix NULL pointer dereference on debug print

Majd Dibbiny (2):
  IB/mlx5: Fix memory leak in query device
  IB/mlx5: Limit mkey page size to 2GB

Maor Gottlieb (3):
  IB/mlx5: Fix atomic cap in indirect UMR
  IB/mlx5: Put non zero value in max_ah
  IB/mlx5: Validate requested RQT size

Max Gurtovoy (1):
  IB/mlx5: Replace numerical constant with predefined MACRO

Moshe Lazer (1):
  IB/mlx5: Resolve soft lock on massive reg MRs

 drivers/infiniband/hw/mlx5/cq.c      |  7 ++---
 drivers/infiniband/hw/mlx5/main.c    | 20 +++++++-----
 drivers/infiniband/hw/mlx5/mem.c     |  7 ++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  8 ++++-
 drivers/infiniband/hw/mlx5/mr.c      | 37 ++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/qp.c      | 59 +++++++++++++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/srq.c     |  2 +-
 7 files changed, 113 insertions(+), 27 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
