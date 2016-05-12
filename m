From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/15] IB/hfi1, rdmavt,
 core: Misc fixes and improvements for 4.7
Date: Thu, 12 May 2016 10:22:26 -0700
Message-ID: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are some patches that address a few bugs and a couple other clean ups that
did not make it in time for 4.6. There are also a couple performance related
patches as well.

There are more clean-ups on the way to address some of the feedback received
during reviews of other patches, however this stuff stands on its own so
separating it out into its own series.

This patch series applies on Doug's k.o/for-4.7 branch.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Ashutosh Dixit (1):
      IB/hfi1: Change hfi1_init loop to preserve error returns

Dean Luick (2):
      IB/hfi1: Remove no-op QSFP reset code
      IB/hfi1: Immediately apply congestion setting MAD

Easwar Hariharan (3):
      IB/hfi1: Ignore non-temperature warnings on a downed link
      IB/hfi1: Wait for QSFP modules to initialize
      IB/hfi1: Correct external device configuration shift

Jakub Pawlak (1):
      IB/hfi1: Correct log message strings

Jianxin Xiong (2):
      IB/hfi1: Keep SC_USER as the last send context type
      ib_pack.h: Add opcode definition for send with invalidate

Jubin John (2):
      IB/hfi1: Remove unnecessary header
      IB/hfi1: Fix hfi_rcvhdr tracepoint

Mike Marciniszyn (3):
      IB/hfi1: Fix pio wait counter double increment
      IB/hfi1: Fix potential panic with sdma drained mechanism
      IB/rdmavt: Increase CQ callback thread priority

Mitko Haralanov (1):
      IB/hfi1: Improve performance of interval RB trees


 drivers/infiniband/sw/rdmavt/cq.c    |    1 
 drivers/staging/rdma/hfi1/chip.c     |   32 ++++++++----
 drivers/staging/rdma/hfi1/diag.c     |    2 -
 drivers/staging/rdma/hfi1/driver.c   |    2 -
 drivers/staging/rdma/hfi1/hfi.h      |    6 +-
 drivers/staging/rdma/hfi1/init.c     |    6 +-
 drivers/staging/rdma/hfi1/mad.c      |   93 ++++++++++++++++++++++------------
 drivers/staging/rdma/hfi1/mmu_rb.c   |   22 ++++----
 drivers/staging/rdma/hfi1/pio.h      |    8 +--
 drivers/staging/rdma/hfi1/platform.c |   21 +++++---
 drivers/staging/rdma/hfi1/platform.h |    1 
 drivers/staging/rdma/hfi1/qp.c       |    1 
 drivers/staging/rdma/hfi1/sdma.c     |    2 -
 drivers/staging/rdma/hfi1/sysfs.c    |    4 +
 drivers/staging/rdma/hfi1/trace.h    |    2 -
 drivers/staging/rdma/hfi1/verbs.c    |    2 -
 include/rdma/ib_pack.h               |    5 ++
 17 files changed, 128 insertions(+), 82 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
