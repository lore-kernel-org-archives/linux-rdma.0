From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] Last NFS/RDMA client patches for v4.15
Date: Mon, 30 Oct 2017 16:21:40 -0400
Message-ID: <20171030201903.8146.45897.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here's my final set of NFS/RDMA client patches for v4.15.

Three of these are clean up patches. The first patch is an important
change, however.

In the earlier set of patches, I changed the Receive CQ to run in
workqueue context. Here, I change the Send CQ to also run in
workqueue context.

In addition, I move it to a different compvec than the Receive CQ.
My performance measurements show that the two completion handlers
interfere with each other if they run in the same workqueue thread.

Please consider this set for v4.15.


Changes since the initial posting:
- Added Reviewed-by: tags to three of these
- Addressed Devesh's patch description comment

---

Chuck Lever (4):
      xprtrdma: Put Send CQ in IB_POLL_WORKQUEUE mode
      rpcrdma: Remove C structure definitions of XDR data items
      xprtrdma: Remove include for linux/prefetch.h
      xprtrdma: Update copyright notices


 include/linux/sunrpc/rpc_rdma.h |   60 +--------------------------------------
 net/sunrpc/xprtrdma/rpc_rdma.c  |    7 +++--
 net/sunrpc/xprtrdma/transport.c |    1 +
 net/sunrpc/xprtrdma/verbs.c     |    4 +--
 net/sunrpc/xprtrdma/xprt_rdma.h |    7 +----
 5 files changed, 9 insertions(+), 70 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
