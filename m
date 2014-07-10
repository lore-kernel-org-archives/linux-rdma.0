From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] NFS/RDMA server patches for 3.17
Date: Thu, 10 Jul 2014 13:44:17 -0400
Message-ID: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-UeZzRo20aYc@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Steve-

Can you include these two potential 3.17 candidate patches in
your testing branch?

---

Chuck Lever (2):
      svcrdma: Remove extra writeargs sanity check for NFSv2/3
      svcrdma: Increase credit limit to 32


 fs/nfsd/nfs3xdr.c               |   15 +--------------
 fs/nfsd/nfsxdr.c                |   16 +---------------
 include/linux/sunrpc/svc_rdma.h |    3 +--
 3 files changed, 3 insertions(+), 31 deletions(-)

-- 
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
