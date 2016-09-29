From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 9/9] nes: Remove code guarded by HAVE_DECL_IBV_QPT_RAW_ETH
Date: Thu, 29 Sep 2016 14:47:56 -0600
Message-ID: <1475182076-5411-10-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Unclear what this was ever for, but we don't support it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libnes/src/nes_uverbs.c | 322 ------------------------------------------------
 1 file changed, 322 deletions(-)

diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 141f769bf14b..aa9c2b9e2b8c 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -206,80 +206,6 @@ int nes_udereg_mr(struct ibv_mr *mr)
 	return 0;
 }
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-static
-int nes_ima_ureplace_cq(struct ibv_cq *cq,
-			int mcrqf,
-			struct nes_uqp *nesuqp)
-{
-	struct nes_ucq *nesucq = to_nes_ucq(cq);
-	int ret;
-	struct nes_ucreate_cq cmd;
-	struct nes_ucreate_cq_resp resp;
-	int comp_vector = nesucq->comp_vector;
-	struct nes_ureg_mr reg_mr_cmd;
-	struct ibv_reg_mr_resp reg_mr_resp;
-	struct nes_uvcontext *nesvctx = to_nes_uctx(cq->context);
-
-	ret = ibv_cmd_destroy_cq(cq);
-	nes_debug(NES_DBG_UD, "%s(%d) mcrqf=%d ret=%d\n",
-			__func__,
-			__LINE__,
-			mcrqf,
-			ret);
-	if (ret)
-		return ret;
-
-	ret = ibv_cmd_dereg_mr(&nesucq->mr);
-	if (ret) {
-		fprintf(stderr, PFX "%s: Failed to deregister"
-			" CQ Memory Region.\n", __func__);
-		return ret;
-	}
-
-	reg_mr_cmd.reg_type = NES_UMEMREG_TYPE_CQ;
-
-	ret = ibv_cmd_reg_mr(&nesvctx->nesupd->ibv_pd, (void *)nesucq->cqes,
-			(nesucq->size*sizeof(struct nes_hw_cqe)),
-			(uintptr_t)nesucq->cqes,
-			IBV_ACCESS_LOCAL_WRITE, &nesucq->mr,
-			&reg_mr_cmd.ibv_cmd, sizeof reg_mr_cmd,
-			&reg_mr_resp, sizeof reg_mr_resp);
-	if (ret) {
-		free((struct nes_hw_cqe *)nesucq->cqes);
-		goto err;
-	}
-
-
-	/* Create the CQ */
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.user_cq_buffer = (__u64)((uintptr_t)nesucq->cqes);
-	cmd.mcrqf = mcrqf | 0x20000000;    /* IMA specific sq number */
-
-	nes_debug(NES_DBG_UD, "%s(%d) mcrqf=%d\n",
-			__func__, __LINE__,
-			mcrqf);
-	ret = ibv_cmd_create_cq(cq->context,
-			nesucq->size-1,
-			cq->channel,
-			comp_vector,
-			&nesucq->ibv_cq, &cmd.ibv_cmd, sizeof cmd,
-			&resp.ibv_resp, sizeof resp);
-	if (ret)
-		goto err;
-
-	nesucq->cq_id = (uint16_t)resp.cq_id;
-	nesucq->udqp = nesuqp;
-	nes_debug(NES_DBG_UD, "%s(%d) cqid=%d mcrqf=%d\n",
-			__func__, __LINE__,
-			nesucq->cq_id, mcrqf);
-
-	return 0;
- err:
-	return ret;
-}
-#endif
-
 /**
  * nes_ucreate_cq
  */
