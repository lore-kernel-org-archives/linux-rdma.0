From: Joe Perches <joe@perches.com>
Subject: [PATCH 6/6] infiniband: qplib_fp: Use dev_fmt
Date: Wed,  9 May 2018 08:15:50 -0700
Message-ID: <51c5082a4add7520b4fac54e58ca26a8156bf5e8.1525878372.git.joe@perches.com>
References: <cover.1525878372.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525878372.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: x86@kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert the embedded dev_<level> uses to use the new dev_fmt
prefix and remove the prefix from the formats.

Miscellanea:

o Add missing terminating newlines to avoid possible interleaving
o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 125 ++++++++++++++-----------------
 1 file changed, 57 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 3a78faba8d91..cbe6dbea9ab6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -36,6 +36,8 @@
  * Description: Fast Path Operators
  */
 
+#define dev_fmt(fmt) "QPLIB: " fmt
+
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
@@ -70,8 +72,7 @@ static void __bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp)
 	rcq = qp->rcq;
 
 	if (!qp->sq.flushed) {
-		dev_dbg(&scq->hwq.pdev->dev,
-			"QPLIB: FP: Adding to SQ Flush list = %p",
+		dev_dbg(&scq->hwq.pdev->dev, "FP: Adding to SQ Flush list = %p\n",
 			qp);
 		bnxt_qplib_cancel_phantom_processing(qp);
 		list_add_tail(&qp->sq_flush, &scq->sqf_head);
@@ -79,8 +80,7 @@ static void __bnxt_qplib_add_flush_qp(struct bnxt_qplib_qp *qp)
 	}
 	if (!qp->srq) {
 		if (!qp->rq.flushed) {
-			dev_dbg(&rcq->hwq.pdev->dev,
-				"QPLIB: FP: Adding to RQ Flush list = %p",
+			dev_dbg(&rcq->hwq.pdev->dev, "FP: Adding to RQ Flush list = %p\n",
 				qp);
 			list_add_tail(&qp->rq_flush, &rcq->rqf_head);
 			qp->rq.flushed = true;
@@ -161,7 +161,7 @@ static void bnxt_qpn_cqn_sched_task(struct work_struct *work)
 		spin_lock_bh(&cq->compl_lock);
 		if (atomic_read(&cq->arm_state) && nq->cqn_handler) {
 			dev_dbg(&nq->pdev->dev,
-				"%s:Trigger cq  = %p event nq = %p\n",
+				"%s: Trigger cq  = %p event nq = %p\n",
 				__func__, cq, nq);
 			nq->cqn_handler(nq, cq);
 		}
@@ -206,8 +206,7 @@ static int bnxt_qplib_alloc_qp_hdr_buf(struct bnxt_qplib_res *res,
 					&qp->sq_hdr_buf_map, GFP_KERNEL);
 		if (!qp->sq_hdr_buf) {
 			rc = -ENOMEM;
-			dev_err(&res->pdev->dev,
-				"QPLIB: Failed to create sq_hdr_buf");
+			dev_err(&res->pdev->dev, "Failed to create sq_hdr_buf\n");
 			goto fail;
 		}
 	}
@@ -220,8 +219,7 @@ static int bnxt_qplib_alloc_qp_hdr_buf(struct bnxt_qplib_res *res,
 						    GFP_KERNEL);
 		if (!qp->rq_hdr_buf) {
 			rc = -ENOMEM;
-			dev_err(&res->pdev->dev,
-				"QPLIB: Failed to create rq_hdr_buf");
+			dev_err(&res->pdev->dev, "Failed to create rq_hdr_buf\n");
 			goto fail;
 		}
 	}
@@ -276,8 +274,7 @@ static void bnxt_qplib_service_nq(unsigned long data)
 			if (!nq->cqn_handler(nq, (cq)))
 				num_cqne_processed++;
 			else
-				dev_warn(&nq->pdev->dev,
-					 "QPLIB: cqn - type 0x%x not handled",
+				dev_warn(&nq->pdev->dev, "cqn - type 0x%x not handled\n",
 					 type);
 			spin_unlock_bh(&cq->compl_lock);
 			break;
@@ -297,16 +294,14 @@ static void bnxt_qplib_service_nq(unsigned long data)
 					      nqsrqe->event))
 				num_srqne_processed++;
 			else
-				dev_warn(&nq->pdev->dev,
-					 "QPLIB: SRQ event 0x%x not handled",
+				dev_warn(&nq->pdev->dev, "SRQ event 0x%x not handled\n",
 					 nqsrqe->event);
 			break;
 		}
 		case NQ_BASE_TYPE_DBQ_EVENT:
 			break;
 		default:
-			dev_warn(&nq->pdev->dev,
-				 "QPLIB: nqe with type = 0x%x not handled",
+			dev_warn(&nq->pdev->dev, "nqe with type = 0x%x not handled\n",
 				 type);
 			break;
 		}
@@ -393,7 +388,7 @@ int bnxt_qplib_enable_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq,
 	rc = request_irq(nq->vector, bnxt_qplib_nq_irq, 0, nq->name, nq);
 	if (rc) {
 		dev_err(&nq->pdev->dev,
-			"Failed to request IRQ for NQ: %#x", rc);
+			"Failed to request IRQ for NQ: %#x\n", rc);
 		goto fail;
 	}
 
