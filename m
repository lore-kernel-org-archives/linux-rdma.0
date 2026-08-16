Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021FF3DD847
	for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 10:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786877078; cv=none; b=YEuz3mebWo7oCaAOjl3q3uakGm3oat4W+6742vCGBuDGyuTTFAx8rtiWUq7AUGcS9YCFzLsM0VCq0W+ROo4uV0iiTxulE3z5PSffL9+87Wgp16ebAmEYIcXj4FpMVKYL1XKVzUa14/r/DTEkEY1D+Xsrm/eNIWeNct1lXMe5yKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786877078; c=relaxed/simple;
	bh=1i9yul6F2l4Q4PPXJh1Yy7BCESqS/JrlBhNG+SNw+WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uU81fhRcKLRL+9aMthzcK+02lLtto5Vja0ez97FQiAnUDUERejddoh7Hu/M9oVMzE8ZoKlSPHUFrg0N/ErUqZWDG+qyhKXKBOutlicAG/CT4CxMhe+Ckn+0LxMKqJ3kxUb/zYMwzy54jWE/RdX4U7vjN1iQtjZLsjuDVp5ygi/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ym1d+jNn; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ym1d+jNn"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4994c49f588so20786035e9.0
        for <linux-rdma@vger.kernel.org>; Sun, 16 Aug 2026 03:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786877075; x=1787481875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wvi2GblmpiPgceuV4OUlqrX9CH6VMj0H+ZOTI97NjFA=;
        b=Ym1d+jNnXP5D7ke4idP0Noo1Da86OvCKCuijUQxoZJ4XcHr+HSsJE4btMyrgZJ18kN
         9RGVjVVMsyZej7XTBSsGbuSGncspHUEGFXcg6PlQ7sYWHMp2atZ0ck63ed1sW2zWzZoe
         6VKKk0y1D3aK+49uJtQQG18l7wkpH3CJL8BPSEDJhrSJpHQBQvBxghKwPR6LMxI+dOfL
         dCrewiO9gwuiRaDydSaYrhJl5BZY45L6ZU3qweIcbu3qmVg3vAvnTkuoaMqE2zJYcJb1
         aYJC/Wn6ePeN4FW2tn3dAkcuRTwkKRcPrILiZAHfSNcO/ZGzSBPqxU9ETCvTISSoijUG
         Bv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786877075; x=1787481875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wvi2GblmpiPgceuV4OUlqrX9CH6VMj0H+ZOTI97NjFA=;
        b=Ku6eJxo2fYUWq0FVYwuFHFxkbgP6LBWSa8ZcLfd2Y5zXh2HMCgrTStRaxrdrGvC8RZ
         sFCQCRkrIYMJo5OWNRO+jBhliXpLIIUf+UxNQYZQrJ2Y78aCvaVrEA2RWshN37N1HmWp
         dX+ESE1mFOIX+XcqRqlqWV1Y97COQQyHTmq7N9YiNfIHrLmYeMiOwZzCYXAsRYyijuO+
         da9kyKXDbrUCBVbfxmutBIwrbnMlXXIphCJw/pFs1xxw4230JFDOca28u+YjJV1r1oPY
         Zsd8JouRZkbnix1ChmczzKlLadLJ62q7scEl9i5w5EuW265bAv5qIrvsmP+Qb1sUfTkp
         sFwA==
X-Forwarded-Encrypted: i=1; AHgh+RpRiiSMC64398ltPV8hgMfyoa55+cF1cCGmw8rPCVBu2wXmYtI2AgyXIf2qW406fWWrkkQdN3Nlz3IN@vger.kernel.org
X-Gm-Message-State: AOJu0YzWm5WMGGnV8QNUFHKADwq3XgQW05V5SXyBnPbHOOhNNYxSo8zi
	cuSMF8/8x54Zt5+gwLeZ1vQcn+Eoo0DpuN44SQzA6DYHhLmprmNyaos=
X-Gm-Gg: AR+sD138isNwfOBUtd1W4nE/DOkmQty5ktp+54rm1ulHCd0gGo1s8ilmctBGmqmF/rc
	fkU+SWg3B82sC6N4RwSOmkHxqFfquNQ5/lOy9NjFWcLgi6Z0YGtTg6t3QS+xcQ3URbLgoDnjepm
	giIpOFd9YemkEtW5AmV/njTogLcE3HhcTl41/SoOOx5DX5m5FHWE25ArU7Cp1P48Mjro64LB8rK
	cDxZ2wZiuoo1av5tgS+0wy0V+7lRNkaA7XY/PbUcfgcNKysajUppXjPPDgbRpMFRwV0HeyoMqXn
	MG+djC8eDWj1ax1EMlpJtlYHye9k5OmCqCUJPg3LLwPrI3uAUnXL0YGhaV6RIeR7t1qrIj6JvfH
	O1FW8LFKRtHkBQuKTzqGkCp+8e8MFw7ZpzABr8XPQ8gApiSf5EErsEBeX4FbxzqAJYmlpyIPZeV
	5Ttb7Z8rfOGUIANeVso65Pk7uLrfm+NQ==
