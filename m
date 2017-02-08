From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/27] IB/hfi1,qib,rdmavt: Patches for 4.11
Date: Wed, 08 Feb 2017 05:25:49 -0800
Message-ID: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Venkata Sandeep Dhanalakota <venkata.s.dhanalakota-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Doug,

Here is a set of patches for our drivers for 4.11. This is a
collection of bug fixes, perf improvements, and clean ups.

This does not include the port reordering patch series or
vnic as those are still undergoing discussion on the list.

Patches apply to your for-4.11 branch and can also be
found in my GitHub repo at:
https://github.com/ddalessa/kernel/tree/for-4.11

---

Brian Welty (5):
      IB/hfi1,qib,rdmavt: Move two IB event functions into rdmavt
      IB/hfi1,qib,rdmavt: Move AETH credit functions into rdmavt
      IB/hfi1,rdmavt: Update copy_sge to use boolean arguments
      IB/hfi1,rdmavt: Move SGE state helper routines into rdmavt
      IB/qib: Updates to use rdmavt's SGE helper routines

Don Hiatt (3):
      IB/hfi1: Add transmit fault injection feature
      IB/hfi1: Add rvt_rnr_tbl_to_usec function
      IB/hfi1,qib,rdmavt: Move AETH defines to rdma/ib_hdrs.h

Easwar Hariharan (1):
      IB/hfi1: Use static CTLE with Preset 6 for integrated HFIs

Jakub Byczkowski (1):
      IB/hfi1: Modify logging frequency of DCC errors

Michael J. Ruhl (2):
      IB/hfi1: Do not set physical link state if DC is in the shutdown state
      IB/hfi1: Code reuse with memdup_copy

Mike Marciniszyn (7):
      IB/hfi1: Correct defered count after processing qp_wait_list
      IB/hfi1: Process qp wait list in IRQ thread periodically
      IB/hfi1: Ensure read of producer s_head is correct
      IB/hfi1: Correct error calldown locking
      IB/hfi1: Add additional fields to qp_stats
      IB/rdmavt,IB/hfi1,IB/qib: Correct ack count for passive (RTR) QPs
      IB/hfi1: Add receive fault injection feature

Sebastian Sanchez (5):
      IB/hfi1: Access hfi1_ibport through rcd pointer
      IB/rdmavt: Use per-CPU reference count for MRs
      IB/hfi1: Allocate context data on memory node
      IB/hfi1: Reduce oversized fields in struct hfi1_packet
      IB/hfi1: Check upper-case EFI variables

Venkata Sandeep Dhanalakota (3):
      IB/rdmavt: Adding timer logic to rdmavt
      IB/hfi1: Use new rdmavt timers
      IB/qib: Use new rdmavt timers


 drivers/infiniband/hw/hfi1/Kconfig        |    6 +
 drivers/infiniband/hw/hfi1/chip.c         |   42 ++--
 drivers/infiniband/hw/hfi1/common.h       |    4 
 drivers/infiniband/hw/hfi1/debugfs.c      |  269 ++++++++++++++++++++++++--
 drivers/infiniband/hw/hfi1/debugfs.h      |   41 ++++
 drivers/infiniband/hw/hfi1/driver.c       |  144 +++++++++-----
 drivers/infiniband/hw/hfi1/efivar.c       |   26 ++-
 drivers/infiniband/hw/hfi1/hfi.h          |   18 +-
 drivers/infiniband/hw/hfi1/init.c         |   17 +-
 drivers/infiniband/hw/hfi1/pcie.c         |    4 
 drivers/infiniband/hw/hfi1/qp.c           |  177 +----------------
 drivers/infiniband/hw/hfi1/qp.h           |   22 --
 drivers/infiniband/hw/hfi1/rc.c           |  296 +++++------------------------
 drivers/infiniband/hw/hfi1/ruc.c          |   55 +----
 drivers/infiniband/hw/hfi1/trace.c        |    4 
 drivers/infiniband/hw/hfi1/trace_misc.h   |   48 +++++
 drivers/infiniband/hw/hfi1/uc.c           |   16 +-
 drivers/infiniband/hw/hfi1/ud.c           |   18 +-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   17 +-
 drivers/infiniband/hw/hfi1/user_sdma.c    |   17 +-
 drivers/infiniband/hw/hfi1/verbs.c        |  170 ++++++-----------
 drivers/infiniband/hw/hfi1/verbs.h        |   29 +--
 drivers/infiniband/hw/qib/qib_common.h    |    4 
 drivers/infiniband/hw/qib/qib_qp.c        |  135 -------------
 drivers/infiniband/hw/qib/qib_rc.c        |  179 +++++-------------
 drivers/infiniband/hw/qib/qib_ruc.c       |   47 -----
 drivers/infiniband/hw/qib/qib_uc.c        |   15 -
 drivers/infiniband/hw/qib/qib_ud.c        |    8 -
 drivers/infiniband/hw/qib/qib_verbs.c     |   96 +--------
 drivers/infiniband/hw/qib/qib_verbs.h     |   10 -
 drivers/infiniband/sw/rdmavt/Makefile     |    4 
 drivers/infiniband/sw/rdmavt/mr.c         |   59 ++++--
 drivers/infiniband/sw/rdmavt/pd.c         |    2 
 drivers/infiniband/sw/rdmavt/qp.c         |  233 +++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/rc.c         |  189 +++++++++++++++++++
 include/rdma/ib_hdrs.h                    |    6 +
 include/rdma/ib_pack.h                    |    2 
 include/rdma/rdma_vt.h                    |   21 ++
 include/rdma/rdmavt_mr.h                  |   60 +++++-
 include/rdma/rdmavt_qp.h                  |   46 +++++
 40 files changed, 1331 insertions(+), 1225 deletions(-)
 create mode 100644 drivers/infiniband/sw/rdmavt/rc.c

--
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
