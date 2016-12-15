From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] libcxgb4: fixes for debug build
Date: Thu, 15 Dec 2016 13:19:06 -0800
Message-ID: <20161215212201.AAA3BE08C3@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 providers/cxgb4/dev.c      | 14 +++++++-------
 providers/cxgb4/libcxgb4.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 69b04ac..3d903e8 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -239,7 +239,7 @@ static void dump_cq(struct c4iw_cq *chp)
                 chp->cq.cqid, chp->cq.queue, chp->cq.cidx,
 	 	chp->cq.sw_queue, chp->cq.sw_cidx, chp->cq.sw_pidx, chp->cq.sw_in_use,
                 chp->cq.size, chp->cq.error, chp->cq.gen, chp->cq.cidx_inc, be64_to_cpu(chp->cq.bits_type_ts),
-		t4_cq_notempty(&chp->cq) || (chp->iq ? t4_iq_notempty(chp->iq) : 0));
+		t4_cq_notempty(&chp->cq));
 
 	for (i=0; i < chp->cq.size; i++) {
 		u64 *p = (u64 *)(chp->cq.queue + i);
@@ -310,10 +310,10 @@ static void dump_qp(struct c4iw_qp *qhp)
 			swsqe->opcode,
 			swsqe->complete,
 			swsqe->signaled,
-			cpu_to_be64(swsqe->cqe.u.flits[0]),
-			cpu_to_be64(swsqe->cqe.u.flits[1]),
-			cpu_to_be64((u64)swsqe->cqe.reserved),
-			cpu_to_be64(swsqe->cqe.bits_type_ts));
+			cpu_to_be64(((uint64_t *)&swsqe->cqe)[0]),
+			cpu_to_be64(((uint64_t *)&swsqe->cqe)[1]),
+			cpu_to_be64(((uint64_t *)&swsqe->cqe)[2]),
+			cpu_to_be64(((uint64_t *)&swsqe->cqe)[3]));
 		if (++cidx == qhp->wq.sq.size)
 			cidx = 0;
 	}
@@ -359,7 +359,7 @@ static void dump_qp(struct c4iw_qp *qhp)
 	}
 }
 
-void dump_state()
+void dump_state(void)
 {
 	struct c4iw_dev *dev;
 	int i;
@@ -462,7 +462,7 @@ found:
 	}
 
 	PDBG("%s found vendor %d device %d type %d\n",
-	     __FUNCTION__, vendor, device, hca_table[i].chip_version);
+	     __FUNCTION__, vendor, device, CHELSIO_CHIP_VERSION(hca_table[i].device >> 8));
 
 	dev = calloc(1, sizeof *dev);
 	if (!dev) {
diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
index 9a4bc98..3b75661 100644
--- a/providers/cxgb4/libcxgb4.h
+++ b/providers/cxgb4/libcxgb4.h
@@ -260,7 +260,7 @@ extern struct c4iw_stats c4iw_stats;
 #endif
 
 #ifdef STALL_DETECTION
-void dump_state();
+void dump_state(void);
 extern int stall_to;
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
