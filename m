From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 00/11] ocrdma bug fixes
Date: Sat, 16 May 2015 13:21:38 +0530
Message-ID: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch series includes fixes for few issues found in 
testing and added few info messages for debugging.
Also, added some debug statistics counters and
updated the driver version.

Please apply.

Devesh Sharma (3):
  RDMA/ocrdma: Report EQ full fatal error
  RDMA/ocrdma: Fix QP state transition in destroy_qp
  RDMA/ocrdma: Use VID 0 if PFC is enabled and vlan is not configured

Meghana Cheripady (1):
  RDMA/ocrdma: Add CQ usage statistics counters

Mitesh Ahuja (3):
  RDMA/ocrdma: Fix the request length for RDMA_QUERY_QP mailbox command
    to FW.
  RDMA/ocrdma: Prevent allocation of DPP PDs if FW doesnt support it
  RDMA/ocrdma: Fix dmac resolution for link local address

Naga Irrinki (1):
  RDMA/ocrdma: Fail connection for MTU lesser than 512

Selvin Xavier (3):
  RDMA/ocrdma: Fix EQ destroy failure during driver unload
  RDMA/ocrdma: Prevent returning failures in the resource destroy path
  RDMA/ocrdma: Update ocrdma version number

 drivers/infiniband/hw/ocrdma/ocrdma.h       |  6 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 12 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 86 +++++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  9 +++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 15 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 31 ++++++-----
 6 files changed, 111 insertions(+), 48 deletions(-)

-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
