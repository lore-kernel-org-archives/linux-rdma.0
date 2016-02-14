From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/12] IB/rdamvt, qib, hfi1: Code cleanups, bug fixes,
 and perf improvements
Date: Sun, 14 Feb 2016 12:09:45 -0800
Message-ID: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds in mostly code clean ups. The driver provided functions
are documented and checked based on which verbs drivers are expecting rdmavt to
provide. There are also a couple of bug fixes included in this series, along with a
performance improvement patch which adds a dual lock to the sending side.

The patches here apply on the previously submitted "Misc bug fixes for hfi1" and
can be seen in context at: https://github.com/ddalessa/kernel/tree/for-4.6.

---

Dennis Dalessandro (7):
      IB/rdmavt: Clean up comments and add more documentation
      IB/rdmavt: Add per verb driver callback checking
      IB/qib: Setup notify free/create mad agent callbacks for rdmavt
      IB/qib,rdmavt: Move smi_ah to qib
      IB/rdmavt: Remove RVT_FLAGs
      IB/rdmavt: Remove signal_supported and comments
      IB/rdmavt: Remove unnecessary exported functions

Harish Chegondi (3):
      IB/qib: Rename several functions by adding a "qib_" prefix
      IB/rdmavt: Add trace and error print statements in post_one_wr
      IB/qib: Destroy SMI AH before de-allocating the protection domain

Kaike Wan (1):
      staging/rdma/hfi1: Put QPs into error state after SL->SC table changes

Mike Marciniszyn (1):
      IB/qib,staging/rdma/hfi1: add s_hlock for use in post send


 drivers/infiniband/hw/qib/qib.h         |   16 -
 drivers/infiniband/hw/qib/qib_iba7322.c |    8 
 drivers/infiniband/hw/qib/qib_mad.c     |    3 
 drivers/infiniband/hw/qib/qib_qp.c      |   62 +++-
 drivers/infiniband/hw/qib/qib_rc.c      |   44 +--
 drivers/infiniband/hw/qib/qib_ruc.c     |   11 -
 drivers/infiniband/hw/qib/qib_uc.c      |   22 +
 drivers/infiniband/hw/qib/qib_ud.c      |   22 +
 drivers/infiniband/hw/qib/qib_verbs.c   |   67 +++-
 drivers/infiniband/hw/qib/qib_verbs.h   |   17 +
 drivers/infiniband/sw/rdmavt/ah.c       |   27 ++
 drivers/infiniband/sw/rdmavt/cq.c       |   35 +-
 drivers/infiniband/sw/rdmavt/mad.c      |   30 +-
 drivers/infiniband/sw/rdmavt/mcast.c    |   34 ++
 drivers/infiniband/sw/rdmavt/mmap.c     |   32 +-
 drivers/infiniband/sw/rdmavt/mmap.h     |    8 
 drivers/infiniband/sw/rdmavt/mr.c       |   43 ++-
 drivers/infiniband/sw/rdmavt/pd.c       |   16 +
 drivers/infiniband/sw/rdmavt/qp.c       |  382 ++++++++++++++----------
 drivers/infiniband/sw/rdmavt/srq.c      |   22 +
 drivers/infiniband/sw/rdmavt/trace.h    |   70 ++++
 drivers/infiniband/sw/rdmavt/vt.c       |  503 ++++++++++++++++++++++++++-----
 drivers/infiniband/sw/rdmavt/vt.h       |    1 
 drivers/staging/rdma/hfi1/mad.c         |   13 +
 drivers/staging/rdma/hfi1/qp.c          |  131 ++++++++
 drivers/staging/rdma/hfi1/qp.h          |   38 --
 drivers/staging/rdma/hfi1/rc.c          |   44 +--
 drivers/staging/rdma/hfi1/ruc.c         |   40 +-
 drivers/staging/rdma/hfi1/uc.c          |   21 +
 drivers/staging/rdma/hfi1/ud.c          |   22 +
 drivers/staging/rdma/hfi1/verbs.c       |    3 
 drivers/staging/rdma/hfi1/verbs.h       |    2 
 include/rdma/rdma_vt.h                  |  184 +++++++----
 include/rdma/rdmavt_qp.h                |   17 +
 34 files changed, 1387 insertions(+), 603 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
