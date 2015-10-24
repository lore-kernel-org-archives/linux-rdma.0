From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 00/16] NFS/RDMA patches for merging into v4.4
Date: Sat, 24 Oct 2015 17:26:19 -0400
Message-ID: <20151024211707.4715.61650.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce client-side support for bi-directional RPC/RDMA.
Bi-directional RPC/RDMA is a pre-requisite for NFSv4.1 on RDMA
transports.

Handle all RPC/RDMA replies in a work queue instead of a tasklet.
This is a pre-requisite to support NFS/RDMA with Kerberos and other
important changes.

Also available in the "nfs-rdma-for-4.4" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.4


Changes since v3:
- Rebased on v4.3-rc6
- Removed partial backchannel support I accidentally introduced in
  UDP and local transports
- Addressed Trond's review comment on "Enable client side NFSv4.1
  backchannel to use other transports." Lightly tested with TCP.


Changes since v2:
- Rebased on v4.3-rc5
- Updated Reviewed-by: and Tested-by: tags
- Some interop testing at NFS Bake-a-thon


Changes since v1:
- Dropped "RFC" in Subject: line
- Rebased on v4.3-rc4 + Steve W's recent fixes
- NFS Server-side backchannel support postponed
- "xprtrdma: Replace global lkey" dropped, already merged
- Addressed Sagi's comments on "Replace send and receive arrays"
- Addressed Jason's comment regarding ib_req_notify_cq return code
- Moved RPC/RDMA reply handling into a work queue

---

Chuck Lever (16):
      xprtrdma: Enable swap-on-NFS/RDMA
      xprtrdma: Re-arm after missed events
      xprtrdma: Prevent loss of completion signals
      xprtrdma: Refactor reply handler error handling
      xprtrdma: Replace send and receive arrays
      xprtrdma: Use workqueue to process RPC/RDMA replies
      xprtrdma: Remove reply tasklet
      xprtrdma: Saving IRQs no longer needed for rb_lock
      SUNRPC: Abstract backchannel operations
      xprtrdma: Pre-allocate backward rpc_rqst and send/receive buffers
      xprtrdma: Pre-allocate Work Requests for backchannel
      xprtrdma: Add support for sending backward direction RPC replies
      xprtrdma: Handle incoming backward direction RPC calls
      svcrdma: Add backward direction service for RPC/RDMA transport
      SUNRPC: Remove the TCP-only restriction in bc_svc_process()
      NFS: Enable client side NFSv4.1 backchannel to use other transports


 fs/nfs/callback.c                        |   40 +--
 include/linux/sunrpc/bc_xprt.h           |    5 
 include/linux/sunrpc/svc_rdma.h          |    6 
 include/linux/sunrpc/xprt.h              |    8 +
 net/sunrpc/backchannel_rqst.c            |   24 +-
 net/sunrpc/svc.c                         |    5 
 net/sunrpc/xprtrdma/Makefile             |    1 
 net/sunrpc/xprtrdma/backchannel.c        |  394 +++++++++++++++++++++++++
 net/sunrpc/xprtrdma/rpc_rdma.c           |  148 ++++++---
 net/sunrpc/xprtrdma/svc_rdma.c           |    6 
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   58 ++++
 net/sunrpc/xprtrdma/transport.c          |   18 +
 net/sunrpc/xprtrdma/verbs.c              |  479 +++++++++++++++---------------
 net/sunrpc/xprtrdma/xprt_rdma.h          |   54 +++
 net/sunrpc/xprtsock.c                    |   17 +
 15 files changed, 927 insertions(+), 336 deletions(-)
 create mode 100644 net/sunrpc/xprtrdma/backchannel.c

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
