From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/22] client-side NFS/RDMA patches proposed for v4.9
Date: Tue, 23 Aug 2016 13:52:02 -0400
Message-ID: <20160823174402.13038.84561.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The following patch series makes these changes:

- Correct use of DMA API
- Delay DMA mapping to permit device driver unload
- Introduce simple RDMA-CM private message exchange
- Support Remote Invalidation
- Support s/g list when sending RPC calls


Available in the "nfs-rdma-for-4.9" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.9


Changes since v1:
- Rebased on v4.8-rc3
- Addressed Trond's comments in 02/22 and 03/22
- Addressed kbuild robot warnings
- Gather Send patch (18/22) rewritten

---

Chuck Lever (22):
      xprtrdma: Eliminate INLINE_THRESHOLD macros
      SUNRPC: Refactor rpc_xdr_buf_init()
      SUNRPC: Generalize the RPC buffer allocation API
      SUNRPC: Generalize the RPC buffer release API
      SUNRPC: Separate buffer pointers for RPC Call and Reply messages
      SUNRPC: Add a transport-specific private field in rpc_rqst
      xprtrdma: Initialize separate RPC call and reply buffers
      xprtrdma: Use smaller buffers for RPC-over-RDMA headers
      xprtrdma: Replace DMA_BIDIRECTIONAL
      xprtrdma: Delay DMA mapping Send and Receive buffers
      xprtrdma: Eliminate "ia" argument in rpcrdma_{alloc,free}_regbuf
      xprtrdma: Simplify rpcrdma_ep_post_recv()
      xprtrdma: Move send_wr to struct rpcrdma_req
      xprtrdma: Move recv_wr to struct rpcrdma_rep
      rpcrdma: RDMA/CM private message data structure
      xprtrdma: Client-side support for rpcrdma_connect_private
      xprtrdma: Basic support for Remote Invalidation
      xprtrdma: Use gathered Send for large inline messages
      xprtrdma: Support larger inline thresholds
      xprtrmda: Report address of frmr, not mw
      xprtrdma: Rename rpcrdma_receive_wc()
      xprtrdma: Eliminate rpcrdma_receive_worker()


 include/linux/sunrpc/rpc_rdma.h            |   39 +++
 include/linux/sunrpc/sched.h               |    4 
 include/linux/sunrpc/xdr.h                 |   12 +
 include/linux/sunrpc/xprt.h                |   12 +
 include/linux/sunrpc/xprtrdma.h            |    4 
 net/sunrpc/backchannel_rqst.c              |    8 -
 net/sunrpc/clnt.c                          |   36 +--
 net/sunrpc/sched.c                         |   35 ++-
 net/sunrpc/xprt.c                          |    2 
 net/sunrpc/xprtrdma/backchannel.c          |   53 +----
 net/sunrpc/xprtrdma/fmr_ops.c              |    7 -
 net/sunrpc/xprtrdma/frwr_ops.c             |   27 ++
 net/sunrpc/xprtrdma/rpc_rdma.c             |  323 +++++++++++++++++-----------
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   19 +-
 net/sunrpc/xprtrdma/transport.c            |  202 ++++++++++--------
 net/sunrpc/xprtrdma/verbs.c                |  237 ++++++++++++---------
 net/sunrpc/xprtrdma/xprt_rdma.h            |  108 ++++++---
 net/sunrpc/xprtsock.c                      |   23 +-
 18 files changed, 677 insertions(+), 474 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
