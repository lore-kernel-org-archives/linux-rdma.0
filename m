Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793388766;
	b=CUVqaloGuY/sCl+QCxOZw0luCKlXdQvoUObb/hAOWYZQFqitJ/M25IgNHQn1aiZeS3He
	 GfRu7zvCkKNEmWGb9Wy8QrF53Dt6QNsop3cUbRh/oorHy/wgcsUNjlBpJvT90O4nmzQLs
	 FUQc2Eda0fGzBu87H5SXvYz5Ip7F7LVKjvgLokHEiwsiQ0kUzVdBKoGqvBlAoU9iBrQG4
	 Ltw0TxeF/VgMxQ8p3Dh633yNTmUpUBp+IO79z02bczcT1WSFU1TDfQTtXnXTjFj6qWEKL
	 se5KPD2V4qF2jWToAjYOBW3xOv85nlQgf8X3REdh0qvnT7DwwDEZHmGI+qLIuU3RlbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793388766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UBWddIU4VOdyo92IdAkPdEqsKaAU9G+Z2dZjBcQLsHU=;
	b=Xr7zbI6136DH4s94/yKkKn2OBZDv5avq1GwivrpWIU9JIOW9DSbGec62VxYhLXFJanKf
	 e0SPCTUbZGaSK9u9UGTTBYFMHS5O63Gh/hdMvWt4WzMWZWD1rD4W8hAIG7C2e8eeszRMZ
	 PBtC8X0OEhSS7vbbHZSua21heXqZ7kPQ/xV7tDRhTz8Z3iF+ppCG0aySi4KYzHZKJ+jFa
	 q98ecUyTidX9MX613ym9rC4vrKIoAfi61PgdkWdK79Szs2x+HfGE+gmcVbAWqVES/DW7y
	 CbT322Tl4AmlxtxYlQBly+bxTNtqHJcJ1sFWYMAfNx6cPeCZSS81+sp4wKwm/VCw5EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NfubqUkT;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66DE606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 19:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A66DE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NfubqUkT
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so11530075e9.2
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 12:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793388764; x=1793993564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UBWddIU4VOdyo92IdAkPdEqsKaAU9G+Z2dZjBcQLsHU=;
        b=NfubqUkT8dMP4qd+Qg6UjrqgwN2JNWm4RSEP8LahGoehducgJ5OsnydioTkTx6pNsR
         iUSw7M15ld0Sx0Iaxh4K1C/Lex0pwTBq8mHsZhHrrvpEAGRQljENn95fqu0WUaNzMmKl
         SyDKDmR/KzsfQGw8NstXwASGrEY27I/Wflk9JCdpmgGM91i7EVE2uwrlo5ujomxARRZB
         SHuY8/oMKdBsigiEi4igzTekwqTC0fTm2tQo4ef6yBDbDGbx/7m6zOKmRjWpZaovDUxr
         VZ6egidwvZG1XVuRmXBUDwpt7L3cIUTROehoqnTlJK82RlqVie6D30J5MGEJr5oUDB8K
         KarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793388764; x=1793993564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UBWddIU4VOdyo92IdAkPdEqsKaAU9G+Z2dZjBcQLsHU=;
        b=Zc2atKjfJG9DMisv2nSllsHm/9t4IBCLWRkoqsuWdvjQJ/Q/ypOUMTLmf9+Gb/fZiy
         6NeIh4sitoaBJMZ+MgaKx2mkNY45iYo3x40K7wVz2xP3aTbwRYzfFY7MVc8qOlMSfLrF
         JEIjzIfJYyRyF5Ib6K482UwgkItAHeYMQA5XyYAUhSesPVGjQEPRmHcF8QQq5hCwPXAc
         KqujqKtiTe4uaU158Lssm1goLVnWgM74cZEGLK/HIquCGJ2w1YEvPRa0OZgTtERfPaEI
         kfIIbaGvM0WidMR5LK5y4Hr0PNLk6Ho7ilqiV5hEdpAtREkGE9DVUN7vd9ic0t/zzpZM
         UckA==
X-Gm-Message-State: AFq9FYLQ6JvJiP8RZ3rP2UJ1LbQeiJNPx8h73hlYD/CTrpx6DHfnt14E
	CZWP0AOiTWG0ECLtvqe/hCt9XUid6qoKsdun8iXrF86ZcokKPWtG+1k=
