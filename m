Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCED423E9E
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 21:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791408465; cv=none; b=T62C6/bTGMojLGqkBAqkHt8/O3hULTFH1j8145qBiDKojU0g5u2XgihVwLTqo+kDkn4Ads5aQUTpMEkQZh9KNq64DOSS+SxFOb79GGFPqXx+vKq8mfEwG6S31kP2st38YVzIhhfUluJsnWYNEQ1N0vkB3nsF8cG5L2/XlwAhLNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791408465; c=relaxed/simple;
	bh=LpK3MlRuVJxJxtDhXN32lu/uryl0DBZALWksguoyIXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDDMnQ8ptaigUjfY2Qi8DN64viqv1xwulzj1ks5/+HaEBKPLbgW0D7+S6R9bl1UceRQxsgYiW6R0HLCyBZGtsTPPI33F7oabC0pp0TglVyD5MPRPt7/31zvNjbH5ZqKqc+h3VgDzYSlANMyy5PH9dUq/icCgh2ZEkGRWbF/Yvhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PFuql5PL; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PFuql5PL"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so16629515e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 14:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791408462; x=1792013262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OtBP7HWDVtqSxKO/0UtHBQZZgW6BHdDPHdI/ZgBGR9s=;
        b=PFuql5PLgLxtN+P1t7XxG4dZbhte/BwfW7gcXmXTJq81fkfusR/8RmgEYn0g/xWzFM
         3dnk0D9euvw1Uoj0uGwvL2CHIzHK4eRypx6A0i8/Ls9W5Mk/sSGmpPNPNQ0ssoGTkzvK
         IB7VUMTrT3s4vdP/tCC20br7az81OGkDKhVYikrCGg0NKkXOl/LJVgxjlYCaRTxg9uZ5
         YDK2GR91nf8f7rRTm2H1SAz+GjgBKyKRsXoSJJLJuM1jMFfxwOv0Cj/agJmtdSbV/vqI
         0jL/LzMRVw6SHRx7aHajkYgOuu+5nnppoVev3aE2Spz5gnmJcAIeFNF5rBaEh1UDnk1L
         SOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791408462; x=1792013262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OtBP7HWDVtqSxKO/0UtHBQZZgW6BHdDPHdI/ZgBGR9s=;
        b=fHbMCAXqBfRxT3PubHEvUu1U/sk/egZ0ik59UjRpmkMIf0rN5YH1/UYeO5vBRHmg+p
         X3jYRdsP788ZfwNOeqULxgE0A2Lfn4DOVkal6Lmi7Kjj1o35yjTJo9jt+PrHZUkmrBcr
         8qqxvtK6zgtWkWkD1AhU0pOVSWgtfQi3Z9BShdZ9J5i58Qe70+ioFDbuvtrlEjuOt/HL
         RJpaEGg9LaLNisNNjtVVsj3ssaGplZutRYqhia7QBzOY6m435iUhfk7WJFUlso8gNr11
         9KzvKvA/QKXzd2F1L/EGzgjveDKoorch3z/AB0eDJUna7/VR97cHc7TrhOpAJGnNbOFO
         wuQg==
X-Gm-Message-State: AFuF++mEPRAOSVtKKxowP2wRXHz7MsalETZsewVgKpbGV5fyPB4uOCO2
	Jih4khYy/59fDtKAoS6KjMeGx/oLjUv1/BkzG5XqN/KqZS/yqLkhPQ0=
X-Gm-Gg: AYBFou3AaK3V8w/T4UGSwlQoH4csNDFFZr5q3saOtBA76a3ZeeaQnjA0M5JOmY/IVGt
	7fdRztptRc5n/M9oh2FCQVtlJYsf6XCE3mcYp2obhEMts7T9lJZfEiY3YZqlePfhfFxX26XRKks
	btD++6mvuuFoH29itV1i9azvHeSWtx/KgZo66t+vZjLBxmZPz+nbJUjfqBW10QQXGndzVOPkYdv
	EPOugfbFvz1b133ZEm5dbuuyX/AGckAvdxYv/pdExWFy8p/VSv+yoffxzeEhCk3rExGe/ACxA26
	ddb/U+FhcW9ro59UvIo+xgRnT4jptEXXS0euzpGyCGDFnsSXwlYEh9g/XU5uez3OJT9r3INoBlI
	oo6YXCth3Ewl0kXCkUgySmlZW9KskVCftGVRJLFIKedagsGMjYYIcVFqOTEhAB9Ye2q3c1x9UJQ
	qncJDKgQIq8dYsfyD3ZP8vLEiPCUUCw8npSXYnaNg=
X-Received: by 2002:a05:600c:5254:b0:4a0:1b15:8852 with SMTP id 5b1f17b1804b1-4a180310d31mr58481475e9.16.1791408461660;
        Wed, 07 Oct 2026 14:27:41 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1843cb261sm20466395e9.3.2026.10.07.14.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:27:41 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Moni Shoua <monis@mellanox.com>,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v3 2/2] RDMA/rxe: copy send WQE to kernel buffer in completer path
