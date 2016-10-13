From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 15/32] cxgb4: remove unused function dump_wqe
Date: Thu, 13 Oct 2016 19:51:18 +0200
Message-ID: <1476381095-20041-16-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 providers/cxgb4/qp.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/providers/cxgb4/qp.c b/providers/cxgb4/qp.c
index 95b459a..376a00a 100644
--- a/providers/cxgb4/qp.c
+++ b/providers/cxgb4/qp.c
@@ -267,20 +267,6 @@ static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 	return 0;
 }
 
-void dump_wqe(void *arg)
-{
-	u64 *p = arg;
-	int len16;
-
-	len16 = be64_to_cpu(*p) & 0xff;
-	while (len16--) {
-		printf("%02x: %016llx ", (u8)(unsigned long)p, (long long)be64_to_cpu(*p));
-		p++;
-		printf("%016llx\n", (long long)be64_to_cpu(*p));
-		p++;
-	}
-}
-
 static void ring_kernel_db(struct c4iw_qp *qhp, u32 qid, u16 idx)
 {
 	struct ibv_modify_qp cmd;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
