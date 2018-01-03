From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] NFS/RDMA server changes for v4.16
Date: Wed, 03 Jan 2018 15:42:10 -0500
Message-ID: <20180103203849.7074.9609.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Bruce-

Would you consider these patches for merging into v4.16?

Changes since v1:
- Rebased on v4.15-rc6
- Address a 0day robot complaint in nfsd3_proc_symlink
- Properly handle error return from svc_rdma_handle_bc_reply

---

Chuck Lever (3):
      svcrdma: Post Receives in the Receive completion handler
      NFSD: Clean up write argument XDR decoders
      NFSD: Clean up symlink argument XDR decoders


 fs/nfsd/nfs3proc.c                         |   18 ++++-
 fs/nfsd/nfs3xdr.c                          |   67 ++++-------------
 fs/nfsd/nfs4proc.c                         |   37 +++-------
 fs/nfsd/nfs4xdr.c                          |   11 ++-
 fs/nfsd/nfsproc.c                          |   23 ++++--
 fs/nfsd/nfsxdr.c                           |   63 ++++++++--------
 fs/nfsd/xdr.h                              |    3 +
 fs/nfsd/xdr3.h                             |    3 +
 fs/nfsd/xdr4.h                             |    3 +
 include/linux/sunrpc/svc.h                 |    4 +
 include/linux/sunrpc/svc_rdma.h            |    2 -
 net/sunrpc/svc.c                           |  109 ++++++++++++++++++++++++++++
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c |    5 -
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c    |    9 --
 net/sunrpc/xprtrdma/svc_rdma_sendto.c      |    6 --
 net/sunrpc/xprtrdma/svc_rdma_transport.c   |   25 ++----
 16 files changed, 225 insertions(+), 163 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
