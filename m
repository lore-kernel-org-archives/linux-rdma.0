From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] bug fixes ocrdma AH
Date: Fri, 5 Sep 2014 15:09:47 +0530
Message-ID: <b980a777-a4c0-446e-ab36-36fbefc3da0e@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series one major and one minor fixes.
the first one fixes the broken UD path from user space
seconde one fixes query-ah.

Devesh Sharma (2):
  RDMA/ocrdma: resolve L2 address when creating user AH
  RDMA/ocrdma: use right macro in query ah

 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |   43 +++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 12 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
