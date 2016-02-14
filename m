From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/16] staging/rdma/hfi1: Adaptive PIO performance
 improvement
Date: Sun, 14 Feb 2016 12:44:06 -0800
Message-ID: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a performance improvement patch series. It adds an adaptive PIO
component where under certain conditions small messages will be sent via PIO
instead of SDMA. This series also includes a change to the progress mechanism
and its interaction with rdmavt enabling a driver hint as to if the progress
should be kicked or the send just queued.

Series applies on the posted "Code cleanups, bug fixes, and perf improvements"
patch. It can also be seen in context at
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dennis Dalessandro (1):
      staging/rdma/hfi1: Remove header memcpy from sdma send path.

Jubin John (3):
      staging/rdma/hfi1: Add s_sendcontext priv field
      staging/rdma/hfi1: Add qp to send context mapping for PIO
      staging/rdma/hfi1: Add send context sw index

Mike Marciniszyn (11):
      staging/rdma/hfi1: add s_avail to qp_stats
      IB/rdmvt: close send engine struct holes
      staging/rdma/hfi1: move txreq header code
      staging/rdma/hfi1: remove s_rdma_mr
      staging/rdma/hfi1: avoid passing pmtu
      staging/rdma/hfi1: fix panic in send engine
      staging/rdma/hfi1: use u8 for vl/sl
      staging/rdma/hfi1: Adaptive PIO for short messages
      IB/qib,staging/rdma/hfi1,IB/rdmavt: progress selection changes
      staging/rdma/hfi: fix CQ completion order issue
      staging/rdma/hfi1: Determine actual operational VLs

Vennila Megavannan (1):
      staging/rdma/hfi1: add cq head and tail information to qpstats


 drivers/infiniband/hw/qib/qib_qp.c      |    7 -
 drivers/infiniband/sw/rdmavt/qp.c       |   10 +
 drivers/staging/rdma/hfi1/Makefile      |    3 
 drivers/staging/rdma/hfi1/chip.c        |   47 +++-
 drivers/staging/rdma/hfi1/chip.h        |    1 
 drivers/staging/rdma/hfi1/diag.c        |   22 +-
 drivers/staging/rdma/hfi1/hfi.h         |   16 +
 drivers/staging/rdma/hfi1/init.c        |    2 
 drivers/staging/rdma/hfi1/iowait.h      |  121 +++++++++
 drivers/staging/rdma/hfi1/pio.c         |  244 +++++++++++++++++++
 drivers/staging/rdma/hfi1/pio.h         |  106 ++++++++
 drivers/staging/rdma/hfi1/qp.c          |   89 ++++++-
 drivers/staging/rdma/hfi1/qp.h          |    1 
 drivers/staging/rdma/hfi1/rc.c          |   77 ++++--
 drivers/staging/rdma/hfi1/ruc.c         |   26 +-
 drivers/staging/rdma/hfi1/sdma.c        |  102 +++-----
 drivers/staging/rdma/hfi1/sdma.h        |   84 -------
 drivers/staging/rdma/hfi1/sdma_txreq.h  |  135 +++++++++++
 drivers/staging/rdma/hfi1/uc.c          |   42 +++
 drivers/staging/rdma/hfi1/ud.c          |   65 +++--
 drivers/staging/rdma/hfi1/user_sdma.c   |    7 -
 drivers/staging/rdma/hfi1/verbs.c       |  396 ++++++++++++-------------------
 drivers/staging/rdma/hfi1/verbs.h       |   45 ++--
 drivers/staging/rdma/hfi1/verbs_txreq.c |  149 ++++++++++++
 drivers/staging/rdma/hfi1/verbs_txreq.h |  116 +++++++++
 include/rdma/rdmavt_qp.h                |   26 +-
 26 files changed, 1410 insertions(+), 529 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/sdma_txreq.h
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.c
 create mode 100644 drivers/staging/rdma/hfi1/verbs_txreq.h

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
