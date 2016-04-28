From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/10] NFS/RDMA server updates proposed for v4.7
Date: Thu, 28 Apr 2016 11:14:27 -0400
Message-ID: <20160428150915.13068.94602.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Shirley's server-side IPv6 patch, a number of minor fixes and
clean-ups found during code review, and one experimental patch.

The last patch in the series changes the server's send CQ and
receive CQ from soft IRQ to workqueue. There is a measurable
performance degradation documented in the patch description.
Maybe I've missed something? But for now this patch is for
review and discussion only.

Available in the "nfsd-rdma-for-4.7" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.7

---

Chuck Lever (9):
      svcrdma: Do not add XDR padding to xdr_buf page vector
      svcrdma: svc_rdma_put_context() is invoked twice in Send error path
      svcrdma: Remove superfluous line from rdma_read_chunks()
      svcrdma: Post Receives only for forward channel requests
      svcrdma: Drain QP before freeing svcrdma_xprt
      svcrdma: Eliminate code duplication in svc_rdma_recvfrom()
      svcrdma: Generalize svc_rdma_xdr_decode_req()
      svcrdma: Simplify the check for backward direction replies
      svcrdma: Switch CQs from IB_POLL_SOFTIRQ to IB_POLL_WORKQUEUE

Shirley Ma (1):
      svcrdma: Support IPv6 with NFS/RDMA


 fs/nfsd/nfs3xdr.c                        |    2 -
 include/linux/sunrpc/svc_rdma.h          |    2 -
 net/sunrpc/xprtrdma/svc_rdma_marshal.c   |   31 +++++++++----
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |   71 +++++++++---------------------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   28 +++++-------
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   43 ++++++++++++------
 6 files changed, 85 insertions(+), 92 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
