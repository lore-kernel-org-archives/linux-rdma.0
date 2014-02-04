From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 02/17] RDMA/ocrdma: SQ and RQ doorbell offset clean up
Date: Tue, 4 Feb 2014 11:56:55 +0530
Message-ID: <90a4275f-4616-498a-b8b5-d18a1faeedff@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>

Introducing new macros to define SQ and RQ doorbell offset.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    7 -------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    5 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   23 +++++++----------------
 3 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 61f508e..1b51e67 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -386,13 +386,6 @@ static inline struct ocrdma_srq *get_ocrdma_srq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct ocrdma_srq, ibsrq);
 }
 
-
-static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp)
-{
-	return ((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY &&
-		 qp->id < 128) ? 24 : 16);
-}
-
 static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)
 {
 	int cqe_valid;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 60d5ac2..e71685a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -103,7 +103,10 @@ enum {
 	OCRDMA_DB_GEN2_SRQ_OFFSET	= OCRDMA_DB_GEN2_RQ_OFFSET,
 	OCRDMA_DB_CQ_OFFSET		= 0x120,
 	OCRDMA_DB_EQ_OFFSET		= OCRDMA_DB_CQ_OFFSET,
-	OCRDMA_DB_MQ_OFFSET		= 0x140
+	OCRDMA_DB_MQ_OFFSET		= 0x140,
+
+	OCRDMA_DB_SQ_SHIFT		= 16,
+	OCRDMA_DB_RQ_SHIFT		= 24
 };
 
 #define OCRDMA_DB_CQ_RING_ID_MASK       0x3FF	/* bits 0 - 9 */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cc2ad14..ead59d5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1127,15 +1127,9 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	}
 	uresp.db_page_addr = usr_db;
 	uresp.db_page_size = dev->nic_info.db_page_size;
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
-		uresp.db_sq_offset = OCRDMA_DB_GEN2_SQ_OFFSET;
-		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
-		uresp.db_shift = 24;
-	} else {
-		uresp.db_sq_offset = OCRDMA_DB_SQ_OFFSET;
-		uresp.db_rq_offset = OCRDMA_DB_RQ_OFFSET;
-		uresp.db_shift = 16;
-	}
+	uresp.db_sq_offset = OCRDMA_DB_GEN2_SQ_OFFSET;
+	uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
+	uresp.db_shift = OCRDMA_DB_RQ_SHIFT;
 
 	if (qp->dpp_enabled) {
 		uresp.dpp_credit = dpp_credit_lmt;
@@ -1308,7 +1302,7 @@ static void ocrdma_flush_rq_db(struct ocrdma_qp *qp)
 {
 	if (qp->db_cache) {
 		u32 val = qp->rq.dbid | (qp->db_cache <<
-				ocrdma_get_num_posted_shift(qp));
+				OCRDMA_DB_RQ_SHIFT);
 		iowrite32(val, qp->rq_db);
 		qp->db_cache = 0;
 	}
@@ -2052,7 +2046,7 @@ static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 
 static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)
 {
-	u32 val = qp->sq.dbid | (1 << 16);
+	u32 val = qp->sq.dbid | (1 << OCRDMA_DB_SQ_SHIFT);
 
 	iowrite32(val, qp->sq_db);
 }
@@ -2157,12 +2151,9 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)
 {
-	u32 val = qp->rq.dbid | (1 << ocrdma_get_num_posted_shift(qp));
+	u32 val = qp->rq.dbid | (1 << OCRDMA_DB_RQ_SHIFT);
 
-	if (qp->state != OCRDMA_QPS_INIT)
-		iowrite32(val, qp->rq_db);
-	else
-		qp->db_cache++;
+	iowrite32(val, qp->rq_db);
 }
 
 static void ocrdma_build_rqe(struct ocrdma_hdr_wqe *rqe, struct ib_recv_wr *wr,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
