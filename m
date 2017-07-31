From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [pull request][rdma-rc 00/14] RDMA fixes for-4.13
Date: Mon, 31 Jul 2017 10:09:10 +0300
Message-ID: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following changes since commit 5dc78ad1904db597bdb4427f3ead437aae86f54c:

  IB/ipoib: Notify on modify QP failure only when relevant (2017-07-23 10:52:00 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-07-31

for you to fetch changes up to 38a974d578451dbbde0c40fc2d81fba44027a338:

  IB/uverbs: Fix device cleanup (2017-07-30 10:43:15 +0300)

----------------------------------------------------------------
RDMA fixes for 4.13

This is cleanup series to various static checkers errors along with two
major kernel panics fixes from from Parav and Yishai.

----------------------------------------------------------------
Leon Romanovsky (12):
      RDMA/(core,ulp): Convert register/unregister event handler to be void
      RDMA/core: Cleanup device capability enum
      RDMA/core: Remove unimplemented node_types and node transport
      RDMA/core: Delete BUG() from unreachable flow
      RDMA/core: Refactor get link layer wrapper
      RDMA/uverbs: Prevent leak of reserved field
      RDMA/mlx4: Avoid potential derefence warning
      RDMA/mlx4: Remove gfp_mask argument from acquire_group call
      RDMA/mlx5: Fix existence check for extended address vector
      RDMA/bnxt_re: Delete unsupported modify_port function
      RDMA/usnic: Fix remove address space warning
      RDMA/mthca: Make explicit conversion to 64bit value

Parav Pandit (1):
      IB/core: Fix race condition in resolving IP to MAC

Yishai Hadas (1):
      IB/uverbs: Fix device cleanup

 drivers/infiniband/core/addr.c                  | 62 +++++++++++++++++++------
 drivers/infiniband/core/cache.c                 | 23 ++++-----
 drivers/infiniband/core/device.c                |  8 +---
 drivers/infiniband/core/sa_query.c              |  3 +-
 drivers/infiniband/core/sysfs.c                 |  3 --
 drivers/infiniband/core/uverbs_cmd.c            |  2 +-
 drivers/infiniband/core/uverbs_main.c           | 16 +------
 drivers/infiniband/core/verbs.c                 | 32 ++++---------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c        | 17 -------
 drivers/infiniband/hw/bnxt_re/ib_verbs.h        |  3 --
 drivers/infiniband/hw/bnxt_re/main.c            |  1 -
 drivers/infiniband/hw/mlx4/mcg.c                | 11 ++---
 drivers/infiniband/hw/mlx5/odp.c                |  2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c         |  2 +-
 drivers/infiniband/hw/usnic/usnic_fwd.c         | 12 +----
 drivers/infiniband/hw/usnic/usnic_fwd.h         |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c     | 10 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c       | 10 +---
 drivers/infiniband/ulp/iser/iser_verbs.c        |  6 +--
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  7 +--
 drivers/infiniband/ulp/srpt/ib_srpt.c           |  5 +-
 include/linux/mlx5/qp.h                         |  1 -
 include/rdma/ib_verbs.h                         | 26 +++++------
 23 files changed, 105 insertions(+), 159 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
