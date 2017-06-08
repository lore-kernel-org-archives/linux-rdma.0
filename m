From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/13] NFS/RDMA client-side patches proposed for v4.13
Date: Thu, 08 Jun 2017 11:51:39 -0400
Message-ID: <20170608154339.18945.5500.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series contains a major fix for client-side NFS/RDMA.

When a signal fires, it's possible for the server's RPC reply to
race with the client code that terminates the RPC after a signal.
The result is both of these code paths try to invalidate the same
MR at the same time.

Because FRWR invalidation is typically fast, it's nearly impossible
to hit the race with FRWR. However, FMR invalidation happens at
about the same speed as the NFS server responds, so it's more likely
to hit this window when using FMR. FMR is also more sensitive to
concurrent operations on the same MR, which can result in a kernel
crash or an HCA firmware reset.

As part of closing the signal race window, the reply handler is
restructured and several error recovery paths in the invalidation
code are fixed.

In addition to this fix, there are a pair of small but important
changes to make NFSv4.1 Transparent State Migration work. These
enable basic migration test cases to pass successfully.


Available in the "nfs-rdma-for-4.13" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfs-rdma-for-4.13


Changes since v1:
- Moved back-portable fixes to top of series
- Split fixes for CONFIRMED_R and contrived slot into separate patches
- Tested and reworked fixes for CONFIRMED_R and contrived slot number

---

Chuck Lever (13):
      xprtrdma: On invalidation failure, remove MWs from rl_registered
      xprtrdma: Pre-mark remotely invalidated MRs
      xprtrdma: Pass only the list of registered MRs to ro_unmap_sync
      xprtrdma: Rename rpcrdma_req::rl_free
      xprtrdma: Fix client lock-up after application signal fires
      xprtrdma: Fix FRWR invalidation error recovery
      xprtrdma: Don't defer MR recovery if ro_map fails
      NFSv4.1: Handle EXCHGID4_FLAG_CONFIRMED_R during NFSv4.1 migration
      NFSv4.1: Use seqid returned by EXCHANGE_ID after state migration
      xprtrdma: Demote "connect" log messages
      xprtrdma: FMR does not need list_del_init()
      xprtrdma: Replace PAGE_MASK with offset_in_page()
      xprtrdma: Fix documenting comments in frwr_ops.c


 fs/nfs/nfs4client.c             |    5 ++
 fs/nfs/nfs4proc.c               |    7 +-
 fs/nfs/nfs4state.c              |   16 +++--
 include/linux/nfs_fs_sb.h       |    2 +
 net/sunrpc/xprtrdma/fmr_ops.c   |   47 ++++++++-------
 net/sunrpc/xprtrdma/frwr_ops.c  |   69 ++++++++++------------
 net/sunrpc/xprtrdma/rpc_rdma.c  |  125 +++++++++++++++++++++++++--------------
 net/sunrpc/xprtrdma/transport.c |    3 +
 net/sunrpc/xprtrdma/verbs.c     |   55 ++++-------------
 net/sunrpc/xprtrdma/xprt_rdma.h |   40 ++++++++++++
 10 files changed, 215 insertions(+), 154 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
