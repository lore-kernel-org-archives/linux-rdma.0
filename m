From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/8] IB/rdmavt: Add functions for cq, qp, post send and recv
Date: Sat, 09 Jan 2016 06:59:56 -0800
Message-ID: <20160109145731.8585.48926.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series continues adding support for verbs into rdmavt. This brings in
completion queue, queue pair, and post send/recv functionality.

It also introduces event tracing and moves some more of the hfi1/qib
registration functionality.

This patch set applies on top of the "Start to rely on rdmavt for qp support"
series previously submitted.

---

Dennis Dalessandro (8):
      IB/rdmavt: Add completion queue functions
      IB/rdmavt: Add post send to rdmavt
      IB/rdmavt: Add support for tracing events
      IB/rdmavt: Add modify qp
      IB/rdmavt: Add destroy qp verb
      IB/rdmavt: Add post receive to rdmavt
      IB/rdmavt: Add multicast functions
      IB/rdmavt: Add misc dev register functionality


 drivers/infiniband/sw/rdmavt/Makefile |    5 
 drivers/infiniband/sw/rdmavt/cq.c     |  445 +++++++++++++++++++
 drivers/infiniband/sw/rdmavt/cq.h     |    4 
 drivers/infiniband/sw/rdmavt/mcast.c  |  335 ++++++++++++++-
 drivers/infiniband/sw/rdmavt/mcast.h  |    2 
 drivers/infiniband/sw/rdmavt/qp.c     |  760 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/trace.c  |   49 ++
 drivers/infiniband/sw/rdmavt/trace.h  |  117 +++++
 drivers/infiniband/sw/rdmavt/vt.c     |   60 +++
 include/rdma/rdma_vt.h                |   66 +++
 include/rdma/rdmavt_cq.h              |   99 ++++
 include/rdma/rdmavt_mr.h              |    9 
 include/rdma/rdmavt_qp.h              |   66 +++
 13 files changed, 1974 insertions(+), 43 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.c
 create mode 100644 drivers/infiniband/sw/rdmavt/trace.h
 create mode 100644 include/rdma/rdmavt_cq.h

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