@@ -401,8 +396,7 @@ int bnxt_qplib_enable_nq(struct pci_dev *pdev, struct bnxt_qplib_nq *nq,
 	cpumask_set_cpu(nq_idx, &nq->mask);
 	rc = irq_set_affinity_hint(nq->vector, &nq->mask);
 	if (rc) {
-		dev_warn(&nq->pdev->dev,
-			 "QPLIB: set affinity failed; vector: %d nq_idx: %d\n",
+		dev_warn(&nq->pdev->dev, "set affinity failed; vector: %d nq_idx: %d\n",
 			 nq->vector, nq_idx);
 	}
 
@@ -636,7 +630,7 @@ int bnxt_qplib_post_srq_recv(struct bnxt_qplib_srq *srq,
 
 	spin_lock(&srq_hwq->lock);
 	if (srq->start_idx == srq->last_idx) {
-		dev_err(&srq_hwq->pdev->dev, "QPLIB: FP: SRQ (0x%x) is full!",
+		dev_err(&srq_hwq->pdev->dev, "FP: SRQ (0x%x) is full!\n",
 			srq->id);
 		rc = -EINVAL;
 		spin_unlock(&srq_hwq->lock);
@@ -1298,7 +1292,7 @@ int bnxt_qplib_query_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		}
 	}
 	if (i == res->sgid_tbl.max)
-		dev_warn(&res->pdev->dev, "QPLIB: SGID not found??");
+		dev_warn(&res->pdev->dev, "SGID not found??\n");
 
 	qp->ah.hop_limit = sb->hop_limit;
 	qp->ah.traffic_class = sb->traffic_class;
@@ -1502,7 +1496,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		if (qp->state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
 			sch_handler = true;
 			dev_dbg(&sq->hwq.pdev->dev,
-				"%s Error QP. Scheduling for poll_cq\n",
+				"%s: Error QP. Scheduling for poll_cq\n",
 				__func__);
 			goto queue_err;
 		}
@@ -1510,7 +1504,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 
 	if (bnxt_qplib_queue_full(sq)) {
 		dev_err(&sq->hwq.pdev->dev,
-			"QPLIB: prod = %#x cons = %#x qdepth = %#x delta = %#x",
+			"prod = %#x cons = %#x qdepth = %#x delta = %#x\n",
 			sq->hwq.prod, sq->hwq.cons, sq->hwq.max_elements,
 			sq->q_full_delta);
 		rc = -ENOMEM;
@@ -1535,7 +1529,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 		/* Copy the inline data */
 		if (wqe->inline_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
 			dev_warn(&sq->hwq.pdev->dev,
-				 "QPLIB: Inline data length > 96 detected");
+				 "Inline data length > 96 detected\n");
 			data_len = BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH;
 		} else {
 			data_len = wqe->inline_len;
@@ -1750,7 +1744,7 @@ int bnxt_qplib_post_send(struct bnxt_qplib_qp *qp,
 			queue_work(qp->scq->nq->cqn_wq, &nq_work->work);
 		} else {
 			dev_err(&sq->hwq.pdev->dev,
-				"QPLIB: FP: Failed to allocate SQ nq_work!");
+				"FP: Failed to allocate SQ nq_work!\n");
 			rc = -ENOMEM;
 		}
 	}
@@ -1789,13 +1783,13 @@ int bnxt_qplib_post_recv(struct bnxt_qplib_qp *qp,
 	if (qp->state == CMDQ_MODIFY_QP_NEW_STATE_ERR) {
 		sch_handler = true;
 		dev_dbg(&rq->hwq.pdev->dev,
-			"%s Error QP. Scheduling for poll_cq\n",
+			"%s: Error QP. Scheduling for poll_cq\n",
 			__func__);
 		goto queue_err;
 	}
 	if (bnxt_qplib_queue_full(rq)) {
-		dev_err(&rq->hwq.pdev->dev,
-			"QPLIB: FP: QP (0x%x) RQ is full!", qp->id);
+		dev_err(&rq->hwq.pdev->dev, "FP: QP (0x%x) RQ is full!\n",
+			qp->id);
 		rc = -EINVAL;
 		goto done;
 	}
@@ -1844,7 +1838,7 @@ int bnxt_qplib_post_recv(struct bnxt_qplib_qp *qp,
 			queue_work(qp->rcq->nq->cqn_wq, &nq_work->work);
 		} else {
 			dev_err(&rq->hwq.pdev->dev,
-				"QPLIB: FP: Failed to allocate RQ nq_work!");
+				"FP: Failed to allocate RQ nq_work!\n");
 			rc = -ENOMEM;
 		}
 	}
@@ -1906,7 +1900,7 @@ int bnxt_qplib_create_cq(struct bnxt_qplib_res *res, struct bnxt_qplib_cq *cq)
 
 	if (!cq->dpi) {
 		dev_err(&rcfw->pdev->dev,
-			"QPLIB: FP: CREATE_CQ failed due to NULL DPI");
+			"FP: CREATE_CQ failed due to NULL DPI\n");
 		return -EINVAL;
 	}
 	req.dpi = cpu_to_le32(cq->dpi->dpi);
