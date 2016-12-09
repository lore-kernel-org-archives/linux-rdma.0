From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: [GIT PULL] Please pull NFSoRDMA client side changes for 4.10
Date: Fri, 9 Dec 2016 16:01:50 -0500
Message-ID: <3ab13b73-d1ca-5b7e-b8e4-ec1385c2e612@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Trond,

The following changes since commit e5517c2a5a49ed5e99047008629f1cd60246ea0e:

  Linux 4.9-rc7 (2016-11-27 13:08:04 -0800)

are available in the git repository at:

  git://git.linux-nfs.org/projects/anna/nfs-rdma.git tags/nfs-rdma-4.10-1

for you to fetch changes up to 3a72dc771cc38e4d6e441a86256a3d7788a84c01:

  xprtrdma: Relocate connection helper functions (2016-11-29 16:45:44 -0500)

----------------------------------------------------------------
New Features:
- Support for SG_GAP devices

Bugfixes and cleanups:
- Cap size of callback buffer resources
- Improve send queue and RPC metric accounting
- Fix coverity warning
- Avoid calls to ro_unmap_safe()
- Refactor FRMR invalidation
- Error message improvements

Thanks,
Anna
----------------------------------------------------------------
Chuck Lever (12):
      xprtrdma: Cap size of callback buffer resources
      xprtrdma: Make FRWR send queue entry accounting more accurate
      xprtrdma: Support for SG_GAP devices
      SUNRPC: Proper metric accounting when RPC is not transmitted
      xprtrdma: Address coverity complaint about wait_for_completion()
      xprtrdma: Avoid calls to ro_unmap_safe()
      xprtrdma: Refactor FRMR invalidation
      xprtrdma: Update documenting comment
      xprtrdma: Squelch "max send, max recv" messages at connect time
      xprtrdma: Shorten QP access error message
      xprtrdma: Update dprintk in rpcrdma_count_chunks
      xprtrdma: Relocate connection helper functions

 net/sunrpc/stats.c                | 10 ++++++----
 net/sunrpc/xprtrdma/backchannel.c |  4 +++-
 net/sunrpc/xprtrdma/frwr_ops.c    | 94 ++++++++++++++++++++++++++++++++++++++++++++--------------------------------------------------
 net/sunrpc/xprtrdma/rpc_rdma.c    | 36 +-----------------------------------
 net/sunrpc/xprtrdma/transport.c   | 34 ++++++++++++++++++++++++++++++++--
 net/sunrpc/xprtrdma/verbs.c       | 37 ++++++++++++++++++++-----------------
 net/sunrpc/xprtrdma/xprt_rdma.h   | 31 ++++++++++++++++++++++---------
 7 files changed, 128 insertions(+), 118 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
