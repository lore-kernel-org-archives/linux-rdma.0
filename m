Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85823043DE
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788117229; cv=none; b=s4kpTHSDJfJDIBr0yjI3iOkKKhyHxsP+IRidFcGe+VtMX+HTTJrzBrBK5tYDGvKq+bkwetTwzs0OOUP/A+dVWlOofM/mUYZSVNKQcf5mYTeTB8j+Pl9bRd9++RID6+wSve81aNGSAJH/nZ8BnpPzOS+aBGKj183Tb8Iq6oC1y/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788117229; c=relaxed/simple;
	bh=Ickl4tcmRfSAwRn7Eg15SrxaCbugV3qKGXe2wHFKgYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLLjueMRqbmzVE6HBSSKNIWynQO9Lg5Cedf1ikChkyhoaN8QtHsUErospnvPvG2wcWSuppIOVD0bUoCWBdx2CZKNk2e0QAHwKBM35Kku0rRlPkNwabVppeuL2MFtb2IL8yFiOIQE/fyDK7kfg3A3LdTvFc0cC20Q4NZgMdrMPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgC8KNSl; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgC8KNSl"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b8ce9b733so18398715e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 12:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788117226; x=1788722026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFDCRp5iLVLLrWQoHLfBTkFl85/GIbVDgQeGHoRD9z0=;
        b=OgC8KNSlIGVIe2i2lA4srtWqodpMjodwhDu7LC7aJFstt5Fv6RG4AF+6W8jX6nfgQK
         3729A+KfARqa5Boin5xT9R12EzGD689+Vlkq/zrm6gde8XAWXdMzwsPyX7bewo4iwn4O
         8AZ/XO9GTxmGv0QST5aBVQFq2huOFC2ltFUiEkVWFpxK5+/zgVl7kXPpnlyp8XOXZwkZ
         Zy2L5cMEH1mqlzrZHsvUWOxF0V5v08BAwRkWap1G1/al8a/iGjMuNzXaA4+iVBZk2U+K
         diL3a7E5+KhN1FGJLVd85sAeHgZ6daqEItuBXVRkmqRHuy7WOjeZxPGi0ceX41D28lsR
         O4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788117226; x=1788722026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFDCRp5iLVLLrWQoHLfBTkFl85/GIbVDgQeGHoRD9z0=;
        b=ANbeaVRiZ1CIo1iPjVIJi1THyXLZZ7rksHWyak12gIfkRsjoyHZ1hOoFPXMjiwvGiA
         Bp8+miMvv93ELUeODP2u7MgmbApILsh5EK/0JclSS0XPKjq/0cBBI1rdLHiOLqoTcWG3
         yQbsSJ1lGuzlKf4K6kvMCKhU+ryBxQcU/KjBx+yvBJUpAU5tsXbKELeLx9t01bUrA4S6
         SqmaS7r259liI5xOJiU8VmLL3a2KlvmCilwa3aYgvLB1HsGGdO6HtKVlMkDF04h6YW6H
         fJte9nUn6fu8wJYKIU+gL+ZKLzlRc2BiVX9wg2xKtcxy/Uu/cXoiCfowmqrdE9C4QreX
         3ntA==
X-Forwarded-Encrypted: i=1; AHgh+RrhwQL+HNofztJ4Iv0AD8IELCU05ZDJWdRma7v0SH64X0tpbcggNKsGSmGIXjcdraRyenrj3A440NTd@vger.kernel.org
X-Gm-Message-State: AFuF++lrg38mdqbKYFaP0htiyom89hizNe9r0hIoDXteLFzQv9m8tDCW
	Futko1brGbIpCqEY04Q4Hx1sZxxyrUsBeDgEfgkLKL1RZCLMozrGRo8=
X-Gm-Gg: AR+sD11LhCR/WwAYLLQYz11AxG0UMe/JiuKERWzPxYZAkLdts2e3S6W+qD24cMH/XA5
	WGzcElsGknWwqTbnfhJsZncdrN+8CkpNqsDXjO17OpEmwSncNhGkWjzbaYtFAIvCqhMSgJid38F
	nk3wGpyKV0L14Byek8bL6gtpxF6hX3oi5bi7mtlqagtjFFtJx+hX8hnxQMyWk8M7jwSBxuayxjf
	2qV6ayqf+qeZ1EFe6Bse5DIYWAiNmKezJxvJU+EKfzp2fbN4aO4Oblmm7JF4l9wpafLW9+wconj
	eKFmPhClB4x7QEJuBt3fcZ66J9O1qkPm1Gb4XVUvao0+t2qri/ykWGzRPZwChdSirK/Uk+as7EL
	lPvQETHBgJkaoHpV4Rv6Xn03aknMZ7nc8OL6UMgxGKntQrrBXNpDvRRBH7VLpFL6yDnDQNVzLU6
	Neiidm8VJD2gldikYyKcRFEgZSNrUkvCsEikP6SSCs
