From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/10] IB/hfi1,rdmavt: Another set of fixes for 4.7
Date: Tue, 24 May 2016 12:50:03 -0700
Message-ID: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Doug, here are a few more fixes that we would like to get into 4.7 if possible.
These apply on top of the series to get the driver out of staging. I can always
respin if needed.

Included here is one patch which has a stable tag for 4.6 since it fixes a hard
lockup. The others are minor bug fixes.

Patches can also be viewed in my repo at:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Dean Luick (2):
      IB/hfi1: Add a retry for the first-time QSFP access
      IB/hfi1: Correct 8051 link parameter settings

Jianxin Xiong (2):
      IB/hfi1,qib: Add ieth to the packet header definitions
      IB/hfi1: Add tracing support for send with invalidate opcode

Jubin John (2):
      IB/hfi1: Fix pio map initialization
      IB/hfi1: Fix credit return threshold adjustment

Mike Marciniszyn (3):
      IB/hfi1: Fix hard lockup due to not using save/restore spin lock
      IB/rdmavt: Max atomic value should be a u8
      IB/rdamvt: Fix rdmavt s_ack_queue sizing

Sebastian Sanchez (1):
      IB/hfi1: Update pkey table properly after link down or FM start


 drivers/infiniband/hw/hfi1/chip.c     |   16 ++++++++++++++--
 drivers/infiniband/hw/hfi1/chip.h     |    6 ++++++
 drivers/infiniband/hw/hfi1/mad.c      |    6 ++++++
 drivers/infiniband/hw/hfi1/pio.c      |   24 ++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/platform.c |    6 ++++--
 drivers/infiniband/hw/hfi1/qp.c       |    5 +++--
 drivers/infiniband/hw/hfi1/qsfp.c     |   16 ++++++++++++++++
 drivers/infiniband/hw/hfi1/trace.c    |    7 +++++++
 drivers/infiniband/hw/hfi1/trace.h    |    2 ++
 drivers/infiniband/hw/hfi1/verbs.c    |    2 ++
 drivers/infiniband/hw/hfi1/verbs.h    |    1 +
 drivers/infiniband/hw/qib/qib_verbs.h |    1 +
 drivers/infiniband/sw/rdmavt/qp.c     |   22 ++++++++++++++++++++--
 include/rdma/rdma_vt.h                |   13 +++++++++++--
 include/rdma/rdmavt_qp.h              |    5 +----
 15 files changed, 114 insertions(+), 18 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
