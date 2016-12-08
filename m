From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/23] IB/hfi1,qib,rdmavt: Patches for 4.10
Date: Wed, 07 Dec 2016 19:32:08 -0800
Message-ID: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here is a set of patches for our drivers for 4.10. This is a
collection of bug fixes, perf improvements, and clean ups.
The patches apply on top of the last series I submitted. However
if things do not apply cleanly let me know I can rebase.

Can also be found in GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.10

---

Dean Luick (5):
      IB/hfi1: Read new EPROM format
      IB/hfi1: Fix dc8051 multiple qword memory reads
      IB/hfi1: Export 8051 memory and LCB registers via debugfs
      IB/hfi1: Add special setting for low power AOC
      IB/hfi1: Preserve external device completed bit

Dennis Dalessandro (1):
      IB/rdmavt: Fix trace hierarchy

Don Hiatt (1):
      IB/hfi1: Remove dependence on qp->s_cur_size

Harish Chegondi (1):
      IB/hfi1: Avoid credit return allocation for cpu-less NUMA nodes

Jakub Pawlak (1):
      IB/hfi1: Disable header suppression for short packets

Jianxin Xiong (1):
      IB/hfi1: Show statistics counters under IB stats interface

Mike Marciniszyn (6):
      IB/rdmavt: Add trace of MR segs
      IB/rdmavt: Add a send completion helper
      IB/hfi1,IB/qib: Use new send completion helper
      IB/rdmavt: Add swqe mr deref helper
      IB/hfi1,IB/qib: use rvt swqe mr deref helper
      IB/rdmavt,IB/hfi1,IB/qib: Add inlines for mtu division

Mitko Haralanov (1):
      IB/hfi1: Remove usage of qp->s_cur_sge

Sebastian Sanchez (5):
      IB/hfi1: Use non-atomic __test_and_clear_bit in hot path
      IB/hfi1: Remove critical section gap in sc_buffer_alloc()
      IB/hfi1: Replace qp->refcount release code with standard driver wrapper
      IB/hfi1: Use reference count wrapper for MRs
      IB/qib: Use standard refcount wrapper for QPs

Tadeusz Struk (1):
      IB/hfi1: Remove definition of unused hfi1_affinity struct


 drivers/infiniband/hw/hfi1/affinity.c    |    3 
 drivers/infiniband/hw/hfi1/affinity.h    |    9 -
 drivers/infiniband/hw/hfi1/chip.c        |    5 +
 drivers/infiniband/hw/hfi1/debugfs.c     |  110 ++++++++++++++++
 drivers/infiniband/hw/hfi1/driver.c      |    3 
 drivers/infiniband/hw/hfi1/eprom.c       |  211 +++++++++++++++++++++++++++++-
 drivers/infiniband/hw/hfi1/firmware.c    |   10 +
 drivers/infiniband/hw/hfi1/hfi.h         |    1 
 drivers/infiniband/hw/hfi1/pio.c         |   22 ---
 drivers/infiniband/hw/hfi1/platform.c    |   44 ++++++
 drivers/infiniband/hw/hfi1/rc.c          |   60 ++-------
 drivers/infiniband/hw/hfi1/ruc.c         |   28 +---
 drivers/infiniband/hw/hfi1/uc.c          |    4 -
 drivers/infiniband/hw/hfi1/ud.c          |    4 -
 drivers/infiniband/hw/hfi1/user_sdma.c   |   60 ++++++---
 drivers/infiniband/hw/hfi1/verbs.c       |  190 +++++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/verbs_txreq.h |    1 
 drivers/infiniband/hw/qib/qib_driver.c   |    3 
 drivers/infiniband/hw/qib/qib_rc.c       |   44 +-----
 drivers/infiniband/hw/qib/qib_ruc.c      |   24 ---
 drivers/infiniband/hw/qib/qib_verbs.c    |   33 +----
 drivers/infiniband/sw/rdmavt/mcast.c     |    5 -
 drivers/infiniband/sw/rdmavt/mr.c        |   12 +-
 drivers/infiniband/sw/rdmavt/qp.c        |   17 ++
 drivers/infiniband/sw/rdmavt/trace.h     |  141 +-------------------
 drivers/infiniband/sw/rdmavt/trace_mr.h  |  112 ++++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_qp.h  |   96 ++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_rvt.h |   81 ++++++++++++
 drivers/infiniband/sw/rdmavt/trace_tx.h  |  132 +++++++++++++++++++
 include/rdma/rdmavt_qp.h                 |   77 +++++++++++
 include/uapi/rdma/hfi/hfi1_user.h        |    2 
 31 files changed, 1147 insertions(+), 397 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_mr.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_qp.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rvt.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_tx.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
