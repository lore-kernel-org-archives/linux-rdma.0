From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 00/18] IB/hfi1, rdmavt,
 qib: First batch of fixes for 4.8
Date: Fri, 01 Jul 2016 16:00:43 -0700
Message-ID: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

Here is a set of fixes and improvmenets that would be for the next release. They
apply onto of the last set of RC fixes previously posted.

Of particular note in here is the twsi code clean up that was asked for
previously while we were in staging. I think this does the job of not
duplicating what is already present in the kernel. These are the two patches
from Dean.

The patches from Mike improve rdmavt and make the posting of sends more friendly
to work with and extend.

There are also performance improvement patches in this bunch as well as well as
a couple minor fixes that we felt are more appropriate for the next merge cycle
rather than RC.

These patches have been added to my GitHub branch and have passed zero day
builds.

https://github.com/ddalessa/kernel/tree/for-4.8

---

Dean Luick (2):
      IB/hfi1: Use built-in i2c bit-shift bus adapter
      IB/hfi1: Remove TWSI references

Ira Weiny (2):
      IB/hfi1: Clean up port state structure definition
      IB/hfi1: Remove unnecessary done label in hfi1_write_iter

Jakub Pawlak (3):
      IB/hfi1: Add VL XmitDiscards counters to the opapmaquery
      IB/hfi1: Add counter to track unsupported packets drop
      IB/hfi1: Correct receive packet handler assignment

Jianxin Xiong (1):
      IB/hfi1: Improve SDMA engine assignment for user SDMA

Mike Marciniszyn (5):
      IB/hfi1: Fix trace sparse errors
      IB/rdmavt: Add data structures and routines for table driven post send
      IB/hfi1: Add hfi1 post send tables
      IB/qib: Add qib post send table
      IB/rdmavt: Use new driver specific post send table

Sebastian Sanchez (4):
      IB/hfi1: Separate tracepoints into specific headers
      IB/hfi1: Add global structure for affinity assignments
      IB/hfi1: Reserve and collapse CPU cores for contexts
      IB/hfi1: Refine user process affinity algorithm

Tadeusz Struk (1):
      IB/hfi1: Fix typo


 drivers/infiniband/hw/hfi1/Kconfig        |    3 
 drivers/infiniband/hw/hfi1/Makefile       |    2 
 drivers/infiniband/hw/hfi1/affinity.c     |  526 +++++++++--
 drivers/infiniband/hw/hfi1/affinity.h     |   34 +
 drivers/infiniband/hw/hfi1/chip.c         |   82 +-
 drivers/infiniband/hw/hfi1/chip.h         |    2 
 drivers/infiniband/hw/hfi1/driver.c       |    1 
 drivers/infiniband/hw/hfi1/file_ops.c     |   46 +
 drivers/infiniband/hw/hfi1/hfi.h          |   67 +
 drivers/infiniband/hw/hfi1/init.c         |   36 +
 drivers/infiniband/hw/hfi1/mad.c          |   26 -
 drivers/infiniband/hw/hfi1/mad.h          |    7 
 drivers/infiniband/hw/hfi1/qp.c           |   44 +
 drivers/infiniband/hw/hfi1/qp.h           |    2 
 drivers/infiniband/hw/hfi1/qsfp.c         |  409 +++++++--
 drivers/infiniband/hw/hfi1/qsfp.h         |    3 
 drivers/infiniband/hw/hfi1/rc.c           |    8 
 drivers/infiniband/hw/hfi1/trace.h        | 1333 -----------------------------
 drivers/infiniband/hw/hfi1/trace_ctxts.h  |  141 +++
 drivers/infiniband/hw/hfi1/trace_dbg.h    |  155 +++
 drivers/infiniband/hw/hfi1/trace_ibhdrs.h |  209 +++++
 drivers/infiniband/hw/hfi1/trace_misc.h   |   81 ++
 drivers/infiniband/hw/hfi1/trace_rc.h     |  123 +++
 drivers/infiniband/hw/hfi1/trace_rx.h     |  322 +++++++
 drivers/infiniband/hw/hfi1/trace_tx.h     |  642 ++++++++++++++
 drivers/infiniband/hw/hfi1/twsi.c         |  489 -----------
 drivers/infiniband/hw/hfi1/twsi.h         |   65 -
 drivers/infiniband/hw/hfi1/user_sdma.c    |   29 +
 drivers/infiniband/hw/hfi1/verbs.c        |   32 -
 drivers/infiniband/hw/qib/qib_qp.c        |   43 +
 drivers/infiniband/hw/qib/qib_verbs.c     |    2 
 drivers/infiniband/hw/qib/qib_verbs.h     |    2 
 drivers/infiniband/sw/rdmavt/qp.c         |  113 ++
 drivers/infiniband/sw/rdmavt/vt.c         |    3 
 include/rdma/opa_port_info.h              |   16 
 include/rdma/rdma_vt.h                    |    3 
 include/rdma/rdmavt_qp.h                  |   28 +
 37 files changed, 2811 insertions(+), 2318 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi1/trace_ctxts.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_dbg.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_ibhdrs.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_misc.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_rc.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_rx.h
 create mode 100644 drivers/infiniband/hw/hfi1/trace_tx.h
 delete mode 100644 drivers/infiniband/hw/hfi1/twsi.c
 delete mode 100644 drivers/infiniband/hw/hfi1/twsi.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
