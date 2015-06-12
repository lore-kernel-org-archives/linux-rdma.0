From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] NFSoRDMA Client Changes for 4.2
Date: Fri, 12 Jun 2015 15:15:42 -0400
Message-ID: <557B2FDE.6010907@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Trond,

The following changes since commit d4a4f75cd8f29cd9464a5a32e9224a91571d6649:

  Linux 4.1-rc7 (2015-06-07 20:23:50 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-for-4.2

for you to fetch changes up to 40c6ed0c8a7f2c5d67f5d6774bbce230a42176db:

  xprtrdma: Reduce per-transport MR allocation (2015-06-12 13:10:37 -0400)


Thanks,
Anna

----------------------------------------------------------------
NFS: NFSoRDMA Client Changes

These patches continue to build up for improving the rsize and wsize that the
NFS client uses when talking over RDMA.  In addition, these patches also add
in scalability enhancements and other bugfixes.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

----------------------------------------------------------------
Chuck Lever (14):
      xprtrdma: Warn when there are orphaned IB objects
      xprtrdma: Replace rpcrdma_rep::rr_buffer with rr_rxprt
      xprtrdma: Remove rr_func
      xprtrdma: Use ib_device pointer safely
      xprtrdma: Introduce helpers for allocating MWs
      xprtrdma: Acquire FMRs in rpcrdma_fmr_register_external()
      xprtrdma: Introduce an FRMR recovery workqueue
      xprtrdma: Acquire MRs in rpcrdma_register_external()
      xprtrdma: Remove unused LOCAL_INV recovery logic
      xprtrdma: Remove ->ro_reset
      xprtrdma: Remove rpcrdma_ia::ri_memreg_strategy
      xprtrdma: Split rb_lock
      xprtrdma: Stack relief in fmr_op_map()
      xprtrdma: Reduce per-transport MR allocation

 include/linux/sunrpc/xprtrdma.h    |   3 ++-
 net/sunrpc/xprtrdma/fmr_ops.c      | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------
 net/sunrpc/xprtrdma/frwr_ops.c     | 227 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
 net/sunrpc/xprtrdma/physical_ops.c |  14 ++------------
 net/sunrpc/xprtrdma/rpc_rdma.c     |   8 ++------
 net/sunrpc/xprtrdma/transport.c    |  17 +++++++++--------
 net/sunrpc/xprtrdma/verbs.c        | 257 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |  38 +++++++++++++++++++++++-------------
 8 files changed, 345 insertions(+), 339 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
