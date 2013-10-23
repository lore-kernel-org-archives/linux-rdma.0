From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/9] Mellanox mlx5 driver updates for 3.13
Date: Wed, 23 Oct 2013 09:53:12 +0300
Message-ID: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

The following set of patches contains fixes and enhancements to the mlx5 driver
for the 3.13 merge window.

Eli  

Eli Cohen (7):
  IB/mlx5: Fix check of number of entries in create CQ
  IB/mlx5: Multithreaded create mr
  IB/mlx5: Fix overflow check in IB_WR_FAST_REG_MR
  IB/mlx5: Simplify mlx5_ib_destroy_srq
  mlx5: Fix cleanup flow when DMA mapping fails
  mlx5: Support arbitrary page size to firmware
  mlx5: Clear reserved area in set_hca_cap

Moshe Lazer (2):
  IB/mlx5: Fix srq free in destroy qp
  mlx5_core: Change optimal_reclaimed_pages for better performance

 drivers/infiniband/hw/mlx5/cq.c                    |  23 +--
 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   6 +
 drivers/infiniband/hw/mlx5/mr.c                    | 163 +++++++++++++----
 drivers/infiniband/hw/mlx5/qp.c                    |  12 +-
 drivers/infiniband/hw/mlx5/srq.c                   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 106 ++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  35 +++-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |  32 ++--
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 195 +++++++++++++++------
 include/linux/mlx5/device.h                        |   9 +-
 include/linux/mlx5/driver.h                        |  18 +-
 14 files changed, 451 insertions(+), 169 deletions(-)

-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
