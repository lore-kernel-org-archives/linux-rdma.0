From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/31] staging/rdma/hfi1: Add rdmavt support to hfi1
Date: Tue, 19 Jan 2016 14:41:28 -0800
Message-ID: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series adds rdmavt support to hfi1. More specifically it removes code
duplication from hfi1 and uses the common rdmavt version. There are still a few
more patches to go after this but this is a large chunk of the work and most of
these patches have previously been submitted as RFC, first to staging, and then
to linux-rdma. The 3 patches from Harish and the one from Ira are new vs the
RFC.

The series will apply on the rdmavt series "clean ups, mad agents, and
query_qp".

---

Dennis Dalessandro (27):
      staging/rdma/hfi1: Begin to use rdmavt for verbs
      staging/rdma/hfi1: Add basic rdmavt capability flags for hfi1
      staging/rdma/hfi1: Use rdmavt protection domain
      staging/rdma/hfi1: Remove MR data structures from hfi1
      staging/rdma/hfi1: Remove driver specific members from hfi1 qp type
      staging/rdma/hfi1: Add device specific info prints
      staging/rdma/hfi1: Use correct rdmavt header files after move.
      staging/rdma/hfi1: Use address handle in rdmavt and remove from hfi1
      staging/rdma/hfi1: Implement hfi1 support for AH notification
      staging/rdma/hfi1: Remove hfi1 MR and hfi1 specific qp type
      staging/rdma/hfi1: Remove srq from hfi1
      staging/rdma/hfi1: Remove ibport and use rdmavt version
      staging/rdma/hfi1: Remove mmap from hfi1
      staging/rdma/hfi1: Use rdmavt pkey verbs function
      staging/rdma/hfi1: Use rdmavt send flags and recv flags
      staging/rdma/hfi1: Remove qpdev and qpn table from hfi1
      staging/rdma/hfi1: Remove create_qp functionality
      staging/rdma/hfi1: Remove CQ data structures and functions from hfi1
      staging/rdma/hfi1: Clean up return handling
      staging/rdma/hfi1: Use rdmavt version of post_send
      staging/rdma/hfi1: Remove multicast verbs functions
      staging/rdma/hfi1: Remove modify queue pair from hfi1
      staging/rdma/hfi1: Remove destroy qp verb
      staging/rdma/hfi1: Remove post_recv and use rdmavt version
      staging/rdma/hfi1: Clean up register device
      staging/rdma/hfi1: Use rdmavt device allocation function
      staging/rdma/hfi1: Remove create and free mad agents

Harish Chegondi (3):
      staging/rdma/hfi1: Remove user context allocation and de-alloction functions
      staging/rdma/hfi1: Remove query_device function
      staging/rdma/hfi1: Remove hfi1_query_qp function

Ira Weiny (1):
      staging/rdma/hfi1: Consolidate dma ops for hfi1


 drivers/infiniband/sw/rdmavt/cq.c       |    4 
 drivers/infiniband/sw/rdmavt/qp.c       |    7 
 drivers/staging/rdma/hfi1/Kconfig       |    2 
 drivers/staging/rdma/hfi1/Makefile      |    6 
 drivers/staging/rdma/hfi1/chip.c        |   36 -
 drivers/staging/rdma/hfi1/common.h      |    3 
 drivers/staging/rdma/hfi1/cq.c          |  558 ------------
 drivers/staging/rdma/hfi1/diag.c        |   13 
 drivers/staging/rdma/hfi1/driver.c      |   66 +
 drivers/staging/rdma/hfi1/hfi.h         |   31 -
 drivers/staging/rdma/hfi1/init.c        |   18 
 drivers/staging/rdma/hfi1/intr.c        |    2 
 drivers/staging/rdma/hfi1/keys.c        |  356 --------
 drivers/staging/rdma/hfi1/mad.c         |  218 ++---
 drivers/staging/rdma/hfi1/mmap.c        |  192 ----
 drivers/staging/rdma/hfi1/mr.c          |  473 ----------
 drivers/staging/rdma/hfi1/pio.c         |   12 
 drivers/staging/rdma/hfi1/qp.c          | 1456 +++++--------------------------
 drivers/staging/rdma/hfi1/qp.h          |  165 +---
 drivers/staging/rdma/hfi1/rc.c          |  385 ++++----
 drivers/staging/rdma/hfi1/ruc.c         |  230 +++--
 drivers/staging/rdma/hfi1/sdma.h        |    8 
 drivers/staging/rdma/hfi1/srq.c         |   62 +
 drivers/staging/rdma/hfi1/sysfs.c       |   18 
 drivers/staging/rdma/hfi1/trace.c       |    2 
 drivers/staging/rdma/hfi1/trace.h       |   51 -
 drivers/staging/rdma/hfi1/uc.c          |   67 +
 drivers/staging/rdma/hfi1/ud.c          |  148 ++-
 drivers/staging/rdma/hfi1/verbs.c       | 1007 +++++----------------
 drivers/staging/rdma/hfi1/verbs.h       |  731 +---------------
 drivers/staging/rdma/hfi1/verbs_mcast.c |  385 --------
 31 files changed, 1251 insertions(+), 5461 deletions(-)
 delete mode 100644 drivers/staging/rdma/hfi1/cq.c
 delete mode 100644 drivers/staging/rdma/hfi1/keys.c
 delete mode 100644 drivers/staging/rdma/hfi1/mmap.c
 delete mode 100644 drivers/staging/rdma/hfi1/mr.c
 delete mode 100644 drivers/staging/rdma/hfi1/verbs_mcast.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