X-Gm-Gg: AYBFou0d9ec7ZyyyFF2qMEFh5qZhoSTFiaM30MhX2X/NZqEyrKh/RSCjp2HNMAftpPN
	4SPIenR/j6u7pR+TNqenRFgDUkx45jOVLcnUl+A3NOoscW0MkB0F5KQ5wDJmx9dmQG9xotL1l8d
	XSZVsYOmL+xvbxhu8IUqa4AFO0aN85OJa+OnG9pLNrJJ0pAH3q0APae9UWNw9DA9EBcTKpr/TTE
	phHbsjEyh5lSbae1AKc2A8HrNI0M04PcGXRYCBrwYF0q7IxTutM216TAtioobukS07wcJPl53nC
	AwIMPPVu3pi259/rc4QBtrS3WJH8CPtap4AwmJM1NYiwdzHzCbmEAwHcwHvjgZu1GgLZS2EkNt+
	N5de5RGKnhcWzTX10aPgPsVt533TRjGt+QT3O98tbqwOlbMmcF8Q0YPPUpL1O6h9U0hjNqF/hp7
	5DCo/G17jZUOzb70IKrFeXrx7XB4QNdgwm9QyJUrpke6Flb6JQ/6p+9F5DM+u2ExrZrWBn1GOaJ
	Zlc5v/NCVlyebRAA8MRy+Wt1qlK9vjHOJH6YbtnBk6kMP4+zV+YliMjrjcG1lpdd4PnCl2nbucp
	7zy33jf3Adk=
X-Received: by 2002:a05:600c:4f0f:b0:4a1:e00b:a10b with SMTP id 5b1f17b1804b1-4ac17b2cde9mr83290705e9.7.1793388763971;
        Fri, 30 Oct 2026 12:32:43 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm4799150f8f.27.2026.10.30.12.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 12:32:42 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v10 2/2] RDMA/rxe: copy send WQE to kernel buffer in completer path
Date: Fri, 30 Oct 2026 19:32:35 +0000
Message-ID: <20261030193235.3470653-3-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261030193235.3470653-1-tristan@talencesecurity.com>
References: <20261030193235.3470653-1-tristan@talencesecurity.com>
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

The completer reads send WQEs from the same userspace-mapped shared
queue as the requester. Even after the requester copies the WQE to a
kernel-private buffer (previous patch), the completer still reads
directly from shared memory, leaving it exposed to the same TOCTOU
races.

Fix by copying the WQE in get_wqe() to a completer-private buffer
using the full queue element data size. The local copy is reused
when the same WQE is being processed with unchanged state, which
preserves DMA progress across multi-packet RDMA READ responses.
A fresh copy is taken when the state changes or a new WQE appears.

After copying, reject invalid opcodes (above IB_WR_REG_MR), out-of-
bounds num_sge, and invalid cur_sge by transitioning the QP to error
state through COMPST_ERROR. This prevents invalid SGE walks in
copy_data() from corrupted DMA indices.

The state read from the shared queue is preserved via smp_load_acquire()
and restored after the memcpy to prevent a concurrent userspace write
from overwriting it with a stale value.

DMA progress (resid, cur_sge, sge_offset) is written back alongside
completion status and rd_atomic state on completion, after each
intermediate response packet, and before retry invalidation. The
per-packet writeback in COMPST_UPDATE_COMP ensures the shared queue
always reflects the latest DMA offset, so a forced cache re-read (from
a state change in the shared queue) picks up current progress rather
than stale initial values.

The cache is invalidated on QP reset, when a completion advances to
the next WQE, on error retry, and on RNR retry to ensure fresh state
after the requester retransmits. The requester retry path also clears
the completer cache so the completer re-reads from the shared queue
after retransmission with updated PSN bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---

Changes since v9:
  - Bisection fix: move qp->comp.comp_wqe_valid invalidation from
    patch 1/2 into this patch where the field is defined, so each
    commit compiles independently (sashiko finding).

Changes since v8:
  - Write back DMA progress in COMPST_UPDATE_COMP after each
    intermediate response packet, so a forced cache re-read picks up
    current progress instead of stale initial values (sashiko finding).

Changes since v7:
  - Write back DMA progress before invalidating completer cache on
    error retry, so req_retry() resumes multi-packet reads from the
    correct offset (sashiko finding).
  - Invalidate completer cache in COMPST_RNR_RETRY to prevent stale
    PSN comparison after RNR timer fires (sashiko finding).

Changes since v6:
  - Fixed all sashiko review findings (2 Critical + 9 High).
  - FORTIFY_SOURCE: memcpy into enclosing struct, not inner member.
  - Copy size: max(max_sge * sizeof(ib_sge), max_inline).
  - Opcode bound: IB_WR_REG_MR (was IB_WR_ATOMIC_WRITE).
  - Validate num_sge + cur_sge, preserve smp_load_acquire state.
  - DMA progress writeback (resid, cur_sge, sge_offset).
  - *wqe_p = NULL for posted state, invalidate on retry.
  - Addressed Zhu Yanjun review feedback.

Changes since v5:
  - Added opcode bounds check and num_sge clamp after copy.

Changes since v4:
  - Resent from the correct sender address.

Changes since v3:
  - Copy full queue element (max_sge SGEs) instead of per-WQE size.
  - Invalidate on QP reset, ERR flush, RESET state check.

Changes since v2:
  - WRITE_ONCE/smp_store_release for field writeback.

