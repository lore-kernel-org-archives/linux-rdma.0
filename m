From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/3] Add const to various core functions
Date: Sun, 31 May 2015 17:15:28 -0400
Message-ID: <1433106931-5215-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to support some of Jason's comments to add const to the functions I am
adding for OPA the following patches clean up the call trees of the currently
defined functions.

They stand on their own as clean up patches.  Therefore, I am submitting them
separately from the OPA patches.

---
Changes from V1:
	Clean up 0-day build
	Clean up commit messages

Ira Weiny (3):
  IB/core cleanup: Add const to RDMA helpers
  IB/core cleanup: Add const on args - device->process_mad
  IB/core cleanup: Add const to args - agent_send_response

 drivers/infiniband/core/addr.c                |    4 +-
 drivers/infiniband/core/agent.c               |    8 ++--
 drivers/infiniband/core/agent.h               |    4 +-
 drivers/infiniband/core/cache.c               |    8 ++--
 drivers/infiniband/core/verbs.c               |    9 +++--
 drivers/infiniband/hw/amso1100/c2_provider.c  |    6 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |    6 ++--
 drivers/infiniband/hw/cxgb4/provider.c        |    5 ++-
 drivers/infiniband/hw/ehca/ehca_iverbs.h      |    4 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c         |   14 ++++----
 drivers/infiniband/hw/ipath/ipath_mad.c       |    8 ++--
 drivers/infiniband/hw/ipath/ipath_verbs.h     |    6 ++--
 drivers/infiniband/hw/mlx4/mad.c              |   21 +++++++------
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |    8 ++--
 drivers/infiniband/hw/mlx5/mad.c              |    8 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |    8 ++--
 drivers/infiniband/hw/mthca/mthca_cmd.c       |    4 +-
 drivers/infiniband/hw/mthca/mthca_cmd.h       |    4 +-
 drivers/infiniband/hw/mthca/mthca_dev.h       |    6 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c       |   10 +++---
 drivers/infiniband/hw/nes/nes_verbs.c         |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |    6 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |    6 ++--
 drivers/infiniband/hw/qib/qib_mad.c           |   10 +++---
 drivers/infiniband/hw/qib/qib_verbs.h         |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/mad.c |    2 +-
 include/linux/mlx5/driver.h                   |    2 +-
 include/rdma/ib_addr.h                        |    6 ++--
 include/rdma/ib_cache.h                       |    8 ++--
 include/rdma/ib_verbs.h                       |   39 +++++++++++++------------
 30 files changed, 121 insertions(+), 117 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
