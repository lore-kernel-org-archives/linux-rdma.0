From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-next v3 00/24] RDMA core, drivers and IPoIB fixes
Date: Thu, 17 Aug 2017 15:50:31 +0300
Message-ID: <20170817125055.31424-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

This is bunch of fixes to the RDMA stack which we found during code review,
static checkers cleanups and by various code inspections.

There is one exception to this batch - patch from Feras to add
statistics support to SRIOV VF in IPoIB.

However, the diff stat of that change is so small and I didn't find
other batch to attach it.
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

Thanks

Changelog
v2->v3:
 * Dropped node_type removal patch
 * Dropped following pull request with cleanups and UAPI changes and
   integrate two leftover patches into this pull request.
v1->v2:
 * Dropped patch to remove empty gid function from hns, till proper
   solution will be found.
 * Added two new patches to rxe and mlx5 - add static annotation.

v0->v1:
 * Patch 20: Reused memchr_inv function instead of open-coded variant
 * Added Dennis's ROB tags

----------------------------------------------------------------
The following changes since commit 3e5f0881f17525e3b49835947a5e0cf2d681b1e2:

  IB/hns: Avoid compile test under non 64bit environments (2017-08-14 11:16:53 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2017-08-17

for you to fetch changes up to e2456daaf8b627e9b3a93115bd2366dfce9347fb:

  RDMA/nes: Remove zeroed parameter from port query callback (2017-08-17 10:55:29 +0300)

Erez Shitrit (1):
      IB/ipoib: Sync between remove_one to sysfs calls that use rtnl_lock

Feras Daoud (1):
      IB/ipoib: Add get statistics support to SRIOV VF

Guy Levi (4):
      IB/mlx4: Fix RSS QP type in creation verb
      IB/mlx4: Fix struct mlx4_ib_create_wq alignment
      IB/mlx4: Remove redundant attribute in mlx4_ib_create_qp_rss struct
      IB/mlx4: Check that reserved fields in mlx4_ib_create_qp_rss are zero

Kamal Heib (1):
      IB/rxe: Make rxe_counter_name static

Leon Romanovsky (12):
      IB/cma: Fix erroneous validation of supported default GID type
      RDMA/mlx4: Don't use uninitialized variable
      RDMA/(core,ulp): Convert register/unregister event handler to be void
      RDMA/core: Cleanup device capability enum
      RDMA/core: Delete BUG() from unreachable flow
      RDMA/core: Refactor get link layer wrapper
      RDMA/mlx4: Remove gfp_mask argument from acquire_group call
      RDMA/usnic: Fix remove address space warning
      RDMA/mthca: Make explicit conversion to 64bit value
      RDMA/mlx5: Limit scope of get vector affinity local function
      RDMA/mlx4: Properly annotate link layer variable
      RDMA/nes: Remove zeroed parameter from port query callback

Maor Gottlieb (2):
      RDMA/mlx4: Fix create qp command alignment
      IB/mlx5: Add necessary delay drop assignment

Parav Pandit (1):
      IB/uverbs: Introduce and use helper functions to copy ah attributes

Talat Batheesh (2):
      IB/mlx4: Fix some spelling mistakes
      IB/mlx5: Fix some spelling mistakes

 drivers/infiniband/core/cache.c                 |  23 ++---
 drivers/infiniband/core/cma.c                   |   4 +-
 drivers/infiniband/core/device.c                |   8 +-
 drivers/infiniband/core/sa_query.c              |   3 +-
 drivers/infiniband/core/uverbs_cmd.c            | 124 ++++++++++--------------
 drivers/infiniband/core/uverbs_main.c           |  13 +--
 drivers/infiniband/core/verbs.c                 |  34 +++----
 drivers/infiniband/hw/mlx4/alias_GUID.c         |   2 +-
 drivers/infiniband/hw/mlx4/cq.c                 |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c                |   9 +-
 drivers/infiniband/hw/mlx4/qp.c                 |  22 ++---
 drivers/infiniband/hw/mlx5/cq.c                 |   2 +-
 drivers/infiniband/hw/mlx5/mad.c                |   2 +-
 drivers/infiniband/hw/mlx5/main.c               |   6 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c         |   2 +-
 drivers/infiniband/hw/nes/nes_verbs.c           |   5 -
 drivers/infiniband/hw/usnic/usnic_fwd.c         |  12 +--
 drivers/infiniband/hw/usnic/usnic_fwd.h         |   2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c     |  10 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c     |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib.h            |   1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |   8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |  16 ++-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c       |  22 ++++-
 drivers/infiniband/ulp/iser/iser_verbs.c        |   6 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |   7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c           |   5 +-
 include/rdma/ib_verbs.h                         |  10 +-
 include/uapi/rdma/mlx4-abi.h                    |   6 +-
 29 files changed, 154 insertions(+), 214 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