Date: Wed,  7 Oct 2026 21:27:37 +0000
Message-ID: <20261007212737.1989004-3-tristmd@gmail.com>
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

The rxe completer processes send Work Queue Entries (WQEs) directly
from the mmap'd shared send queue without copying them to kernel memory.
Userspace can modify WQE fields (num_sge, opcode, PSN values, DMA state)
while the completer is processing them, leading to inconsistent
decisions in check_psn() and check_ack(), and potential out-of-bounds
access in copy_data() via a corrupted dma.num_sge.

This is the completer-path counterpart to the previous commit which
fixed the requester path.

Fix by copying the WQE to a kernel-private buffer in get_wqe() before
processing. The local copy is reused across multi-packet operations
(e.g. RDMA READ responses) when the WQE state is unchanged, preserving
DMA progress across completer invocations. The copy is refreshed when
the state changes (via smp_load_acquire pairing with the requester
smp_store_release) to ensure PSN and other fields are consistent.

Field updates (status, has_rd_atomic) are written back to the shared
queue using WRITE_ONCE() before advancing the consumer pointer, so
userspace observes consistent completion values.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  | 54 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1390e861bd1d7..f57c4396c28cb 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -88,6 +88,18 @@ static inline unsigned long rnrnak_jiffies(u8 timeout)
 		usecs_to_jiffies(rnrnak_usec[timeout]), 1);
 }
 
+static void rxe_comp_writeback_wqe(struct rxe_qp *qp)
+{
+	struct rxe_send_wqe *shared = qp->comp.shared_wqe;
+	struct rxe_send_wqe *local = &qp->comp.comp_wqe.wqe;
+
+	if (!qp->comp.comp_wqe_valid || !shared)
+		return;
+
+	WRITE_ONCE(shared->status, local->status);
+	WRITE_ONCE(shared->has_rd_atomic, local->has_rd_atomic);
+}
+
 static enum ib_wc_opcode wr_to_wc_opcode(enum ib_wr_opcode opcode)
 {
 	switch (opcode) {
@@ -142,17 +154,52 @@ static inline enum comp_state get_wqe(struct rxe_qp *qp,
 				      struct rxe_send_wqe **wqe_p)
 {
 	struct rxe_send_wqe *wqe;
+	u32 state;
+	unsigned int num_sge;
 
 	/* we come here whether or not we found a response packet to see if
 	 * there are any posted WQEs
 	 */
 	wqe = queue_head(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
-	*wqe_p = wqe;
 
 	/* no WQE or requester has not started it yet */
-	if (!wqe || wqe->state == wqe_state_posted)
+	if (!wqe) {
+		*wqe_p = NULL;
 		return pkt ? COMPST_DONE : COMPST_EXIT;
+	}
 
+	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
+	state = smp_load_acquire(&wqe->state);
+	if (state == wqe_state_posted) {
+		*wqe_p = wqe;
+		return pkt ? COMPST_DONE : COMPST_EXIT;
+	}
+
+	/* Reuse existing local copy if still processing same WQE
+	 * with unchanged state (preserves DMA progress for multi-packet ops)
+	 */
+	if (qp->comp.comp_wqe_valid && qp->comp.shared_wqe == wqe &&
+	    qp->comp.comp_wqe.wqe.state == state) {
+		wqe = &qp->comp.comp_wqe.wqe;
+		*wqe_p = wqe;
+		goto check_state;
+	}
+
+	/* Copy shared WQE to kernel-private buffer */
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > RXE_MAX_SGE))
+		num_sge = RXE_MAX_SGE;
+
+	qp->comp.shared_wqe = wqe;
+	memcpy(&qp->comp.comp_wqe.wqe, wqe,
+	       sizeof(*wqe) + num_sge * sizeof(struct rxe_sge));
+	qp->comp.comp_wqe_valid = true;
+	qp->comp.comp_wqe.wqe.dma.num_sge = num_sge;
+
+	wqe = &qp->comp.comp_wqe.wqe;
+	*wqe_p = wqe;
+
+check_state:
 	/* WQE does not require an ack */
 	if (wqe->state == wqe_state_done)
 		return COMPST_COMP_WQE;
@@ -454,6 +501,9 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	if (post)
 		make_send_cqe(qp, wqe, &cqe);
 
+	rxe_comp_writeback_wqe(qp);
+	qp->comp.comp_wqe_valid = false;
+
 	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
 
 	if (post)
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index a22dfc6e5ae3c..6205dbc29dff6 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -130,6 +130,12 @@ struct rxe_comp_info {
 	int			started_retry;
 	u32			retry_cnt;
 	u32			rnr_retry;
+	struct rxe_send_wqe	*shared_wqe;
+	bool			comp_wqe_valid;
+	struct {
+		struct rxe_send_wqe	wqe;
+		struct ib_sge		sge[RXE_MAX_SGE];
+	} comp_wqe;
 };
 
 /* responder states */
-- 
2.47.3

