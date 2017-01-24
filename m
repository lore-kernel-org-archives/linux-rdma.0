From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/7] Server-side NFS/RDMA changes for v4.11
Date: Tue, 24 Jan 2017 15:34:29 -0500
Message-ID: <20170124193242.11807.91861.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm dividing up the nfsd-rdma-rw-api series. For v4.11, here are the
first patches in that series. They should be non-controversial. The
remaining patches are still under review.

These are largely clean-ups, except for the last patch. Switching
completion polling from soft IRQ to a worker thread has a few
benefits:

- svcrdma's completion handlers invoke svc_xprt_put(). We discovered
recently svc_xprt_put() is supposed to be called only in a process
context. This will become more important when NFS/RDMA supports
multi-path.

- eventually we'd like to allocate pages for RDMA Read in the
completion handler, and not defer RDMA Read to svc_rdma_recvfrom.
Using GFP_KERNEL can sleep, which is not allowed in soft IRQ context

- several places where BH's are disabled can be converted to simple
spin_locks.


Available in the "nfsd-rdma-for-4.11" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.11


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
 include/linux/sunrpc/svc_rdma.h            |   17 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |   17 +
 net/sunrpc/xprtrdma/svc_rdma_marshal.c     |  320 +++++++++++-----------------
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |   20 +-
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |   13 -
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |   61 +++--
 7 files changed, 199 insertions(+), 258 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
