From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/8] Fixes for NFS/RDMA client
Date: Mon, 03 Feb 2014 16:01:47 -0500
Message-ID: <20140203205903.3533.39213.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---

Chuck Lever (8):
      NFS: incorrect "port=" value in /proc/mounts
      NFS: Use port 20049 by default for NFS/RDMA mounts
      NFS: advertise only supported callback netids
      NFS: Add debugging message in nfs4_callback_null()
      SUNRPC: Display tk_pid where possible
      SUNRPC: remove KERN_INFO from dprintk() call sites
      SUNRPC: Fix large reads on NFS/RDMA
      NFS: Fix READDIR oops with NFSv4 on RDMA


 fs/nfs/callback_xdr.c           |    1 
 fs/nfs/client.c                 |    1 
 fs/nfs/nfs4proc.c               |   24 +++++++++---
 fs/nfs/nfs4xdr.c                |    3 -
 fs/nfs/super.c                  |    2 +
 include/uapi/linux/nfs.h        |    1 
 net/sunrpc/xprtrdma/rpc_rdma.c  |   80 ++++++++++++++++++++++-----------------
 net/sunrpc/xprtrdma/transport.c |   29 ++++++++------
 8 files changed, 86 insertions(+), 55 deletions(-)

-- 
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
