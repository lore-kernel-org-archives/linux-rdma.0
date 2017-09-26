From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next v2 0/2] iw_cxgb4 pr_debug() changes for 4.14-rc
Date: Tue, 26 Sep 2017 23:10:08 +0530
Message-ID: <1506447610-12909-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,
Previous submission of these changes wont apply clean above "for-next"
branch due to the recent patches of Steve pulled into it. Current
series is generated on top of your "for-next" branch.
Please consider these for smoother application of subsequent patches.

Changes since original submission
- Make patches on top of "for-next" branch.

Thanks,
Bharat.

Potnuri Bharat Teja (2):
  iw_cxgb4: Remove __func__ parameter from pr_debug()
  iw_cxgb4: change pr_debug to appropriate log level

 drivers/infiniband/hw/cxgb4/cm.c       | 244 ++++++++++++++++-----------------
 drivers/infiniband/hw/cxgb4/cq.c       |  50 +++----
 drivers/infiniband/hw/cxgb4/device.c   |  16 +--
 drivers/infiniband/hw/cxgb4/ev.c       |   2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  17 +--
 drivers/infiniband/hw/cxgb4/mem.c      |  26 ++--
 drivers/infiniband/hw/cxgb4/provider.c |  36 ++---
 drivers/infiniband/hw/cxgb4/qp.c       |  59 ++++----
 drivers/infiniband/hw/cxgb4/resource.c |  46 +++----
 drivers/infiniband/hw/cxgb4/t4.h       |  20 ++-
 10 files changed, 249 insertions(+), 267 deletions(-)

-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
