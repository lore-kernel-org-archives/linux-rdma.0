From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 00/10] NFS/RDMA server for 3.20
Date: Fri, 09 Jan 2015 14:21:54 -0500
Message-ID: <20150109191910.4901.29548.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In addition to miscellaneous clean up, the following series of
patches for the Linux NFS server introduces support in the
server=E2=80=99s RPC/RDMA transport implementation for RDMA_NOMSG type
messages, and fixes a bug that prevents the server from handling
RPC/RDMA messages with inline content following a read list.

These patches are contained in the branch "nfsd-rdma-for-3.20" at:

  git://git.linux-nfs.org/projects/cel/cel-2.6.git

---

Chuck Lever (10):
      svcrdma: Handle additional inline content
      Move read list XDR round-up logic
      svcrdma: Support RDMA_NOMSG requests
      svcrdma: rc_position sanity checking
      svcrdma: Plant reader function in struct svcxprt_rdma
      svcrdma: Find rmsgp more reliably
      svcrdma: Scrub BUG_ON() and WARN_ON() call sites
      svcrdma: Clean up read chunk counting
      svcrdma: Remove unused variable
      svcrdma: Clean up dprintk


 include/linux/sunrpc/svc_rdma.h          |   13 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c   |   16 --
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  251 +++++++++++++++++++---=
--------
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   46 +++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   47 +++---
 5 files changed, 224 insertions(+), 149 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
