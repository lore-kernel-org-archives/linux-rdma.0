From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [PATCH 0/2] RPCRDMA Fixes
Date: Wed, 09 Feb 2011 13:45:23 -0600
Message-ID: <20110209194430.22358.46254.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: spelic-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This pair of patches fixes a problem with the marshalling of XDR into
RPCRDMA messages and an issue with FRMR mapping in the presence of transport
errors. The problems were discovered together as part of looking into the
ENOSPC problems seen by spelic-9AbUPqfR1/13js5NuHN3yg@public.gmane.org

The fixes, however, are independent and do not rely on each other. I have tested
them indepently and together on 64b with both Infiniband and iWARP. They have been
compile tested on 32b.

---

Tom Tucker (2):
      RPCRDMA: Fix FRMR registration/invalidate handling.
      RPCRDMA: Fix to XDR page base interpretation in marshalling logic.


 net/sunrpc/xprtrdma/rpc_rdma.c  |   86 +++++++++++++++++++--------------------
 net/sunrpc/xprtrdma/verbs.c     |   52 ++++++++++++++++++++----
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 
 3 files changed, 87 insertions(+), 52 deletions(-)

-- 
Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
