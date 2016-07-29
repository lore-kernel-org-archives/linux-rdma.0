From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 0/2] iw_cxgb4 fixes for 4.8
Date: Fri, 29 Jul 2016 13:29:02 -0700
Message-ID: <cover.1469824142.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Doug, here are few iw_cxgb4 fixes that I would
like to hit 4.8.

Thanks,

Steve.
---

Steve Wise (2):
  iw_cxgb4: stop MPA_REPLY timer when disconnecting
  iw_cxgb4: explicitly move the qp to ERROR state during flush

 drivers/infiniband/hw/cxgb4/cm.c | 12 +++++++++++-
 drivers/infiniband/hw/cxgb4/qp.c |  9 +++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
