From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core] qedr: Fix a wrong field in struct rdma_rq_sge
Date: Tue, 17 Jan 2017 13:44:12 -0600
Message-ID: <1484682252-32964-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 13b2b3cf148c ("libqedr: fix queue wrapping logic")

After enabling FP_DP_VERBOSE macro, for example:
#define FP_DP_VERBOSE(...)     DP_VERBOSE(__VA_ARGS__)

libqedr compilation fails with the error below:

In file included from ../providers/qedr/qelr_verbs.c:48:0:
../providers/qedr/qelr_verbs.c: In function ‘qelr_post_recv’:
../providers/qedr/qelr_verbs.c:1447:14: error: ‘struct rdma_rq_sge’ has no member named ‘first_addr’
           rqe->first_addr.hi, rqe->first_addr.lo);

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 providers/qedr/qelr_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 793b1f4..93a0e35 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -1444,7 +1444,7 @@ int qelr_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 			FP_DP_VERBOSE(cxt->dbg_fp, QELR_MSG_CQ,
 				      "[%d]: len %d key %x addr %x:%x\n", i,
 				      rqe->length, rqe->flags,
-				      rqe->first_addr.hi, rqe->first_addr.lo);
+				      rqe->addr.hi, rqe->addr.lo);
 		}
 		/* Special case of no sges. FW requires between 1-4 sges...
 		 * in this case we need to post 1 sge with length zero. this is
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
