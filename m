From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/6] ocrdma: Add sparse annotations
Date: Thu,  6 Apr 2017 16:42:23 -0600
Message-ID: <1491518545-14746-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1491518545-14746-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491518545-14746-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                  |  2 +-
 providers/ocrdma/ocrdma_abi.h   | 39 ++++++++++++++++++++++++++-------------
 providers/ocrdma/ocrdma_verbs.c | 20 ++++++++++----------
 3 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 77f46eed0f4422..1ff3189c9d295e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -385,7 +385,7 @@ add_subdirectory(providers/mlx5) # NO SPARSE
 add_subdirectory(providers/mlx5/man) # NO SPARSE
 add_subdirectory(providers/mthca) # NO SPARSE
 add_subdirectory(providers/nes) # NO SPARSE
-add_subdirectory(providers/ocrdma) # NO SPARSE
+add_subdirectory(providers/ocrdma)
 add_subdirectory(providers/qedr) # NO SPARSE
 add_subdirectory(providers/vmw_pvrdma) # NO SPARSE
 endif()
diff --git a/providers/ocrdma/ocrdma_abi.h b/providers/ocrdma/ocrdma_abi.h
index 8156458131238a..e43e30aa7817d0 100644
--- a/providers/ocrdma/ocrdma_abi.h
+++ b/providers/ocrdma/ocrdma_abi.h
@@ -242,27 +242,27 @@ struct ocrdma_cqe {
 	union {
 		/* w0 to w2 */
 		struct {
-			uint32_t wqeidx;
-			uint32_t bytes_xfered;
-			uint32_t qpn;
+			__le32 wqeidx;
+			__le32 bytes_xfered;
+			__le32 qpn;
 		} wq;
 		struct {
-			uint32_t lkey_immdt;
-			uint32_t rxlen;
-			uint32_t buftag_qpn;
+			__le32 lkey_immdt;
+			__le32 rxlen;
+			__le32 buftag_qpn;
 		} rq;
 		struct {
-			uint32_t lkey_immdt;
-			uint32_t rxlen_pkey;
-			uint32_t buftag_qpn;
+			__le32 lkey_immdt;
+			__le32 rxlen_pkey;
+			__le32 buftag_qpn;
 		} ud;
 		struct {
-			uint32_t word_0;
-			uint32_t word_1;
-			uint32_t qpn;
+			__le32 word_0;
+			__le32 word_1;
+			__le32 qpn;
 		} cmn;
 	};
-	uint32_t flags_status_srcqpn;	/* w3 */
+	__le32 flags_status_srcqpn;	/* w3 */
 } __attribute__ ((packed));
 
 struct ocrdma_sge {
@@ -335,6 +335,19 @@ struct ocrdma_hdr_wqe {
 	uint32_t total_len;
 } __attribute__ ((packed));
 
+struct ocrdma_hdr_wqe_le {
+	__le32 cw;
+	union {
+		__le32 rsvd_tag;
+		__le32 rsvd_stag_flags;
+	};
+	union {
+		__le32 immdt;
+		__le32 lkey;
+	};
+	__le32 total_len;
+} __attribute__ ((packed));
+
 struct ocrdma_ewqe_atomic {
 	uint32_t ra_hi;
 	uint32_t ra_lo;
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 7aa5499626249a..6f140c33dbe509 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -59,7 +59,7 @@ static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 static inline void ocrdma_swap_cpu_to_le(void *dst, uint32_t len)
 {
 	int i = 0;
-	uint32_t *src_ptr = dst;
+        __le32 *src_ptr = dst;
 	uint32_t *dst_ptr = dst;
 	for (; i < (len / 4); i++)
 		*dst_ptr++ = le32toh(*src_ptr++);
@@ -1099,26 +1099,26 @@ int ocrdma_destroy_qp(struct ibv_qp *ibqp)
 
 static void ocrdma_ring_sq_db(struct ocrdma_qp *qp)
 {
-	uint32_t db_val = htole32((qp->sq.dbid | (1 << 16)));
+	__le32 db_val = htole32((qp->sq.dbid | (1 << 16)));
 
 	udma_to_device_barrier();
-	*(uint32_t *) (((uint8_t *) qp->db_sq_va)) = db_val;
+	*(__le32 *) (((uint8_t *) qp->db_sq_va)) = db_val;
 }
 
 static void ocrdma_ring_rq_db(struct ocrdma_qp *qp)
 {
-	uint32_t db_val = htole32((qp->rq.dbid | (1 << qp->db_shift)));
+	__le32 db_val = htole32((qp->rq.dbid | (1 << qp->db_shift)));
 
 	udma_to_device_barrier();
-	*(uint32_t *) ((uint8_t *) qp->db_rq_va) = db_val;
+	*(__le32 *) ((uint8_t *) qp->db_rq_va) = db_val;
 }
 
 static void ocrdma_ring_srq_db(struct ocrdma_srq *srq)
 {
-	uint32_t db_val = htole32(srq->rq.dbid | (1 << srq->db_shift));
+	__le32 db_val = htole32(srq->rq.dbid | (1 << srq->db_shift));
 
 	udma_to_device_barrier();
-	*(uint32_t *) (srq->db_va) = db_val;
+	*(__le32 *) (srq->db_va) = db_val;
 }
 
 static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
@@ -1137,7 +1137,7 @@ static void ocrdma_ring_cq_db(struct ocrdma_cq *cq, uint32_t armed,
 	val |= (num_cqe << OCRDMA_DB_CQ_NUM_POPPED_SHIFT);
 
 	udma_to_device_barrier();
-	*(uint32_t *) ((uint8_t *) (cq->db_va) + OCRDMA_DB_CQ_OFFSET) =
+	*(__le32 *) ((uint8_t *) (cq->db_va) + OCRDMA_DB_CQ_OFFSET) =
 	    htole32(val);
 }
 
@@ -1323,7 +1323,7 @@ static void ocrdma_build_dpp_wqe(void *va, struct ocrdma_hdr_wqe *wqe,
 
 	/* convert WQE header to LE format */
 	for (; i < hdr_len; i++)
-		*((uint32_t *) va + i) =
+		*((__le32 *) va + i) =
 			htole32(*((uint32_t *) wqe + i));
 	/* Convertion of data is done in HW */
 	for (; i < pyld_len; i++)
@@ -1585,7 +1585,7 @@ static enum ibv_wc_status ocrdma_to_ibwc_err(uint16_t status)
 static void ocrdma_update_wc(struct ocrdma_qp *qp, struct ibv_wc *ibwc,
 			     uint32_t wqe_idx)
 {
-	struct ocrdma_hdr_wqe *hdr;
+	struct ocrdma_hdr_wqe_le *hdr;
 	struct ocrdma_sge *rw;
 	int opcode;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
