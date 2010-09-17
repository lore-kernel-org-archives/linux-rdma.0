From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.37 0/2] cxgb4 fixes / enhancements.
Date: Fri, 17 Sep 2010 15:40:04 -0500
Message-ID: <20100917204004.25530.62611.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are 2 more fixes for 2.6.37.  These two resolve all the known fastreg
issues for T4.

Steve Wise (2):
      RDMA/cxgb4: Fastreg NSMR fixes.
      RDMA/cxgb4: Don't set completion flag for read requests.


 drivers/infiniband/hw/cxgb4/provider.c |    4 +-
 drivers/infiniband/hw/cxgb4/qp.c       |   54 +++++++++++++++-----------------
 drivers/infiniband/hw/cxgb4/t4.h       |    4 +-
 3 files changed, 30 insertions(+), 32 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
