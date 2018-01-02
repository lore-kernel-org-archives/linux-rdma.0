From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v2 0/7] RDMA resource tracking
Date: Tue,  2 Jan 2018 10:18:25 +0200
Message-ID: <20180102081832.5264-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changelog:
v1->v2:
 * Rebased on latest rdma/for-next
 * Replaced mutex lock which protect linked lists to be RW semaphore.
   It has no impact on current implementation, because there is only one
   reader (nldev) and it is serialized. However better to be prepared
   for multiple readers from the beginning.
 * Added reinitialization next QP entry logic to ensure that it exists
   and didn't vanish during fill_req_qp() work.
v0->v1:
 * Dropped RFC
 * Separated to thre series, one for for-rc, and two for-next.

-------
The original goal of this series was to allow ability to view connection
(QP) information about running processes, however I used this opportunity and
created common infrastructure to track and report various resources. The report
part is implemented in netlink (nldev), but smart ULPs can now create
advanced usage models based on device utilization.

The current implementation relies on one lock per-object per-device, so
creation/destroying of various objects (CQ, PD, e.t.c) on various or the
same devices doesn't interfere each with another.

The data protection is performed with SRCU and its reader-writer model
ensures that resource won't be destroyed till readers will finish their
work.

Possible future work will include:
 * Reducing number of locks in RDMA, because of SRCU.
 * Converting CMA to be based completely on resource tracking.
 * Addition of other objects and extending current to give full
   and detailed state of the RDMA kernel stack.
 * Replacing synchronize_srcu with call_srcu to make destroy flow
   non-blocking.
 * Provide reliable device reset flow, preserving resource creation ordering.

The patches are available in the git repository at:
  git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-next-2018-01-02

	Thanks
---------------------------------------

Leon Romanovsky (7):
  RDMA/restrack: Add general infrastructure to track RDMA resources
  RDMA/core: Add helper function to create named QPs
  RDMA: Annotate create QP callers
  RDMA/core: Add resource tracking for create and destroy CQs
  RDMA/core: Add resource tracking for create and destroy PDs
  RDMA/nldev: Provide global resource utilization
  RDMA/nldev: Provide detailed QP information

 drivers/infiniband/core/Makefile           |   2 +-
 drivers/infiniband/core/cma.c              |   1 +
 drivers/infiniband/core/core_priv.h        |  20 ++
 drivers/infiniband/core/cq.c               |   3 +
 drivers/infiniband/core/device.c           |   7 +
 drivers/infiniband/core/mad.c              |   1 +
 drivers/infiniband/core/nldev.c            | 386 +++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.c         | 178 +++++++++++++
 drivers/infiniband/core/uverbs_cmd.c       |   5 +-
 drivers/infiniband/core/uverbs_std_types.c |   2 +
 drivers/infiniband/core/verbs.c            |   8 +-
 drivers/infiniband/hw/mlx4/mad.c           |   1 +
 drivers/infiniband/hw/mlx4/qp.c            |   1 +
 drivers/infiniband/hw/mlx5/gsi.c           |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c    |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c |   1 +
 drivers/infiniband/ulp/srp/ib_srp.c        |   1 +
 drivers/infiniband/ulp/srpt/ib_srpt.c      |   1 +
 include/rdma/ib_verbs.h                    |  23 +-
 include/rdma/restrack.h                    | 149 +++++++++++
 include/uapi/rdma/rdma_netlink.h           |  54 ++++
 net/smc/smc_ib.c                           |   1 +
 22 files changed, 844 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/core/restrack.c
 create mode 100644 include/rdma/restrack.h

--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
