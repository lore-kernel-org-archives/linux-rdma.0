From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 00/14] Patch set for 3.14
Date: Tue, 14 Jan 2014 17:45:09 +0200
Message-ID: <1389714323-20130-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This is mlx5 update for 3.14, it includes fixes and small features
(implementation for the cq modify and resize verbs). The patches contain
changes to both mlx5_ib and mlx5_core but for the sake of simplicity I am
sending you all of them.

Thanks,
Eli

Dan Carpenter (1):
  mlx5_core: Remove dead code

Eli Cohen (12):
  IB/mlx5: Remove unused coded in mr.c
  IB/mlx5: Fix micro UAR allocator
  IB/mlx5: Clear out struct before create QP command
  net/mlx5_core: Use mlx5 core style warning
  IB/mlx5: Make sure doorbell record is visible before doorbell
  IB/mlx5: Implement modify CQ
  IB/mlx5: Add support for resize CQ
  net/mlx5_core: Improve debugfs readability
  mlx5_core: Fix PowerPC support
  IB/mlx5: Allow creation of QPs with zero length work queues
  IB/mlx5: Abort driver cleanup if teardown hca fails
  IB/mlx5: Remove old field for create mkey mailbox

Haggai Eran (1):
  net/mlx5_core: Fix out arg size in access_register command

 drivers/infiniband/hw/mlx5/cq.c                    | 306 +++++++++++++++++++--
 drivers/infiniband/hw/mlx5/main.c                  |  13 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   4 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   1 -
 drivers/infiniband/hw/mlx5/qp.c                    | 130 ++++++---
 drivers/infiniband/hw/mlx5/user.h                  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  39 ++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  10 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |   5 +-
 include/linux/mlx5/cq.h                            |  18 +-
 include/linux/mlx5/device.h                        |  31 ++-
 include/linux/mlx5/qp.h                            |  45 +++
 15 files changed, 542 insertions(+), 95 deletions(-)

-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
