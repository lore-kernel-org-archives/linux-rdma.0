From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 14/23] staging/rdma/hfi1: Prevent silent data corruption with user SDMA
Date: Mon, 19 Oct 2015 12:43:38 -0400
Message-ID: <1445273027-29634-15-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

User SDMA keeps track of progress into the submitted IO vectors by tracking an
offset into the vectors when packets are submitted. This offset is updated
after a successful submission of a txreq to the SDMA engine.

The same offset was used when determining whether an IO vector should be
'freed' (pages unpinned) in the SDMA callback functions.

This was causing a silent data corruption in big jobs (> 2 nodes, 120 ranks
each) on the receive side because the send side was mistakenly unpinning the
vector pages before the HW has processed all descriptors referencing the
vector.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c | 90 ++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 10ab8073d3f2..36c838dcf023 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -146,7 +146,8 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 #define KDETH_OM_MAX_SIZE  (1 << ((KDETH_OM_LARGE / KDETH_OM_SMALL) + 1))
 
 /* Last packet in the request */
-#define USER_SDMA_TXREQ_FLAGS_LAST_PKT   (1 << 0)
+#define TXREQ_FLAGS_REQ_LAST_PKT   (1 << 0)
+#define TXREQ_FLAGS_IOVEC_LAST_PKT (1 << 0)
 
 #define SDMA_REQ_IN_USE     0
 #define SDMA_REQ_FOR_THREAD 1
@@ -249,13 +250,22 @@ struct user_sdma_request {
 	unsigned long flags;
 };
 
+/*
+ * A single txreq could span up to 3 physical pages when the MTU
+ * is sufficiently large (> 4K). Each of the IOV pointers also
+ * needs it's own set of flags so the vector has been handled
+ * independently of each other.
+ */
 struct user_sdma_txreq {
 	/* Packet header for the txreq */
 	struct hfi1_pkt_header hdr;
 	struct sdma_txreq txreq;
 	struct user_sdma_request *req;
-	struct user_sdma_iovec *iovec1;
-	struct user_sdma_iovec *iovec2;
+	struct {
+		struct user_sdma_iovec *vec;
+		u8 flags;
+	} iovecs[3];
+	int idx;
 	u16 flags;
 	unsigned busycount;
 	u64 seqnum;
@@ -294,21 +304,6 @@ static int defer_packet_queue(
 	unsigned seq);
 static void activate_packet_queue(struct iowait *, int);
 
-static inline int iovec_may_free(struct user_sdma_iovec *iovec,
-				       void (*free)(struct user_sdma_iovec *))
-{
-	if (ACCESS_ONCE(iovec->offset) == iovec->iov.iov_len) {
-		free(iovec);
-		return 1;
-	}
-	return 0;
-}
-
-static inline void iovec_set_complete(struct user_sdma_iovec *iovec)
-{
-	iovec->offset = iovec->iov.iov_len;
-}
-
 static int defer_packet_queue(
 	struct sdma_engine *sde,
 	struct iowait *wait,
@@ -825,11 +820,11 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		tx->flags = 0;
 		tx->req = req;
 		tx->busycount = 0;
-		tx->iovec1 = NULL;
-		tx->iovec2 = NULL;
+		tx->idx = -1;
+		memset(tx->iovecs, 0, sizeof(tx->iovecs));
 
 		if (req->seqnum == req->info.npkts - 1)
-			tx->flags |= USER_SDMA_TXREQ_FLAGS_LAST_PKT;
+			tx->flags |= TXREQ_FLAGS_REQ_LAST_PKT;
 
 		/*
 		 * Calculate the payload size - this is min of the fragment
@@ -858,7 +853,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 					goto free_tx;
 			}
 
-			tx->iovec1 = iovec;
+			tx->iovecs[++tx->idx].vec = iovec;
 			datalen = compute_data_length(req, tx);
 			if (!datalen) {
 				SDMA_DBG(req,
@@ -948,10 +943,17 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 					      iovec->pages[pageidx],
 					      offset, len);
 			if (ret) {
+				int i;
+
 				dd_dev_err(pq->dd,
 					   "SDMA txreq add page failed %d\n",
 					   ret);
-				iovec_set_complete(iovec);
+				/* Mark all assigned vectors as complete so they
+				 * are unpinned in the callback. */
+				for (i = tx->idx; i >= 0; i--) {
+					tx->iovecs[i].flags |=
+						TXREQ_FLAGS_IOVEC_LAST_PKT;
+				}
 				goto free_txreq;
 			}
 			iov_offset += len;
@@ -959,8 +961,11 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			data_sent += len;
 			if (unlikely(queued < datalen &&
 				     pageidx == iovec->npages &&
-				     req->iov_idx < req->data_iovs - 1)) {
+				     req->iov_idx < req->data_iovs - 1 &&
+				     tx->idx < ARRAY_SIZE(tx->iovecs))) {
 				iovec->offset += iov_offset;
+				tx->iovecs[tx->idx].flags |=
+					TXREQ_FLAGS_IOVEC_LAST_PKT;
 				iovec = &req->iovs[++req->iov_idx];
 				if (!iovec->pages) {
 					ret = pin_vector_pages(req, iovec);
@@ -968,8 +973,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 						goto free_txreq;
 				}
 				iov_offset = 0;
-				tx->iovec2 = iovec;
-
+				tx->iovecs[++tx->idx].vec = iovec;
 			}
 		}
 		/*
@@ -981,11 +985,15 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			req->tidoffset += datalen;
 		req->sent += data_sent;
 		if (req->data_len) {
-			if (tx->iovec1 && !tx->iovec2)
-				tx->iovec1->offset += iov_offset;
-			else if (tx->iovec2)
-				tx->iovec2->offset += iov_offset;
+			tx->iovecs[tx->idx].vec->offset += iov_offset;
+			/* If we've reached the end of the io vector, mark it
+			 * so the callback can unpin the pages and free it. */
+			if (tx->iovecs[tx->idx].vec->offset ==
+			    tx->iovecs[tx->idx].vec->iov.iov_len)
+				tx->iovecs[tx->idx].flags |=
+					TXREQ_FLAGS_IOVEC_LAST_PKT;
 		}
