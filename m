From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/24] NFS/RDMA client patches proposed for v4.8
Date: Tue, 14 Jun 2016 23:15:16 -0400
Message-ID: <20160615030626.14794.43805.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series implements the following:

- Fixes to FMR disconnect recovery
- Removal of the insecure ALLPHYSICAL memory registration mode
- Significant reductions in per-transport memory consumption
- Support for sec=krb5, sec=krb5i, and sec=krb5p with NFS/RDMA
  (with no performance impact on sec=sys)
- Pre-requisites for device removal support

Kerberos with NFS/RDMA is useful mainly for secure authentication of
each RPC transaction (sec=krb5). The Kerberos integrity and privacy
services are also available, providing feature parity with TCP in
environments where the use of sec=krb5i or sec=krb5p is mandated by
IT policy.

Sagi's proposed fix for mlx4's new FRWR API is included. I'll drop
it from my series once the official version of this fix is merged.


Available in the "nfs-rdma-for-4.8" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.8


Changes since v1:
- Rebased on v4.7-rc3
- Re-ordered series so FMR fixes come first
- Fix ib_unmap_fmr list handling
- Replaced the bogus 256-MRs-per-QP patch with dynamic MR allocation
- Add performance counters to expose MR allocation and recovery behavior
- Included Sagi's proposed mlx4 priv pages fix
- Make it easier to merge my datatouch patch with Scott's bug fix
- Split some patches for readability
- Drop some clean-up patches to keep the series patch count down

---

Chuck Lever (23):
      xprtrdma: Remove FMRs from the unmap list after unmapping
      xprtrdma: Create common scatterlist fields in rpcrdma_mw
      xprtrdma: Move init and release helpers
      xprtrdma: Rename fields in rpcrdma_fmr
      xprtrdma: Use scatterlist for DMA mapping and unmapping under FMR
      xprtrdma: Refactor MR recovery work queues
      xprtrdma: Do not leak an MW during a DMA map failure
      xprtrdma: Remove ALLPHYSICAL memory registration mode
      xprtrdma: Remove rpcrdma_map_one() and friends
      xprtrdma: Reply buffer exhaustion can be catastrophic
      xprtrdma: Honor ->send_request API contract
      xprtrdma: Chunk list encoders must not return zero
      xprtrdma: Allocate MRs on demand
      xprtrdma: Release orphaned MRs immediately
      xprtrdma: Place registered MWs on a per-req list
      xprtrdma: Chunk list encoders no longer share one rl_segments array
      xprtrdma: rpcrdma_inline_fixup() overruns the receive page list
      xprtrdma: Do not update {head,tail}.iov_len in rpcrdma_inline_fixup()
      xprtrdma: Update only specific fields in private receive buffer
      xprtrdma: Clean up fixup_copy_count accounting
      xprtrdma: No direct data placement with krb5i and krb5p
      svc: Avoid garbage replies when pc_func() returns rpc_drop_reply
      NFS: Don't drop CB requests with invalid principals

Sagi Grimberg (1):
      mlx4-ib: Use coherent memory for priv pages


 drivers/infiniband/hw/mlx4/mlx4_ib.h  |    1 
 drivers/infiniband/hw/mlx4/mr.c       |   42 +---
 fs/nfs/callback_xdr.c                 |    6 -
 include/linux/sunrpc/auth.h           |    3 
 include/linux/sunrpc/gss_api.h        |    2 
 net/sunrpc/auth_gss/auth_gss.c        |    2 
 net/sunrpc/auth_gss/gss_krb5_mech.c   |    2 
 net/sunrpc/auth_gss/gss_mech_switch.c |   12 +
 net/sunrpc/svc.c                      |    8 +
 net/sunrpc/xprtrdma/Makefile          |    2 
 net/sunrpc/xprtrdma/fmr_ops.c         |  372 +++++++++++++++------------------
 net/sunrpc/xprtrdma/frwr_ops.c        |  352 +++++++++++--------------------
 net/sunrpc/xprtrdma/physical_ops.c    |  122 -----------
 net/sunrpc/xprtrdma/rpc_rdma.c        |  274 +++++++++++++-----------
 net/sunrpc/xprtrdma/transport.c       |   40 ++--
 net/sunrpc/xprtrdma/verbs.c           |  189 +++++++++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h       |  116 ++++------
 17 files changed, 684 insertions(+), 861 deletions(-)
 delete mode 100644 net/sunrpc/xprtrdma/physical_ops.c

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
