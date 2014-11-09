From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/10] NFS/RDMA patches for 3.19
Date: Sat, 08 Nov 2014 20:14:03 -0500
Message-ID: <20141109010328.8806.5861.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi-

This is a set of fixes and clean-ups for xprtrdma. Also available
in the nfs-rdma-for-3.19 topic branch at

  git://linux-nfs.org/projects/cel/cel-2.6.git

I've run cthon04, iozone, dbench, multi-process kernel build and
xfstests with NFSv3 and NFSv4.0 against a Linux and a Solaris
NFS server via RDMA, with all three memory registration modes.

Changes since v1:

- Merged up to v3.18-rc3
- Dropped patches that enable NFSv4.1 support for now
- CQ completion vector spinning dropped for now
- Addressed Anna's review comments
- Several bug fixes

---

Chuck Lever (10):
      xprtrdma: Return an errno from rpcrdma_register_external()
      xprtrdma: Cap req_cqinit
      xprtrdma: unmap all FMRs during transport disconnect
      xprtrdma: Refactor tasklet scheduling
      xprtrdma: Re-write rpcrdma_flush_cqs()
      xprtrdma: Enable pad optimization
      xprtrdma: Display async errors
      SUNRPC: serialize iostats updates
      NFS: SETCLIENTID XDR buffer sizes are incorrect
      NFS: Clean up nfs4_init_callback()


 fs/nfs/nfs4client.c             |   31 +++++------
 fs/nfs/nfs4xdr.c                |   10 ++-
 include/linux/sunrpc/metrics.h  |    3 +
 net/sunrpc/stats.c              |   21 +++++--
 net/sunrpc/xprtrdma/transport.c |    4 +
 net/sunrpc/xprtrdma/verbs.c     |  114 ++++++++++++++++++++++++++++++++++-----
 net/sunrpc/xprtrdma/xprt_rdma.h |    6 ++
 7 files changed, 146 insertions(+), 43 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
