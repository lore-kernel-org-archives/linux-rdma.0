Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792973657;
	b=NslHVSvwkk+bR4m6TTJbXd1jHs4STaOnJjdLH/uxviGU9b20FWxYRzXli4oukI97T6dz
	 fXFDD7XK6PKtbLtFw5nUplJ+tlapd8qkim8WttsCCVrkK6SF2U8RQqTfH/W/ZnBVnFeEQ
	 coTthgN1P/hX2DyST1TabTKHbwl2VRMzeN0NJNb6QpBReg0nvNSxNPcCPXFSxdTQJuj7g
	 DC+6rtrj5aEGnAVjchTcQQBeTeBP8yqp17ypHcufVzZdW7DXrWzdMfsFr5T8Efaq8q6aK
	 SRj2KOthKD5k4bLzPmC8bg/cv5b54AsRjPsiE2afZz4GKDCdkWXVKPNPzfbpY1jN64g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792973657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DtTXzgjp0eUdeNiI2nFzORCZfgmN16+gati70mNFXqE=;
	b=StGwNcEgsFz6iUB4gLrqPftdMEGtG47CXcJHxDhmmYGdPeIkt9OmeSJoddBtS8+rojXj
	 QkO61/nb9mHT2JQzF5ZPJfXOLm2tRmlVjVg/O8VBbyc67oonLxdpsx3UUkv0zl3Pbv48W
	 CtYuzRPcSD97/hKBaPyIgM6pSPabkSCdJSs4ZXD+vm76baiJAVBTEAAJoJD/cn9b6nauT
	 koH1gAndLOUfdU6ZGgAe8tMalrOr75wN0jjLKST0eabuRJIs1tFshDPxBbYghVE4yqbxr
	 sBjvNFW0XHiARIRMnZjUzuMw1iF6C0dJWKmo3pjsVM2iMjMBmK5/T2U9W3L4lt0k+gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MNuq6tdu;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F0606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 00:14:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E72F0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MNuq6tdu
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so1483502f8f.0
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 17:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792973655; x=1793578455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DtTXzgjp0eUdeNiI2nFzORCZfgmN16+gati70mNFXqE=;
        b=MNuq6tdumc8+QAQVSn1X422lLnv1noJAyVNrJy3YAxHjnEsnxLD45m4W1N05/TKVkA
         bq7mPPeZQAVmuG3E33KhOqjs5aBYy7Lg7TqqfkWFZpvXTJljRo60+wYReegYI78ftpNW
         EKZ2nvPkH2eH7bEB/TXtBVK83cNHFzXIWB2FvGuZjoLpAF1RPJqJ8oUzko6ltR3eTPRB
         cACyxmq9rlYf1aQEeH85kJ482OvVUSs94HdVlQDdX9DCmfwXnU2VTizbJdiIJLE746Bq
         WE2CPZ6Nwa2vXo8IX3qx0RkcIUScrW2vKBY2uZAO/8qAt3fCWKcZLnoT87j7FxTGJb3O
         KqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792973655; x=1793578455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DtTXzgjp0eUdeNiI2nFzORCZfgmN16+gati70mNFXqE=;
        b=rEnhGWOKZ3rHBYrBm7FRg/U0AI1eMwyLCzWpt68ljaLm3hmCvhFV55d39B0gc1MVQn
         Nbj/uj2oB8Qo68qMUntUwuLoo5f59+crufrXutNcVsVfwSmqaz3pZQjVHUren2TJXhVQ
         TZKXKjnDf/jDIrxSIsNr8a7uXsWWYsVj78D4N663anm5yZkxf9Dmrsqp66ZHoLkVDkKo
         QZTYBX4aGecS6KqvTEYEPDPqImpN8Wbf8Z6sKEG15vVznBcuLZNC5E5zD/IND8AC3OyM
         40Yw/DU2QewjPX5E3loYSr7UqKPUOk0NSoKp8dn8x2Snkv0ctbkEMxVbjgfyt5G8W3P9
         eTxA==
X-Gm-Message-State: AFq9FYLT7AMRYbwWV6XgIk+coXSkkaWb1EvvSyj3Y3XaUcMjYr6wIlbd
	YKoO6Y2kX+BxLr4Vlm93ilOeEnsnG0y5wF7kvYgp40I173PzkjDdaHjp5Ie+
