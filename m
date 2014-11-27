From: Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Thu, 27 Nov 2014 06:26:21 +0530
Message-ID: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Please apply.

Somnath Kotur (2):
  IB/Core: Changes to the IB Core infrastructure for RoCE V2.
  IB/ocrdma: Changes to comply with RoCEv2 Specification changes

 drivers/infiniband/core/addr.c              |   13 +++++-
 drivers/infiniband/core/cm.c                |   15 ++++---
 drivers/infiniband/core/cma.c               |    4 +-
 drivers/infiniband/core/sa_query.c          |    1 +
 drivers/infiniband/core/verbs.c             |   47 +++++++++++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   64 +++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   26 +++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   16 ++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   11 ++++-
 include/rdma/ib_addr.h                      |    3 +-
 include/rdma/ib_sa.h                        |    1 +
 include/rdma/ib_verbs.h                     |   15 ++++++
 13 files changed, 187 insertions(+), 31 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
