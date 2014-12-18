From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/14] ocrdma bug fixes
Date: Thu, 18 Dec 2014 14:12:54 +0530
Message-ID: <0ebadf84-dbcd-402a-b968-e4d0229d82ec@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series introduces following changes:
a. Bug fixes for ocrdma driver.
b. Move PD allocation to ocrdma driver.
c. Add support for interrupt moderation.
d. IB stack compliant port stats.
e. Dbugfs enhancements for ocrdma stats.
f. Code clean-up

Devesh Sharma (4):
  RDMA/ocrdma: Report correct count of interrupt vectors while
    registering ocrdma device.
  RDMA/ocrdma: Discontinue support of RDMA-READ-WITH-INVALIDATE
  RDMA/ocrdma: Honor return value of ocrdma_resolve_dmac.
  RDMA/ocrdma: set vlan present bit for user AH

Mitesh Ahuja (7):
  RDMA/ocrdma: Add support for IB stack compliant stats in sysfs.
  RDMA/ocrdma: Increase the GID table size.
  RDMA/ocrdma: Move PD resource management to driver.
  RDMA/ocrdma: Host crash on destroying device resources.
  RDMA/ocrdma: Add support for interrupt moderation.
  RDMA/ocrdma: remove reference of ocrdma_dev out of ocrdma_qp
    structure.
  RDMA/ocrdma: Update the ocrdma module version string

Padmanabh Ratnakar (1):
  RDMA/ocrdma: Report correct state in ibv_query_qp

Selvin Xavier (2):
  RDMA/ocrdma: DebugFs enhancments for ocrdma driver.
  RDMA/ocrdma: Allow expansion of the SQ CQEs via buddy CQ expansion of
    the QP

 drivers/infiniband/hw/ocrdma/ocrdma.h       |   38 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   38 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |    6 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  313 +++++++++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   12 +-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   68 ++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  242 +++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |    6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  170 ++++++++++++---
 10 files changed, 810 insertions(+), 85 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
