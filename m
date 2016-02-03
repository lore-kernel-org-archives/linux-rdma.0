From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 00/10] NFS/RDMA server patches for v4.6
Date: Wed, 03 Feb 2016 10:51:21 -0500
Message-ID: <20160203154411.13868.48268.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For review.

- Fix XDR round-up in write chunks (take 3)
- Pre-allocate FRWRs when accepting a connection
- Add proper handling of bad header XDR
- Convert the server to use the new core CQ API added in v4.5.

Also available in the "nfsd-rdma-for-4.6" topic branch of this git
repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.6

---

Chuck Lever (10):
      svcrdma: Do not send XDR roundup bytes for a write chunk
      svcrdma: Make svc_rdma_get_frmr() not sleep
      svcrdma: svc_rdma_post_recv() should close connection on error
      rpcrdma: Add missing XDR union fields for RDMA errors
      svcrdma: Make RDMA_ERROR messages work
      svcrdma: Use correct XID in error replies
      svcrdma: Hook up the logic to return ERR_CHUNK
      svcrdma: Remove close_out exit path
      svcrdma: Use new CQ API for RPC-over-RDMA server receive CQs
      svcrdma: Use new CQ API for RPC-over-RDMA server send CQs


 include/linux/sunrpc/rpc_rdma.h            |   13 +
 include/linux/sunrpc/svc_rdma.h            |   18 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   15 -
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |   62 ++--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   61 +---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   79 ++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |  488 +++++++++++-----------------
 7 files changed, 346 insertions(+), 390 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
