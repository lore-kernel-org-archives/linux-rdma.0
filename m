From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [PATCH 0/2] svcrdma: NFSRDMA Server fixes for 2.6.37
Date: Tue, 12 Oct 2010 15:33:46 -0500
Message-ID: <20101012203332.22154.37230.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bruce,

These fixes are ready for 2.6.37. They fix two bugs in the server-side
NFSRDMA transport.

Thanks,
Tom
---

Tom Tucker (2):
      svcrdma: Cleanup DMA unmapping in error paths.
      svcrdma: Change DMA mapping logic to avoid the page_address kernel API


 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   19 ++++---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   82 ++++++++++++++++++++++--------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   41 +++++++--------
 3 files changed, 92 insertions(+), 50 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
