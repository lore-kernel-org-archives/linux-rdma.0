From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 24/28] Fix gcc 5.4, clang 3.6 warnings about unused objects
Date: Mon,  5 Sep 2016 15:08:14 -0600
Message-ID: <1473109698-31408-25-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mostly just delete cruft.

nes has a number of unused related to HAVE_DECL_IBV_QPT_RAW_ETH,
perhaps this code should be deleted entirely because whatever
QPT_RAW_ETH is, it is not part of this repository.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libcxgb3/src/qp.c                  | 41 --------------------------------------
 libibumad/tests/umad_reg2_compat.c |  1 -
 libnes/src/nes_uverbs.c            | 17 +++++++++-------
 libocrdma/src/ocrdma_verbs.c       |  3 ++-
 librdmacm/examples/cmtime.c        | 16 ---------------
 5 files changed, 12 insertions(+), 66 deletions(-)

diff --git a/libcxgb3/src/qp.c b/libcxgb3/src/qp.c
index 34b6fa9f5632..7dd3c7e342a7 100644
--- a/libcxgb3/src/qp.c
+++ b/libcxgb3/src/qp.c
@@ -285,47 +285,6 @@ int t3a_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	return ret;
 }
 
-/* 
- * XXX: This is going to be moved to firmware. 
- *      Missing pdid/qpid check for now.
- */
-static inline int iwch_sgl2pbl_map(struct iwch_device *rhp,
-				   struct ibv_sge *sg_list, uint32_t num_sgle,
-				   uint32_t *pbl_addr, uint8_t *page_size)
-{
-	int i;
-	struct iwch_mr *mhp;
-	uint32_t offset;
-	for (i = 0; i < num_sgle; i++) {
-		mhp = rhp->mmid2ptr[t3_mmid(sg_list[i].lkey)];
-		if (!mhp) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
-			return -1;
-		}
-		if (sg_list[i].addr < mhp->va_fbo) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
-			return -1;
-		}
-		if (sg_list[i].addr + ((uint64_t) sg_list[i].length) <
-		    sg_list[i].addr) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
-			return -1;
-		}
-		if (sg_list[i].addr + ((uint64_t) sg_list[i].length) >
-		    mhp->va_fbo + ((uint64_t) mhp->len)) {
-			PDBG("%s %d\n", __FUNCTION__, __LINE__);
-			return -1;
-		}
-		offset = sg_list[i].addr - mhp->va_fbo;
-		offset += ((uint32_t) mhp->va_fbo) %
-		    (1UL << (12 + mhp->page_size));
-		pbl_addr[i] = mhp->pbl_addr +
-		    (offset >> (12 + mhp->page_size));
-		page_size[i] = mhp->page_size;
-	}
-	return 0;
-}
-
 static inline int iwch_build_rdma_recv(struct iwch_device *rhp,
 				       union t3_wr *wqe, 
 				       struct ibv_recv_wr *wr)
