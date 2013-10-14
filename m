From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] please pull infiniband.git
Date: Mon, 14 Oct 2013 11:16:15 -0700
Message-ID: <1381774575-8817-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git tags/rdma-for-linus

----------------------------------------------------------------

Last batch of IB changes for 3.12: many mlx5 hardware driver fixes plus
one trivial semicolon cleanup.

----------------------------------------------------------------
Eli Cohen (12):
      IB/mlx5: Fix send work queue size calculation
      mlx5: Remove checksum on command interface commands
      IB/mlx5: Decrease memory consumption of mr caches
      IB/mlx5: Avoid async events on invalid port number
      mlx5: Keep polling to reclaim pages while any returned
      mlx5: Fix layout of struct mlx5_init_seg
      IB/mlx5: Disable atomic operations
      mlx5: Fix opt param mask for sq err to rts transition
      IB/mlx5: Fix opt param mask according to firmware spec
      mlx5: Fix error code translation from firmware to driver
      IB/mlx5: Fix alignment of reg umr gather buffers
      IB/mlx5: Ensure proper synchronization accessing memory

Joe Perches (1):
      IB: Remove unnecessary semicolons

Moshe Lazer (2):
      IB/mlx5: Flush cache workqueue before destroying it
      IB/mlx5: Fix memory leak in mlx5_ib_create_srq

Roland Dreier (1):
      Merge branch 'misc' into for-next

Sagi Grimberg (1):
      IB/mlx5: Fix eq names to display nicely in /proc/interrupts

 drivers/infiniband/hw/amso1100/c2_ae.c             |  2 +-
 drivers/infiniband/hw/mlx5/main.c                  | 16 +++--
 drivers/infiniband/hw/mlx5/mr.c                    | 70 +++++++++----------
 drivers/infiniband/hw/mlx5/qp.c                    | 80 ++++++++--------------
 drivers/infiniband/hw/mlx5/srq.c                   |  4 +-
 drivers/infiniband/hw/mthca/mthca_eq.c             |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c           |  6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  6 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 28 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 21 ++----
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 16 ++++-
 include/linux/mlx5/device.h                        |  4 +-
 include/linux/mlx5/driver.h                        |  6 +-
 15 files changed, 126 insertions(+), 141 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
