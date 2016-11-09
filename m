From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/7] server-side NFS/RDMA patches proposed for v4.10
Date: Wed, 09 Nov 2016 12:33:37 -0500
Message-ID: <20161109165814.15735.47815.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'd like to propose these server-side changes for v4.10. They
include:

- Drop connection on GSS sequence window overflow
- Remove unnecessary spin lock in the svc_rdma_send path
- A number of minor clean-ups

Available in the "nfsd-rdma-for-4.10" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.10


Meanwhile, I've been working on converting the server-side RPC/RDMA
transport to use the new generic R/W API. The prototype for the
svc_rdma_sendto path works for some forms of the transport header,
but still has a few bugs. The svc_rdma_recvfrom path will be next,
but is an even larger task.

When this work is further along I will publish a topic branch.

---

Chuck Lever (7):
      svcrdma: Clear xpt_bc_xps in xprt_setup_rdma_bc() error exit arm
      svcauth_gss: Close connection when dropping an incoming message
      svcrdma: Renovate sendto chunk list parsing
      svcrdma: Remove BH-disabled spin locking in svc_rdma_send()
      svcrdma: Remove DMA map accounting
      svcrdma: Remove svc_rdma_op_ctxt::wc_status
      svcrdma: Break up dprintk format in svc_rdma_accept()


 include/linux/sunrpc/svc_rdma.h            |    7 --
 net/sunrpc/auth_gss/svcauth_gss.c          |    2 -
 net/sunrpc/svc.c                           |   14 +++-
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    1 
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   19 +++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   99 +++++++++-------------------
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |   87 ++++++++-----------------
 7 files changed, 87 insertions(+), 142 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
