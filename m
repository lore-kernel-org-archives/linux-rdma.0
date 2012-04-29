From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/7] IB: initial batch of patches for 3.5
Date: Sun, 29 Apr 2012 17:04:20 +0300
Message-ID: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

This is an initial batch having seven patches - the first four are just pile
of fixes 1/7 to iser, 2/7 to the IB core, 3/7 to mlx4_core and 4/7 to mlx4_ib.

[PATCH for-next 1/7] IB/iser: Fix buggy error flow in iser ep connection establishment
[PATCH for-next 2/7] IB/core: enhance the qp use counter to track multicast attach/detach
[PATCH for-next 3/7] net/mlx4_core: change bitmap allocator to work in round-robin fashion
[PATCH for-next 4/7] IB/mlx4: put priority bits in WQE of IBoE MLX QP

the last three patches come from a work done now by Shlomo to add TSS/RSS support
to IPoIB, these are just three patches which needed as pre-step for RSS/TSS

[PATCH for-next 5/7] net/mlx4: add new cap flags field to track more capabilities
[PATCH for-next 6/7] IB/mlx4: replace KERN_yyy printk call with pr_yyy ones
[PATCH for-next 7/7] IB/mlx4: increase the number of vectors (EQs) available for ULPs

Jack Morgenstein (1):
  net/mlx4_core: change bitmap allocator to work in round-robin fashion

Or Gerlitz (2):
  IB/iser: Fix buggy error flow in iser ep connection establishment
  IB/core: enhance the qp use counter to track multicast attach/detach

Oren Duer (1):
  IB/mlx4: put priority bits in WQE of IBoE MLX QP

Shlomo Pongratz (3):
  net/mlx4: add new cap flags field to track more capabilities
  IB/mlx4: replace KERN_yyy printk call with pr_yyy ones
  IB/mlx4: increase the number of vectors (EQs) available for ULPs

 drivers/infiniband/core/verbs.c            |   14 ++++-
 drivers/infiniband/hw/mlx4/cq.c            |   13 ++--
 drivers/infiniband/hw/mlx4/main.c          |   97 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h       |    2 +
 drivers/infiniband/hw/mlx4/mr.c            |    2 +-
 drivers/infiniband/hw/mlx4/qp.c            |   18 +++---
 drivers/infiniband/hw/mlx4/srq.c           |    2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c   |    5 +-
 drivers/infiniband/ulp/iser/iser_verbs.c   |    3 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c |    1 -
 drivers/net/ethernet/mellanox/mlx4/fw.c    |   29 ++++++++
 drivers/net/ethernet/mellanox/mlx4/fw.h    |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c  |    2 +
 include/linux/mlx4/device.h                |    8 ++
 include/linux/mlx4/qp.h                    |    3 +-
 include/rdma/ib_verbs.h                    |    2 +-
 16 files changed, 172 insertions(+), 31 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
