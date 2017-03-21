From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 00/20] IB/hfi1, qib,
 rdmavt: Another round of patches for 4.11
Date: Mon, 20 Mar 2017 17:24:32 -0700
Message-ID: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,
Here is another round of patches for 4.11. Included with the usual bug fixes
and general improvements of particular interest are new versions of the two
patches that you didn't take for the first set. The fault injection stuff.
We decided to go ahead and use the already existing config variable for those.
The other interesting thing here is a patch to the IB core for MGID/MLID
checking.

Patches apply on top of Linus' master branch which includes your most recent
pull request so this should apply equally well to your tree. Patches can 
also be found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.11

Changes since v1:
-----------------
Correct 0-day build errors in fault injection patches
Correct swqe completion trace message location

---

Dean Luick (1):
      IB/hfi1: Force logical link down

Don Hiatt (2):
      IB/hfi1: Add receive fault injection feature
      IB/hfi1: Add transmit fault injection feature

Easwar Hariharan (1):
      IB/hfi1: Check for QSFP presence before attempting reads

Michael J. Ruhl (5):
      IB/hfi1: Race hazard avoidance in user SDMA driver
      IB/hfi1: Cache registers during state change
      IB/hfi1: Add a patch value to the firmware version string
      IB/hfi1: Ensure VL index is within bounds
      IB/core: If the MGID/MLID pair is not on the list return an error

Mike Marciniszyn (7):
      IB/rdmavt,IB/hfi1,IB/qib: Make wc opcode translation driver dependent
      IB/rdmavt: Add additional fields to post send trace
      IB/rdmavt: Add tracing for cq entry and poll
      IB/rdmavt: Add swqe completion trace
      IB/rdmavt: Avoid reseting wqe send_flags in unreserve
      IB/hfi1: Eliminate synchronize_rcu() in mr delete
      IB/rdmavt,IB/qib,IB/hfi1: Make percpu refcount optional for user MRs

Sebastian Sanchez (2):
      IB/hfi1: NULL pointer dereference when freeing rhashtable
      IB/rdmavt,IB/hfi1: Fix timer migration regressions

Tadeusz Struk (2):
      IB/hfi1: Check device id early during init
      IB/hfi1: Protect the global dev_cntr_names and port_cntr_names


 drivers/infiniband/core/uverbs_cmd.c    |   13 +-
 drivers/infiniband/hw/hfi1/chip.c       |  178 ++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/chip.h       |   18 +-
 drivers/infiniband/hw/hfi1/debugfs.c    |  230 +++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/debugfs.h    |   62 ++++++++
 drivers/infiniband/hw/hfi1/driver.c     |   19 +++
 drivers/infiniband/hw/hfi1/firmware.c   |   14 +-
 drivers/infiniband/hw/hfi1/hfi.h        |   11 +
 drivers/infiniband/hw/hfi1/init.c       |   19 +--
 drivers/infiniband/hw/hfi1/rc.c         |   12 +-
 drivers/infiniband/hw/hfi1/ruc.c        |    7 +
 drivers/infiniband/hw/hfi1/sdma.c       |   43 ++++--
 drivers/infiniband/hw/hfi1/trace_misc.h |   48 ++++++
 drivers/infiniband/hw/hfi1/trace_rc.h   |    7 -
 drivers/infiniband/hw/hfi1/trace_tx.h   |   43 ++++++
 drivers/infiniband/hw/hfi1/user_sdma.c  |    3 
 drivers/infiniband/hw/hfi1/verbs.c      |  104 ++++++++++++--
 drivers/infiniband/hw/hfi1/verbs.h      |    5 +
 drivers/infiniband/hw/qib/qib_rc.c      |   10 +
 drivers/infiniband/hw/qib/qib_ruc.c     |    5 +
 drivers/infiniband/hw/qib/qib_verbs.c   |   20 +++
 drivers/infiniband/sw/rdmavt/cq.c       |    3 
 drivers/infiniband/sw/rdmavt/mr.c       |   55 +++++--
 drivers/infiniband/sw/rdmavt/qp.c       |   32 +---
 drivers/infiniband/sw/rdmavt/trace.h    |    4 -
 drivers/infiniband/sw/rdmavt/trace_cq.h |  127 +++++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_rc.h |  109 +++++++++++++++
 drivers/infiniband/sw/rdmavt/trace_tx.h |   34 ++++-
 include/rdma/ib_pack.h                  |    2 
 include/rdma/rdma_vt.h                  |    1 
 include/rdma/rdmavt_qp.h                |    7 -
 31 files changed, 1096 insertions(+), 149 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_cq.h
 create mode 100644 drivers/infiniband/sw/rdmavt/trace_rc.h

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
