From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 0/7] RDMA core, IPoiB and mlx5 fixes
Date: Sun, 24 Sep 2017 21:46:28 +0300
Message-ID: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch fixes struct name wrongly exposed
in UAPI, number of crashes in various part of infiniband
stack and mlx5 driver.

Thanks

Alex Vesker (1):
  IB/ipoib: Fix inconsistency with free_netdev and free_rdma_netdev

Ilya Lesokhin (2):
  IB/mlx5: Simplify mlx5_ib_cont_pages
  IB/mlx5: Fix NULL deference on mlx5_ib_update_xlt failure

Leon Romanovsky (1):
  IB/core: Fix typo in the name of the tag-matching cap struct

Parav Pandit (2):
  IB/core: Fix qp_sec use after free access
  IB: Correct MR length field to be 64-bit

Shalom Lagziel (1):
  IB/ipoib: Fix sysfs Pkey create<->remove possible deadlock

 drivers/infiniband/core/security.c        |  4 ++-
 drivers/infiniband/core/uverbs_cmd.c      | 14 ++++-----
 drivers/infiniband/hw/mlx5/main.c         | 10 +++----
 drivers/infiniband/hw/mlx5/mem.c          | 47 +++++++++++--------------------
 drivers/infiniband/hw/mlx5/mr.c           | 27 +++++++++++-------
 drivers/infiniband/hw/nes/nes_verbs.c     |  4 +--
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 15 +++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c | 30 ++++++++++++++------
 drivers/infiniband/ulp/iser/iser_memory.c |  2 +-
 include/rdma/ib_verbs.h                   |  6 ++--
 include/uapi/rdma/ib_user_verbs.h         |  2 +-
 net/sunrpc/xprtrdma/frwr_ops.c            |  2 +-
 12 files changed, 90 insertions(+), 73 deletions(-)

--
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
