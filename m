From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 00/10] ODP Fixes and Improvements
Date: Mon,  3 Apr 2017 13:06:30 +0300
Message-ID: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Please find the following patch set from Artemy. This patch set fixes
and extends ODP support.

This patch set has the following steps:

1. Code simplification for all IB drivers.
2. Three fixes to existing ODP code.
3. Adds generic infrastructure for regions consisting of physically
   contiguous chunks of arbitrary order. Utilizing this infrastructure
   added specific treatment to ODP MRs allocated with MAP_HUGETLB.
4. Adds ODP suport to Memory Windows (MW). Memory windows allow the
   application to have more flexible control over access to its memory.
   The operation of associating an MW with an MR is called binding. When
   MW is bound to ODP MR it may cause page fault which should be
   properly handled.

Thanks

Artemy Kovalyov (10):
  IB: Replace ib_umem page_size by page_shift
  IB/mlx5: Fix function updating xlt emergency path
  IB/mlx5: Fix UMR size calculation
  IB/mlx5: Fix implicit MR GC
  IB/mlx5: Decrease verbosity level of ODP errors
  IB/umem: Add contiguous ODP support
  IB/mlx5: Add contiguous ODP support
  IB/umem: Add support to huge ODP
  IB/mlx5: Extract page fault code
  IB/mlx5: Add ODP support to MW

 drivers/infiniband/core/umem.c                 |  17 +-
 drivers/infiniband/core/umem_odp.c             |  81 ++++--
 drivers/infiniband/hw/bnxt_re/ib_verbs.c       |  12 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   4 +-
 drivers/infiniband/hw/cxgb4/mem.c              |   4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c        |   3 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c        |   9 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c        |   3 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      |   7 +-
 drivers/infiniband/hw/mlx4/cq.c                |   2 +-
 drivers/infiniband/hw/mlx4/mr.c                |   6 +-
 drivers/infiniband/hw/mlx4/qp.c                |   2 +-
 drivers/infiniband/hw/mlx4/srq.c               |   2 +-
 drivers/infiniband/hw/mlx5/mem.c               |  13 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |   1 +
 drivers/infiniband/hw/mlx5/mr.c                |   6 +-
 drivers/infiniband/hw/mlx5/odp.c               | 344 +++++++++++++++----------
 drivers/infiniband/hw/mthca/mthca_provider.c   |   5 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |  15 +-
 drivers/infiniband/hw/qedr/verbs.c             |   8 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c |   2 +-
 drivers/infiniband/sw/rdmavt/mr.c              |   8 +-
 drivers/infiniband/sw/rxe/rxe_mr.c             |   8 +-
 include/rdma/ib_umem.h                         |   8 +-
 include/rdma/ib_umem_odp.h                     |   6 +-
 include/rdma/ib_verbs.h                        |   1 +
 27 files changed, 337 insertions(+), 244 deletions(-)

--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
