From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 0/2] update ocrdma to dual license
Date: Fri, 12 Jun 2015 22:15:03 +0530
Message-ID: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A series to update the license from GPL to GPL/Dual-BSD licensing
for ocrdma source.

Devesh Sharma (2):
  RDMA/ocrdma: update license from gpl to dual license
  RDMA/ocrdma: update module license to dual license

 drivers/infiniband/hw/ocrdma/ocrdma.h       |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   55 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   53 ++++++++++++++++---------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   53 ++++++++++++++++---------
 12 files changed, 409 insertions(+), 229 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
