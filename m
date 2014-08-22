From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] RDMA/ocrdma: ocrdma bug fixes
Date: Fri, 22 Aug 2014 16:57:18 +0530
Message-ID: <2a431e3d-4d09-49ff-a847-d9ef08ff2932@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series has bug fixes for 3.17

Devesh Sharma (1):
  RDMA/ocrdma: add default gid at index 0

Selvin Xavier (1):
  RDMA/ocrdma: get vlan tag from ib_qp_attrs

 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |    9 +++++----
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   10 ++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
