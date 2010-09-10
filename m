From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 00/11] cxgb4 fixes / enhancements.
Date: Fri, 10 Sep 2010 11:14:42 -0500
Message-ID: <20100910161442.6829.91594.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are some bug fixes and enhancements for 2.6.37.

Steve Wise (11):
      RDMA/cxgb4: Set the default TCP send window to 128KB.
      RDMA/cxgb4: Use a mutex for QP and EP state transitions.
      RDMA/cxgb4: Support on-chip SQs.
      RDMA/cxgb4: Centralize the wait logic.
      RDMA/cxgb4: debugfs files for dumping active stags.
      RDMA/cxgb4: log HW lack-of-resource errors.
      RDMA/cxgb4: Handle CPL_RDMA_TERMINATE messages.
      RDMA/cxgb4: Ignore TERMINATE CQEs
      RDMA/cxgb4: Ignore positive return values from cxgb4_*_send() functions.
      RDMA/cxgb4: Zero out ISGL padding.
      RDMA/cxgb4: Don't use null ep ptr.


 drivers/infiniband/hw/cxgb4/cm.c       |  172 +++++++++++-------------
 drivers/infiniband/hw/cxgb4/cq.c       |   24 +--
 drivers/infiniband/hw/cxgb4/device.c   |  171 +++++++++++++++++++-----
 drivers/infiniband/hw/cxgb4/ev.c       |    2 
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   68 +++++++---
 drivers/infiniband/hw/cxgb4/mem.c      |    9 -
 drivers/infiniband/hw/cxgb4/provider.c |   28 +++-
 drivers/infiniband/hw/cxgb4/qp.c       |  227 +++++++++++++++++++-------------
 drivers/infiniband/hw/cxgb4/resource.c |   62 +++++++++
 drivers/infiniband/hw/cxgb4/t4.h       |   40 +++++-
 drivers/infiniband/hw/cxgb4/user.h     |    7 +
 11 files changed, 528 insertions(+), 282 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
