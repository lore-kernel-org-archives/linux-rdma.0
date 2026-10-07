Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322793914EB
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791412355; cv=none; b=QbNY7zh+oxA4XkYECM+UZXWm61rShltSSzCiFYjK0qWdyf14BnCF11g5BTV6+KW7EN8eq/Ljrp2Kdq2Ek6PUH8mK9VSNZbqfyvB0aQRhwpTdd5phYdYY73sNADSs3uT/BOWd6AOoq9Z71GIrF5TUlE+UUIoJIXJqNaptombfj8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791412355; c=relaxed/simple;
	bh=8+U5D2e5SYzZrGrK1iL1HrfwBcX1Qkb57io62ZvQyms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKdwvL4LMDTK4ELX6ox7HuM4I/HQTmpF4EDN67/fpL+SJi5U9Sg9wxb2lP8axEIAu3wFyK01s6hCoUdL1ZXOr+7y9XkJzmlk2UFglaRcqrLdgAxc0Bm/EzYuvyj3qO55jVPTgHoSlCtH+DjGZKuGYg7mZzQT5FTpXaq3MpM/4e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNGdMFKk; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNGdMFKk"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48c14a06c95so1894075f8f.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 15:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791412351; x=1792017151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ijnB+OFRCY2MBDBmpyYwGFKzVgbk/JgZe3RlorNey9w=;
        b=BNGdMFKk58gaT3jjcwzDxxRlH8sWxuMmQel35qZfTOGZYQZS4E33wksR86SdYNoA+S
         S/jlJqf50D9+xlv7m20j2tunQSbngJubUkozLyPqPwguJPdTHZwzEjtBFLXn0oPSPoKp
         Nw//cyiiGCxhWUVnqQGxDPPVSDFg+XPlSWBH8qGoXp3b3HkkB71aJW47Ij9f59PsZKJh
         gumS6QxXhAUB8jwyCGudqjt5Q4DxEeVmQMAIWfwELFDVK6PP+X6RffgWeW8w4iUADJrf
         uENasNX9J/zGyAikFmSEKn3qIQJZrXxreJRlbD6xSrUVB3etpUhAjMQGYHkP7YO7c5rt
         0igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412351; x=1792017151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ijnB+OFRCY2MBDBmpyYwGFKzVgbk/JgZe3RlorNey9w=;
        b=DQ+ofEK+rL9UQJhDeOh/Rbbp6KJl3gGWRxlbARyeNWaGaejxp3uqRycaE3JlcK6+p4
         qDzmwwn50SMPPkWCAjIbG07WnN1OO/LbxGhcxK2bjKKefehNbaqWr8lKHe8S4fxJ3rTp
         VqBeBQL7gMevUWrC40TRNJL0N4bmupO/1g89XtRUJWTHoprn6wyqzUKEf6GPNajG8Zjl
         N8DlUXXtCZVyH2nVFjofNbMLXd/E98QTHZDtqa3KBdXw5uXEn/PZRTTiI+5g2sLInQ9v
         dbA2GjRw9n/qlm+yV0biyzVgmfjF8NXIg99c+A9byqHRILwIvyZd/uNLpIhiGBEougqh
         N1PA==
X-Gm-Message-State: AFq9FYKcmw0NUbqX16o+uihHwcKNzFJyRgkdGr8g3wehfQrrD+mM1RF7
	f2JsOry0pQhPCnPgHirsj8h40svWLwqrl3rX46qTU6UpXaHsruzU+UuiwfGQ
X-Gm-Gg: AYBFou3c8IJX6qvftMccc3Zktg1JUAdZkpPJ9FKZQsLzljApunF9p6qqRyMyr4YHcNl
	38+3s1plNNaiTxJbB5fapoBCAIyvVsQM4Q3R3/mprIedGWMpOsrsjlW5xEKyjZpUA91VETt1Gpt
	s3Fk2+QGlCL3TX77PxwEbdreevq7OP189bz/t+EGNr8abKEOUnP/xZtg7mFW8h+lwYqypJF4+4x
	wOb4MHzQwCVAMgPuEy/HnPYmpFdLYavsmEY38tnW7q0depnIsF7bMNDzZIKk6z686HTMTELmIuU
	SAiI8UO1KYuH2Pw3QYQUHJd86N0bXA+dUnI7oRTG5z6dMF2xJumMQIW0XDiXqhijn6OI2VHd+ne
	ULtL5D1LyKMWIO2lCtghzUUvFeGy424wE8EvsvnGl5KRRTEaVMSExYd2k6/e5QPpz0/GdOgovSt
	mAQH2xupPF+S0wijfp6JB9WgAHJBMu+l/Za6X/+HM=
X-Received: by 2002:a05:6000:26c8:b0:48a:fc9a:3765 with SMTP id ffacd0b85a97d-48c7289b124mr7353204f8f.46.1791412351306;
        Wed, 07 Oct 2026 15:32:31 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d1fec3sm7743500f8f.37.2026.10.07.15.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 15:32:30 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	bob.pearson@hpe.com,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/2] RDMA/rxe: copy send WQE to kernel buffer in completer path
Date: Wed,  7 Oct 2026 22:32:22 +0000
Message-ID: <20261007223222.2342804-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007223222.2342804-1-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The completer reads send WQEs from the same userspace-mapped shared
queue as the requester. Even after the requester copies the WQE to a
kernel-private buffer (previous patch), the completer still reads
directly from shared memory, leaving it exposed to the same TOCTOU
races.

Fix by copying the WQE in get_wqe() to a completer-private buffer
using the full queue element size (max_sge SGEs). The local copy is
reused when the same WQE is being processed with unchanged state,
which preserves DMA progress across multi-packet RDMA READ responses.
A fresh copy is taken when the state changes or a new WQE appears.

State transitions from the requester are observed through an
smp_load_acquire() / smp_store_release() pair. Completion status and
rd_atomic state are written back through WRITE_ONCE() before the
consumer index advances.

The copy is invalidated on QP reset and when the completion advances
to the next WQE.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  | 53 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1390e861bd1d7..ca31093fdf3aa 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -137,22 +137,69 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
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
+	/* Copy shared WQE to kernel-private buffer. Copy the full
+	 * element (max_sge SGEs) so that inline data, which shares
+	 * the flex array with SGEs, is always captured.
+	 */
+	qp->comp.shared_wqe = wqe;
+	memcpy(&qp->comp.comp_wqe.wqe, wqe,
+	       sizeof(*wqe) + qp->sq.max_sge * sizeof(struct rxe_sge));
+	qp->comp.comp_wqe_valid = true;
+	if (qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge)
+		qp->comp.comp_wqe.wqe.dma.num_sge = qp->sq.max_sge;
+
+	wqe = &qp->comp.comp_wqe.wqe;
+	*wqe_p = wqe;
 
+check_state:
 	/* WQE does not require an ack */
 	if (wqe->state == wqe_state_done)
 		return COMPST_COMP_WQE;
@@ -454,6 +501,8 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	if (post)
 		make_send_cqe(qp, wqe, &cqe);
 
+	rxe_comp_writeback_wqe(qp);
+	qp->comp.comp_wqe_valid = false;
 	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
 
 	if (post)
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

