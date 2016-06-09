From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/10] IB/hfi1,qib,rdmavt: Fixes for 4.7 rc
Date: Thu, 09 Jun 2016 07:51:01 -0700
Message-ID: <20160609144644.12702.4832.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Doug, here are some fixes which we would like to land in 4.7 RC. These are
bug fixes. Some more serious than others.

Patches apply on your k.o/for-4.7-rc tree.

Patches can also be viewed in my repo and have passed 0day builds:
https://github.com/ddalessa/kernel/tree/for-4.7

---

Brian Welty (2):
      IB/rdmavt: Correct required callback functions for MODIFY_QP
      IB/rdmavt: Correct warning during QPN allocation

Ira Weiny (2):
      IB/hfi1: Prevent context loss
      IB/qib: Prevent context loss

Jubin John (2):
      IB/hfi1: Fix credit return threshold adjustment
      IB/hfi1: Increase packet egress timeout

Sebastian Sanchez (2):
      IB/hfi1: Remove FULL_MGMT_P_KEY from pkey table at link up
      IB/hfi1: Send a pkey change event on driver pkey update

Tadeusz Struk (2):
      IB/hfi1: Fix potential NULL ptr dereference
      IB/hfi1: Fix potential buffer overflow


 drivers/infiniband/hw/hfi1/chip.c        |   28 ++++++++++++++++++++--------
 drivers/infiniband/hw/hfi1/file_ops.c    |    3 +++
 drivers/infiniband/hw/hfi1/init.c        |    2 +-
 drivers/infiniband/hw/hfi1/mad.c         |   19 ++++++++++++-------
 drivers/infiniband/hw/hfi1/mad.h         |    2 ++
 drivers/infiniband/hw/hfi1/pio.c         |   26 +++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/qsfp.c        |    3 ++-
 drivers/infiniband/hw/qib/qib_file_ops.c |    5 +++++
 drivers/infiniband/sw/rdmavt/qp.c        |    4 ++--
 drivers/infiniband/sw/rdmavt/vt.c        |    4 +---
 10 files changed, 71 insertions(+), 25 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
