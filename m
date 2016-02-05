From: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/6] iWARP patches for the 4.5-rc2 rebase
Date: Fri, 5 Feb 2016 14:01:55 -0800
Message-ID: <cover.1454709715.git.swise@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are the remaining iwarp-wip patches rebased on nvmf-4.5.  I've pushed
this to branch nvmf-4.5-iwarp.  

Sagi, it would be great if you could add these when you rebase.

Thanks!

Steve
---

Christoph Hellwig (2):
  IB: add a simple MR pool
  nvmet_rdma: use generic RDMA READ/WRITE path

Steve Wise (4):
  IB: New common API for draining a queue pair
  iw_cxgb4: add drain_qp function
  nvme-rdma: use ib_drain_qp() function
  IB: generic RDMA READ/WRITE API

 drivers/infiniband/core/Makefile       |   2 +-
 drivers/infiniband/core/mr_pool.c      |  85 ++++++++
 drivers/infiniband/core/verbs.c        |  76 +++++++
 drivers/infiniband/hw/cxgb4/cq.c       |   6 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   2 +
 drivers/infiniband/hw/cxgb4/provider.c |   1 +
 drivers/infiniband/hw/cxgb4/qp.c       |   8 +
 drivers/nvme/host/rdma.c               |  35 +---
 drivers/nvme/target/Makefile           |   2 +-
 drivers/nvme/target/rdma.c             | 205 +++++--------------
 drivers/nvme/target/rw.c               | 348 +++++++++++++++++++++++++++++++++
 drivers/nvme/target/rw.h               |  81 ++++++++
 include/rdma/ib_verbs.h                |  12 +-
 include/rdma/mr_pool.h                 |  20 ++
 14 files changed, 696 insertions(+), 187 deletions(-)
 create mode 100644 drivers/infiniband/core/mr_pool.c
 create mode 100644 drivers/nvme/target/rw.c
 create mode 100644 drivers/nvme/target/rw.h
 create mode 100644 include/rdma/mr_pool.h

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
