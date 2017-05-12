From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 0/6] IB/hfi1,qib: Cleanups and updates for-next
Date: Fri, 12 May 2017 09:19:25 -0700
Message-ID: <20170512161106.1290.45891.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here are some patches for-next. There are some clean ups to remove unused code
and useless initializations. We also continue cleaning up the code by packing
more fields into the hfi1_packet to keep them in a single place and adding
some enhancements to the input/output header tracing.

These apply on top of the two patches I just sent for RC.

Patches can can also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.13

---

Don Hiatt (3):
      IB/hfi1: Add functions to parse BTH/IB headers
      IB/hfi1: Separate input/output header tracing
      IB/hfi1: Setup common IB fields in hfi1_packet struct

Ira Weiny (1):
      IB/hfi1: Remove unused mk_qpn function

Mike Marciniszyn (1):
      IB/rdmavt: Compress adjacent SGEs in rvt_lkey_ok()

Sebastian Sanchez (1):
      IB/hfi1: Remove unnecessary initialization from tx request


 drivers/infiniband/hw/hfi1/chip.c         |    9 -
 drivers/infiniband/hw/hfi1/chip.h         |    2 
 drivers/infiniband/hw/hfi1/common.h       |    1 
 drivers/infiniband/hw/hfi1/driver.c       |  162 ++++++++++-----
 drivers/infiniband/hw/hfi1/hfi.h          |   68 ++----
 drivers/infiniband/hw/hfi1/qp.c           |    6 -
 drivers/infiniband/hw/hfi1/rc.c           |   42 +---
 drivers/infiniband/hw/hfi1/ruc.c          |   91 ++++----
 drivers/infiniband/hw/hfi1/trace.c        |   58 +++++
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |  322 +++++++++++++++++++----------
 drivers/infiniband/hw/hfi1/trace_rx.h     |    9 +
 drivers/infiniband/hw/hfi1/uc.c           |   18 --
 drivers/infiniband/hw/hfi1/ud.c           |   27 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    |   12 +
 drivers/infiniband/hw/hfi1/verbs.c        |   98 ++++-----
 drivers/infiniband/hw/hfi1/verbs.h        |    6 -
 drivers/infiniband/hw/qib/qib_ruc.c       |    2 
 drivers/infiniband/sw/rdmavt/mr.c         |   51 ++++-
 drivers/infiniband/sw/rdmavt/qp.c         |   23 +-
 drivers/infiniband/sw/rdmavt/trace_mr.h   |   62 ++++++
 drivers/infiniband/sw/rdmavt/trace_tx.h   |   11 +
 include/rdma/ib_hdrs.h                    |   84 ++++++++
 include/rdma/ib_verbs.h                   |    2 
 include/rdma/rdma_vt.h                    |    3 
 include/rdma/rdmavt_qp.h                  |    2 
 25 files changed, 751 insertions(+), 420 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