@@ -1103,15 +1029,6 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 
 	/* fprintf(stderr, PFX "%s\n", __FUNCTION__); */
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-	if (attr->qp_type == IBV_QPT_RAW_ETH) {
-		attr->cap.max_send_sge = NES_UD_MAX_SG_LIST_SZ;
-		attr->cap.max_recv_sge = NES_UD_MAX_SG_LIST_SZ;
-		nes_debug(NES_DBG_UD, "%s(%d) patching max_sge for UD\n",
-				__func__, __LINE__);
-	}
-#endif
-
 	/* Sanity check QP size before proceeding */
 	sqdepth = nes_qp_get_qdepth(attr->cap.max_send_wr, attr->cap.max_send_sge);
 	if (!sqdepth) {
@@ -1168,58 +1085,6 @@ struct ibv_qp *nes_ucreate_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 	nesuqp->ibv_qp.qp_num = resp.qp_id;
 	nesuqp->rdma0_msg = 1;
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-	if (attr->qp_type == IBV_QPT_RAW_ETH) {
-		int i = 0;
-
-		nesuqp->nes_ud_sksq_fd = open("/dev/infiniband/nes_ud_sksq",
-						O_RDWR);
-		if (nesuqp->nes_ud_sksq_fd <= 0)
-			return 0;
-		nesuqp->sksq_shared_ctxt = mmap(NULL, 4096,
-					PROT_WRITE | PROT_READ,
-					MAP_SHARED,
-					nesuqp->nes_ud_sksq_fd, 0);
-		if (nesuqp->sksq_shared_ctxt == 0)
-			return 0;
-
-		/* no LSMM for UD */
-		nesuqp->sq_head = 0;
-		nesuqp->sq_tail = 0;
-		nes_debug(NES_DBG_UD, "%s(%d) qpid=0x%x\n",
-			__func__, __LINE__, nesuqp->qp_id);
-
-		/* reallocate CQs after QP is created */
-		if (nes_ima_ureplace_cq(attr->recv_cq,
-					resp.qp_id & 0xffff,
-					nesuqp) != 0)
-			return NULL;
-
-		if (nes_ima_ureplace_cq(attr->send_cq,
-					resp.qp_id >> 16,
-					nesuqp) != 0)
-			return NULL;
-
-		/* allocate N+1, last one would be used for NULL */
-		nesuqp->pend_rx_wr = malloc(NES_UD_RX_BATCH_SZ *
-						sizeof *nesuqp->pend_rx_wr);
-		if (!nesuqp)
-			exit(0);
-
-		for (i = 0; i < NES_UD_RX_BATCH_SZ; i++) {
-			nesuqp->pend_rx_wr[i].sg_list =
-				malloc(NES_UD_MAX_SG_LIST_SZ *
-					sizeof *nesuqp->pend_rx_wr[i].sg_list);
-			nesuqp->pend_rx_wr[i].next =
-					(i < NES_UD_RX_BATCH_SZ-1) ?
-						&nesuqp->pend_rx_wr[i+1] : 0;
-		}
-		/* prepare the wr_id tables */
-		memset(&nesuqp->send_wr_id[0], 0, sizeof(uint64_t) * 512);
-		memset(&nesuqp->recv_wr_id[0], 0, sizeof(uint64_t) * 512);
-	}
-#endif
-
 	return &nesuqp->ibv_qp;
 }
 
@@ -1311,27 +1176,6 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 
 	pthread_spin_destroy(&nesuqp->lock);
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-	if (qp->qp_type == IBV_QPT_RAW_ETH) {
-		int i = 0;
-
-		if (nesuqp->pend_rx_wr) {
-			for (i = 0; i < NES_UD_RX_BATCH_SZ; i++)
-				if (nesuqp->pend_rx_wr[i].sg_list) {
-					free(nesuqp->pend_rx_wr[i].sg_list);
-					nesuqp->pend_rx_wr[i].sg_list  = 0;
-				}
-		}
-		free(nesuqp->pend_rx_wr);
-		nesuqp->pend_rx_wr = 0;
-		if (nesuqp->sksq_shared_ctxt)
-			munmap(nesuqp->sksq_shared_ctxt, 4096);
-
-		nesuqp->sksq_shared_ctxt = 0;
-		close(nesuqp->nes_ud_sksq_fd);
-	}
-#endif
-
 	/* Clean any pending completions from the cq(s) */
 	if (nesuqp->send_cq)
 		nes_clean_cq(nesuqp, nesuqp->send_cq);
