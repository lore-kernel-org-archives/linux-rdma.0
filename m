From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 0/7] RDMA/cxgb4: Fixes and Enhancements
Date: Fri, 11 Mar 2011 16:29:40 -0600
Message-ID: <20110311222826.16418.43582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Roland,

Here are some bug fixes and enhancements for the next merge.

---

Steve Wise (7):
      RDMA/cxgb4: Dispatch FATAL event on EEH errors.
      RDMA/cxgb4: Do CIDX_INC updates every 1/16 cq depth cqe reaps.
      RDMA/cxgb4: remove db_drop_task.
      RDMA/cxgb4: Use ULP_MODE_TCPDDP.
      RDMA/cxgb4: Enable on-chip SQ support by default.
      RDMA/cxgb4: Turn on delayed ACK.
      RDMA/cxgb4: debugfs dump_qp() updates.


 drivers/infiniband/hw/cxgb4/cm.c       |    6 ++++--
 drivers/infiniband/hw/cxgb4/device.c   |   24 ++++++++++++++++++------
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |    1 -
 drivers/infiniband/hw/cxgb4/qp.c       |    4 ++--
 drivers/infiniband/hw/cxgb4/t4.h       |    8 +++++++-
 drivers/net/cxgb4/t4_msg.h             |    1 +
 6 files changed, 32 insertions(+), 12 deletions(-)

-- 
Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