X-Received: by 2002:a05:600c:8119:b0:499:596b:2e91 with SMTP id 5b1f17b1804b1-49987a58078mr259086605e9.3.1786877075078;
        Sun, 16 Aug 2026 03:44:35 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610ed6dsm54841945e9.8.2026.08.16.03.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 03:44:33 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Moni Shoua <monis@mellanox.com>,
	linux-rdma@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 1/2] RDMA/rxe: copy send WQE to kernel buffer before processing
Date: Sun, 16 Aug 2026 10:44:31 +0000
Message-ID: <20260816104432.849996-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
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
to preserve DMA progress state (cur_sge, sge_offset, resid). State
changes are written back to the shared queue so the completer can observe
them (e.g., wqe_state_pending for RC acknowledgment processing).

The copy is invalidated when:
 - The WQE index advances (last packet sent, error, local ops, UD oversized)
 - A retry occurs (req_retry resets WQE state in shared memory)

The num_sge field is validated against qp->sq.max_sge on copy-in to
reject corrupted values early.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/infiniband/sw/rxe/rxe_req.c   | 55 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 12d03f390b097..499f398b674c7 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -161,6 +161,20 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 }
 
+/* Write local WQE copy back to shared queue so the completer
+ * can observe state transitions (e.g., wqe_state_pending).
+ */
+static void rxe_req_writeback_wqe(struct rxe_qp *qp)
+{
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe) {
+		unsigned int num_sge = qp->req.send_wqe.wqe.dma.num_sge;
+		size_t size = sizeof(struct rxe_send_wqe) +
+			      num_sge * sizeof(struct rxe_sge);
+
+		memcpy(qp->req.shared_wqe, &qp->req.send_wqe.wqe, size);
+	}
+}
+
 static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
 {
 	struct rxe_queue *q = qp->sq.queue;
@@ -178,6 +192,8 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 {
 	struct rxe_send_wqe *wqe;
 	unsigned long flags;
+	unsigned int num_sge;
+	size_t copy_size;
 
 	req_check_sq_drain_done(qp);
 
@@ -193,6 +209,29 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 
+	/* If we already have a valid local copy of this WQE, use it.
+	 * This preserves DMA progress state across multi-packet sends.
+	 */
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
+		return &qp->req.send_wqe.wqe;
+
+	/* Copy WQE from userspace-mapped shared queue to kernel-private
+	 * buffer. Userspace can concurrently modify num_sge, SGE entries,
+	 * or inline data offsets, leading to inconsistent state in
+	 * copy_data(). This is the send-path variant of the receive-path
+	 * fix in rxe_get_recv_wqe().
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
@@ -582,9 +621,14 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
 {
 	qp->req.opcode = pkt->opcode;
 
-	if (pkt->mask & RXE_END_MASK)
+	/* Write back local WQE state before possibly advancing index */
+	rxe_req_writeback_wqe(qp);
+
+	if (pkt->mask & RXE_END_MASK) {
 		qp->req.wqe_index = queue_next_index(qp->sq.queue,
 						     qp->req.wqe_index);
+		qp->req.send_wqe_valid = false;
+	}
 
 	qp->need_req_skb = 0;
 
@@ -635,6 +679,7 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	wqe->state = wqe_state_done;
 	wqe->status = IB_WC_SUCCESS;
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
+	qp->req.send_wqe_valid = false;
 
 	return 0;
 }
@@ -695,6 +740,7 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
+		qp->req.send_wqe_valid = false;
 	}
 
 	wqe = req_next_wqe(qp);
@@ -761,6 +807,7 @@ int rxe_requester(struct rxe_qp *qp)
 						       qp->req.wqe_index);
 			wqe->state = wqe_state_done;
 			wqe->status = IB_WC_SUCCESS;
+			qp->req.send_wqe_valid = false;
 			goto done;
 		}
 		payload = mtu;
@@ -820,12 +867,18 @@ int rxe_requester(struct rxe_qp *qp)
 	 * will continue looping and return to rxe_requester
 	 */
 done:
+	/* Write back local WQE for paths that skip update_state()
+	 * (local ops, UD oversized packets).
+	 */
+	rxe_req_writeback_wqe(qp);
 	ret = 0;
 	goto out;
 err:
 	/* update wqe_index for each wqe completion */
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
 	wqe->state = wqe_state_error;
+	rxe_req_writeback_wqe(qp);
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

