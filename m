From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/9] NFS/RDMA server patches for v4.6
Date: Mon, 08 Feb 2016 12:24:21 -0500
Message-ID: <20160208171756.13423.14384.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A round of fixes and clean-ups.

Also available in the "nfsd-rdma-for-4.6" topic branch of this git
repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.6


Changes since v1:
o Rebased on v4.5-rc3
o Patch 02/10 (pre-allocate frmrs) dropped
o Patch 04/10 replaced with more surgical patch
o Refined reporting of flushed completions
o Function names of completion methods changed to match client's
   new completion function naming convention

---

Chuck Lever (9):
      svcrdma: Do not send XDR roundup bytes for a write chunk
      svcrdma: svc_rdma_post_recv() should close connection on error
      rpcrdma: Add RPCRDMA_HDRLEN_ERR
      svcrdma: Make RDMA_ERROR messages work
      svcrdma: Use correct XID in error replies
      svcrdma: Hook up the logic to return ERR_CHUNK
      svcrdma: Remove close_out exit path
      svcrdma: Use new CQ API for RPC-over-RDMA server receive CQs
      svcrdma: Use new CQ API for RPC-over-RDMA server send CQs


 include/linux/sunrpc/rpc_rdma.h            |    1 
 include/linux/sunrpc/svc_rdma.h            |   18 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   15 -
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |   62 +++-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   61 ++--
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   79 ++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |  446 +++++++++-------------------
 7 files changed, 299 insertions(+), 383 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
