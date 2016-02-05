From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc 0/4] ocrdma bug fixes
Date: Fri,  5 Feb 2016 20:06:36 +0530
Message-ID: <1454683001-21275-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains some of the bug fixes for ocrdma driver.

Selvin Xavier (4):
  RDMA/ocrdma: Initialize stats resources in the driver before ib device
    registration.
  RDMA/ocrdma: populate max_sge_rd in device attributes
  RDMA/ocrdma: Fix pkey_index returned by driver in rq work completion
  RDMA/ocrdma: Fixing ocrdma debugfs directory remove

 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 16 +++++-----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  7 +++----
 4 files changed, 16 insertions(+), 15 deletions(-)

-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
