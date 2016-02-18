From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 00/10] NFS/RDMA server patches for v4.6
Date: Thu, 18 Feb 2016 12:43:43 -0500
Message-ID: <20160218173840.12825.26769.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Two major changes: Finish server-side support for RDMA_ERROR type
messages, and convert the server's completion handlers to the new
core CQ API.

Also available in the "nfsd-rdma-for-4.6" topic branch of this git
repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.6


Changes since v2:
- Rebased on v4.5-rc4
- checkpatch.pl passes
- Fix iWARP RDMA Read path regression
- Reduce NFSv4.1 CB message size maximum in CREATE_SESSION
- Another pass at fixing Write chunk XDR padding
- Various clean ups


Changes since v1:
- Rebased on v4.5-rc3
- Patch 02/10 (pre-allocate frmrs) dropped
- Patch 04/10 replaced with more surgical patch
- Refined reporting of flushed completions
- Function names of completion methods changed to match client's
  new completion function naming convention

---

Chuck Lever (10):
      svcrdma: Do not write xdr_buf::tail in a Write chunk
      nfsd: Lower NFSv4.1 callback message size limit
      svcrdma: svc_rdma_post_recv() should close connection on error
      rpcrdma: Add RPCRDMA_HDRLEN_ERR
      svcrdma: Make RDMA_ERROR messages work
      svcrdma: Use correct XID in error replies
      svcrdma: Hook up the logic to return ERR_CHUNK
      svcrdma: Remove close_out exit path
      svcrdma: Use new CQ API for RPC-over-RDMA server receive CQs
      svcrdma: Use new CQ API for RPC-over-RDMA server send CQs


 fs/nfsd/nfs4state.c                        |   24 +-
 include/linux/sunrpc/auth.h                |    7 
 include/linux/sunrpc/rpc_rdma.h            |    1 
 include/linux/sunrpc/svc_rdma.h            |   18 +
 net/sunrpc/auth_null.c                     |    4 
 net/sunrpc/auth_unix.c                     |    6 
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   15 -
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |   64 +++-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   60 ++--
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   88 +++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |  445 +++++++++-------------------
 11 files changed, 333 insertions(+), 399 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
