Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990C141D120
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 21:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791408463; cv=none; b=YV4o5RuFj3Ye077E9lBxISlMy8vrDFa3Y3DuZeeO7BVbvzVA8TOUjmPpkxBlSEMqHK1cvIAuxcQABudRFUNe9POQBuH4Vvf5WK0nUEBKk6AirEsHqyiIlQTvEYyGLetbiQb21/2eBB/SiTSLe8gOdlNdU5g73wrqFqoJVoEsbIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791408463; c=relaxed/simple;
	bh=l5jQ+Y8jBAbwtSkbxdcx5lHSetVcKmMiEz54gfHs/LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+CpXL/5PSCv7YJATZTFU0m7I8RQWBRyzNgGqvYNTKtCSlv0uEquVeNvNe1GZ48OTTkTymyuLKoE4ywyrF2qjvp7VNFkAtc6RiNWUrjjhIRFaYny10iTtahOde5c0rsyabNqHZ8fTBPmZrETvSUFpAcdfXVShsLAUtD5vqmC6/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7K2lhRo; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7K2lhRo"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a180fbeef5so11331695e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 14:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791408460; x=1792013260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aGjaeApZIthLmi6v3k0uwBqZC4UxQIhUEzIWGVGDRjY=;
        b=d7K2lhRo3puNEBbvyOCdMv7FITZFhxRw0KCMuDoAHWoukYlIr2NIbSFVVUy/HeSmlx
         A85MFrZs/dsafsU8pitvaqUC2sfJuOj4XszFiJYpWaR/+fUGofEUNi+vZvUngyWyhrQf
         zzs6QXrAOWROSniGNP0FoD5yqx2o+N+joSblzSti4eK3F1SUu8zhhasplozW2n1AJjj4
         I9mYZXXp481BAN0xFeekRIm6Z/m+cEDlkg60EP022wIRoEKPLWDrdL9SZVTEQvKGufMA
         ZzLYxKSiCZptJ27Cs+s0uH6z057UH6t90gxXps/YpRyW9/kvXKxaJMQ0Z333wJ0eLzRX
         wmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791408460; x=1792013260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aGjaeApZIthLmi6v3k0uwBqZC4UxQIhUEzIWGVGDRjY=;
        b=GWxoOESiscDjrFqlO0kpN+Y76LngGxXMl7StWRoJukGmhyhaEH7/ct5/l+UgpoHyBh
         ioBaVeP3JlAYg4kkvhCSqLZzDex5jbOQbcUNuzVrn+6W/VLfVgf9Ozr667OAqTWjUxtY
         elWOXIYCsyTKw41IRR3CdGwgFaVVdb6FkzzGknHeiL3oRMskyGce18L/UYQCkrexRfob
         kYB8Gi9K+Mizr6F6My3bZism4pFlJ2ljdr5e54WNljZMTJADoRgTnEpePnnLzW0WymRn
         bYVtLf2JjQpiM8LjzTE5vLrgXw5/Ic074C2OMjOQ8D9WUvO0+70Z0CC/+avO1rk+xXEM
         p9gQ==
X-Gm-Message-State: AFuF++mb6ciYQK7qiuqYgSjCpDHSQtAromqPviXksRSeWrYZdZClorgT
	U2TnUtKV7vnTb7Bqx8ojCl8JqsgBfzOQiwMrodSDC6tkt8ZPGXeekHc=
X-Gm-Gg: AYBFou2C/EwVuheh4ZnlNRmLBixC0my03FpTlAk+v517OBHjs8oYaMFlo8U6RJZhbAN
	hrgzL7AxGw1A8y0I1yN2nL1gGvIo9+dOxe3J/ASkTYfgiazUyElFxuz3we8r/co72wecfJjdlHq
	2eFOogq3JMdeiFpZGVv02fYlshE4SLGl64FVZdXM5ZCYhxQlWzGd2dfB6PWdroWA4DgZR28o3xb
	qQNH602OlpgZP01Om9QIn7wCuUPZerHKUChVDZltTkPezslSKNcCLGv5tzIeYwVU5SrfoD3Vd8K
	4cOF11+aEEssHdnLVEwZjjykdIGwVA05SymjSy4YxnTbY9XktouDGdv8PsS7kYKLZ6EiJ7bgzSj
	h7wgCQsHAlzEUtekkRwsLnP23Gd2Urr3O8M51+rApitFvDUyCOSiAOqyFWUGWz2NtIDSudqyKE8
	wpILs1awhGKsEWbyXoMJSg/m2cT/iT6+PNH0hAr7E=
X-Received: by 2002:a05:600c:a08e:b0:49f:bd3c:bc24 with SMTP id 5b1f17b1804b1-4a18066dc0bmr60210665e9.31.1791408459574;
        Wed, 07 Oct 2026 14:27:39 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb261sm20466395e9.3.2026.10.07.14.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:27:38 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Moni Shoua <monis@mellanox.com>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v3 1/2] RDMA/rxe: copy send WQE to kernel buffer before processing
Date: Wed,  7 Oct 2026 21:27:36 +0000
Message-ID: <20261007212737.1989004-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007212737.1989004-1-tristmd@gmail.com>
References: <20261007212737.1989004-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The rxe send queue is mapped into userspace via mmap. The requester
processes Work Queue Entries (WQEs) directly from this shared buffer
without first copying them to kernel memory. Userspace can modify WQE
fields (num_sge, sge_offset, SGE entries) between kernel reads,
leading to inconsistent state in copy_data().

