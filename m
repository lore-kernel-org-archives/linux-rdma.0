From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 0/4] RDMA/ocrdma: Add RoCE-v2 support
Date: Thu, 28 Jan 2016 08:59:55 -0500
Message-ID: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series adds support for RoCE-v2 protocol
on Avago's RoCE enabled adapters.

Devesh Sharma (3):
  RDMA/ocrdma: Support RoCE-v2 in the UD path
  RDMA/ocrdma: Support RoCE-v2 in the RC path
  RDMA/ocrdma: Support user AH creation for RoCE-v2

Somnath Kotur (1):
  RDMA/ocrdma: Export udp encapsulation capability

 drivers/infiniband/hw/ocrdma/ocrdma.h       |  8 +++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 75 ++++++++++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 26 +++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  4 ++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 16 ++++--
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 22 +++++++--
 7 files changed, 134 insertions(+), 22 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