X-Gm-Gg: AYBFou1e7g9HYrb94RYqDu7WFnYKTs0A02FNoHnFUdS207kw/mtQ6fcKHa4jCt1fYna
	GBSoYkVBWmHva1jpUel7KEaQUybHLFE27IjiPKTCYTzvc4UQ/kt6ChZYOKx4mUJSqxVv+EdAl5e
	PELFp3R0B3veSp8NRPIq7BscNwLVgbYDWmWJqwRrGDjx4caaDVmJnQN0kISsF9g7NU2Yn+2Z8BQ
	eBtIC9UsEyLvAWyFNTtpB9AW0WrJqFOf1nIT7EQkjmhNc3vmYmWsWQNEzFmilFi29GhjZ2DEbXd
	wyrP8MmqJImhInSrMo0PdLgebjl2nDKGSTEdobOV9sh0W8/P2APjhvs7DwZDxf58OofSifCJsBB
	zL+j89MxQ5MSJ4wWwmif+Po0rj0hN7zRyZzDH0HZlwJRLFsZvc0xZ19CWdmHqobk9yekxU9NC5q
	GtnvwxoCIiUifu1Inp9Mvm+UB/hrCD/z5utSjkAKXPtuprAtkhxTIV9lg8HTe7/PdwgjeypaC8m
	FouJ9K4OAKvmIBQCFE60tHAIda+suj6fgtlWg==
X-Received: by 2002:a05:6000:186d:b0:48e:4300:c713 with SMTP id ffacd0b85a97d-48e4300c875mr9915431f8f.14.1792973655308;
        Sun, 25 Oct 2026 17:14:15 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ece13aasm11940830f8f.58.2026.10.25.17.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 17:14:13 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	rpearsonhpe@gmail.com
Subject: [PATCH v6 2/2] RDMA/rxe: copy send WQE to kernel buffer in completer path
Date: Mon, 26 Oct 2026 00:14:05 +0000
Message-ID: <20261026001405.1698455-3-tristan@talencesecurity.com>
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

The completer reads send WQEs from the same userspace-mapped shared
queue as the requester. Even after the requester copies the WQE to a
kernel-private buffer (previous patch), the completer still reads
directly from shared memory, leaving it exposed to the same TOCTOU
races.

Fix by copying the WQE in get_wqe() to a completer-private buffer
using the full queue element data size (max_inline bytes). The local
copy is reused when the same WQE is being processed with unchanged
state, which preserves DMA progress across multi-packet RDMA READ
responses. A fresh copy is taken when the state changes or a new WQE
appears.

After copying, sanitize attacker-controlled fields: reject out-of-range
opcodes to prevent an OOB array access, and clamp num_sge against the
QP maximum so subsequent DMA operations stay within bounds.

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
 drivers/infiniband/sw/rxe/rxe_comp.c  | 60 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  1 +
 drivers/infiniband/sw/rxe/rxe_verbs.h |  6 +++
 3 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1390e861bd1d74..6e72cfeb10ec8d 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -137,22 +137,76 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
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
+		return pkt ? COMPST_DONE : COMPST_EXIT;
+	}
+
+	/* Pairs with smp_store_release() in rxe_req_writeback_wqe() */
+	state = smp_load_acquire(&wqe->state);
+	if (state == wqe_state_posted) {
+		*wqe_p = wqe;
 		return pkt ? COMPST_DONE : COMPST_EXIT;
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
+	/* Copy shared WQE to kernel-private buffer. Use max_inline
+	 * as copy size since it covers both SGEs and inline data,
+	 * which share the flex array.
+	 */
+	qp->comp.shared_wqe = wqe;
+	memcpy(&qp->comp.comp_wqe.wqe, wqe,
+	       sizeof(*wqe) + qp->sq.max_inline);
+	qp->comp.comp_wqe_valid = true;
+
+	/* Sanitize attacker-controlled fields from the copy */
+	if (unlikely(qp->comp.comp_wqe.wqe.wr.opcode > IB_WR_ATOMIC_WRITE)) {
+		qp->comp.comp_wqe_valid = false;
+		*wqe_p = NULL;
+		return pkt ? COMPST_DONE : COMPST_EXIT;
+	}
+	if (qp->comp.comp_wqe.wqe.dma.num_sge > qp->sq.max_sge)
+		qp->comp.comp_wqe.wqe.dma.num_sge = qp->sq.max_sge;
+
+	wqe = &qp->comp.comp_wqe.wqe;
+	*wqe_p = wqe;
 
+check_state:
 	/* WQE does not require an ack */
 	if (wqe->state == wqe_state_done)
 		return COMPST_COMP_WQE;
@@ -454,6 +508,8 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	if (post)
 		make_send_cqe(qp, wqe, &cqe);
 
+	rxe_comp_writeback_wqe(qp);
+	qp->comp.comp_wqe_valid = false;
 	queue_advance_consumer(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
 
 	if (post)
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 77606c4a039b17..450254a1310171 100644
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
index a22dfc6e5ae3cf..6205dbc29dff6d 100644
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