X-Received: by 2002:a05:600c:3e1a:b0:49c:cee2:a508 with SMTP id 5b1f17b1804b1-49ccee2a541mr165296425e9.16.1788117225759;
        Sun, 30 Aug 2026 12:13:45 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd8148fbdsm2404705e9.3.2026.08.30.12.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 12:13:44 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Moni Shoua <monis@mellanox.com>,
	Ibrahim Hashimov <security@auditcode.ai>,
	linux-rdma@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 1/2] RDMA/rxe: copy send WQE to kernel buffer before processing
Date: Sun, 30 Aug 2026 19:13:42 +0000
Message-ID: <20260830191344.2026524-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260816104432.849996-1-tristmd@gmail.com>
References: <20260816104432.849996-1-tristmd@gmail.com>
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
to preserve DMA progress state (cur_sge, sge_offset, resid). Modified
fields are written back individually using WRITE_ONCE() with
smp_store_release() for the state field to ensure the completer
observes consistent values.

The copy is invalidated when:
 - The WQE index advances (last packet sent, error, local ops,
   UD oversized)
 - A retry occurs (req_retry resets WQE state in shared memory)

The num_sge field is validated against qp->sq.max_sge on copy-in to
reject corrupted values early.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
v1 -> v2:
 - Replace bulk memcpy() writeback with targeted WRITE_ONCE() for
   individual fields (cur_sge, sge_offset, resid, status) and
   smp_store_release() for the state field, addressing review feedback
   from Zhu Yanjun

 drivers/infiniband/sw/rxe/rxe_req.c   | 60 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 12d03f390b097..59b22bb160908 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -161,6 +161,26 @@ static void req_check_sq_drain_done(struct rxe_qp *qp)
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 }
 
+/* Write back modified WQE fields to the shared queue using
+ * WRITE_ONCE() so the completer observes consistent values.
+ * Only the fields modified by the requester are written back;
+ * state is written last as the publication field.
+ */
+static void rxe_req_writeback_wqe(struct rxe_qp *qp)
+{
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe) {
+		struct rxe_send_wqe *shared = qp->req.shared_wqe;
+		struct rxe_send_wqe *local = &qp->req.send_wqe.wqe;
+
+		WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
+		WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
+		WRITE_ONCE(shared->dma.resid, local->dma.resid);
+		WRITE_ONCE(shared->status, local->status);
+		/* Ensure fields above are visible before state transition */
+		smp_store_release(&shared->state, local->state);
+	}
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
 
@@ -193,6 +215,28 @@ static struct rxe_send_wqe *req_next_wqe(struct rxe_qp *qp)
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
 
+	/* If we already have a valid local copy of this WQE, use it.
+	 * This preserves DMA progress state across multi-packet sends.
+	 */
+	if (qp->req.send_wqe_valid && qp->req.shared_wqe == wqe)
+		return &qp->req.send_wqe.wqe;
+
+	/* Copy WQE from userspace-mapped shared queue to kernel-private
+	 * buffer to prevent TOCTOU races on num_sge, SGE entries, and
+	 * inline data offsets. This is the send-path counterpart to
+	 * rxe_get_recv_wqe().
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
@@ -582,9 +626,14 @@ static void update_state(struct rxe_qp *qp, struct rxe_pkt_info *pkt)
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
 
@@ -635,6 +684,7 @@ static int rxe_do_local_ops(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	wqe->state = wqe_state_done;
 	wqe->status = IB_WC_SUCCESS;
 	qp->req.wqe_index = queue_next_index(qp->sq.queue, qp->req.wqe_index);
+	qp->req.send_wqe_valid = false;
 
 	return 0;
 }
@@ -695,6 +745,7 @@ int rxe_requester(struct rxe_qp *qp)
 	if (unlikely(qp->req.need_retry && !qp->req.wait_for_rnr_timer)) {
 		req_retry(qp);
 		qp->req.need_retry = 0;
+		qp->req.send_wqe_valid = false;
 	}
 
 	wqe = req_next_wqe(qp);
@@ -761,6 +812,7 @@ int rxe_requester(struct rxe_qp *qp)
 						       qp->req.wqe_index);
 			wqe->state = wqe_state_done;
 			wqe->status = IB_WC_SUCCESS;
+			qp->req.send_wqe_valid = false;
 			goto done;
 		}
 		payload = mtu;
@@ -820,12 +872,18 @@ int rxe_requester(struct rxe_qp *qp)
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

