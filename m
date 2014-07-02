From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 0/3] RDMA/ocrdma: fixes for endian ness and SL
Date: Wed, 2 Jul 2014 11:36:03 +0530
Message-ID: <7984d348-c9aa-4f4a-b7e6-97c291ba577f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series mainly contains fixes for endian ness issues and obtaining
service level from device structure. This also has a fix for reporting
correct hw_ver.

Devesh Sharma (2):
  RDMA/ocrdma: obtain sl from deivce structure
  RDMA/ocrdma: update sli data structure for endian ness

Mitesh Ahuja (1):
  RDMA/ocrdma: report asic-id in query device

 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   36 ++++---
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  147 ++++++++++++++++++++-------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 4 files changed, 134 insertions(+), 55 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
