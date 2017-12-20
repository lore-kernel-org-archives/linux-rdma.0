From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 00/12] Add static trace points to xprtrdma
Date: Wed, 20 Dec 2017 16:30:15 -0500
Message-ID: <20171220210236.29321.59307.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

For v4.16, please consider this series, which adds a variety of
static trace points to the RPC-over-RDMA client implementation.

One short series of patches for v4.16 remains after this one.

---

Chuck Lever (12):
      rdma/ib: Add trace point macros to display human-readable values
      rpcrdma: infrastructure for static trace points in rpcrdma.ko
      xprtrdma: Add trace points in RPC Call transmit paths
      xprtrdma: Add trace points in the RPC Reply handler paths
      xprtrdma: Add trace points to instrument memory registration
      xprtrdma: Add trace points in reply decoder path
      xprtrdma: Add trace points to instrument memory invalidation
      xprtrdma: Add trace points to instrument MR allocation and recovery
      xprtrdma: Add trace points for connect events
      xprtrdma: Add trace points in the client-side backchannel code paths
      xprtrdma: Add trace points to instrument QP and CQ access upcalls
      xprtrdma: Instrument allocation/release of rpcrdma_req/rep objects


 include/trace/events/rdma.h       |  128 +++++
 include/trace/events/rpcrdma.h    |  889 +++++++++++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/backchannel.c |    8 
 net/sunrpc/xprtrdma/fmr_ops.c     |    4 
 net/sunrpc/xprtrdma/frwr_ops.c    |   38 +-
 net/sunrpc/xprtrdma/module.c      |   12 
 net/sunrpc/xprtrdma/rpc_rdma.c    |   72 +--
 net/sunrpc/xprtrdma/transport.c   |   24 -
 net/sunrpc/xprtrdma/verbs.c       |   70 +--
 net/sunrpc/xprtrdma/xprt_rdma.h   |    4 
 10 files changed, 1107 insertions(+), 142 deletions(-)
 create mode 100644 include/trace/events/rdma.h
 create mode 100644 include/trace/events/rpcrdma.h

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