@@ -1343,85 +1187,6 @@ int nes_udestroy_qp(struct ibv_qp *qp)
 	return 0;
 }
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-static inline
-int nes_ima_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
-		struct ibv_send_wr **bad_wr)
-{
-	struct nes_uqp *nesuqp = to_nes_uqp(ib_qp);
-	int new_req_cnt = 0;
-	uint32_t outstanding_wqes;
-	uint32_t qsize = nesuqp->sq_size;
-	int ret = 0;
-	struct ibv_send_wr *tmp_wr = ib_wr;
-	struct nes_ud_send_wr *nes_ud_wr = 0;
-	int bc = 0;
-	int sq_head;
-	int wr_id_head;
-
-	while (tmp_wr) {
-		new_req_cnt++;
-		tmp_wr = tmp_wr->next;
-	}
-	if (nesuqp->sq_head >= nesuqp->sq_tail)
-		outstanding_wqes = nesuqp->sq_head - nesuqp->sq_tail;
-	else
-		outstanding_wqes = nesuqp->sq_head + qsize - nesuqp->sq_tail;
-
-	if (unlikely(outstanding_wqes >= (qsize - new_req_cnt)))
-		return -EINVAL;
-
-	/* we know that there is sufficient space in the send queue */
-	/* so we can store wr_id in the wr_id queue */
-	sq_head = nesuqp->sq_head;
-
-	if (sq_head + new_req_cnt >= qsize)
-		nesuqp->sq_head = sq_head + new_req_cnt - qsize;
-	else
-		nesuqp->sq_head = sq_head + new_req_cnt;
-
-	nes_ud_wr = (struct nes_ud_send_wr *)nesuqp->sksq_shared_ctxt;
-	bc = 0;
-
-	/* set up the qp id in the shared page message */
-	nes_ud_wr->qpn = nesuqp->qp_id;
-
-	while (ib_wr) {
-		nes_ud_wr->sg_list[bc].addr = ib_wr->sg_list[0].addr;
-		nes_ud_wr->sg_list[bc].length = ib_wr->sg_list[0].length;
-		nes_ud_wr->sg_list[bc].lkey = ib_wr->sg_list[0].lkey;
-		nes_ud_wr->flags = ib_wr->send_flags;
-		nes_ud_wr->flags = nes_ud_wr->flags | (ib_wr->imm_data << 16);
-		/* store the wr_id in the internal queue */
-		/* the queue is in sync with the queue in kernel */
-		/* the wr_id will be read in poll_cq */
-		wr_id_head = bc + sq_head;
-		if (wr_id_head > (qsize - 1))
-			wr_id_head = wr_id_head - qsize;
-
-		nesuqp->send_wr_id[wr_id_head] = ib_wr->wr_id;
-		if (++bc >= 64) {
-			nes_ud_wr->wr_cnt = bc;
-			ret = write(nesuqp->nes_ud_sksq_fd, 0, 0);
-			if (ret != 0)
-				goto out;
-			nes_ud_wr =
-			(struct nes_ud_send_wr *)nesuqp->sksq_shared_ctxt;
-			bc = 0;
-		}
-		ib_wr = ib_wr->next;
-	}
-	if (bc > 0) {
-		nes_ud_wr->wr_cnt = bc;
-		ret = write(nesuqp->nes_ud_sksq_fd, 0, 0);
-		if (ret != 0)
-			goto out;
-	}
-out:
-	return ret;
-}
-#endif
-
 /**
  * nes_upost_send
  */
@@ -1441,11 +1206,6 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	uint32_t total_payload_length = 0;
 	int sge_index;
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-	if (ib_qp->qp_type == IBV_QPT_RAW_ETH)
-		return nes_ima_upost_send(ib_qp, ib_wr, bad_wr);
-#endif
-
 	pthread_spin_lock(&nesuqp->lock);
 
 	head = nesuqp->sq_head;
