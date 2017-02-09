From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/4] infiniband: chelsio
Date: Thu,  9 Feb 2017 14:23:47 -0800
Message-ID: <cover.1486678686.git.joe@perches.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Neaten logging

Joe Perches (4):
  cxgb3: Use more common logging style
  cxgb3: Convert PDBG to pr_debug
  cxgb4: Use more common logging style
  cxgb4: Convert PDBG to pr_debug

 drivers/infiniband/hw/cxgb3/cxio_dbg.c      |  35 +--
 drivers/infiniband/hw/cxgb3/cxio_hal.c      | 201 +++++++--------
 drivers/infiniband/hw/cxgb3/cxio_hal.h      |   7 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c |  25 +-
 drivers/infiniband/hw/cxgb3/iwch.c          |  19 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c       | 269 ++++++++++---------
 drivers/infiniband/hw/cxgb3/iwch_cm.h       |  18 +-
 drivers/infiniband/hw/cxgb3/iwch_cq.c       |  21 +-
 drivers/infiniband/hw/cxgb3/iwch_ev.c       |  26 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c      |   2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 112 ++++----
 drivers/infiniband/hw/cxgb3/iwch_provider.h |   9 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |  67 +++--
 drivers/infiniband/hw/cxgb4/cm.c            | 387 ++++++++++++++--------------
 drivers/infiniband/hw/cxgb4/cq.c            |  79 +++---
 drivers/infiniband/hw/cxgb4/device.c        | 141 +++++-----
 drivers/infiniband/hw/cxgb4/ev.c            |  39 ++-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  48 ++--
 drivers/infiniband/hw/cxgb4/mem.c           |  34 ++-
 drivers/infiniband/hw/cxgb4/provider.c      |  42 ++-
 drivers/infiniband/hw/cxgb4/qp.c            |  96 +++----
 drivers/infiniband/hw/cxgb4/resource.c      |  64 +++--
 drivers/infiniband/hw/cxgb4/t4.h            |  24 +-
 23 files changed, 861 insertions(+), 904 deletions(-)

-- 
2.10.0.rc2.1.g053435c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