This is the send-path counterpart to the receive-path fixes:
  - commit 22b8fbded65b8 ("RDMA/rxe: Fix TOCTOU heap overflow in
    get_srq_wqe")
  - commit d6ab440240a04 ("RDMA/rxe: Copy WQE to local buffer in
    non-SRQ receive path")

Fix by copying the send WQE to a kernel-private buffer in req_next_wqe()
before processing. The local copy is reused across multi-packet sends
to preserve DMA progress state (cur_sge, sge_offset, resid). Field
updates are written back to the shared queue using WRITE_ONCE() for
individual fields and smp_store_release() for state transitions, so
the completer and userspace observe consistent values without the
tearing risk of bulk memcpy().

The copy is invalidated when the WQE index advances (last packet sent,
error, local ops, UD oversized) or when a retry resets WQE state.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/infiniband/sw/rxe/rxe_req.c   | 59 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f7..c72de69630e58 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -161,6 +161,26 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 }
 
+/* Write back requester WQE fields to shared memory using targeted
+ * stores so the completer and userspace observe consistent state.
+ */
+static void rxe_req_writeback_wqe(struct rxe_qp *qp)
+{
+	struct rxe_send_wqe *shared = qp->req.shared_wqe;
+	struct rxe_send_wqe *local = &qp->req.send_wqe.wqe;
+
+	if (!qp->req.send_wqe_valid || !shared)
+		return;
+
+	WRITE_ONCE(shared->status, local->status);
+	WRITE_ONCE(shared->first_psn, local->first_psn);
+	WRITE_ONCE(shared->last_psn, local->last_psn);
+	WRITE_ONCE(shared->mask, local->mask);
+	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
+	/* State must be last so the completer sees prior updates */
+	smp_store_release(&shared->state, local->state);
+}
+
 static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
 {
 	struct rxe_queue *q = qp->sq.queue;
@@ -178,6 +198,8 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 {
 	struct rxe_send_wqe *wqe;
 	unsigned long flags;
+	unsigned int num_sge;
+	size_t copy_size;
 
 	req_check_sq_drain_done(qp);
 
@@ -193,6 +215,24 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 
+	/* Reuse the existing kernel-private copy if still valid */
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
+		return &qp->req.send_wqe.wqe;
+
+	/* Copy WQE from userspace-mapped shared queue to kernel-private
+	 * buffer to prevent TOCTOU races on DMA state fields.
+	 */
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > qp->sq.max_sge)) {
+		rxe_dbg_qp(qp, "invalid num_sge in send WQE\n");
+		return NULL;
+	}
+	copy_size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
+	memcpy(&qp->req.send_wqe.wqe, wqe, copy_size);
+	qp->req.shared_wqe = wqe;
+	qp->req.send_wqe_valid = true;
+
+	wqe = &qp->req.send_wqe.wqe;
 	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
 	return wqe;
 }
@@ -582,9 +622,13 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 {
 	qp->req.opcode = pkt->opcode;
 
-	if (pkt->mask & RXE_END_MASK)
+	rxe_req_writeback_wqe(qp);
+
+	if (pkt->mask & RXE_END_MASK) {
 		qp->req.wqe_index = queue_next_index(qp->sq.queue,
 						     qp->req.wqe_index);
+		qp->req.send_wqe_valid = false;
+	}
 
 	qp->need_req_skb = 0;
 
@@ -634,7 +678,9 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 
 	wqe->state = wqe_state_done;
 	wqe->status = IB_WC_SUCCESS;
+	rxe_req_writeback_wqe(qp);
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
+	qp->req.send_wqe_valid = false;
 
 	return 0;
 }
@@ -695,6 +741,7 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
+		qp->req.send_wqe_valid = false;
 	}
 
 	wqe = req_next_wqe(qp);
@@ -772,10 +819,12 @@ int rxe_requester(struct rxe_qp *qp)
 			wqe->last_psn = qp->req.psn;
 			qp->req.psn = (qp->req.psn + 1) & BTH_PSN_MASK;
 			qp->req.opcode = IB_OPCODE_UD_SEND_ONLY;
-			qp->req.wqe_index = queue_next_index(qp->sq.queue,
-						       qp->req.wqe_index);
 			wqe->state = wqe_state_done;
 			wqe->status = IB_WC_SUCCESS;
+			rxe_req_writeback_wqe(qp);
+			qp->req.wqe_index = queue_next_index(qp->sq.queue,
+						       qp->req.wqe_index);
+			qp->req.send_wqe_valid = false;
 			goto done;
 		}
 		payload = mtu;
@@ -839,8 +888,10 @@ int rxe_requester(struct rxe_qp *qp)
 	goto out;
 err:
 	/* update wqe_index for each wqe completion */
-	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
 	wqe->state = wqe_state_error;
+	rxe_req_writeback_wqe(qp);
+	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
+	qp->req.send_wqe_valid = false;
 	rxe_qp_error(qp);
 exit:
 	ret = -EAGAIN;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0f5ffd94643f9..a22dfc6e5ae3c 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -114,6 +114,12 @@ struct rxe_req_info {
 	int			wait_for_rnr_timer;
 	int			noack_pkts;
 	int			again;
+	struct rxe_send_wqe	*shared_wqe;
+	bool			send_wqe_valid;
+	struct {
+		struct rxe_send_wqe	wqe;
+		struct ib_sge		sge[RXE_MAX_SGE];
+	} send_wqe;
 };
 
 struct rxe_comp_info {
-- 
2.47.3