Changes since v1:
  - Split into per-path patches. Cache across multi-packet ops.

 drivers/infiniband/sw/rxe/rxe_comp.c  | 76 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
 drivers/infiniband/sw/rxe/rxe_req.c   |  1 +
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1390e861bd1d7..2021e7301c8a9 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -137,22 +137,87 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
 	rxe_sched_task(&qp->send_task);
 }
 
+/* Write back completer WQE fields to shared memory */
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
+	WRITE_ONCE(shared->dma.resid, local->dma.resid);
+	WRITE_ONCE(shared->dma.cur_sge, local->dma.cur_sge);
+	WRITE_ONCE(shared->dma.sge_offset, local->dma.sge_offset);
+}
+
 static inline enum comp_state get_wqe(struct rxe_qp *qp,
 				      struct rxe_pkt_info *pkt,
 				      struct rxe_send_wqe **wqe_p)
 {
 	struct rxe_send_wqe *wqe;
+	u32 state;
 
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
+
+	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
+	state = smp_load_acquire(&wqe->state);
+	if (state == wqe_state_posted) {
+		*wqe_p = NULL;
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
+	/* Copy shared WQE to kernel-private buffer.
+	 * Copy size matches the queue element data area.
+	 */
+	qp->comp.shared_wqe = wqe;
+	memcpy(&qp->comp.comp_wqe, wqe,
+	       sizeof(*wqe) + max_t(int,
+				qp->sq.max_sge * sizeof(struct ib_sge),
+				qp->sq.max_inline));
+	qp->comp.comp_wqe_valid = true;
+
+	/* Preserve the state we observed via smp_load_acquire()
+	 * since memcpy may have overwritten it with a stale read.
+	 */
+	qp->comp.comp_wqe.wqe.state = state;
+
+	/* Reject corrupted opcode or SGE indices, error the QP */
+	if (unlikely(qp->comp.comp_wqe.wqe.wr.opcode > IB_WR_REG_MR) ||
+	    qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge ||
+	    (qp->comp.comp_wqe.wqe.dma.resid &&
+	     qp->comp.comp_wqe.wqe.dma.cur_sge >= qp->sq.max_sge)) {
+		qp->comp.comp_wqe.wqe.status = IB_WC_LOC_QP_OP_ERR;
+		wqe = &qp->comp.comp_wqe.wqe;
+		*wqe_p = wqe;
+		return COMPST_ERROR;
+	}
+
+	wqe = &qp->comp.comp_wqe.wqe;
+	*wqe_p = wqe;
 
+check_state:
 	/* WQE does not require an ack */
 	if (wqe->state == wqe_state_done)
 		return COMPST_COMP_WQE;
@@ -454,6 +519,8 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	if (post)
 		make_send_cqe(qp, wqe, &cqe);
 
+	rxe_comp_writeback_wqe(qp);
+	qp->comp.comp_wqe_valid = false;
 	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
 
 	if (post)
@@ -736,6 +803,7 @@ int rxe_completer(struct rxe_qp *qp)
 				qp->req.again = 1;
 			}
 
+			rxe_comp_writeback_wqe(qp);
 			state = COMPST_DONE;
 			break;
 
@@ -788,6 +856,8 @@ int rxe_completer(struct rxe_qp *qp)
 							RXE_CNT_COMP_RETRY);
 					qp->req.need_retry = 1;
 					qp->comp.started_retry = 1;
+					rxe_comp_writeback_wqe(qp);
+					qp->comp.comp_wqe_valid = false;
 					qp->req.again = 1;
 				}
 				goto done;
@@ -809,6 +879,8 @@ int rxe_completer(struct rxe_qp *qp)
 				 * rnr timer has fired
 				 */
 				qp->req.wait_for_rnr_timer = 1;
+				rxe_comp_writeback_wqe(qp);
+				qp->comp.comp_wqe_valid = false;
 				rxe_dbg_qp(qp, "set rnr nak timer\n");
 				// TODO who protects from destroy_qp??
 				mod_timer(&qp->rnr_nak_timer,
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 77606c4a039b1..450254a131017 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -582,6 +582,7 @@ static void rxe_qp_reset(struct rxe_qp *qp)
 	qp->req.wait_for_rnr_timer = 0;
 	qp->req.noack_pkts = 0;
 	qp->req.send_wqe_valid = false;
+	qp->comp.comp_wqe_valid = false;
 	qp->resp.msn = 0;
 	qp->resp.opcode = -1;
 	qp->resp.drop_msg = 0;
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index dd8ad19ed1d86..b226b9cec3a16 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -752,6 +752,7 @@ int rxe_requester(struct rxe_qp *qp)
 		req_retry(qp);
 		qp->req.need_retry = 0;
 		qp->req.send_wqe_valid = false;
+		qp->comp.comp_wqe_valid = false;
 	}
 
 	wqe = req_next_wqe(qp);
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

