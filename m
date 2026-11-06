Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003147;
	b=VtjNl4qILWQkMx/hqmk62NPo3rvgGfaME2u5s7QbhSxAsCMaXmiwhUVwBk0vCDrC+WqI
	 ouy3x1VLHz887rTtGXAxgaBS1tjM0DGvL/VBC6m7hp9Wg6lUICqnJiPGZVFiA1vd+26BS
	 rSdP1t6NmAEMIfIEnnrSElotGZz9PIS7s2E2E8fTeoh/pZQWcOVupAIiU0tWOfOPIKDZ/
	 pSVK0tl5rEGsVVUyQV18dSwxvYpRHh0ISK8m54pbt3pH7YsBGSMHLd65aezcfXp5lVhsc
	 i0Ms7OqHiJJk9iGuoc10gTAmUtzDkUUYEiDyMj0TsizeAiM/bHrTdmm0+EVWrg0JD/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=4Nzt8fHJDrg9z/hmNIwZXVyYswS/2ActSVeIRhPRncw=;
	b=eCNoNFGtWRa5Z9kPcTtOX5/tY4sxoMh7fzJLYNAVAC0r4W+O80+ywrlaAwilPGC624ht
	 02Zyv+9ohagHB1J2ZEcDrlZkE3e9HsWM6ZqeI94uCzgjfs6aktsSBaizwSOpQz95wQ/Iu
	 GiOvGQvAAxd7cokNiaGnkaFwwIAbqT8MAH8SDx6/ZCArigm9ZrJzVvpqPMFSnXtyDWVkT
	 6BFZUzOLz/A1BorfGhQE/qIIgH7uCPwlr3ZV/uHcWf8D7T6oGevCNGdRWjpHrPO+0X3ar
	 SmNZkLP1tuKfNxK5Q2eXrNXg1MHIjcHdx6ImJFq0XIqAWFCoOKwRTDtWrLdkfWe2/xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jeo+5D+N;
	arc=none smtp.remote-ip=209.85.222.198
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89A4606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B89A4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jeo+5D+N
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f2373e9b4so140262785a.1
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 14:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003146; x=1794607946; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Nzt8fHJDrg9z/hmNIwZXVyYswS/2ActSVeIRhPRncw=;
        b=jeo+5D+NgqiMiNHzXQhM8K6ZQM68/M9DNQ/xN/Vw7CXhNjbo3dRC57466KuDakuWRc
         UKTtg/yt85uMz4XZRQS4zSGoWtKgOCWcDeQIXn+sEiHh2j9dEgCL5XvigaMUTzlfsIz6
         iEfTv8/goVgg3EJfGVaWMXBWaXhWJmRsqqALgX4B+gJTKnbgLJ1Aq9QWDftW50x0cXEV
         J8+si/k1HRF8wmii+/22Gy9PGw9dm5l9wHBsWotwTBrqbvPjAhDEbgMsDgoA/lnZcnAn
         smBFFGq7ApvRXITFhp+oP7gho7NYe3O3dnImatYwQNoLHQrjgOUt3nn7xZ5HS0BtT1QP
         waDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003146; x=1794607946;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Nzt8fHJDrg9z/hmNIwZXVyYswS/2ActSVeIRhPRncw=;
        b=t6ep5Vavn+Rfma1B7s81PsteHyk/vA7b4u4Wqk8cmh2cA663hVXXo5/Pl/rrKm0kKb
         zCV4HV/qUz2ihY5TGL1iIsH33aJiOe/7m8Ydt+9abpEEYc4qovakFt1praSqziq4Agbu
         9W+yOcXvvsgXk5Yy7j77blTNzUD10lJ6aVnqjfEMZaPRCQTz35tBcHq8VtMEOTaaIDuf
         JGVICb+p4mcdFs2OAmqDoRcZwdxEoiOkMBoIM8qtIqmSnHIHk+8y66jOFainvluD+mp1
         Z1dpPeZryHjhzF4YnIAiIQVjRTsC+Zzok1GoIKqo613YWgIZxZBGHCD0PU3ORagiA2Qi
         VQPQ==
X-Gm-Message-State: APuU4Z8Cjcl4DzOk5XOpCkfCs1sX0eQeS96B9RFbnTgDaFhf56foRI4w
	l090Ex16/cV6NzgSx/Wb7obimhfBYkOVJ0f5bFzt1OIUnUE9UzMpnZmJJqFk/DhNApJfdQ4enSl
	RfM8Tx0LhyA==
