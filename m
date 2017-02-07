From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/7] Server-side NFS/RDMA changes for v4.11
Date: Tue, 07 Feb 2017 11:58:06 -0500
Message-ID: <20170207165131.14422.47088.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bruce-

These are largely clean-ups, except for the last patch. Switching
completion polling from soft IRQ to a worker thread has a few
benefits:

- svcrdma's completion handlers invoke svc_xprt_put(). We discovered
recently svc_xprt_put() is supposed to be called only in a process
context. This will become more important when NFS/RDMA becomes
capable of multi-path operation.

- eventually we'd like to allocate pages for RDMA Read in the
completion handler, and not defer RDMA Read to svc_rdma_recvfrom.
GFP_KERNEL memory allocation can sleep, which is not allowed in soft
IRQ context.

- several places where BH's are disabled can be converted to simple
spin_locks.


Available in the "nfsd-rdma-for-4.11" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.11


Changes since v2:
- Rebased on v4.10-rc7
- Addressed Christoph's review comments


Changes since v1:
- Rebased on v4.10-rc6


---

Chuck Lever (7):
      svcrdma: Another sendto chunk list parsing update
      svcrdma: Clean up RPC-over-RDMA Reply header encoder
      svcrdma: Clean up RPC-over-RDMA Call header decoder
      svcrdma: Clean up backchannel send header encoding
      svcrdma: Remove unused sc_dto_q field
      svcrdma: Combine list fields in struct svc_rdma_op_ctxt
      svcrdma: Poll CQs in "workqueue" mode


 include/linux/sunrpc/rpc_rdma.h            |    9 +
 include/linux/sunrpc/svc_rdma.h            |   13 -
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |  299 ++++++++++------------------
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   20 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   22 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |   61 +++---
 7 files changed, 180 insertions(+), 261 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
