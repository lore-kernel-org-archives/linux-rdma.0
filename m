From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 00/22] staging/rdma/hfi1: Fix bugs and performance issues
Date: Mon, 19 Oct 2015 22:11:15 -0400
Message-ID: <1445307097-8244-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The following are fixes to the hfi1 driver for stability, security, and
performance.

Changes from v1:
	Reviewed each patch for new features.  Found 2 which fixed congestion
	notification in some corner cases but they could be considered
	additional features, so they were dropped.

	Split code clean up from patch 14 "Implement Expected Receive TID
	caching" into a separate patch.

	Updated some commit messages to be clear how those patches fixed the
	driver.


Caz Yokoyama (1):
  staging/rdma/hfi1: Reset firmware instead of reloading Sbus

Dean Luick (4):
  staging/rdma/hfi1: Extend the offline timeout
  staging/rdma/hfi1: Add a schedule in send thread
  staging/rdma/hfi1: Add irqsaves in the packet processing path
  staging/rdma/hfi1: Thread the receive interrupt.

Easwar Hariharan (4):
  staging/rdma/hfi1: Fix code to reset ASIC CSRs on FLR
  staging/rdma/hfi1: Remove QSFP_ENABLED from HFI capability mask
  staging/rdma/hfi1: Fix port bounce issues with 0.22 DC firmware
  staging/rdma/hfi1: Load SBus firmware once per ASIC

Jareer Abdel-Qader (1):
  staging/rdma/hfi1: close shared context security hole

Jubin John (2):
  staging/rdma/hfi1: Add unit # to verbs txreq cache name
  staging/rdma/hfi1: Update driver version string to 0.9-294

Mike Marciniszyn (3):
  staging/rdma/hfi1: Fix regression in send performance
  staging/rdma/hfi: modify workqueue for parallelism
  staging/rdma/hfi1: add additional rc traces

Mitko Haralanov (4):
  staging/rdma/hfi1: Prevent silent data corruption with user SDMA
  staging/rdma/hfi1: Macro code clean up
  staging/rdma/hfi1: Implement Expected Receive TID caching
  staging/rdma/hfi1: Allow tuning of SDMA interrupt rate

Niranjana Vishwanathapura (2):
  staging/rdma/hfi1: Add coalescing support for SDMA TX descriptors
  staging/rdma/hfi1: Fix sparse error in sdma.h file

Vennila Megavannan (1):
  staging/rdma/hfi1: Prevent host software lock up

 drivers/staging/rdma/hfi1/Makefile       |    2 +-
 drivers/staging/rdma/hfi1/chip.c         |  157 +++-
 drivers/staging/rdma/hfi1/chip.h         |    2 +
 drivers/staging/rdma/hfi1/common.h       |   19 +-
 drivers/staging/rdma/hfi1/driver.c       |   77 +-
 drivers/staging/rdma/hfi1/file_ops.c     |  495 ++-----------
 drivers/staging/rdma/hfi1/firmware.c     |   37 +-
 drivers/staging/rdma/hfi1/hfi.h          |   85 ++-
 drivers/staging/rdma/hfi1/init.c         |   23 +-
 drivers/staging/rdma/hfi1/iowait.h       |    6 +-
 drivers/staging/rdma/hfi1/mad.c          |    4 +-
 drivers/staging/rdma/hfi1/pcie.c         |   15 +-
 drivers/staging/rdma/hfi1/pio.c          |   14 +-
 drivers/staging/rdma/hfi1/qp.c           |   47 +-
 drivers/staging/rdma/hfi1/qp.h           |   51 ++
 drivers/staging/rdma/hfi1/qsfp.c         |   13 +-
 drivers/staging/rdma/hfi1/rc.c           |   23 +-
 drivers/staging/rdma/hfi1/ruc.c          |   55 +-
 drivers/staging/rdma/hfi1/sdma.c         |  160 +++-
 drivers/staging/rdma/hfi1/sdma.h         |   82 ++-
 drivers/staging/rdma/hfi1/trace.c        |    4 +-
 drivers/staging/rdma/hfi1/trace.h        |  180 +++--
 drivers/staging/rdma/hfi1/ud.c           |    1 +
 drivers/staging/rdma/hfi1/user_exp_rcv.c | 1171 ++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/user_exp_rcv.h |   82 +++
 drivers/staging/rdma/hfi1/user_pages.c   |  110 +--
 drivers/staging/rdma/hfi1/user_sdma.c    |  103 ++-
 drivers/staging/rdma/hfi1/user_sdma.h    |   10 +-
 drivers/staging/rdma/hfi1/verbs.c        |   50 +-
 drivers/staging/rdma/hfi1/verbs.h        |    9 +-
 include/uapi/rdma/hfi/hfi1_user.h        |   46 +-
 31 files changed, 2171 insertions(+), 962 deletions(-)
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.c
 create mode 100644 drivers/staging/rdma/hfi1/user_exp_rcv.h

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
