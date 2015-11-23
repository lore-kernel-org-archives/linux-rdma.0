From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/9] NFS/RDMA client patches for 4.5
Date: Mon, 23 Nov 2015 17:13:48 -0500
Message-ID: <20151123220627.32702.62667.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For 4.5, I'd like to address the send queue accounting and
invalidation/unmap ordering issues Jason brought up a couple of
months ago. Here's a first shot at that.

Also available in the "nfs-rdma-for-4.5" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.5

---

Chuck Lever (9):
      xprtrdma: Add a safety margin for receive buffers
      xprtrdma: Move struct ib_send_wr off the stack
      xprtrdma: Introduce ro_unmap_sync method
      xprtrdma: Add ro_unmap_sync method for FRWR
      xprtrdma: Add ro_unmap_sync method for FMR
      xprtrdma: Add ro_unmap_sync method for all-physical registration
      SUNRPC: Introduce xprt_commit_rqst()
      xprtrdma: Invalidate in the RPC reply handler
      xprtrdma: Revert commit e7104a2a9606 ('xprtrdma: Cap req_cqinit').


 include/linux/sunrpc/xprt.h        |    1 
 net/sunrpc/xprt.c                  |   14 +++
 net/sunrpc/xprtrdma/fmr_ops.c      |   64 +++++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c     |  175 +++++++++++++++++++++++++++++++-----
 net/sunrpc/xprtrdma/physical_ops.c |   13 +++
 net/sunrpc/xprtrdma/rpc_rdma.c     |   21 ++++
 net/sunrpc/xprtrdma/verbs.c        |   12 +-
 net/sunrpc/xprtrdma/xprt_rdma.h    |   17 ++-
 8 files changed, 284 insertions(+), 33 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
