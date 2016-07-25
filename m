From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/28] RDMA/hfi1,qib,rdmavt: Second round of fixes for 4.8
Date: Mon, 25 Jul 2016 13:37:47 -0700
Message-ID: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Grzegorz Heldt <grzegorz.heldt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here are the next set of fixes for 4.8. There is one marked as stable but it
should filter through the process and require no special handling. This is
mostly bug fixes but there are some clean ups as well.

This does bring in a new feature, that is to support fast register memory region
(FRMR) in rdmavt and hfi1.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.8

---

Dasaratharaman Chandramouli (5):
      IB/hfi1: Remove unused elements from struct ahg_ib_header
      IB/hfi1: Rename struct ahg_ib_header to struct hfi1_ahg_info
      IB/hfi1: Cleanup UD packet handler.
      IB/hfi1: Use hdr2sc function to calculate 5-bit SC
      IB/qib, IB/hfi1: Fix grh creation in ud loopback

Dean Luick (3):
      IB/hfi1: Explain state complete frame details
      IB/hfi1: Read all firmware versions
      IB/hfi1: Add static PCIe Gen3 CTLE tuning

Don Hiatt (1):
      IB/hfi1: Rename hfi1_pio_header to hfi1_sdma_header.

Easwar Hariharan (3):
      IB/hfi1: Disable external device configuration requests
      IB/hfi1: Ignore QSFP interrupts until power stabilizes
      IB/hfi1: Reset QSFP on every run through channel tuning

Grzegorz Heldt (1):
      IB/hfi1: Fix trace message units

Harish Chegondi (1):
      IB/hfi1: Modify the default number of kernel receive conexts

Jakub Pawlak (1):
      IB/hfi1: Fix integrity errors counter value calculation

Jianxin Xiong (9):
      IB/rdmavt: Add support for ib_map_mr_sg
      IB/rdmavt: Add mechanism to invalidate MR keys
      IB/rdmavt: Handle local operations in post send
      IB/hfi1: Handle send with invalidate opcode in the RC recv path
      IB/hfi1: Work request processing for fast register mr and invalidate
      IB/hfi1: Add support for extended memory management
      IB/rdmavt: Add missing spin_lock_init call for rdi->n_cqs_lock
      IB/hfi1: Fix "suspicious rcu_dereference_check() usage" warnings
      IB/rdmavt,hfi1: Fix NFSoRDMA failure with FRMR enabled

Mike Marciniszyn (1):
      IB/hfi1: Add the capability for reserved operations

Mitko Haralanov (1):
      IB/hfi1: Pull FECN/BECN processing to a common place

Tadeusz Struk (1):
      IB/hfi1: Add sysfs entry to override SDMA interrupt affinity

Tymoteusz Kielan (1):
      IB/hfi1: Fix to fully initialize send context area


 drivers/infiniband/hw/hfi1/affinity.c       |   68 ++++++++++
 drivers/infiniband/hw/hfi1/affinity.h       |    4 +
 drivers/infiniband/hw/hfi1/chip.c           |  193 +++++++++++++++++++++------
 drivers/infiniband/hw/hfi1/chip.h           |    1 
 drivers/infiniband/hw/hfi1/chip_registers.h |    4 +
 drivers/infiniband/hw/hfi1/driver.c         |   51 ++++---
 drivers/infiniband/hw/hfi1/firmware.c       |  125 +++++++++++++++++
 drivers/infiniband/hw/hfi1/hfi.h            |   36 ++++-
 drivers/infiniband/hw/hfi1/init.c           |   15 +-
 drivers/infiniband/hw/hfi1/mad.c            |   34 +----
 drivers/infiniband/hw/hfi1/pcie.c           |   68 +++++++++-
 drivers/infiniband/hw/hfi1/pio.c            |    2 
 drivers/infiniband/hw/hfi1/platform.c       |   20 +--
 drivers/infiniband/hw/hfi1/qp.c             |   24 +++
 drivers/infiniband/hw/hfi1/qp.h             |    2 
 drivers/infiniband/hw/hfi1/rc.c             |   82 +++++++++--
 drivers/infiniband/hw/hfi1/ruc.c            |   57 ++++++--
 drivers/infiniband/hw/hfi1/sysfs.c          |   25 +++
 drivers/infiniband/hw/hfi1/uc.c             |   61 ++++-----
 drivers/infiniband/hw/hfi1/ud.c             |   86 ++++--------
 drivers/infiniband/hw/hfi1/verbs.c          |   42 +++---
 drivers/infiniband/hw/hfi1/verbs.h          |    8 -
 drivers/infiniband/hw/hfi1/verbs_txreq.h    |    2 
 drivers/infiniband/hw/qib/qib_ud.c          |    8 +
 drivers/infiniband/sw/rdmavt/cq.c           |    1 
 drivers/infiniband/sw/rdmavt/mr.c           |  124 +++++++++++++++++
 drivers/infiniband/sw/rdmavt/mr.h           |    2 
 drivers/infiniband/sw/rdmavt/qp.c           |  146 +++++++++++++++++---
 drivers/infiniband/sw/rdmavt/vt.c           |    7 +
 include/rdma/rdma_vt.h                      |    4 +
 include/rdma/rdmavt_mr.h                    |    1 
 include/rdma/rdmavt_qp.h                    |   54 ++++++++
 32 files changed, 1039 insertions(+), 318 deletions(-)

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
