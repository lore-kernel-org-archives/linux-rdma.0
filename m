From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/5] Fix "support large inline thresholds"
Date: Mon, 23 Jan 2017 15:52:37 -0500
Message-ID: <20170123205159.21699.47373.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

I've received a number of reports that v4.9 commit 655fec6987be
("xprtrdma: Use gathered Send for large inline messages") causes
NFS/RDMA mounts to fail for devices that have a small max_sge.

This series addresses that problem. Would you consider this series
of bug fixes for v4.10-rc?


Available in the "nfs-rdma-for-4.10-rc" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

And for online review:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=shortlog;h=refs/heads/nfs-rdma-for-4.10-rc


Changes since v1:
- Rebased on v4.10-rc5
- Renamed some variables for clarity
- Clarified patch descriptions
- Added Tested-by and Reviewed-by tags

---

Chuck Lever (5):
      xprtrdma: Fix Read chunk padding
      xprtrdma: Per-connection pad optimization
      xprtrdma: Disable pad optimization by default
      xprtrdma: Reduce required number of send SGEs
      xprtrdma: Shrink send SGEs array


 net/sunrpc/xprtrdma/rpc_rdma.c  |   62 +++++++++++++++++++++++++--------------
 net/sunrpc/xprtrdma/transport.c |    2 +
 net/sunrpc/xprtrdma/verbs.c     |   15 ++++++---
 net/sunrpc/xprtrdma/xprt_rdma.h |   14 ++++++---
 4 files changed, 60 insertions(+), 33 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
