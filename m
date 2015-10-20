From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-next 0/5] RDMA/ocrdma: bug fixes
Date: Tue, 20 Oct 2015 14:17:55 +0530
Message-ID: <1445330880-3912-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series includs fix in CQ door bell logic, check to prevent
driver crash and code cleanup.
Please apply.

Devesh Sharma (1):
  RDMA/ocrdma: Prevent CQ-Doorbell floods

Naga Irrinki (1):
  RDMA/ocrdma: Check resource ids received in Async CQE

Selvin Xavier (3):
  RDMA/ocrdma: Cleanup unused device list and rcu variables
  RDMA/ocrdma: Avoid a possible crash in ocrdma_rem_port_stats
  RDMA/ocrdma: Bump up ocrdma version number to 11.0.0.0

 drivers/infiniband/hw/ocrdma/ocrdma.h       |  3 +--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 30 +++++++++++++++++++++++++----
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  | 16 ++-------------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 11 +++--------
 5 files changed, 33 insertions(+), 29 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
