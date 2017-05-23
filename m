From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/4] Add support of NOIO allocations to IPoIB
Date: Tue, 23 May 2017 11:39:49 +0300
Message-ID: <20170523083953.14892-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

These patches adds native support to NOIO allocations during
create QP for IPoIB.

In contrast to the commit 09b93088d750 ("IB: Add a QP creation flag
to use GFP_NOIO allocations"), which added specific QP create flag,
this series uses standard memalloc_noio_* calls to mark GFP_NOIO
for all allocations paths below.

This change allows to all drivers benefit from this facitlity
and not only mlx4 and qib. As a nice outcome, there is a lot
simplification in the mlx4 and qib drivers by removing need to
carry GFP flags.

Thanks

Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Leon Romanovsky (4):
  IB/IPoIB: Convert IPoIB to memalloc_noio_* calls
  IB/{rdmavt, qib}: Remove gfp flags argument
  {net, IB}/mlx4: Remove gfp flags argument
  IB/core: Remove NOIO QP create flag

 drivers/infiniband/hw/mlx4/cq.c                    |  6 +--
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  1 -
 drivers/infiniband/hw/mlx4/qp.c                    | 40 ++++++++----------
 drivers/infiniband/hw/mlx4/srq.c                   |  8 ++--
 drivers/infiniband/hw/qib/qib_qp.c                 | 15 ++++---
 drivers/infiniband/hw/qib/qib_verbs.h              |  4 +-
 drivers/infiniband/sw/rdmavt/qp.c                  | 48 ++++++----------------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c            | 16 ++++----
 drivers/net/ethernet/mellanox/mlx4/alloc.c         | 29 +++++++------
 drivers/net/ethernet/mellanox/mlx4/cq.c            |  4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  6 +--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c           |  7 ++--
 drivers/net/ethernet/mellanox/mlx4/icm.h           |  3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            | 17 ++++----
 drivers/net/ethernet/mellanox/mlx4/qp.c            | 20 ++++-----
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |  4 +-
 include/linux/mlx4/device.h                        | 10 ++---
 include/rdma/ib_verbs.h                            |  2 +-
 include/rdma/rdma_vt.h                             |  5 +--
 22 files changed, 108 insertions(+), 147 deletions(-)

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
