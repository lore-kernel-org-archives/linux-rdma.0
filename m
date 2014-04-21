From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 00/17] NFS/RDMA patches for review
Date: Mon, 21 Apr 2014 18:00:45 -0400
Message-ID: <20140421214442.12569.8950.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After folks tried out RPCRDMA_REGISTER support as I requested in
the cover letter of the last version of this series, existing
problems were discovered already in the upstream kernel, starting
with the problem addressed by Steve's LOCAL_WRITE patch from last
week.

Rather than address them, this series simply removes what is now an
obsolete memory registration mode.  For some time, HCAs that do not
support FRMR fall back on ALLPHYSICAL mode, leaving REGISTER to
gather bit rot.

In addition I added three patches that implement improvements to
the new split completion handler, based on suggestions from Sagi
Grimberg.

Test and review the "nfs-rdma-client" branch:

  git://git.linux-nfs.org/projects/cel/cel-2.6.git

Thanks!

---

Allen Andrews (1):
      nfs-rdma: Fix for FMR leaks

Chuck Lever (15):
      xprtrdma: Reduce the number of hardway buffer allocations
      xprtrdma: Limit work done by completion handler
      xprtrmda: Reduce calls to ib_poll_cq() in completion handlers
      xprtrmda: Reduce lock contention in completion handlers
      xprtrdma: Split the completion queue
      xprtrdma: Make rpcrdma_ep_destroy() return void
      xprtrdma: Simplify rpcrdma_deregister_external() synopsis
      xprtrdma: Add CONFIG setting that can disable ALLPHYSICAL
      xprtrdma: mount reports "Invalid mount option" if memreg mode not supported
      xprtrdma: Fall back to MTHCAFMR when FRMR is not supported
      xprtrdma: Remove REGISTER memory registration mode
      xprtrdma: Remove MEMWINDOWS registration modes
      xprtrdma: Remove BOUNCEBUFFERS memory registration mode
      xprtrdma: RPC/RDMA must invoke xprt_wake_pending_tasks() in process context
      xprtrdma: Enable RDMA pad optimization by default

Steve Wise (1):
      xprtrdma: mind the device's max fast register page list depth


 include/linux/sunrpc/xprtrdma.h |    2 
 net/sunrpc/Kconfig              |   14 +
 net/sunrpc/xprtrdma/rpc_rdma.c  |   63 +---
 net/sunrpc/xprtrdma/transport.c |   34 --
 net/sunrpc/xprtrdma/verbs.c     |  694 +++++++++++++++------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h |   16 +
 6 files changed, 316 insertions(+), 507 deletions(-)

-- 
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
