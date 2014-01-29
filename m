From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] RDMA/ocrdma: SQ and RQ doorbell offset clean up
Date: Wed, 29 Jan 2014 11:45:26 +0000
Message-ID: <d9c5cfb1-c463-4cbb-9b86-da318a680306@CMEXHTCAS2.ad.emulex.com>
References: <1384774063-28522-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384774063-28522-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please discard this patch. 
Due to IP based GID changes, this won't apply clean, We are planning to send you a new series of patches on for-next tree please use that instead.

-Regards
 Devesh
-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Sent: Monday, November 18, 2013 4:58 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [PATCH] RDMA/ocrdma: SQ and RQ doorbell offset clean up

From: Devesh Sharma<devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Introducing new macros to define SQ and RQ doorbell offset.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    7 -------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    5 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   18 ++++++------------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index adc11d1..07d156f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -384,13 +384,6 @@ static inline struct ocrdma_srq *get_ocrdma_srq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct ocrdma_srq, ibsrq);  }
 
-
-static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp) -{
-	return ((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY &&
-		 qp->id < 128) ? 24 : 16);
-}
-
 static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)  {
 	int cqe_valid;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 9f9570e..38df269 100644
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
index 69f1d12..c80ba6e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1092,15 +1092,9 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
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
@@ -1273,7 +1267,7 @@ static void ocrdma_flush_rq_db(struct ocrdma_qp *qp)  {
 	if (qp->db_cache) {
 		u32 val = qp->rq.dbid | (qp->db_cache <<
-				ocrdma_get_num_posted_shift(qp));
+				OCRDMA_DB_RQ_SHIFT);
 		iowrite32(val, qp->rq_db);
 		qp->db_cache = 0;
 	}
@@ -2018,7 +2012,7 @@ static int ocrdma_build_fr(struct ocrdma_qp *qp, struct ocrdma_hdr_wqe *hdr,
 
 static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)  {
-	u32 val = qp->sq.dbid | (1 << 16);
+	u32 val = qp->sq.dbid | (1 << OCRDMA_DB_SQ_SHIFT);
 
 	iowrite32(val, qp->sq_db);
 }
@@ -2123,7 +2117,7 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)  {
-	u32 val = qp->rq.dbid | (1 << ocrdma_get_num_posted_shift(qp));
+	u32 val = qp->rq.dbid | (1 << OCRDMA_DB_RQ_SHIFT);
 
 	if (qp->state != OCRDMA_QPS_INIT)
 		iowrite32(val, qp->rq_db);
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