@@ -2146,7 +2140,7 @@ static int do_wa9060(struct bnxt_qplib_qp *qp, struct bnxt_qplib_cq *cq,
 						 *  comes back
 						 */
 						dev_dbg(&cq->hwq.pdev->dev,
-							"FP:Got Phantom CQE");
+							"FP:Got Phantom CQE\n");
 						sq->condition = false;
 						sq->single = true;
 						rc = 0;
@@ -2163,7 +2157,7 @@ static int do_wa9060(struct bnxt_qplib_qp *qp, struct bnxt_qplib_cq *cq,
 			peek_raw_cq_cons++;
 		}
 		dev_err(&cq->hwq.pdev->dev,
-			"Should not have come here! cq_cons=0x%x qp=0x%x sq cons sw=0x%x hw=0x%x",
+			"Should not have come here! cq_cons=0x%x qp=0x%x sq cons sw=0x%x hw=0x%x\n",
 			cq_cons, qp->id, sw_sq_cons, cqe_sq_cons);
 		rc = -EINVAL;
 	}
@@ -2186,18 +2180,15 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
 	qp = (struct bnxt_qplib_qp *)((unsigned long)
 				      le64_to_cpu(hwcqe->qp_handle));
 	if (!qp) {
-		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: Process Req qp is NULL");
+		dev_err(&cq->hwq.pdev->dev, "FP: Process Req qp is NULL\n");
 		return -EINVAL;
 	}
 	sq = &qp->sq;
 
 	cqe_sq_cons = HWQ_CMP(le16_to_cpu(hwcqe->sq_cons_idx), &sq->hwq);
 	if (cqe_sq_cons > sq->hwq.max_elements) {
-		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: CQ Process req reported ");
-		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: sq_cons_idx 0x%x which exceeded max 0x%x",
+		dev_err(&cq->hwq.pdev->dev, "FP: CQ Process req reported\n");
+		dev_err(&cq->hwq.pdev->dev, "sq_cons_idx 0x%x which exceeded max 0x%x\n",
 			cqe_sq_cons, sq->hwq.max_elements);
 		return -EINVAL;
 	}
