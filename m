From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/6] NFS/RDMA server patches for 4.5
Date: Mon, 07 Dec 2015 15:42:22 -0500
Message-ID: <20151207203851.12988.97804.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Here are patches to support server-side bi-directional RPC/RDMA
operation (to enable NFSv4.1 on RPC/RDMA transports). Thanks to
all who reviewed v1 and v2.

Also available in the "nfsd-rdma-for-4.5" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.5


Changes since v2:
- Rebased on v4.4-rc4
- Backchannel code in new source file to address dprintk issues
- svc_rdma_get_context() now uses a pre-allocated cache
- Dropped svc_rdma_send clean up


Changes since v1:

- Rebased on v4.4-rc3
- Removed the use of CONFIG_SUNRPC_BACKCHANNEL
- Fixed computation of forward and backward max_requests
- Updated some comments and patch descriptions
- pr_err and pr_info converted to dprintk
- Simplified svc_rdma_get_context()
- Dropped patch removing access_flags field
- NFSv4.1 callbacks tested with for-4.5 client

---

Chuck Lever (6):
      svcrdma: Do not send XDR roundup bytes for a write chunk
      svcrdma: Improve allocation of struct svc_rdma_op_ctxt
      svcrdma: Define maximum number of backchannel requests
      svcrdma: Add infrastructure to send backwards direction RPC/RDMA calls
      svcrdma: Add infrastructure to receive backwards direction RPC/RDMA replies
      xprtrdma: Add class for RDMA backwards direction transport


 include/linux/sunrpc/svc_rdma.h            |   13 +
 include/linux/sunrpc/xprt.h                |    1 
 net/sunrpc/xprt.c                          |    1 
 net/sunrpc/xprtrdma/Makefile               |    2 
 net/sunrpc/xprtrdma/svc_rdma.c             |   17 --
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |  305 ++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   51 +++++
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   68 ++++++
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |  104 ++++++++--
 net/sunrpc/xprtrdma/transport.c            |   31 ++-
 net/sunrpc/xprtrdma/xprt_rdma.h            |   15 +
 11 files changed, 559 insertions(+), 49 deletions(-)
 create mode 100644 net/sunrpc/xprtrdma/svc_rdma_backchannel.c

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
