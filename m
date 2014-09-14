From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/6] minor mlx5 fixes for 3.18
Date: Sun, 14 Sep 2014 16:47:49 +0300
Message-ID: <1410702475-28826-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

the following series of patches contains some trivial fixes. The patches are
rebased on Linus's tree since they refer to mlx5 patches that are not yet on 
your ib-next branch, namely:

4d2f9bb mlx5: Adjust events to use unsigned long param instead of void *
f241e74 mlx5: minor fixes (mainly avoidance of hidden casts)
9603b61 mlx5: Move pci device handling from mlx5_ib to mlx5_core

Eli

Eli Cohen (5):
  IB/mlx5: Clear umr resources after ib_unregister_device
  IB/mlx5: Improve debug prints in mlx5_ib_reg_user_mr
  IB/core: Avoid leakage from kernel to user space
  IB/mlx5: Fix possible array overflow
  IB/mlx5: Remove duplicate code from mlx5_set_path

Yishai Hadas (1):
  IB/mlx5: Modify to work with arbitrary page size

 drivers/infiniband/core/uverbs_main.c |  1 +
 drivers/infiniband/hw/mlx5/main.c     |  8 ++++----
 drivers/infiniband/hw/mlx5/mem.c      | 18 ++++++++++--------
 drivers/infiniband/hw/mlx5/mr.c       |  6 +++---
 drivers/infiniband/hw/mlx5/qp.c       | 21 +++++----------------
 5 files changed, 23 insertions(+), 31 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