@@ -2236,9 +2227,9 @@ static int bnxt_qplib_cq_process_req(struct bnxt_qplib_cq *cq,
 		    hwcqe->status != CQ_REQ_STATUS_OK) {
 			cqe->status = hwcqe->status;
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Processed Req ");
+				"FP: CQ Processed Req\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id[%d] = 0x%llx with status 0x%x",
+				"wr_id[%d] = 0x%llx with status 0x%x\n",
 				sw_sq_cons, cqe->wr_id, cqe->status);
 			cqe++;
 			(*budget)--;
@@ -2304,7 +2295,7 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
 	qp = (struct bnxt_qplib_qp *)((unsigned long)
 				      le64_to_cpu(hwcqe->qp_handle));
 	if (!qp) {
-		dev_err(&cq->hwq.pdev->dev, "QPLIB: process_cq RC qp is NULL");
+		dev_err(&cq->hwq.pdev->dev, "process_cq RC qp is NULL\n");
 		return -EINVAL;
 	}
 	if (qp->rq.flushed) {
@@ -2330,9 +2321,9 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
 			return -EINVAL;
 		if (wr_id_idx > srq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process RC ");
+				"FP: CQ Process RC\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id idx 0x%x exceeded SRQ max 0x%x",
+				"wr_id idx 0x%x exceeded SRQ max 0x%x\n",
 				wr_id_idx, srq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2345,9 +2336,9 @@ static int bnxt_qplib_cq_process_res_rc(struct bnxt_qplib_cq *cq,
 		rq = &qp->rq;
 		if (wr_id_idx > rq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process RC ");
+				"FP: CQ Process RC\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id idx 0x%x exceeded RQ max 0x%x",
+				"wr_id idx 0x%x exceeded RQ max 0x%x\n",
 				wr_id_idx, rq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2383,7 +2374,7 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
 	qp = (struct bnxt_qplib_qp *)((unsigned long)
 				      le64_to_cpu(hwcqe->qp_handle));
 	if (!qp) {
-		dev_err(&cq->hwq.pdev->dev, "QPLIB: process_cq UD qp is NULL");
+		dev_err(&cq->hwq.pdev->dev, "process_cq UD qp is NULL\n");
 		return -EINVAL;
 	}
 	if (qp->rq.flushed) {
@@ -2413,9 +2404,9 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
 
 		if (wr_id_idx > srq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process UD ");
+				"FP: CQ Process UD\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id idx 0x%x exceeded SRQ max 0x%x",
+				"wr_id idx 0x%x exceeded SRQ max 0x%x\n",
 				wr_id_idx, srq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2428,9 +2419,9 @@ static int bnxt_qplib_cq_process_res_ud(struct bnxt_qplib_cq *cq,
 		rq = &qp->rq;
 		if (wr_id_idx > rq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process UD ");
+				"FP: CQ Process UD\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id idx 0x%x exceeded RQ max 0x%x",
+				"wr_id idx 0x%x exceeded RQ max 0x%x\n",
 				wr_id_idx, rq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2483,7 +2474,7 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 				      le64_to_cpu(hwcqe->qp_handle));
 	if (!qp) {
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: process_cq Raw/QP1 qp is NULL");
+			"process_cq Raw/QP1 qp is NULL\n");
 		return -EINVAL;
 	}
 	if (qp->rq.flushed) {
@@ -2517,14 +2508,14 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 		srq = qp->srq;
 		if (!srq) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: SRQ used but not defined??");
+				"FP: SRQ used but not defined??\n");
 			return -EINVAL;
 		}
 		if (wr_id_idx > srq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process Raw/QP1 ");
+				"FP: CQ Process Raw/QP1\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: wr_id idx 0x%x exceeded SRQ max 0x%x",
+				"wr_id idx 0x%x exceeded SRQ max 0x%x\n",
 				wr_id_idx, srq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2537,9 +2528,9 @@ static int bnxt_qplib_cq_process_res_raweth_qp1(struct bnxt_qplib_cq *cq,
 		rq = &qp->rq;
 		if (wr_id_idx > rq->hwq.max_elements) {
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: FP: CQ Process Raw/QP1 RQ wr_id ");
+				"FP: CQ Process Raw/QP1 RQ wr_id\n");
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: ix 0x%x exceeded RQ max 0x%x",
+				"ix 0x%x exceeded RQ max 0x%x\n",
 				wr_id_idx, rq->hwq.max_elements);
 			return -EINVAL;
 		}
@@ -2574,14 +2565,14 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
 	/* Check the Status */
 	if (hwcqe->status != CQ_TERMINAL_STATUS_OK)
 		dev_warn(&cq->hwq.pdev->dev,
-			 "QPLIB: FP: CQ Process Terminal Error status = 0x%x",
+			 "FP: CQ Process Terminal Error status = 0x%x\n",
 			 hwcqe->status);
 
 	qp = (struct bnxt_qplib_qp *)((unsigned long)
 				      le64_to_cpu(hwcqe->qp_handle));
 	if (!qp) {
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: CQ Process terminal qp is NULL");
+			"FP: CQ Process terminal qp is NULL\n");
 		return -EINVAL;
 	}
 
@@ -2597,9 +2588,9 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
 
 	if (cqe_cons > sq->hwq.max_elements) {
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: CQ Process terminal reported ");
+			"FP: CQ Process terminal reported\n");
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: sq_cons_idx 0x%x which exceeded max 0x%x",
+			"sq_cons_idx 0x%x which exceeded max 0x%x\n",
 			cqe_cons, sq->hwq.max_elements);
 		goto do_rq;
 	}
@@ -2647,9 +2638,9 @@ static int bnxt_qplib_cq_process_terminal(struct bnxt_qplib_cq *cq,
 		goto done;
 	} else if (cqe_cons > rq->hwq.max_elements) {
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: CQ Processed terminal ");
+			"FP: CQ Processed terminal\n");
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: reported rq_cons_idx 0x%x exceeds max 0x%x",
+			"reported rq_cons_idx 0x%x exceeds max 0x%x\n",
 			cqe_cons, rq->hwq.max_elements);
 		goto done;
 	}
