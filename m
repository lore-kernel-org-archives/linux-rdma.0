From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/6] IB/hfi1: Performance improvements for 4.16
Date: Thu, 01 Feb 2018 10:45:58 -0800
Message-ID: <20180201184446.5918.46068.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason and Doug,

Here are a few patches that provide performance optimizations in our driver.

This is a resubmit of my previous patch set [1] broken up into smaller logically
grouped patch sets.

As always my GitHub had these in-tree for context:
https://github.com/ddalessa/kernel/tree/for-4.16

[1] https://www.spinics.net/lists/linux-rdma/msg60011.html

---

Mitko Haralanov (1):
      IB/hfi1: Remove dependence on qp->s_hdrwords

Sebastian Sanchez (5):
      IB/hfi1: Compute BTH only for RDMA_WRITE_LAST/SEND_LAST packet
      IB/hfi1: Optimize packet type comparison using 9B and bypass code paths
      IB/hfi1: Look up ibport using a pointer in receive path
      IB/hfi1: Remove unnecessary fecn and becn fields
      IB/hfi1: Optimize process_receive_ib()


 drivers/infiniband/hw/hfi1/driver.c       |   43 +++++++++++-------------
 drivers/infiniband/hw/hfi1/hfi.h          |   18 ++++------
 drivers/infiniband/hw/hfi1/iowait.h       |    9 +++++
 drivers/infiniband/hw/hfi1/qp.c           |    4 +-
 drivers/infiniband/hw/hfi1/qp.h           |   13 +++++++
 drivers/infiniband/hw/hfi1/rc.c           |   51 ++++++++++++++---------------
 drivers/infiniband/hw/hfi1/ruc.c          |   42 +++++++++---------------
 drivers/infiniband/hw/hfi1/trace.c        |    8 ++---
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   16 +++++----
 drivers/infiniband/hw/hfi1/trace_rx.h     |   28 ++++++----------
 drivers/infiniband/hw/hfi1/uc.c           |    9 +----
 drivers/infiniband/hw/hfi1/ud.c           |   30 +++++++----------
 drivers/infiniband/hw/hfi1/verbs.c        |   10 +++---
 drivers/infiniband/hw/hfi1/verbs.h        |   19 +++--------
 drivers/infiniband/hw/hfi1/verbs_txreq.h  |    7 ++++
 drivers/infiniband/hw/qib/qib_rc.c        |    3 +-
 drivers/infiniband/hw/qib/qib_uc.c        |    3 +-
 drivers/infiniband/hw/qib/qib_ud.c        |    3 +-
 include/rdma/ib_hdrs.h                    |   19 +++++++----
 19 files changed, 160 insertions(+), 175 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
