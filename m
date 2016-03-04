From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 00/11] NFS/RDMA client patches for v4.6
Date: Fri, 04 Mar 2016 11:27:17 -0500
Message-ID: <20160304162447.13590.9524.stgit@oracle120-ib.cthon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

These are ready for you to take.

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


Changes since v2:
- Rebased on 4.5-rc6
- Simplified reporting of flushed completions
- Tested at Connectathon

Changes since v1:
- Rebased on 4.5-rc4
- Fix NFSv4.1-related 4.5-rc regression
- Addressed review comments from Devesh Sharma
- Dropped invalidate-on-signal patch
- Fix hang in frwr_op_unmap_sync
- Various clean ups

---

Chuck Lever (11):
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
 net/sunrpc/xprtrdma/fmr_ops.c      |   28 ++---
 net/sunrpc/xprtrdma/frwr_ops.c     |  143 ++++++++++++++++---------
 net/sunrpc/xprtrdma/physical_ops.c |    1 
 net/sunrpc/xprtrdma/rpc_rdma.c     |  108 ++++++++++++++-----
 net/sunrpc/xprtrdma/verbs.c        |  204 +++++++++++-------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |   14 +-
 8 files changed, 259 insertions(+), 253 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
