From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 00/14] Server-side NFS/RDMA changes for v4.12
Date: Thu, 16 Mar 2017 11:52:25 -0400
Message-ID: <20170316154132.4482.56769.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series overhauls the "reply send" side of the RPC-over-RDMA
transport to use the new rdma_rw API. Benefits include:

<> Better code modularity, less code duplication with other ULPs

<> Ability for svcrdma to use any registration mode for RDMA Writes

<> Correctly handles RPCs that have both a Write and a Reply chunk

<> Much better handling of Write chunk overrun


No significant performance changes noticed with this overhaul.

Additions outweigh deletions for two reasons: there are more large
block comments in the new code, and code to handle "call receive"
is also added in svc_rdma_rw.c, but not used yet.


Available in the "nfsd-rdma-for-4.12" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.12

---

Chuck Lever (14):
      svcrdma: Move send_wr to svc_rdma_op_ctxt
      svcrdma: Add svc_rdma_map_reply_hdr()
      svcrdma: Eliminate RPCRDMA_SQ_DEPTH_MULT
      svcrdma: Add helper to save pages under I/O
      svcrdma: Introduce local rdma_rw API helpers
      svcrdma: Use rdma_rw API in RPC reply path
      svcrdma: Clean up RDMA_ERROR path
      svcrdma: Report Write/Reply chunk overruns
      svcrdma: Clean up RPC-over-RDMA backchannel reply processing
      svcrdma: Reduce size of sge array in struct svc_rdma_op_ctxt
      svcrdma: Remove old RDMA Write completion handlers
      svcrdma: Remove the req_map cache
      svcrdma: Clean out old XDR encoders
      svcrdma: Clean up svc_rdma_post_recv() error handling


 include/linux/sunrpc/rpc_rdma.h            |    3 
 include/linux/sunrpc/svc_rdma.h            |   81 +--
 net/sunrpc/xprtrdma/Makefile               |    2 
 net/sunrpc/xprtrdma/svc_rdma.c             |    8 
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   74 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |  148 +++--
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   80 ++-
 net/sunrpc/xprtrdma/svc_rdma_rw.c          |  785 +++++++++++++++++++++++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |  872 ++++++++++++----------------
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |  176 ++----
 10 files changed, 1438 insertions(+), 791 deletions(-)
 create mode 100644 net/sunrpc/xprtrdma/svc_rdma_rw.c

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