@@ -2678,7 +2669,7 @@ static int bnxt_qplib_cq_process_cutoff(struct bnxt_qplib_cq *cq,
 	/* Check the Status */
 	if (hwcqe->status != CQ_CUTOFF_STATUS_OK) {
 		dev_err(&cq->hwq.pdev->dev,
-			"QPLIB: FP: CQ Process Cutoff Error status = 0x%x",
+			"FP: CQ Process Cutoff Error status = 0x%x\n",
 			hwcqe->status);
 		return -EINVAL;
 	}
@@ -2699,15 +2690,13 @@ int bnxt_qplib_process_flush_list(struct bnxt_qplib_cq *cq,
 	spin_lock_irqsave(&cq->flush_lock, flags);
 	list_for_each_entry(qp, &cq->sqf_head, sq_flush) {
 		dev_dbg(&cq->hwq.pdev->dev,
-			"QPLIB: FP: Flushing SQ QP= %p",
-			qp);
+			"FP: Flushing SQ QP= %p\n", qp);
 		__flush_sq(&qp->sq, qp, &cqe, &budget);
 	}
 
 	list_for_each_entry(qp, &cq->rqf_head, rq_flush) {
 		dev_dbg(&cq->hwq.pdev->dev,
-			"QPLIB: FP: Flushing RQ QP= %p",
-			qp);
+			"FP: Flushing RQ QP= %p\n", qp);
 		__flush_rq(&qp->rq, qp, &cqe, &budget);
 	}
 	spin_unlock_irqrestore(&cq->flush_lock, flags);
@@ -2775,7 +2764,7 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 			goto exit;
 		default:
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: process_cq unknown type 0x%lx",
+				"process_cq unknown type 0x%lx\n",
 				hw_cqe->cqe_type_toggle &
 				CQ_BASE_CQE_TYPE_MASK);
 			rc = -EINVAL;
@@ -2788,7 +2777,7 @@ int bnxt_qplib_poll_cq(struct bnxt_qplib_cq *cq, struct bnxt_qplib_cqe *cqe,
 			 * next one
 			 */
 			dev_err(&cq->hwq.pdev->dev,
-				"QPLIB: process_cqe error rc = 0x%x", rc);
+				"process_cqe error rc = 0x%x\n", rc);
 		}
 		raw_cons++;
 	}
-- 
2.15.0
