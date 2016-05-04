From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/9] NFS/RDMA server patches proposed for v4.7
Date: Wed, 04 May 2016 10:52:38 -0400
Message-ID: <20160504144730.6602.89073.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Shirley's server-side IPv6 patch, and a number of minor fixes and
clean-ups found during code review.

Available in the "nfsd-rdma-for-4.7" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.7


Changes since v1:
- Rebased on v4.6-rc6
- Patch converting CQs to workqueue has been dropped for now
- A number of clean-ups

---

Chuck Lever (8):
      svcrdma: Do not add XDR padding to xdr_buf page vector
      svcrdma: svc_rdma_put_context() is invoked twice in Send error path
      svcrdma: Remove superfluous line from rdma_read_chunks()
      svcrdma: Post Receives only for forward channel requests
      svcrdma: Drain QP before freeing svcrdma_xprt
      svcrdma: Eliminate code duplication in svc_rdma_recvfrom()
      svcrdma: Generalize svc_rdma_xdr_decode_req()
      svcrdma: Simplify the check for backward direction replies

Shirley Ma (1):
      svcrdma: Support IPv6 with NFS/RDMA


 fs/nfsd/nfs3xdr.c                        |    2 -
 include/linux/sunrpc/svc_rdma.h          |    2 -
 net/sunrpc/xprtrdma/svc_rdma_marshal.c   |   32 ++++++++++-----
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   65 ++++++++----------------------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   28 ++++++-------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   17 +++++++-
 6 files changed, 70 insertions(+), 76 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
