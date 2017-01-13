From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/5] Fix "support large inline thresholds"
Date: Fri, 13 Jan 2017 12:42:48 -0500
Message-ID: <20170113173023.32692.30661.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've received a number of reports that v4.9 commit 655fec6987be
("xprtrdma: Use gathered Send for large inline messages") causes
NFS/RDMA mounts to fail for devices that have a small max_sge.

This series addresses that problem.

A much smaller fix was provided initially. It worked for devices
with as small as five send SGEs. However, additional research has
shown that there is at least one in-tree device that supports only
three send SGEs.

The current series should enable NFS/RDMA again on those devices.


Available in the "nfs-rdma-for-4.10-rc" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git

And for online review:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=shortlog;h=refs/heads/nfs-rdma-for-4.10-rc

---

Chuck Lever (5):
      xprtrdma: Fix Read chunk padding
      xprtrdma: Per-connection pad optimization
      xprtrdma: Disable pad optimization by default
      xprtrdma: Reduce required number of send SGEs
      xprtrdma: Shrink send SGEs array


 net/sunrpc/xprtrdma/rpc_rdma.c  |   59 ++++++++++++++++++++++++++-------------
 net/sunrpc/xprtrdma/transport.c |    2 +
 net/sunrpc/xprtrdma/verbs.c     |   15 ++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h |   13 ++++++---
 4 files changed, 58 insertions(+), 31 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