@@ -1617,83 +1377,6 @@ int nes_upost_send(struct ibv_qp *ib_qp, struct ibv_send_wr *ib_wr,
 	return err;
 }
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-static inline
-int nes_ima_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
-		struct ibv_recv_wr **bad_wr)
-{
-	struct nes_uqp *nesuqp = to_nes_uqp(ib_qp);
-	int new_req_cnt = 0;
-	uint32_t outstanding_wqes;
-	uint32_t qsize = nesuqp->rq_size;
-	struct ibv_send_wr *tmp_wr = (struct ibv_send_wr *)ib_wr;
-	int ret = 0;
-	struct nes_ud_recv_wr *nes_ud_wr;
-	int rq_head;
-	int bc;
-	int wr_id_head;
-
-	nes_ud_wr = (struct nes_ud_recv_wr *)
-				(((char *)nesuqp->sksq_shared_ctxt) + 2048);
-	while (tmp_wr) {
-		new_req_cnt++;
-		tmp_wr = tmp_wr->next;
-	}
-
-	if (nesuqp->rq_head >= nesuqp->rq_tail)
-		outstanding_wqes = nesuqp->rq_head - nesuqp->rq_tail;
-	else
-		outstanding_wqes = nesuqp->rq_head + qsize - nesuqp->rq_tail;
-
-	if (unlikely(outstanding_wqes >= (qsize - new_req_cnt)))
-		return -EINVAL;
-
-	/* now we know thay the rq has sufficient
-	   place so we can start wr_id storing */
-	rq_head = nesuqp->rq_head;
-
-	if (rq_head + new_req_cnt >= qsize)
-		nesuqp->rq_head = rq_head + new_req_cnt - qsize;
-	else
-		nesuqp->rq_head = rq_head + new_req_cnt;
-
-	/* set the queue number in the shared page */
-	nes_ud_wr->qpn = nesuqp->qp_id;
-	bc = 0;
-	while (ib_wr) {
-		if (ib_wr->num_sge > NES_UD_MAX_SG_LIST_SZ)
-			return -EINVAL;
-
-		nes_ud_wr->sg_list[nesuqp->pending_rcvs].addr =
-						ib_wr->sg_list[0].addr;
-		nes_ud_wr->sg_list[nesuqp->pending_rcvs].length =
-						ib_wr->sg_list[0].length;
-		nes_ud_wr->sg_list[nesuqp->pending_rcvs].lkey =
-						ib_wr->sg_list[0].lkey;
-
-		/* store the wr_id */
-		wr_id_head = bc + rq_head;
-		if (wr_id_head > (qsize - 1))
-			wr_id_head = wr_id_head - qsize;
-
-		nesuqp->recv_wr_id[wr_id_head] = ib_wr->wr_id;
-		bc++;
-
-		++nesuqp->pending_rcvs;
-		if (nesuqp->pending_rcvs >= NES_UD_RX_BATCH_SZ) {
-			nes_ud_wr->wr_cnt = nesuqp->pending_rcvs;
-			ret = read(nesuqp->nes_ud_sksq_fd, 0, 0);
-			if (ret != 0)
-				goto out;
-			nesuqp->pending_rcvs = 0;
-		}
-		ib_wr = ib_wr->next;
-	}
-out:
-	return ret;
-}
-#endif
-
 /**
  * nes_upost_recv
  */
@@ -1713,11 +1396,6 @@ int nes_upost_recv(struct ibv_qp *ib_qp, struct ibv_recv_wr *ib_wr,
 	uint32_t total_payload_length;
 	int sge_index;
 
-#if HAVE_DECL_IBV_QPT_RAW_ETH
-	if (ib_qp->qp_type == IBV_QPT_RAW_ETH)
-		return nes_ima_upost_recv(ib_qp, ib_wr, bad_wr);
-#endif
-
 	if (unlikely(ib_wr->num_sge > 4)) {
 		*bad_wr = ib_wr;
 		return -EINVAL;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
