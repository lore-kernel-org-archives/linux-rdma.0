From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 0/4] RDMA/cxgb4: bug fixes.
Date: Fri, 23 Jul 2010 14:12:21 -0500
Message-ID: <20100723191221.15832.79704.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are some bug fixes for 2.6.36.

Steve Wise (4):
      RDMA/cxgb4: Add timeouts when waiting for FW responses.
      RDMA/cxgb4: Set/Reset the EP timer inside EP lock.
      RDMA/cxgb4: Use correct control txq.
      RDMA/cxgb4: Fix race in fini path.


 drivers/infiniband/hw/cxgb4/cm.c       |   69 ++++++++++++++++----------------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 
 drivers/infiniband/hw/cxgb4/qp.c       |   14 +++---
 3 files changed, 43 insertions(+), 41 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