diff --git a/libibumad/tests/umad_reg2_compat.c b/libibumad/tests/umad_reg2_compat.c
index 6dd4a48a59b2..9c239ee4bfae 100644
--- a/libibumad/tests/umad_reg2_compat.c
+++ b/libibumad/tests/umad_reg2_compat.c
@@ -100,7 +100,6 @@ int open_test_device(void)
 
 void test_register(void)
 {
-	int rc = 0;
 	int agent_id;
 	long method_mask[16 / sizeof(long)];
 	uint32_t class_oui = 0x001405; /* OPENIB_OUI */
diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 6458c51c3f55..983d87a80b8b 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -215,6 +215,7 @@ int nes_udereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static
 int nes_ima_ureplace_cq(struct ibv_cq *cq,
 			int mcrqf,
@@ -296,6 +297,7 @@ int nes_ima_ureplace_cq(struct ibv_cq *cq,
  err:
 	return ret;
 }
+#endif
 
 /**
  * nes_ucreate_cq
@@ -425,7 +427,6 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	int cqe_count = 0;
 	uint32_t head;
 	uint32_t cq_size;
-	uint16_t qp_size;
 
 	volatile struct nes_hw_nic_cqe *cqe = 0;
 	volatile struct nes_hw_nic_cqe *cqes;
@@ -487,7 +488,6 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 			entry->src_qp = nesuqp->qp_id;
 			if (cqe_misc & NES_NIC_CQE_SQ) {
 				entry->opcode = IBV_WC_SEND;
-				qp_size = nesuqp->sq_size;
 
 				entry->wr_id =
 					nesuqp->send_wr_id[nesuqp->sq_tail];
@@ -557,7 +557,6 @@ int nes_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	uint32_t wqe_index;
 	uint32_t wq_tail = 0;
 	struct nes_hw_cqe cqe;
-	uint32_t tmp;
 	uint64_t u64temp;
 	int move_cq_head = 1;
 	uint32_t err_code;
@@ -679,7 +678,6 @@ nes_upoll_cq_update:
 					nesvctx = to_nes_uctx(cq->context);
 				nesvctx->nesupd->udoorbell->cqe_alloc = cpu_to_le32(nesucq->cq_id |
 						(nesucq->polled_completions << 16));
-				tmp = nesvctx->nesupd->udoorbell->cqe_alloc;
 				nesucq->polled_completions = 0;
 			}
 		} else {
@@ -699,7 +697,6 @@ nes_upoll_cq_update:
 			nesvctx = to_nes_uctx(cq->context);
 		nesvctx->nesupd->udoorbell->cqe_alloc = cpu_to_le32(nesucq->cq_id |
 				(nesucq->polled_completions << 16));
-		tmp = nesvctx->nesupd->udoorbell->cqe_alloc;
 		nesucq->polled_completions = 0;
 	}
 	nesucq->head = head;
@@ -1140,7 +1137,6 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	struct nes_uqp *nesuqp;
 	int	sqdepth, rqdepth;
 	int	 status = 1;
-	int i = 0;
 
 	/* fprintf(stderr, PFX "%s\n", __FUNCTION__); */
 
@@ -1211,6 +1207,8 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 
 #if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (attr->qp_type == IBV_QPT_RAW_ETH) {
+		int i = 0;
+
 		nesuqp->nes_ud_sksq_fd = open("/dev/infiniband/nes_ud_sksq",
 						O_RDWR);
 		if (nesuqp->nes_ud_sksq_fd <= 0)
@@ -1327,7 +1325,6 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 {
 	struct nes_uqp *nesuqp = to_nes_uqp(qp);
 	int ret = 0;
-	int i = 0;
 
 	// fprintf(stderr, PFX "%s addr&mr= %p  \n", __FUNCTION__, &nesuqp->mr );
 
@@ -1353,6 +1350,8 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 
 #if HAVE_DECL_IBV_QPT_RAW_ETH
 	if (qp->qp_type == IBV_QPT_RAW_ETH) {
+		int i = 0;
+
 		if (nesuqp->pend_rx_wr) {
 			for (i = 0; i < NES_UD_RX_BATCH_SZ; i++)
 				if (nesuqp->pend_rx_wr[i].sg_list) {
@@ -1381,6 +1380,7 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 	return 0;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static inline
 int nes_ima_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 		struct ibv_send_wr **bad_wr)
@@ -1457,6 +1457,7 @@ int nes_ima_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 out:
 	return ret;
 }
+#endif
 
 /**
  * nes_upost_send
@@ -1653,6 +1654,7 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	return err;
 }
 
+#if HAVE_DECL_IBV_QPT_RAW_ETH
 static inline
 int nes_ima_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 		struct ibv_recv_wr **bad_wr)
@@ -1727,6 +1729,7 @@ int nes_ima_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 out:
 	return ret;
 }
+#endif
 
 /**
  * nes_upost_recv
diff --git a/libocrdma/src/ocrdma_verbs.c b/libocrdma/src/ocrdma_verbs.c
index 60626260656d..8eb70db2693a 100644
--- a/libocrdma/src/ocrdma_verbs.c
+++ b/libocrdma/src/ocrdma_verbs.c
@@ -945,10 +945,11 @@ static inline void *ocrdma_hwq_head(struct ocrdma_qp_hwq_info *q)
 	return q->va + (q->head * q->entry_size);
 }
 
-static inline void *ocrdma_wq_tail(struct ocrdma_qp_hwq_info *q)
+/*static inline void *ocrdma_wq_tail(struct ocrdma_qp_hwq_info *q)
 {
 	return q->va + (q->tail * q->entry_size);
 }
+*/
 
 static inline void *ocrdma_hwq_head_from_idx(struct ocrdma_qp_hwq_info *q,
 					     uint32_t idx)
diff --git a/librdmacm/examples/cmtime.c b/librdmacm/examples/cmtime.c
index e45980b9bb04..f0b4d0276288 100644
--- a/librdmacm/examples/cmtime.c
+++ b/librdmacm/examples/cmtime.c
@@ -128,13 +128,6 @@ static inline int __list_empty(struct work_list *list)
 	return list->list.next == &list->list;
 }
 
-static inline int list_empty(struct work_list *work_list)
-{
-	pthread_mutex_lock(&work_list->lock);
-	return work_list->list.next == &work_list->list;
-	pthread_mutex_unlock(&work_list->lock);
-}
-
 static inline struct list_head *__list_remove_head(struct work_list *work_list)
 {
 	struct list_head *list_item;
@@ -144,15 +137,6 @@ static inline struct list_head *__list_remove_head(struct work_list *work_list)
 	return list_item;
 }
 
-static inline struct list_head *list_remove_head(struct work_list *work_list)
-{
-	struct list_head *list_item;
-	pthread_mutex_lock(&work_list->lock);
-	list_item = __list_remove_head(work_list);
-	pthread_mutex_unlock(&work_list->lock);
-	return list_item;
-}
-
 static inline void list_add_tail(struct work_list *work_list, struct list_head *req)
 {
 	int empty;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
