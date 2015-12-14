From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/15] staging/rdma/hfi1: Initial patches to add rdmavt
 support in HFI1
Date: Mon, 14 Dec 2015 12:27:49 -0500
Message-ID: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series is being submitted as a Request For Comment only. It depends
on code submitted to the rdma subsystem [1].

This work is the first submission aimed to satisfy the TODO item for removing
duplicated code in hfi1. At the time of submission hfi1 and qib contained alot
of duplicated verbs processing code. The qib driver is having similar changes
made to use rdmavt. This will result in a common code base that both drivers and
future drivers such as soft-roce can use.

Note that due to the ongoing submission of hfi1 improvement patches, there will
likely be a number of conflicts which will still need to be resolved.

We also are still faced with the issue of separate trees for this work as was
discussed previously [2]. The result of that conversation was to keep the
drivers in separate trees until the 4.5 merge window. We are hoping that after
this merge window a single maintainer can take control of hfi1, qib, and rdmavt
so that these patches can move forward and be applied.

For now though we would like to get feedback on these patches with more to
follow.

[1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg30074.html
[2] https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg29360.html

---

Dennis Dalessandro (15):
      IB/hfi1: Begin to use rdmavt for verbs
      IB/hfi1: Add basic rdmavt capability flags for hfi1
      IB/hfi1: Consolidate dma ops for hfi1
      IB/hfi1: Use rdmavt protection domain
      IB/hfi1: Remove MR data structures from hfi1
      IB/hfi1: Remove driver specific members from hfi1 qp type
      IB/hfi1: Add device specific info prints
      IB/hfi1: Use correct rdmavt header files after move.
      IB/hfi1: Use address handle in rdmavt and remove from hfi1
      IB/hfi1: Implement hfi1 support for AH notification
      IB/hfi1: Remove hfi1 MR and hfi1 specific qp type
      IB/hfi1: Remove srq from hfi1
      IB/hfi1: Remove ibport and use rdmavt version
      IB/hfi1: Remove mmap from hfi1
      IB/hfi1: Use rdmavt pkey verbs function


 drivers/staging/rdma/hfi1/Kconfig       |    2 
 drivers/staging/rdma/hfi1/Makefile      |    4 
 drivers/staging/rdma/hfi1/chip.c        |   36 +-
 drivers/staging/rdma/hfi1/common.h      |    2 
 drivers/staging/rdma/hfi1/cq.c          |   20 +
 drivers/staging/rdma/hfi1/diag.c        |   13 -
 drivers/staging/rdma/hfi1/driver.c      |   31 +-
 drivers/staging/rdma/hfi1/hfi.h         |   27 +-
 drivers/staging/rdma/hfi1/init.c        |    5 
 drivers/staging/rdma/hfi1/intr.c        |    2 
 drivers/staging/rdma/hfi1/keys.c        |  356 ---------------------
 drivers/staging/rdma/hfi1/mad.c         |  163 +++++-----
 drivers/staging/rdma/hfi1/mmap.c        |  192 -----------
 drivers/staging/rdma/hfi1/mr.c          |  522 ------------------------------
 drivers/staging/rdma/hfi1/pio.c         |   10 -
 drivers/staging/rdma/hfi1/qp.c          |  214 +++++++-----
 drivers/staging/rdma/hfi1/qp.h          |   44 +--
 drivers/staging/rdma/hfi1/rc.c          |  155 +++++----
 drivers/staging/rdma/hfi1/ruc.c         |  161 +++++----
 drivers/staging/rdma/hfi1/sdma.h        |    8 
 drivers/staging/rdma/hfi1/srq.c         |   58 ++-
 drivers/staging/rdma/hfi1/sysfs.c       |   18 +
 drivers/staging/rdma/hfi1/trace.h       |   22 +
 drivers/staging/rdma/hfi1/uc.c          |   19 +
 drivers/staging/rdma/hfi1/ud.c          |   91 +++--
 drivers/staging/rdma/hfi1/verbs.c       |  526 +++++++++++--------------------
 drivers/staging/rdma/hfi1/verbs.h       |  531 ++++---------------------------
 drivers/staging/rdma/hfi1/verbs_mcast.c |   36 +-
 28 files changed, 843 insertions(+), 2425 deletions(-)
 delete mode 100644 drivers/staging/rdma/hfi1/keys.c
 delete mode 100644 drivers/staging/rdma/hfi1/mmap.c
 delete mode 100644 drivers/staging/rdma/hfi1/mr.c

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
