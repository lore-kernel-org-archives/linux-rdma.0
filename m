From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1 0/5] NFS/RDMA client patches for v4.15, pt. 2
Date: Mon, 16 Oct 2017 15:00:57 -0400
Message-ID: <20171016185641.13594.5374.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This second set of NFS/RDMA client patches addresses shortcomings in
the rpcrdma.ko RPC Reply handler path. The major piece of work here
is moving the Receive completion handler out of soft IRQ and into a
friendlier workqueue context.

Please consider these patches for v4.15.


---

Chuck Lever (5):
      xprtrdma: Throw away reply when version is unrecognized
      xprtrdma: Move decoded header fields into rpcrdma_rep
      xprtrdma: Refactor rpcrdma_reply_handler some more
      xprtrdma: Invoke rpcrdma_reply_handler directly from RECV completion
      xprtrdma: Decode credits field in rpcrdma_reply_handler


 net/sunrpc/xprtrdma/rpc_rdma.c  |  200 ++++++++++++++++++++++-----------------
 net/sunrpc/xprtrdma/verbs.c     |   33 +-----
 net/sunrpc/xprtrdma/xprt_rdma.h |   31 ++++--
 3 files changed, 138 insertions(+), 126 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
