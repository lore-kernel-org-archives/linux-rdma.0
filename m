From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/13] IB/rdmavt/qib/hfi1/core: First round for 4.9
Date: Tue, 06 Sep 2016 04:33:52 -0700
Message-ID: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are a handful of fixes that we didn't think were fitting for the RC release
so we are submitting these for 4.9. Note there is a change to the core here but
it is pretty harmless. There are also some improvements to rdmavt.

This applies on the last set of fixes I sent out for RC and can be seen in my
git tree:

https://github.com/ddalessa/kernel/tree/for-4.9

---

Dean Luick (1):
      IB/hfi1: Move serdes tune inside link start function

Harish Chegondi (1):
      IB/hfi1: Fix the count of user packets submitted to an SDMA engine

Mike Marciniszyn (9):
      IB/rdmavt: Add functions to get and release QP references
      IB/rdmavt,IB/qib,IB/hfi1: Use new QP put get routines
      IB/core: Add ib headers for general use
      IB/qib,IB/hfi: Use core common header file
      IB/rdmavt: Correct sparse annotation
      IB/hfi1: Move iowait_init() to priv allocate
      IB/rdmavt: Move reset calldown to reset path
      IB/rdmavt: Add qp init function
      IB/rdmavt,IB/hfi1: Add lockdep asserts for lock debug

Tadeusz Struk (1):
      IB/hfi1: Fix locking scheme for affinity settings

Tymoteusz Kielan (1):
      IB/hfi1: Fix user-space buffers mapping with IOMMU enabled


 drivers/infiniband/hw/hfi1/affinity.c     |   91 ++++++++-------
 drivers/infiniband/hw/hfi1/affinity.h     |    3 
 drivers/infiniband/hw/hfi1/chip.c         |   40 +++----
 drivers/infiniband/hw/hfi1/chip.h         |    2 
 drivers/infiniband/hw/hfi1/common.h       |    8 -
 drivers/infiniband/hw/hfi1/driver.c       |   35 +++---
 drivers/infiniband/hw/hfi1/file_ops.c     |   41 +++++--
 drivers/infiniband/hw/hfi1/hfi.h          |   17 +--
 drivers/infiniband/hw/hfi1/init.c         |   44 ++++---
 drivers/infiniband/hw/hfi1/mad.c          |    1 
 drivers/infiniband/hw/hfi1/pio.c          |   20 ++-
 drivers/infiniband/hw/hfi1/pio.h          |    2 
 drivers/infiniband/hw/hfi1/qp.c           |   33 +++--
 drivers/infiniband/hw/hfi1/rc.c           |  113 ++++++++++--------
 drivers/infiniband/hw/hfi1/ruc.c          |    4 -
 drivers/infiniband/hw/hfi1/sdma.c         |   24 ++--
 drivers/infiniband/hw/hfi1/sdma.h         |    3 
 drivers/infiniband/hw/hfi1/trace.c        |   27 +---
 drivers/infiniband/hw/hfi1/trace_ctxts.h  |   13 +-
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |   14 +-
 drivers/infiniband/hw/hfi1/trace_rx.h     |    4 -
 drivers/infiniband/hw/hfi1/uc.c           |    6 -
 drivers/infiniband/hw/hfi1/ud.c           |   12 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    |   31 ++---
 drivers/infiniband/hw/hfi1/verbs.c        |   18 +--
 drivers/infiniband/hw/hfi1/verbs.h        |   90 +--------------
 drivers/infiniband/hw/hfi1/verbs_txreq.c  |    2 
 drivers/infiniband/hw/qib/qib.h           |    1 
 drivers/infiniband/hw/qib/qib_driver.c    |    7 -
 drivers/infiniband/hw/qib/qib_iba7322.c   |    2 
 drivers/infiniband/hw/qib/qib_rc.c        |   73 +++++-------
 drivers/infiniband/hw/qib/qib_ruc.c       |    4 -
 drivers/infiniband/hw/qib/qib_uc.c        |    6 -
 drivers/infiniband/hw/qib/qib_ud.c        |    6 -
 drivers/infiniband/hw/qib/qib_verbs.c     |   14 +-
 drivers/infiniband/hw/qib/qib_verbs.h     |   94 ++-------------
 drivers/infiniband/sw/rdmavt/qp.c         |  117 +++++++++++--------
 include/rdma/ib_hdrs.h                    |  178 +++++++++++++++++++++++++++++
 include/rdma/rdmavt_qp.h                  |   19 +++
 39 files changed, 643 insertions(+), 576 deletions(-)
 create mode 100644 include/rdma/ib_hdrs.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
