From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] xprtrdma: Set LOCAL_WRITE for memory regions with REMOTE_WRITE
Date: Wed, 16 Apr 2014 13:35:38 -0500
Message-ID: <20140416183538.23742.54560.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The commit below enforces the requirement that MRs with REMOTE_WRITE
must also have LOCAL_WRITE:

commit 1c636f801615bdfc9b1d46904e8258c7a025670b
Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Oct 31 15:26:32 2013 +0200

   IB/core: Encorce MR access rights rules on kernel consumers

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 net/sunrpc/xprtrdma/verbs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9b038e1..65ce677 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1637,7 +1637,8 @@ static int
 rpcrdma_register_default_external(struct rpcrdma_mr_seg *seg,
 			int *nsegs, int writing, struct rpcrdma_ia *ia)
 {
-	int mem_priv = (writing ? IB_ACCESS_REMOTE_WRITE :
+	int mem_priv = (writing ? IB_ACCESS_REMOTE_WRITE |
+				  IB_ACCESS_LOCAL_WRITE :
 				  IB_ACCESS_REMOTE_READ);
 	struct rpcrdma_mr_seg *seg1 = seg;
 	struct ib_phys_buf ipb[RPCRDMA_MAX_DATA_SEGS];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
