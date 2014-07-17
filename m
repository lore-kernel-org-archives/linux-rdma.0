From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [for-next 0/2] NFS/RDMA client fixes for 3.17
Date: Thu, 17 Jul 2014 19:31:35 +0530
Message-ID: <a6737d3f-aaa8-4a60-9e0f-4469713d8217@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series is test with 3.16-rc5 on top of chuck's
series "[PATCH v3 00/21] NFS/RDMA client patches for 3.17"

This series fixes hot removal of rdma provider driver and
pd_deallocation sequence.

Devesh Sharma (2):
  xprtrdma: take reference of rdma provider module
  xprtrdma: fix deallocation sequence of pd

 net/sunrpc/xprtrdma/verbs.c     |   37 +++++++++++++++++++++++++++----------
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 28 insertions(+), 10 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
