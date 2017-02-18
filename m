From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core v2 6/9] libbnxt_re: Enable UD control path and wqe posting
Date: Sat, 18 Feb 2017 10:43:55 -0500
Message-ID: <1487432638-19607-7-git-send-email-devesh.sharma@broadcom.com>
References: <1487432638-19607-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487432638-19607-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds infrastructure needed to enable unreliable
datagram control path. It also adds support to allow posting
Send WQEs to UD QPs. Following are the major changes:

 - Mmap the shared page exported from kernel driver to
   read AH-ID from kernel space.
 - Adds support to create-AH and destroy-AH.
 - Add support to allow posting UD WQEs.
 - Do not use search-psn memory for UD QPs.

v1->v2
 --Removed extra ref of PD in ah structure

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/bnxt_re-abi.h |  7 ++++
 providers/bnxt_re/main.c        | 17 ++++++++
 providers/bnxt_re/main.h        | 12 ++++++
 providers/bnxt_re/verbs.c       | 93 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 114 insertions(+), 15 deletions(-)

diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index b7eef36..3082d76 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -174,6 +174,13 @@ enum bnxt_re_ud_flags_mask {
 	BNXT_RE_UD_FLAGS_ROCE_IPV6	= 0x03
 };
 
+enum bnxt_re_shpg_offt {
+	BNXT_RE_SHPG_BEG_RESV_OFFT	= 0x00,
+	BNXT_RE_SHPG_AVID_OFFT		= 0x10,
+	BNXT_RE_SHPG_AVID_SIZE		= 0x04,
+	BNXT_RE_SHPG_END_RESV_OFFT	= 0xFF0
+};
+
 struct bnxt_re_db_hdr {
 	__u32 indx;
 	__u32 typ_qid; /* typ: 4, qid:20*/
diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index e58c953..aee5c43 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -129,18 +129,35 @@ static int bnxt_re_init_context(struct verbs_device *vdev,
 	dev->cqe_size = resp.cqe_size;
 	dev->max_cq_depth = resp.max_cqd;
 	pthread_spin_init(&cntx->fqlock, PTHREAD_PROCESS_PRIVATE);
+	/* mmap shared page. */
+	cntx->shpg = mmap(NULL, dev->pg_size, PROT_READ | PROT_WRITE,
+			  MAP_SHARED, cmd_fd, 0);
+	if (cntx->shpg == MAP_FAILED) {
+		cntx->shpg = NULL;
+		goto failed;
+	}
+	pthread_mutex_init(&cntx->shlock, NULL);
+
 	ibvctx->ops = bnxt_re_cntx_ops;
 
 	return 0;
+failed:
+	fprintf(stderr, DEV "Failed to allocate context for device\n");
+	return errno;
 }
 
 static void bnxt_re_uninit_context(struct verbs_device *vdev,
 				   struct ibv_context *ibvctx)
 {
+	struct bnxt_re_dev *dev;
 	struct bnxt_re_context *cntx;
 
+	dev = to_bnxt_re_dev(&vdev->device);
 	cntx = to_bnxt_re_context(ibvctx);
 	/* Unmap if anything device specific was mapped in init_context. */
+	pthread_mutex_destroy(&cntx->shlock);
+	if (cntx->shpg)
+		munmap(cntx->shpg, dev->pg_size);
 	pthread_spin_destroy(&cntx->fqlock);
 }
 
diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index d324ef6..9d99c64 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -123,6 +123,11 @@ struct bnxt_re_mr {
 	struct ibv_mr ibvmr;
 };
 
+struct bnxt_re_ah {
+	struct ibv_ah ibvah;
+	uint32_t avid;
+};
+
 struct bnxt_re_dev {
 	struct verbs_device vdev;
 	uint8_t abi_version;
@@ -138,6 +143,8 @@ struct bnxt_re_context {
 	uint32_t max_qp;
 	uint32_t max_srq;
 	struct bnxt_re_dpi udpi;
+	void *shpg;
+	pthread_mutex_t shlock;
 	pthread_spinlock_t fqlock;
 };
 
@@ -175,6 +182,11 @@ static inline struct bnxt_re_qp *to_bnxt_re_qp(struct ibv_qp *ibvqp)
 	return container_of(ibvqp, struct bnxt_re_qp, ibvqp);
 }
 
+static inline struct bnxt_re_ah *to_bnxt_re_ah(struct ibv_ah *ibvah)
+{
+        return container_of(ibvah, struct bnxt_re_ah, ibvah);
+}
+
 static inline uint32_t bnxt_re_get_sqe_sz(void)
 {
 	return sizeof(struct bnxt_re_bsqe) +
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 2273e82..19c30a0 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -706,9 +706,6 @@ static int bnxt_re_check_qp_limits(struct bnxt_re_context *cntx,
 	struct ibv_device_attr devattr;
 	int ret;
 
-	if (attr->qp_type == IBV_QPT_UD)
-		return -ENOSYS;
-
 	ret = bnxt_re_query_device(&cntx->ibvctx, &devattr);
 	if (ret)
 		return ret;
@@ -784,6 +781,11 @@ static int bnxt_re_alloc_queues(struct bnxt_re_qp *qp,
 		psn_depth++;
 
 	que->depth += psn_depth;
+	/* PSN-search memory is allocated without checking for
+	 * QP-Type. Kenrel driver do not map this memory if it
+	 * is UD-qp. UD-qp use this memory to maintain WC-opcode.
+	 * See definition of bnxt_re_fill_psns() for the use case.
+	 */
 	ret = bnxt_re_alloc_aligned(qp->sqq, pg_size);
 	if (ret)
 		return ret;
@@ -1009,18 +1011,18 @@ static void bnxt_re_fill_psns(struct bnxt_re_qp *qp, struct bnxt_re_psns *psns,
 	uint32_t pkt_cnt = 0, nxt_psn;
 
 	memset(psns, 0, sizeof(*psns));
-	psns->opc_spsn = qp->sq_psn & BNXT_RE_PSNS_SPSN_MASK;
+	if (qp->qptyp == IBV_QPT_RC) {
+		psns->opc_spsn = qp->sq_psn & BNXT_RE_PSNS_SPSN_MASK;
+		pkt_cnt = (len / qp->mtu);
+		if (len % qp->mtu)
+			pkt_cnt++;
+		nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
+		psns->flg_npsn = nxt_psn;
+		qp->sq_psn = nxt_psn;
+	}
 	opcode = bnxt_re_ibv_wr_to_wc_opcd(opcode);
 	psns->opc_spsn |= ((opcode & BNXT_RE_PSNS_OPCD_MASK) <<
 			    BNXT_RE_PSNS_OPCD_SHIFT);
-
-	pkt_cnt = (len / qp->mtu);
-	if (len % qp->mtu)
-		pkt_cnt++;
-	nxt_psn = ((qp->sq_psn + pkt_cnt) & BNXT_RE_PSNS_NPSN_MASK);
-	psns->flg_npsn = nxt_psn;
-	qp->sq_psn = nxt_psn;
-
 	*(uint64_t *)psns = htole64(*(uint64_t *)psns);
 }
 
@@ -1065,6 +1067,26 @@ static int bnxt_re_build_send_sqe(struct bnxt_re_qp *qp, void *wqe,
 	return len;
 }
 
+static int bnxt_re_build_ud_sqe(struct bnxt_re_qp *qp, void *wqe,
+				struct ibv_send_wr *wr, uint8_t is_inline)
+{
+	struct bnxt_re_send *sqe = ((void *)wqe + sizeof(struct bnxt_re_bsqe));
+	struct bnxt_re_ah *ah;
+	int len;
+
+	len = bnxt_re_build_send_sqe(qp, wqe, wr, is_inline);
+	sqe->qkey = wr->wr.ud.remote_qkey;
+	sqe->dst_qp = wr->wr.ud.remote_qpn;
+	if (!wr->wr.ud.ah) {
+		len = -EINVAL;
+		goto bail;
+	}
+	ah = to_bnxt_re_ah(wr->wr.ud.ah);
+	sqe->avid = ah->avid & 0xFFFFF;
+bail:
+	return len;
+}
+
 static int bnxt_re_build_rdma_sqe(struct bnxt_re_qp *qp, void *wqe,
 				  struct ibv_send_wr *wr, uint8_t is_inline)
 {
@@ -1126,9 +1148,14 @@ int bnxt_re_post_send(struct ibv_qp *ibvqp, struct ibv_send_wr *wr,
 		case IBV_WR_SEND_WITH_IMM:
 			hdr->key_immd = wr->imm_data;
 		case IBV_WR_SEND:
-			bytes = bnxt_re_build_send_sqe(qp, sqe, wr, is_inline);
+			if (qp->qptyp == IBV_QPT_UD)
+				bytes = bnxt_re_build_ud_sqe(qp, sqe, wr,
+							     is_inline);
+			else
+				bytes = bnxt_re_build_send_sqe(qp, sqe, wr,
+							       is_inline);
 			if (bytes < 0)
-				ret = ENOMEM;
+				ret = (bytes == -EINVAL) ? EINVAL : ENOMEM;
 			break;
 		case IBV_WR_RDMA_WRITE_WITH_IMM:
 			hdr->key_immd = wr->imm_data;
@@ -1269,10 +1296,46 @@ int bnxt_re_post_srq_recv(struct ibv_srq *ibvsrq, struct ibv_recv_wr *wr,
 
 struct ibv_ah *bnxt_re_create_ah(struct ibv_pd *ibvpd, struct ibv_ah_attr *attr)
 {
+	struct bnxt_re_context *uctx;
+	struct bnxt_re_ah *ah;
+	struct ibv_create_ah_resp resp;
+	int status;
+
+	uctx = to_bnxt_re_context(ibvpd->context);
+
+	ah = calloc(1, sizeof(*ah));
+	if (!ah)
+		goto failed;
+
+	pthread_mutex_lock(&uctx->shlock);
+	memset(&resp, 0, sizeof(resp));
+	status = ibv_cmd_create_ah(ibvpd, &ah->ibvah, attr,
+				   &resp, sizeof(resp));
+	if (status) {
+		pthread_mutex_unlock(&uctx->shlock);
+		free(ah);
+		goto failed;
+	}
+	/* read AV ID now. */
+	rmb();
+	ah->avid = *(uint32_t *)(uctx->shpg + BNXT_RE_SHPG_AVID_OFFT);
+	pthread_mutex_unlock(&uctx->shlock);
+
+	return &ah->ibvah;
+failed:
 	return NULL;
 }
 
 int bnxt_re_destroy_ah(struct ibv_ah *ibvah)
 {
-	return -ENOSYS;
+	struct bnxt_re_ah *ah;
+	int status;
+
+	ah = to_bnxt_re_ah(ibvah);
+	status = ibv_cmd_destroy_ah(ibvah);
+	if (status)
+		return status;
+	free(ah);
+
+	return 0;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
