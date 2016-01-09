From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 00/27] IB/hfi1: Add rdmavt support to hfi1
Date: Sat, 09 Jan 2016 07:16:37 -0800
Message-ID: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset starts to use rdmavt in hfi1. This is being submitted as an RFC
right now. It is based on the previously submitted rdmavt patches, and
is fully functional. However, due to the changes which have been accepted into
hfi1 while in staging (Greg's tree) will not apply to a merged (Doug+Greg) tree.

Once those changes have made it into a branch of Doug's we'll rebase and resolve
the inevitable conflicts and send an updated version.

---

Dennis Dalessandro (25):
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
      IB/hfi1: Use rdmavt send flags and recv flags
      IB/hfi1: Remove qpdev and qpn table from hfi1
      IB/hfi1: Remove create_qp functionality
      IB/hfi1: Remove CQ data structures and functions from hfi1
      IB/hfi1: Use rdmavt version of post_send
      IB/hfi1: Remove modify queue pair from hfi1
      IB/hfi1: Remove destroy qp verb
      IB/hfi1: Remove post_recv and use rdmavt version
      IB/hfi1: Remove multicast verbs functions
      IB/hfi1: Clean up register device

Harish Chegondi (2):
      IB/hfi1: Remove user context allocation and de-alloction functions
      IB/hfi1: Remove query_device function


 drivers/infiniband/sw/rdmavt/cq.c       |    4 
 drivers/staging/rdma/hfi1/Kconfig       |    2 
 drivers/staging/rdma/hfi1/Makefile      |    6 
 drivers/staging/rdma/hfi1/chip.c        |   36 -
 drivers/staging/rdma/hfi1/common.h      |    3 
 drivers/staging/rdma/hfi1/cq.c          |  558 ------------
 drivers/staging/rdma/hfi1/diag.c        |   12 
 drivers/staging/rdma/hfi1/driver.c      |   66 +
 drivers/staging/rdma/hfi1/hfi.h         |   37 -
 drivers/staging/rdma/hfi1/init.c        |    7 
 drivers/staging/rdma/hfi1/intr.c        |    2 
 drivers/staging/rdma/hfi1/keys.c        |  356 --------
 drivers/staging/rdma/hfi1/mad.c         |  163 ++--
 drivers/staging/rdma/hfi1/mmap.c        |  192 ----
 drivers/staging/rdma/hfi1/mr.c          |  473 -----------
 drivers/staging/rdma/hfi1/pio.c         |   12 
 drivers/staging/rdma/hfi1/qp.c          | 1386 +++++--------------------------
 drivers/staging/rdma/hfi1/qp.h          |  150 ---
 drivers/staging/rdma/hfi1/rc.c          |  377 ++++----
 drivers/staging/rdma/hfi1/ruc.c         |  253 +++---
 drivers/staging/rdma/hfi1/sdma.h        |    8 
 drivers/staging/rdma/hfi1/srq.c         |   62 +
 drivers/staging/rdma/hfi1/sysfs.c       |   18 
 drivers/staging/rdma/hfi1/trace.c       |    2 
 drivers/staging/rdma/hfi1/trace.h       |   51 -
 drivers/staging/rdma/hfi1/uc.c          |   67 +
 drivers/staging/rdma/hfi1/ud.c          |  146 ++-
 drivers/staging/rdma/hfi1/verbs.c       |  991 ++++++----------------
 drivers/staging/rdma/hfi1/verbs.h       |  735 +---------------
 drivers/staging/rdma/hfi1/verbs_mcast.c |  385 ---------
 30 files changed, 1226 insertions(+), 5334 deletions(-)
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
