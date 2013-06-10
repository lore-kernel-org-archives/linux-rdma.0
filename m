From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] RDMA/ocrdma: Reorg structures to avoid padding.
Date: Mon, 10 Jun 2013 10:12:42 +0530
Message-ID: <109bf154-09c2-4b68-8f9e-4e0b1a64eab8@CMEXHTCAS2.ad.emulex.com>
References: <1370839362-3871-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370839362-3871-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Reorg structures to better packing to avoid cacheline padding.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 7aa7f0f..d540180 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -236,15 +236,16 @@ struct ocrdma_srq {
 	struct ib_srq ibsrq;
 	struct ocrdma_dev *dev;
 	u8 __iomem *db;
+	struct ocrdma_qp_hwq_info rq;
+	u64 *rqe_wr_id_tbl;
+	u32 *idx_bit_fields;
+	u32 bit_fields_len;
+
 	/* provide synchronization to multiple context(s) posting rqe */
 	spinlock_t q_lock ____cacheline_aligned;
 
-	struct ocrdma_qp_hwq_info rq;
 	struct ocrdma_pd *pd;
 	u32 id;
-	u64 *rqe_wr_id_tbl;
-	u32 *idx_bit_fields;
-	u32 bit_fields_len;
 };
 
 struct ocrdma_qp {
@@ -252,8 +253,6 @@ struct ocrdma_qp {
 	struct ocrdma_dev *dev;
 
 	u8 __iomem *sq_db;
-	/* provide synchronization to multiple context(s) posting wqe, rqe */
-	spinlock_t q_lock ____cacheline_aligned;
 	struct ocrdma_qp_hwq_info sq;
 	struct {
 		uint64_t wrid;
@@ -263,6 +262,9 @@ struct ocrdma_qp {
 		uint8_t  rsvd[3];
 	} *wqe_wr_id_tbl;
 	u32 max_inline_data;
+
+	/* provide synchronization to multiple context(s) posting wqe, rqe */
+	spinlock_t q_lock ____cacheline_aligned;
 	struct ocrdma_cq *sq_cq;
 	/* list maintained per CQ to flush SQ errors */
 	struct list_head sq_entry;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
