From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/3] NFS/RDMA client patches for v4.15
Date: Mon, 09 Oct 2017 12:03:17 -0400
Message-ID: <20171009155524.18726.32086.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

Here is the first set of NFS/RDMA client patches for v4.15. These
close a window where async RPCs that never receive a Reply will
terminate but let the memory invalidation happen later.

I don't think there was much of an exposure here. Hard async RPCs
typically just hang anyway, they can't be interrupted.

Please consider these patches for v4.15.

---

Chuck Lever (3):
      xprtrdma: Don't defer fencing an async RPC's chunks
      xprtrdma: Use ro_unmap_sync in xprt_rdma_send_request
      xprtrdma: Remove ro_unmap_safe


 net/sunrpc/xprtrdma/fmr_ops.c   |   19 -------------------
 net/sunrpc/xprtrdma/frwr_ops.c  |   19 -------------------
 net/sunrpc/xprtrdma/transport.c |    5 +++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 --
 4 files changed, 3 insertions(+), 42 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
