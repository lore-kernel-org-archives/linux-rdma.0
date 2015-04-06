From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Please pull NFSoRDMA client changes
Date: Mon, 6 Apr 2015 08:53:27 -0400
Message-ID: <552281C7.5060606@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Trond,

The following changes since commit e42391cd048809d903291d07f86ed3934ce138e9:

  Linux 4.0-rc6 (2015-03-29 15:26:31 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-for-4.1-1

for you to fetch changes up to d654788e98f74f2df8dfc6079fa314938f739486:

  xprtrdma: Make rpcrdma_{un}map_one() into inline functions (2015-03-31 09:52:53 -0400)

Thanks,
Anna

----------------------------------------------------------------
NFS: NFSoRDMA Client Changes

This patch series creates an operation vector for each of the different
memory registration modes.  This should make it easier to one day increase
credit limit, rsize, and wsize.

Signed-off-by: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>

----------------------------------------------------------------
Chuck Lever (15):
      SUNRPC: Introduce missing well-known netids
      xprtrdma: Display IPv6 addresses and port numbers correctly
      xprtrdma: Perform a full marshal on retransmit
      xprtrdma: Byte-align FRWR registration
      xprtrdma: Prevent infinite loop in rpcrdma_ep_create()
      xprtrdma: Add vector of ops for each memory registration strategy
      xprtrdma: Add a "max_payload" op for each memreg mode
      xprtrdma: Add a "register_external" op for each memreg mode
      xprtrdma: Add a "deregister_external" op for each memreg mode
      xprtrdma: Add "init MRs" memreg op
      xprtrdma: Add "reset MRs" memreg op
      xprtrdma: Add "destroy MRs" memreg op
      xprtrdma: Add "open" memreg op
      xprtrdma: Handle non-SEND completions via a callout
      xprtrdma: Make rpcrdma_{un}map_one() into inline functions

 include/linux/sunrpc/msg_prot.h    |   8 +-
 include/linux/sunrpc/xprtrdma.h    |   5 -
 net/sunrpc/xprtrdma/Makefile       |   3 +-
 net/sunrpc/xprtrdma/fmr_ops.c      | 208 +++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/frwr_ops.c     | 353 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/physical_ops.c |  94 ++++++++++++++
 net/sunrpc/xprtrdma/rpc_rdma.c     |  87 ++++++-------
 net/sunrpc/xprtrdma/transport.c    |  61 ++++++---
 net/sunrpc/xprtrdma/verbs.c        | 699 ++++++++------------------------------------------------------------------------------------------
 net/sunrpc/xprtrdma/xprt_rdma.h    |  90 ++++++++++---
 10 files changed, 882 insertions(+), 726 deletions(-)
 create mode 100644 net/sunrpc/xprtrdma/fmr_ops.c
 create mode 100644 net/sunrpc/xprtrdma/frwr_ops.c
 create mode 100644 net/sunrpc/xprtrdma/physical_ops.c
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
