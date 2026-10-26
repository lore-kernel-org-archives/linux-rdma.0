Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792973653;
	b=4uqf0F8ud3fVINp7Jh52qbzfY0i+BXugXf4cbfjC8ayk7klkTmKmNv2mmrRTgp260y2w
	 aS/3G/AXkDqf+QJbvtRKHA7bIOq9KXncjMuC3FJHNeJfrmvAVCwqU3SMPJ+Z7E9DeS8RJ
	 FUm4+kEWw0Ygp9S8XU4DEs/OXjuFC9QjZBR9DLPs7TRURLc8OQKmS2IoDxY/u/2lIWwdI
	 pWs5caE5UjMOxrqwyui7yqtOgleePtt/rAgNPgTlvb419bcu4BtYXtKYgiOR0wPTIrbTh
	 FTRDqB+femsIdcfDbZP+1t1H/35zqfTDtXNGFycG+Btl/W5sfdRSLI4FdX9upmRj2IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792973653;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0TrP9mNYqecDAs3mTzJJHTEWAfoF/X14gVtd+VHzsKA=;
	b=XNKakYZhdyMEJvzym7P++6i7klnKKSg2LirE6TLEX0E9U4m3IF3Pzq0qm7stNpfsFEWE
	 wUKEA0mXDMKbHS66vu6T7JxLqA9/x6RRUT9dsxMlKBbm2fVf1rNy1FXhER64++G8rxi3R
	 iHN85VklkaVvZYt/jDKW35IGXPRRrZDReguIBGDA+4yJJM5jGxT6vltVtT81UafYXpmNE
	 tgAh1DzYknn6owFGikKJMrRfd1bp9Ol0lEqDsphUC1vCwJsZYrR2hGWOY/3wz8uY9xcee
	 brXNu2c9UP4z9hoMS/UQ8K3ufAFkG+zmuoxxAEggreJpqU+NjGCKzCPnatI4zVj1ALg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Wj3j6isK;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E2606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 00:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 781E2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Wj3j6isK
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so2089541f8f.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 17:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792973652; x=1793578452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0TrP9mNYqecDAs3mTzJJHTEWAfoF/X14gVtd+VHzsKA=;
        b=Wj3j6isKTOsl0G7ZMd0s0pEY71QKd1xZVtb5pY1mJPD3eNwLvkfbAk/OQKFidHBcBD
         zF1PE2xSJ8FWNQhn98hnu8iiBZgD/cQIwbnNuBoSkjXDxPnR+64njgTcIPrTB+kbRbKW
         iZto9aZ9FB/dSMrdSflQWNQ0hYAI9dmZA+RVBOJFO9fQTt7nXMGuq82d3arh+0Mq+DCm
         T440/bHP7zZw6BGc5BBAy0JCDwcL5FPJ0TmQcMDuvZOLlz2VvXZqH5QU4gGK0OruAfMu
         3cl6+m4ZtiCXGT4UNdRSOOa49I3Zp4iAgCWJkEiML45MyCCslqoP7ZBaLxaKbi+nu/mr
         NnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792973652; x=1793578452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0TrP9mNYqecDAs3mTzJJHTEWAfoF/X14gVtd+VHzsKA=;
        b=M0gTt8wNzlcq0kgpDewmoqOPhPzP+c9iH4T3Meb9WlZThePAWaikcJ6SQotaMuZL/5
         4H/F4g0wkrjJh/SO/qrrtog1+u5MGROj+FlRl7syF8CYHWlaVKkt06rfcWZidwJlD9cW
         4nUFWoGtTBenCfHrzBCoSBa+T20yubu8eo6tlB8l7FqTam/w8MKv2ObKU368DgjnB8/N
         dh/FTvfs8BiPnVA9SF8ebl9HD3cgr+UCjNvqOx5anMzOuHMWNm0jAZ1Hu9tTX6PLeLWy
         bsT9bee4SZIOS5rf0eYWw9oDdLzKvBap4IYdr9hRROjE8NSB2T6WtmtpWewR1SLuC9Hw
         PVMQ==
X-Gm-Message-State: AFq9FYKlDnnT5Vmxt6dY63clBIDxBaD64zOSOa1+Ihkjo7YDakHJurVz
	B02++WCD1oY8vORtzvyA2fDrBMsTgOlwLAmAxLzDvR4/z+qfww3mEqcsawgq
X-Gm-Gg: AYBFou043tKkbN1FZTYyCNaLuH3VFnY/NELHTU7lxMRQkTdAS6sfH2MrCHlvsl2x+HT
	lHF+sfKDS2yhHgvOL4VjdygM2MqGgMyWlUdyawKk62JZQCXosRTpgdwiIwi2xcY42GsvVwesnO/
	e9QwG7jlwvZgGMpvttV/vxlLtCNn5g+l6MA/SnCdC5HT9eyrSOTL4ftkLYySXE1csZQqHDmF4QS
	GfhAiBuMUH6TC9R+mVIatWVVaTFWOrhNUqp7/MJEC5OnQrwct5rLKAOVqDCYzvtPACEsr3LPo5F
	wIS8ypltXf4bxX4FpWbHA+65Eowa24N2GQlBJiPqWExUSenOfNDdtGiayjpYDS09RcyCQb9t97y
	kHf1RaaFc2KLf4mPed096aHPzB4nLQ/1rvLAHfh/WBxfKoQUEI/XF1TWhq3Sknpb5TrdbIGnjVx
	d22FLgClRt+Itz3torE8vjyLoE9HdFBynPXzmUQweUSSj5kJpOFNwXur6PDAqwzbuxXouQuidXw
	TlIYaGB6MPjyPcBhI1BuZw5FrsPCfw68S+T9g==
