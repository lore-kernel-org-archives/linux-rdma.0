From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/12] NFS/RDMA client patches for v4.6
Date: Thu, 18 Feb 2016 12:29:54 -0500
Message-ID: <20160218172449.14009.47311.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There continues to be some fallout from enabling NFSv4.1/RDMA, and
from converting the reply handler to use a work queue.  This series
includes some bug fixes for those issues.

Logic to handle the RPC-over-RDMA RDMA_ERROR message type is also
introduced into the RPC reply handler.

Also included is a patch set to convert xprtrdma to use the new core
CQ API.

Available in the "nfs-rdma-for-4.6" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.6


Changes since v1:
- Rebased on 4.5-rc4
- Fix NFSv4.1-related 4.5-rc regression
- Addressed review comments from Devesh Sharma
- Dropped invalidate-on-signal patch
- Fix hang in frwr_op_unmap_sync
- Various clean ups

---

Chuck Lever (12):
      xprtrdma: rpcrdma_bc_receive_call() should init rq_private_buf.len
      xprtrdma: Clean up unused RPCRDMA_INLINE_PAD_THRESH macro
      xprtrdma: Clean up physical_op_map()
      xprtrdma: Clean up dprintk format string containing a newline
      xprtrdma: Segment head and tail XDR buffers on page boundaries
      xprtrdma: Do not wait if ib_post_send() fails
      rpcrdma: Add RPCRDMA_HDRLEN_ERR
      xprtrdma: Properly handle RDMA_ERROR replies
      xprtrdma: Serialize credit accounting again
      xprtrdma: Use new CQ API for RPC-over-RDMA client receive CQs
      xprtrdma: Use an anonymous union in struct rpcrdma_mw
      xprtrdma: Use new CQ API for RPC-over-RDMA client send CQs


 include/linux/sunrpc/rpc_rdma.h    |   12 +-
 include/linux/sunrpc/xprtrdma.h    |    2 
 net/sunrpc/xprtrdma/backchannel.c  |    2 
 net/sunrpc/xprtrdma/fmr_ops.c      |   28 ++---
 net/sunrpc/xprtrdma/frwr_ops.c     |  143 ++++++++++++++++---------
 net/sunrpc/xprtrdma/physical_ops.c |    1 
 net/sunrpc/xprtrdma/rpc_rdma.c     |  108 ++++++++++++++-----
 net/sunrpc/xprtrdma/verbs.c        |  204 +++++++++++-------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |   14 +-
 9 files changed, 261 insertions(+), 253 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
