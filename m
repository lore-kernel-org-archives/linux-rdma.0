From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] More NFS/RDMA client patches for v4.15
Date: Fri, 20 Oct 2017 10:47:31 -0400
Message-ID: <20171020143635.14869.15714.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

Here's my third set of NFS/RDMA client patches for v4.15. There is
one small set remaining after this one, which I can send once this
one is accepted.

This set implements strong Send Queue accounting, replacing the
current system which has been in place since the beginning with a
more reliable system that completely prevents the exposure of RPC
buffer contents after RPC completion (for example, when a Send
retransmit is necessary).

Please consider this set for v4.15.

---

Chuck Lever (9):
      xprtrdma: Clean up SGE accounting in rpcrdma_prepare_msg_sges()
      xprtrdma: Fix error handling in rpcrdma_prepare_msg_sges()
      xprtrdma: Change return value of rpcrdma_prepare_send_sges()
      xprtrdma: "Unoptimize" rpcrdma_prepare_hdr_sge()
      xprtrdma: Add data structure to manage RDMA Send arguments
      xprtrdma: Add a field of bit flags to struct rpcrdma_req
      xprtrdma: Refactor rpcrdma_deferred_completion
      xprtrdma: RPC completion should wait for Send completion
      xprtrdma: Remove atomic send completion counting


 net/sunrpc/xprtrdma/backchannel.c |    6 +
 net/sunrpc/xprtrdma/frwr_ops.c    |    8 -
 net/sunrpc/xprtrdma/rpc_rdma.c    |  178 ++++++++++++++++++++++-----------
 net/sunrpc/xprtrdma/transport.c   |   15 +--
 net/sunrpc/xprtrdma/verbs.c       |  201 +++++++++++++++++++++++++++++++++++--
 net/sunrpc/xprtrdma/xprt_rdma.h   |   79 +++++++++------
 6 files changed, 367 insertions(+), 120 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
