From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/10] IB/hfi1: Adaptive PIO bug fixes and a few others
Date: Mon, 07 Mar 2016 11:34:57 -0800
Message-ID: <20160307193146.4913.42900.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix some bugs with the adaptive PIO feature and enable it by default. There are
also two other minor bug fixes coming along for the ride in this series.

Patches apply on the "Bug fixes post destaging of driver" patch series which was
recently posted. Should apply cleanly on the hfi1 branch of Doug's GitHub repo.

Can be seen in my repo as well:
https://github.com/ddalessa/kernel/tree/for-4.6.

---

Alex Estrin (1):
      IB/rdmavt: Post receive for QP in ERR state

Easwar Hariharan (1):
      IB/hfi1: Improve LED beaconing

Mike Marciniszyn (8):
      IB/hfi1: Report pid in qp_stats to aid debug
      IB/hfi1: Fix issues with qp_stats print
      IB/hfi1: Add unique trace point for pio and sdma send
      IB/hfi1: Fix ordering of trace for accuracy
      IB/hfi1: Fix PIO wakeup timing hole
      IB/hfi1: Fix panic in adaptive pio
      IB/hfi1: Fix adaptive pio packet corruption
      IB/hfi1: Enable adaptive pio by default


 drivers/infiniband/hw/hfi1/driver.c |   59 +++++++++++++++--------------------
 drivers/infiniband/hw/hfi1/hfi.h    |   10 ++----
 drivers/infiniband/hw/hfi1/mad.c    |   20 ++++++------
 drivers/infiniband/hw/hfi1/pio.c    |   12 ++++---
 drivers/infiniband/hw/hfi1/qp.c     |    7 +++-
 drivers/infiniband/hw/hfi1/rc.c     |    2 +
 drivers/infiniband/hw/hfi1/trace.h  |   10 +++++-
 drivers/infiniband/hw/hfi1/verbs.c  |   42 ++++++++++++++-----------
 drivers/infiniband/sw/rdmavt/qp.c   |   34 +++++++++++++++-----
 include/rdma/rdmavt_qp.h            |    1 +
 10 files changed, 110 insertions(+), 87 deletions(-)

-- 
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
