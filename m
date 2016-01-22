From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 00/10] Begin to use rdmavt for qib
Date: Fri, 22 Jan 2016 12:44:19 -0800
Message-ID: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following series implements the beginning support of rdmavt in the qib
driver. The memory registration and protection domain functionality has been
moved out of the driver as well as critical qp data structures. More patches
will follow to incrementally remove code from qib and use the rdmavt
implementation.

This patchset builds on the v3 "Add rdma verbs transport library" patchset.

Changes since v1:
Rebased onto what appears to be the latest branch on Doug's kernel.org repo
 (k.o/for-4.4-rc). I can rebase onto something else if needed.

Changes since v2:
Rebased onto k.o/for-4.5 commit: 59caaed7a72a0e3750dfb84636dae6b781559310
Handle removal of rvt_reg_phys_mr()

Changes since v3:
Reworked to handle conflicts introduced after merging with Dougs k.o/for-4.5

---

Dennis Dalessandro (10):
      IB/qib: Begin to use rdmavt for verbs
      IB/qib: Remove dma.c and use rdmavt version of dma functions
      IB/qib: Use rdmavt protection domain
      IB/qib: Remove most uses of QIB_PERMISSIVE_LID and QIB_MULTICAST_LID_BASE
      IB/qib: Use rdmavt lid defines in qib
      IB/qib: Remove driver specific members from qib qp type
      IB/qib: Add device specific info prints
      IB/qib: Remove qp and mr functionality from qib
      IB/qib: Use address handle in rdmavt and remove from qib
      IB/qib: Remove srq from qib


 drivers/infiniband/hw/qib/Kconfig           |    2 
 drivers/infiniband/hw/qib/Makefile          |    6 
 drivers/infiniband/hw/qib/qib.h             |   17 +
 drivers/infiniband/hw/qib/qib_common.h      |    2 
 drivers/infiniband/hw/qib/qib_cq.c          |    2 
 drivers/infiniband/hw/qib/qib_driver.c      |   22 +
 drivers/infiniband/hw/qib/qib_iba7322.c     |    2 
 drivers/infiniband/hw/qib/qib_init.c        |    5 
 drivers/infiniband/hw/qib/qib_intr.c        |    2 
 drivers/infiniband/hw/qib/qib_keys.c        |  186 +---------
 drivers/infiniband/hw/qib/qib_mad.c         |   11 -
 drivers/infiniband/hw/qib/qib_mmap.c        |   18 -
 drivers/infiniband/hw/qib/qib_mr.c          |  490 ---------------------------
 drivers/infiniband/hw/qib/qib_qp.c          |  165 +++++----
 drivers/infiniband/hw/qib/qib_rc.c          |  105 +++---
 drivers/infiniband/hw/qib/qib_ruc.c         |   84 ++---
 drivers/infiniband/hw/qib/qib_sdma.c        |   25 +
 drivers/infiniband/hw/qib/qib_srq.c         |   38 +-
 drivers/infiniband/hw/qib/qib_sysfs.c       |   20 +
 drivers/infiniband/hw/qib/qib_uc.c          |   15 -
 drivers/infiniband/hw/qib/qib_ud.c          |   53 ++-
 drivers/infiniband/hw/qib/qib_verbs.c       |  449 ++++++++-----------------
 drivers/infiniband/hw/qib/qib_verbs.h       |  484 ++++-----------------------
 drivers/infiniband/hw/qib/qib_verbs_mcast.c |    8 
 24 files changed, 547 insertions(+), 1664 deletions(-)
 delete mode 100644 drivers/infiniband/hw/qib/qib_mr.c

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
