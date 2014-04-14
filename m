From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] NFS/RDMA patches for review
Date: Mon, 14 Apr 2014 18:22:23 -0400
Message-ID: <20140414220041.20646.63991.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm interested in comments and testing, especially with
RPCRDMA_REGISTER mode because I don't have that capability set up on
my client yet.

These apply on top of Allen Andrews' and Steve Wise's recent patches,
which are included in the nfs-rdma-client topic branch at

  git://git.linux-nfs.org/projects/cel/cel-2.6.git

---

Chuck Lever (8):
      xprtrdma: Reduce the number of hardway buffer allocations
      xprtrdma: Split the completion queue
      xprtrdma: Make rpcrdma_ep_destroy() return void
      xprtrdma: Simplify rpcrdma_deregister_external() synopsis
      xprtrdma: Remove support for MEMWINDOWS registration mode
      xprtrdma: Disable ALLPHYSICAL mode by default
      xprtrdma: Remove BOUNCEBUFFERS memory registration mode
      xprtrdma: RPC/RDMA must invoke xprt_wake_pending_tasks() in process context


 include/linux/sunrpc/xprtrdma.h |    3 
 net/sunrpc/Kconfig              |   15 +
 net/sunrpc/xprtrdma/rpc_rdma.c  |   56 +----
 net/sunrpc/xprtrdma/transport.c |   32 ---
 net/sunrpc/xprtrdma/verbs.c     |  457 ++++++++++++++-------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |   10 -
 6 files changed, 195 insertions(+), 378 deletions(-)

-- 
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
