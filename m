Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B089130674C
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 19:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788117230; cv=none; b=J1idSqMYZltmTXN8CrKIw0yJ3zUumI9vBtMKXBkE6ERAmkH5KffzHkpip6BIaLU30MicawXu9Y/o59ZWG2/zwXqg7KnCxvukJ0P8yNHnqp5pDAGxXyDKBf/wJaO9NOJsb4gUMUNjw3oOr6SzEaSK1qxNnd9nwI/Ygi9LrGQlsB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788117230; c=relaxed/simple;
	bh=8ERaRkEBq4AywYTK7Qvy1xaAyo581EM0kxQsGbdTxfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcOTusj9jxdgqFNJatkf4NuVT2dWzguZHDNqSuIeNZZoT0pyn9jgP3EjBxr3yylh27HLsIEGgKuuPzhWfa2TiMisd3kS2ceOLdJKntX8nQ/BL6U7ZpX2340+AjZTmsz/xUZKR6Ws+TDW4zScSOf0/Yvj5rBmX6RKMGHRcMoZzqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oI6hL2rp; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oI6hL2rp"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47fd4531020so1592619f8f.3
        for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 12:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788117227; x=1788722027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9cQBXw53zI3AETGKx0IGl1XCL0GNVMfafqa91w04yFc=;
        b=oI6hL2rp7sbRA3c/H/8UOGdVkTDN9tEwGMRyJoTOiaj2G8DpsOuX/bDIGow1yFAD4i
         LUPF52NUOsZR+X4FreKpR5iA5jRNcFcgVvcBryPbaN7VvubuCFxriVZHenbzpp9v7HDC
         BtwPJnsMo2hhYy9wEPHoZCFHEhn5KdXFhajALYY4K3+6f09V5QZXcUBf86J8G28e87DS
         7gKqD6rb765AnZoP7bPJdFIJ3h2zKdHQBsWb9kuuzZG8vJyIIo6OJgURavm21hlDJEwu
         GpHIkv6P23ceCEOesRC6l5gEMmUCmuPx1hK/EZiHa5r1bBon3F7qFKqo8XIkb8BPFh0r
         nmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788117227; x=1788722027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9cQBXw53zI3AETGKx0IGl1XCL0GNVMfafqa91w04yFc=;
        b=goX1ownjWYp917x7FqBFSFhe1PQefeivTDZ6ZZ/VlFS/END+gp21PbHjNbcaSJ1zRf
         voGicE9GTNH32HKvjdP2IlNLYtSLuXtvGH+jrhbVyAbnTLFSx2mpZJ4zsu1m/csRHWIl
         wjnpjazl2SGF6GwvhUtbmo27KbXC7Nw9fdXHHYPmCQ9r6Aow6rzRiIhq4lHnM4+nPECo
         uYwJLs3qfxpuYD+IB0UKpgCT6SSz5re4XwyfUTo1vQKxeX3Ob9dPGp9Yn4G8Wi6BHCnz
         yurtT04f9zzGvyRvu9cNE0rg2gv0p5yRxLsQjXjLZua56wsV6qClzFWjuJ51el8KSj0h
         +F2g==
X-Forwarded-Encrypted: i=1; AHgh+Rqe5iPwdPflIo7Cw/9HrBra6+VOzH0OxgeMLzIkn9UMvmCq8DKp2MpHLXyRRvUluCmzSUbZpWaM6cQ1@vger.kernel.org
X-Gm-Message-State: AFuF++msuYb3QqTNdmCdD534PoetPpa6objD7ywoNY6HRM6ihudYhiA9
	7GNt+0SqukHj77TeZHwlzyUvKUEYXjtaSL1wz4qt728SLjCxLLFec9k=
X-Gm-Gg: AR+sD10fRfb2z04dBr8HaKpixaSLOR9YfhdkNjFQ75+VgrN/clSRi0OMs4M3Z75BDsM
	kQk4Ko5/2IjjQXrqvD+DtGszKORKip34CxFHKsiNQK6wwPLAigOFDss7h7+K+TzkdtLWjy0r7+6
	0KHrGaLzg5DL6PmRiE/uxNaTYdQU8w0X/dTPmdL/3IDXPeK/tVTR8dcKM63UpmwGKTYNK/OBign
	BlR3iXNY0AbbEqZoL6WmxbuKsLm9UrWzVkq210NXTQLOdSqx6eYQxHhWaIign7cnJZUbelQ2lel
	WSH6wJa6rYF6QkwcotoGzc8gF3QSFVVh8YuQeBt7MYFo0+GrMC6tiDbntVHYDn4/60GPaVUXYLj
	ahKvjw7ilAWY6BxK42V1n899l1hT6zV62OkWMJBbAak8e4OxDNH9DDSLpm7sZkc1GEgs9w4XQYr
	6jG19wsJWspAVPYACzSbZYz6ymlbCC4cw=
