From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Wed,  8 Nov 2017 11:57:33 +0200
Message-ID: <20171108095742.25365-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the third re-incarnation of the CQ pool patches proposed
by Christoph and I.

Our ULPs often want to make smart decisions on completion vector
affinitization when using multiple completion queues spread on
multiple cpu cores. We can see examples for this in iser, srp, nvme-rdma.

This patch set attempts to move this smartness to the rdma core by
introducing per-device CQ pools that by definition spread
across cpu cores. In addition, we completely make the completion
queue allocation transparent to the ULP by adding affinity hints
to create_qp which tells the rdma core to select (or allocate)
a completion queue that has the needed affinity for it.

This API gives us a similar approach to whats used in the networking
stack where the device completion queues are hidden from the application.
With the affinitization hints, we also do not compromise performance
as the completion queue will be affinitized correctly.

One thing that should be noticed is that now different ULPs using this
API may share completion queues (given that they use the same polling context).
However, even without this API they share interrupt vectors (and CPUs
that are assigned to them). Thus aggregating consumers on less completion
queues will result in better overall completion processing efficiency per
completion event (or interrupt).

In addition, we introduce a configfs knob to our nvme-target to
bound I/O threads to a given cpulist (can be a subset). This is
useful for numa configurations where the backend device access is
configured with care to numa affinity, and we want to restrict rdma
device and I/O threads affinity accordingly.

The patch set convert iser, isert, srpt, svcrdma, nvme-rdma and
nvmet-rdma to use the new API.

Comments and feedback is welcome.

Christoph Hellwig (1):
  nvme-rdma: use implicit CQ allocation

Sagi Grimberg (8):
  RDMA/core: Add implicit per-device completion queue pools
  IB/isert: use implicit CQ allocation
  IB/iser: use implicit CQ allocation
  IB/srpt: use implicit CQ allocation
  svcrdma: Use RDMA core implicit CQ allocation
  nvmet-rdma: use implicit CQ allocation
  nvmet: allow assignment of a cpulist for each nvmet port
  nvmet-rdma: assign cq completion vector based on the port allowed cpus

 drivers/infiniband/core/core_priv.h      |   6 +
 drivers/infiniband/core/cq.c             | 193 +++++++++++++++++++++++++++++++
 drivers/infiniband/core/device.c         |   4 +
 drivers/infiniband/core/verbs.c          |  69 ++++++++++-
 drivers/infiniband/ulp/iser/iscsi_iser.h |  19 ---
 drivers/infiniband/ulp/iser/iser_verbs.c |  82 ++-----------
 drivers/infiniband/ulp/isert/ib_isert.c  | 165 ++++----------------------
 drivers/infiniband/ulp/isert/ib_isert.h  |  16 ---
 drivers/infiniband/ulp/srpt/ib_srpt.c    |  46 +++-----
 drivers/infiniband/ulp/srpt/ib_srpt.h    |   1 -
 drivers/nvme/host/rdma.c                 |  62 +++++-----
 drivers/nvme/target/configfs.c           |  75 ++++++++++++
 drivers/nvme/target/nvmet.h              |   4 +
 drivers/nvme/target/rdma.c               |  71 +++++-------
 include/linux/sunrpc/svc_rdma.h          |   2 -
 include/rdma/ib_verbs.h                  |  31 ++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  22 +---
 17 files changed, 468 insertions(+), 400 deletions(-)

-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