X-Received: by 2002:a05:6000:a90:b0:48e:349c:af4a with SMTP id ffacd0b85a97d-48e3eb9a2a3mr6750974f8f.50.1792973651567;
        Sun, 25 Oct 2026 17:14:11 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ece13aasm11940830f8f.58.2026.10.25.17.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 17:14:09 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	rpearsonhpe@gmail.com
Subject: [PATCH v6 1/2] RDMA/rxe: copy send WQE to kernel buffer before processing
Date: Mon, 26 Oct 2026 00:14:04 +0000
Message-ID: <20261026001405.1698455-2-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261026001405.1698455-1-tristan@talencesecurity.com>
References: <20261026001405.1698455-1-tristan@talencesecurity.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
before processing. The copy uses the full queue element data size
(max_inline bytes) so that inline data, which shares the flex array
with SGEs, is always captured regardless of num_sge.

After copying, sanitize attacker-controlled fields: reject out-of-range
opcodes before wr_opcode_mask() to prevent an OOB array access, and
clamp num_sge against the QP maximum so copy_data() never walks past
the SGE array.

The local copy is reused across multi-packet sends to preserve DMA
progress state (cur_sge, sge_offset, resid). Field updates are written
back to the shared queue using WRITE_ONCE() for individual fields and
smp_store_release() for state transitions, so the completer and
userspace observe consistent values without the tearing risk of bulk
memcpy().

The copy is invalidated when the WQE index advances (last packet sent,
error, local ops, UD oversized), when a retry resets WQE state, on QP
reset, or when the QP enters error state for flush.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 64 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 311f285d78a6be..77606c4a039b17 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -581,6 +581,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
 	qp->req.need_retry = 0;
 	qp->req.wait_for_rnr_timer = 0;
 	qp->req.noack_pkts = 0;
+	qp->req.send_wqe_valid = false;
 	qp->resp.msn = 0;
 	qp->resp.opcode = -1;
 	qp->resp.drop_msg = 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f77..dac7eae54838be 100644
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
@@ -193,6 +213,29 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 
+	/* Reuse the existing kernel-private copy if still valid */
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
+		return &qp->req.send_wqe.wqe;
+
+	/* Copy WQE from userspace-mapped shared queue to kernel-private
+	 * buffer. Use max_inline as copy size since it covers both SGEs
+	 * and inline data, which share the flex array.
+	 */
+	memcpy(&qp->req.send_wqe.wqe, wqe,
+	       sizeof(*wqe) + qp->sq.max_inline);
+	qp->req.shared_wqe = wqe;
+	qp->req.send_wqe_valid = true;
+
+	wqe = &qp->req.send_wqe.wqe;
+
+	/* Sanitize attacker-controlled fields from the copy */
+	if (unlikely(wqe->wr.opcode > IB_WR_ATOMIC_WRITE)) {
+		qp->req.send_wqe_valid = false;
+		return NULL;
+	}
+	if (wqe->dma.num_sge > qp->sq.max_sge)
+		wqe->dma.num_sge = qp->sq.max_sge;
+
 	wqe->mask = wr_opcode_mask(wqe->wr.opcode, qp);
 	return wqe;
 }
@@ -582,9 +625,13 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
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
 
@@ -634,7 +681,9 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 
 	wqe->state = wqe_state_done;
 	wqe->status = IB_WC_SUCCESS;
+	rxe_req_writeback_wqe(qp);
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
+	qp->req.send_wqe_valid = false;
 
 	return 0;
 }
@@ -666,6 +715,7 @@ int rxe_requester(struct rxe_qp *qp)
 		wqe = __req_next_wqe(qp);
 		spin_unlock_irqrestore(&qp->state_lock, flags);
 		if (wqe) {
+			qp->req.send_wqe_valid = false;
 			wqe->status = IB_WC_WR_FLUSH_ERR;
 			goto err;
 		} else {
@@ -681,6 +731,7 @@ int rxe_requester(struct rxe_qp *qp)
 		qp->req.wait_psn = 0;
 		qp->req.need_retry = 0;
 		qp->req.wait_for_rnr_timer = 0;
+		qp->req.send_wqe_valid = false;
 		spin_unlock_irqrestore(&qp->state_lock, flags);
 		goto exit;
 	}
@@ -695,6 +746,7 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
+		qp->req.send_wqe_valid = false;
 	}
 
 	wqe = req_next_wqe(qp);
@@ -772,10 +824,12 @@ int rxe_requester(struct rxe_qp *qp)
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
@@ -839,8 +893,10 @@ int rxe_requester(struct rxe_qp *qp)
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
index 0f5ffd94643f92..a22dfc6e5ae3cf 100644
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