X-Received: by 2002:a05:600c:1e0f:b0:49b:9113:e04a with SMTP id 5b1f17b1804b1-49b91c19c77mr347222425e9.1.1788117226723;
        Sun, 30 Aug 2026 12:13:46 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd8148fbdsm2404705e9.3.2026.08.30.12.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 12:13:46 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Moni Shoua <monis@mellanox.com>,
	Ibrahim Hashimov <security@auditcode.ai>,
	linux-rdma@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2 2/2] RDMA/rxe: copy completer WQE to kernel buffer before processing
Date: Sun, 30 Aug 2026 19:13:43 +0000
Message-ID: <20260830191344.2026524-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830191344.2026524-1-tristmd@gmail.com>
References: <20260816104432.849996-1-tristmd@gmail.com>
 <20260830191344.2026524-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The completer reads WQE fields (dma.num_sge, dma.sge[], dma.cur_sge,
wr.opcode, first_psn, last_psn, state, status) directly from the
userspace-mapped shared send queue via queue_head(). Userspace can
modify these fields between completer reads, causing inconsistent
state in do_read() and do_atomic() which call copy_data().

This is the completer-path counterpart to the preceding patch which
fixed the requester path. Although rxe_sender() calls the requester
and completer sequentially (not concurrently), the requester may have
already advanced wqe_index and invalidated its kernel-private copy by
the time the completer processes the READ/ATOMIC response, so the
completer needs its own copy.

Fix by:
 1. Adding a kernel-private WQE copy buffer (comp_wqe) to
    rxe_comp_info
 2. Copying the WQE from shared memory in get_wqe() before any
    processing, with num_sge validation against qp->sq.max_sge
 3. Writing back status/state changes to the shared queue entry in
    do_complete() using WRITE_ONCE() so userspace observes consistent
    completion status

The flush_send_queue() error path is not modified as it runs during
QP teardown (ERR/RESET state) and does not call copy_data().

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
v1 -> v2:
 - Use WRITE_ONCE() for status/state writeback in do_complete(),
   addressing review feedback from Zhu Yanjun

 drivers/infiniband/sw/rxe/rxe_comp.c  | 34 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h |  5 ++++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 1390e861bd1d7..2c57e7a0d4203 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -142,16 +142,38 @@ static inline enum comp_state get_wqe(struct rxe_qp *qp,
 				      struct rxe_send_wqe **wqe_p)
 {
 	struct rxe_send_wqe *wqe;
+	unsigned int num_sge;
+	size_t copy_size;
 
 	/* we come here whether or not we found a response packet to see if
 	 * there are any posted WQEs
 	 */
 	wqe = queue_head(qp->sq.queue, QUEUE_TYPE_FROM_CLIENT);
-	*wqe_p = wqe;
 
 	/* no WQE or requester has not started it yet */
-	if (!wqe || wqe->state == wqe_state_posted)
+	if (!wqe || wqe->state == wqe_state_posted) {
+		*wqe_p = NULL;
 		return pkt ? COMPST_DONE : COMPST_EXIT;
+	}
+
+	/* Copy WQE from userspace-mapped shared queue to kernel-private
+	 * buffer to prevent TOCTOU races on DMA state fields.
+	 * This is the completer-path counterpart to the requester fix.
+	 */
+	num_sge = wqe->dma.num_sge;
+	if (unlikely(num_sge > qp->sq.max_sge)) {
+		rxe_dbg_qp(qp, "invalid num_sge in send WQE (comp)\n");
+		memcpy(&qp->comp.comp_wqe.wqe, wqe, sizeof(*wqe));
+		qp->comp.comp_wqe.wqe.status = IB_WC_LOC_LEN_ERR;
+		qp->comp.shared_wqe = wqe;
+		*wqe_p = &qp->comp.comp_wqe.wqe;
+		return COMPST_ERROR;
+	}
+	copy_size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
+	memcpy(&qp->comp.comp_wqe.wqe, wqe, copy_size);
+	qp->comp.shared_wqe = wqe;
+	*wqe_p = &qp->comp.comp_wqe.wqe;
+	wqe = *wqe_p;
 
 	/* WQE does not require an ack */
 	if (wqe->state == wqe_state_done)
@@ -446,6 +468,14 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	struct rxe_cqe cqe;
 	bool post;
 
+	/* Write back status to the shared queue entry so the CQE
+	 * and any retry logic sees the correct completion status.
+	 */
+	if (qp->comp.shared_wqe) {
+		WRITE_ONCE(qp->comp.shared_wqe->status, wqe->status);
+		WRITE_ONCE(qp->comp.shared_wqe->state, wqe->state);
+	}
+
 	/* do we need to post a completion */
 	post = ((qp->sq_sig_type == IB_SIGNAL_ALL_WR) ||
 			(wqe->wr.send_flags & IB_SEND_SIGNALED) ||
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index a22dfc6e5ae3c..f1d647ddc1e05 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -130,6 +130,11 @@ struct rxe_comp_info {
 	int			started_retry;
 	u32			retry_cnt;
 	u32			rnr_retry;
+	struct rxe_send_wqe	*shared_wqe;
+	struct {
+		struct rxe_send_wqe	wqe;
+		struct ib_sge		sge[RXE_MAX_SGE];
+	} comp_wqe;
 };
 
 /* responder states */
-- 
2.47.3

