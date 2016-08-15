From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/3] server-side NFS/RDMA patches proposed for v4.9
Date: Mon, 15 Aug 2016 16:57:58 -0400
Message-ID: <20160815205032.11731.16708.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Posted for review, the following patch series makes these changes:

- Introduce simple RDMA-CM private message exchange
- Support Remote Invalidation

Available in the "nfsd-rdma-for-4.9" topic branch of this git repo:

git://git.linux-nfs.org/projects/cel/cel-2.6.git


Or for browsing:

http://git.linux-nfs.org/?p=cel/cel-2.6.git;a=log;h=refs/heads/nfsd-rdma-for-4.9


---

Chuck Lever (3):
      rpcrdma: RDMA/CM private message data structure
      svcrdma: Server-side support for rpcrdma_connect_private
      svcrdma: support Remote Invalidation for prototyping


 include/linux/sunrpc/rpc_rdma.h          |   35 ++++++++++++++++++
 include/linux/sunrpc/svc_rdma.h          |    1 +
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |   58 ++++++++++++++++++++++++++++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   42 +++++++++++++++++++---
 4 files changed, 128 insertions(+), 8 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
