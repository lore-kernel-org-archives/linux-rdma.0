From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/6] mlx5 and mlx4 drivers updates and fixes for 3.13
Date: Thu, 31 Oct 2013 15:26:30 +0200
Message-ID: <1383225996-14828-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here are some some fixes to mlx4 and mlx5 driver for the 3.13 merge window.

Thanks,
Eli

Eli Cohen (6):
  IB/mlx5: Remove dead code
  IB/core: Encorce MR access rights rules on kernel consumers
  IB/mlx5: Fix list_del of empty list
  IB/mlx4: Fix device max capabilities check
  IB/mlx4: Fix endless loop in resize CQ
  IB/mlx5: Fix page shift in create CQ for userspace

 drivers/infiniband/core/uverbs_cmd.c                | 10 +++-------
 drivers/infiniband/core/verbs.c                     | 14 ++++++++++++++
 drivers/infiniband/hw/mlx4/cq.c                     |  9 +++++++--
 drivers/infiniband/hw/mlx5/cq.c                     |  2 +-
 drivers/infiniband/hw/mlx5/mr.c                     |  5 -----
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c |  3 ++-
 include/rdma/ib_verbs.h                             | 13 +++++++++++++
 7 files changed, 40 insertions(+), 16 deletions(-)

-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