X-Received: from qkau11-n1.prod.google.com ([2002:a05:620a:a1cb:10b0:93c:320e:f493])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:4002:b0:939:3fcd:4c3a
 with SMTP id af79cd13be357-945f34af2b8mr568211985a.17.1794003145192; Fri, 06
 Nov 2026 14:12:25 -0800 (PST)
Date: Fri,  6 Nov 2026 22:12:00 +0000
In-Reply-To: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106221201.2266301-5-jmoroni@google.com>
Subject: [PATCH rdma-next 4/4] RDMA/irdma: Release SRQ slots during CQ scrub
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

When the CQ is scrubbed during QP destroy, any unpolled SRQ
completions are invalidated, which causes those SRQ slots to
be leaked because the SRQ tail only advances when completions
are polled.

Fix this by releasing the SRQ slots whenever an SRQ CQE is scrubbed
during QP destroy as well as during the small window prior to CQ
scrub where the QP is marked as "destroy_pending".

In practice, the leak only matters if a consumer posts new buffers
to replace the ones tied to the discarded completions, but releasing
the slots keeps the driver's SRQ accounting correct.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/uk.c | 33 +++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 05f512b01525..afd1f5ba0c28 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1130,6 +1130,19 @@ bool irdma_uk_cq_empty(struct irdma_cq_uk *cq)
 	return polarity != cq->polarity;
 }
 
+/**
+ * irdma_srq_release_wqe() - Release an SRQ WQE.
+ * @srq: SRQ
+ */
+static void irdma_srq_release_wqe(struct irdma_srq_uk *srq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(srq->lock, flags);
+	IRDMA_RING_MOVE_TAIL(srq->srq_ring);
+	spin_unlock_irqrestore(srq->lock, flags);
+}
+
 /**
  * irdma_uk_cq_poll_cmpl - get cq completion info
  * @cq: hw cq
@@ -1226,6 +1239,12 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 		get_64bit_val(cqe, 8, &comp_ctx);
 	qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
 	if (!qp || qp->destroy_pending) {
+		/* destroy_pending is set prior to locking and scrubbing the CQ
+		 * so this can potentially be reached.
+		 */
+		if (qp && is_srq && info->q_type == IRDMA_CQE_QTYPE_RQ &&
+		    qp->srq_uk)
+			irdma_srq_release_wqe(qp->srq_uk);
 		ret_code = -EFAULT;
 		goto exit;
 	}
@@ -1278,8 +1297,6 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	info->op_type = (u8)FIELD_GET(IRDMACQ_OP, qword3);
 
 	if (info->q_type == IRDMA_CQE_QTYPE_RQ && is_srq) {
-		unsigned long flags;
-
 		srq = qp->srq_uk;
 
 		get_64bit_val(cqe, 8, &info->wr_id);
@@ -1292,11 +1309,9 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 		} else {
 			info->stag_invalid_set = false;
 		}
-		spin_lock_irqsave(srq->lock, flags);
-		IRDMA_RING_MOVE_TAIL(srq->srq_ring);
-		spin_unlock_irqrestore(srq->lock, flags);
-		pring = &srq->srq_ring;
 
+		irdma_srq_release_wqe(srq);
+		pring = &srq->srq_ring;
 	} else if (info->q_type == IRDMA_CQE_QTYPE_RQ && !is_srq) {
 		u32 array_idx;
 
@@ -1792,8 +1807,12 @@ void irdma_uk_clean_cq(struct irdma_qp_uk *qp, struct irdma_cq_uk *cq)
 
 		if (cq->avoid_mem_cflct && FIELD_GET(IRDMA_CQ_SRQ, qword3)) {
 			get_64bit_val(cqe, 40, &comp_ctx);
-			if ((struct irdma_qp_uk *)(unsigned long)comp_ctx == qp)
+			if ((struct irdma_qp_uk *)(unsigned long)comp_ctx == qp) {
+				if (qp->srq_uk &&
+				    FIELD_GET(IRDMA_CQ_SQ, qword3) == IRDMA_CQE_QTYPE_RQ)
+					irdma_srq_release_wqe(qp->srq_uk);
 				set_64bit_val(cqe, 40, 0);
+			}
 		} else {
 			get_64bit_val(cqe, 8, &comp_ctx);
 			if ((struct irdma_qp_uk *)(unsigned long)comp_ctx == qp)
-- 
2.56.0.455.g6c5a503b38-goog