+
 		/*
 		 * It is important to increment this here as it is used to
 		 * generate the BTH.PSN and, therefore, can't be bulk-updated
@@ -1214,7 +1222,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 				req->seqnum));
 
 	/* Set ACK request on last packet */
-	if (unlikely(tx->flags & USER_SDMA_TXREQ_FLAGS_LAST_PKT))
+	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
 		hdr->bth[2] |= cpu_to_be32(1UL<<31);
 
 	/* Set the new offset */
@@ -1246,7 +1254,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 		KDETH_SET(hdr->kdeth.ver_tid_offset, TID,
 			  EXP_TID_GET(tidval, IDX));
 		/* Clear KDETH.SH only on the last packet */
-		if (unlikely(tx->flags & USER_SDMA_TXREQ_FLAGS_LAST_PKT))
+		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
 			KDETH_SET(hdr->kdeth.ver_tid_offset, SH, 0);
 		/*
 		 * Set the KDETH.OFFSET and KDETH.OM based on size of
@@ -1290,7 +1298,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 	/* BTH.PSN and BTH.A */
 	val32 = (be32_to_cpu(hdr->bth[2]) + req->seqnum) &
 		(HFI1_CAP_IS_KSET(EXTENDED_PSN) ? 0x7fffffff : 0xffffff);
-	if (unlikely(tx->flags & USER_SDMA_TXREQ_FLAGS_LAST_PKT))
+	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
 		val32 |= 1UL << 31;
 	AHG_HEADER_SET(req->ahg, diff, 6, 0, 16, cpu_to_be16(val32 >> 16));
 	AHG_HEADER_SET(req->ahg, diff, 6, 16, 16, cpu_to_be16(val32 & 0xffff));
@@ -1331,7 +1339,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 		val = cpu_to_le16(((EXP_TID_GET(tidval, CTRL) & 0x3) << 10) |
 					(EXP_TID_GET(tidval, IDX) & 0x3ff));
 		/* Clear KDETH.SH on last packet */
-		if (unlikely(tx->flags & USER_SDMA_TXREQ_FLAGS_LAST_PKT)) {
+		if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT)) {
 			val |= cpu_to_le16(KDETH_GET(hdr->kdeth.ver_tid_offset,
 								INTR) >> 16);
 			val &= cpu_to_le16(~(1U << 13));
@@ -1358,10 +1366,16 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 	if (unlikely(!req || !pq))
 		return;
 
-	if (tx->iovec1)
-		iovec_may_free(tx->iovec1, unpin_vector_pages);
-	if (tx->iovec2)
-		iovec_may_free(tx->iovec2, unpin_vector_pages);
+	/* If we have any io vectors associated with this txreq,
+	 * check whether they need to be 'freed'. */
+	if (tx->idx != -1) {
+		int i;
+
+		for (i = tx->idx; i >= 0; i--) {
+			if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT)
+				unpin_vector_pages(tx->iovecs[i].vec);
+		}
+	}
 
 	tx_seqnum = tx->seqnum;
 	kmem_cache_free(pq->txreq_cache, tx);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
