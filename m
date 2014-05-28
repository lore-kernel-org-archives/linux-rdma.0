From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 00/24] Series short description
Date: Wed, 28 May 2014 10:31:51 -0400
Message-ID: <20140528142521.23214.39655.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Updates since v4:

- Rebased on v3.15-rc7
- Addressed Trond's review comment in "Reset connection timeout..."
- Wake up RPC tasks only when cwnd is growing in "Avoid deadlock when..."
- Fix patch description of "Remove MEMWINDOWS registration modes"

Pull from the "nfs-rdma-client" branch of my git repo:

  git://git.linux-nfs.org/projects/cel/cel-2.6.git

---

Allen Andrews (1):
      nfs-rdma: Fix for FMR leaks

Chuck Lever (21):
      xprtrdma: Disconnect on registration failure
      xprtrdma: Remove BUG_ON() call sites
      xprtrdma: Avoid deadlock when credit window is reset
      SUNRPC: Move congestion window constants to header file
      xprtrdma: Reset connection timeout after successful reconnect
      xprtrdma: Use macros for reconnection timeout constants
      xprtrdma: Remove Tavor MTU setting
      xprtrdma: Ensure ia->ri_id->qp is not NULL when reconnecting
      xprtrdma: Reduce the number of hardway buffer allocations
      xprtrdma: Limit work done by completion handler
      xprtrmda: Reduce calls to ib_poll_cq() in completion handlers
      xprtrmda: Reduce lock contention in completion handlers
      xprtrdma: Split the completion queue
      xprtrdma: Make rpcrdma_ep_destroy() return void
      xprtrdma: Simplify rpcrdma_deregister_external() synopsis
      xprtrdma: mount reports "Invalid mount option" if memreg mode not supported
      xprtrdma: Fall back to MTHCAFMR when FRMR is not supported
      xprtrdma: Remove REGISTER memory registration mode
      xprtrdma: Remove MEMWINDOWS registration modes
      xprtrdma: Remove BOUNCEBUFFERS memory registration mode
      xprtrdma: RPC/RDMA must invoke xprt_wake_pending_tasks() in process context

Shirley Ma (1):
      xprtrdma: Allocate missing pagelist

Steve Wise (1):
      xprtrdma: mind the device's max fast register page list depth


 include/linux/sunrpc/xprt.h     |    6 
 net/sunrpc/xprt.c               |   28 -
 net/sunrpc/xprtrdma/rpc_rdma.c  |  119 +++---
 net/sunrpc/xprtrdma/transport.c |   90 ++---
 net/sunrpc/xprtrdma/verbs.c     |  753 ++++++++++++++++-----------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |   17 +
 6 files changed, 411 insertions(+), 602 deletions(-)

-- 
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
