Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9505C3F926D
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790615914; cv=none; b=uVCWkU8M4hpmVFnQqq6JJd/uVlCAsLueKP5acxdwe6OgAjOmXBisbYn5UtLxVgjz01MQV5KWM2Tdi7XliADE8uplXt1I5/K/SNQ5Y7YMSUEd3K4+mxYIIBoXCXs9cqrS5df5ubVRXCyqCN1/zL4E4vT9e7GSo73TO270d6MASqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790615914; c=relaxed/simple;
	bh=hWuaMcaAwTkbyMj8HLDf2zprF9Ov5rQwyMoJUf8Yv9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOLNKiGqawQQyO0QNiDMSriQt4EXGlDfMZbWiEaOdDqZhgWD//DCfpa6T1TTFv3UcfxSdgjSJ85l5M/BGnc+dCD1oNt7hEslc8DuOljuXDaA7nP58GoI/RIaslWJPof9HkiWJQ0fmzqdThVaNl6afSYE+nygcXcRDMCOk7GA+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZzWzJSb; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZzWzJSb"
Received: by mail-pj2-f39.google.com with SMTP id 98e67ed59e1d1-3a47d5764feso585937a91.2
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790615912; x=1791220712; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tsxxZqu/e5alkQ/9a1WyhnZ5MzktcoX/8HVXHoiojYs=;
        b=jZzWzJSbat51dnjmybCKvUWUx9yh+SUKQy5RtY6lyc3Ejgf8OYlkdBfRPzCUzSE5ce
         bzZyUnamQ99qksek+pp7bOcIwFJLP4O9jEY/Q+j5/8hZvgjQ5PELCn5SADoIBKwxv3YW
         hxLp6kRZl8MOqp9aWhPNarwyaQqtOh+YpAZDCp6mSB0rvVBGNTC2gcDSz03iIo/ISjYh
         EZbU8cRERmn7H4BBVLXxSDChoK0Yo+NR+dTM+E7A2hgs6s5tvkSEUnfEHxnyr5DgKt5d
         oPltY5GSu+LxcmG8LMZCdMELFLZOhPg4Bs/Ss1X6wXC4L9EIUgeY+jxOrx9Xd30jMA8k
         XPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615912; x=1791220712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tsxxZqu/e5alkQ/9a1WyhnZ5MzktcoX/8HVXHoiojYs=;
        b=QPJN3xIHYGQnzSMFj2Nz0S5u3wvKA9aifDA9QvmpGvn6t997qfSNHLL0ckdiOKkuQr
         eeswxF+4ZQd2Af1syBGKUkjpzZ6S4SmQzMlpI4RsTana74uj2ei1b+QGrnmFDE0J2qER
         eRDjM+r7MOQb/7mHomWfwdxFQXGbouMOW4axq4+M/UCqT6KoqcvWHldytdF2svJ7SnW7
         idJyqaGgvTuv25uO61I1U66h0nP8qbcDcQZWDWHk0omTRhknUUiAJ1AVJvp291bC25PW
         HPbLzvZvU0hsbRKyiCyyTCQWrvqR7Dpd8AnVhHgoCNd9UMbajKlHX5KvxTFXEt7JdU/i
         w4Zg==
X-Forwarded-Encrypted: i=1; AKwUvBzFLDC8k/36BOnZQaK268544ckMVnLkDolK13+vEOHwLeKS515Mr7zgtPem6bOWliS++I05yzMzY9te@vger.kernel.org
X-Gm-Message-State: AFq9FYKF+jUiBbB7a+kRYy/aPeu/jbKX0bfTQWuQ8HoKAaDdsXlo/eyl
	OjrdxU2m0NTeD8Rpc11Le+zoNd7YcXrrwoLuR0hE31XrFDWMejdYXs3M
X-Gm-Gg: AYBFou1wTggtAhpryvGa4dBpNRy8Uc/BdLC4NmB6gU8D+bSqSqKtX5lI19VZLy9Gu3k
	3aFnZJI8Nly4Wa6bsd23IcLFk0WIa0Xsull0IguYbWDy9aq0f0DLk9xdPY51UGad70u/cOCVGn+
	OemwK5w+fUIJ7hrV2Z+TOGtfdrGn7J2bt+h/Px1JJYHr+8yiR1Ztl6gu2Haxu8Ifo+u8BT1+E7X
	CC7G8hENHtKybRy9UysePXq5MUuWPXm+PcqcUbe3am/bYLM1emSlwAQFIE8+ggIk+JEdI/+n67W
	+5rdTP3E6oxFddJgwHSm1JkY3Bh4LitUwXCDT4w/P6gcLnbpoA+hxS84RdEBaOJisSqOOz+z1PV
	OwNtUBC9vxXE9cWVpEkFjwQO3YqodjRepRMrsGCpmUPU0lKCdf7P7vFYR/AYq4IHV44016MGmp8
	ZPZoU6aXnQBipB5yDU0T+GoL2641nsqCSEZ9689sk6p8kjbcXW6AgJzQ6KhOFd/2yRgHy0u72ck
	b/jcKEVoKsxlGFzztdScBgH
X-Received: by 2002:a17:90b:4c42:b0:39e:6c68:c787 with SMTP id 98e67ed59e1d1-3a098e5897amr12847976a91.61.1790615911502;
        Mon, 28 Sep 2026 10:18:31 -0700 (PDT)
Received: from localhost.localdomain ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4986bb8f6sm189139a91.0.2026.09.28.10.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:18:30 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/4] RDMA/rxe: Invalidate MWs on QP destroy
Date: Tue, 29 Sep 2026 01:17:55 +0800
Message-ID: <20260928171756.3254016-4-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A type-2 MW holds a reference to the QP that bound it. If the QP is
destroyed while an MW is still bound, the MW keeps the QP alive and the
responder can retain a stale QP association.

Scanning the global MW pool to find these MWs is unsafe: pool entries are
struct rxe_pool_elem pointers, and concurrent deallocation can invalidate
the object being visited. It is also unnecessary because only MWs bound to
the QP being destroyed are relevant.

Track type-2 MWs on a per-QP list. Clear qp->valid and stop the send task
before invalidating the list so a late bind cannot attach a new MW after
invalidation. Yield between MWs to avoid spending a long time in a
non-preemptible loop when a QP has many bound MWs.

Fixes: 32a577b4c3a9 ("RDMA/rxe: Add support for bind MW work requests")

Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
---
Changes in v2:

- Track type-2 MWs bound to a QP in a per-QP list instead of scanning
  the global MW pool.
- Fix the XArray iterator type mismatch by no longer treating pool
  elements as struct rxe_mw pointers.
- Clear qp->valid and stop the send task before invalidating MWs so a
  late bind cannot attach a new MW after invalidation.
- Yield between MW invalidations to avoid long non-preemptible loops.

v1: https://lore.kernel.org/linux-rdma/20260928155351.3222978-4-cccccccccccc777777@gmail.com/

drivers/infiniband/sw/rxe/rxe_loc.h   |  1 +
drivers/infiniband/sw/rxe/rxe_mw.c    | 44 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 ++
 drivers/infiniband/sw/rxe/rxe_verbs.c |  8 +++++
 drivers/infiniband/sw/rxe/rxe_verbs.h |  3 ++
 5 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 5e95e5c5e32d6..5c648a5ef34b1 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -90,6 +90,7 @@ int rxe_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata);
 int rxe_dealloc_mw(struct ib_mw *ibmw);
 int rxe_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe);
 int rxe_invalidate_mw(struct rxe_qp *qp, u32 rkey);
+void rxe_invalidate_mws(struct rxe_qp *qp);
 struct rxe_mr *rxe_mw_get_mr(struct rxe_qp *qp, int access, u32 rkey,
 			     u64 *offset);
 void rxe_mw_cleanup(struct rxe_pool_elem *elem);
diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 82e9fef89b6c3..678f251c8ded3 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -166,6 +166,9 @@ static int rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 
 	if (mw->ibmw.type == IB_MW_TYPE_2) {
 		mw->qp = qp;
+		spin_lock(&qp->mw_lock);
+		list_add(&mw->qp_list, &qp->mw_list);
+		spin_unlock(&qp->mw_lock);
 	}
 
 	return 0;
@@ -247,11 +250,13 @@ static int rxe_check_invalidate_mw(struct rxe_qp *qp, struct rxe_mw *mw)
 
 static void rxe_do_invalidate_mw(struct rxe_mw *mw)
 {
-	struct rxe_qp *qp;
 	struct rxe_mr *mr;
+	struct rxe_qp *qp = mw->qp;
+
+	spin_lock(&qp->mw_lock);
+	list_del_init(&mw->qp_list);
+	spin_unlock(&qp->mw_lock);
 
-	/* valid type 2 MW will always have a QP pointer */
-	qp = mw->qp;
 	mw->qp = NULL;
 	rxe_put(qp);
 
@@ -298,6 +303,35 @@ int rxe_invalidate_mw(struct rxe_qp *qp, u32 rkey)
 	return ret;
 }
 
+void rxe_invalidate_mws(struct rxe_qp *qp)
+{
+	struct rxe_mw *mw;
+
+	for (;;) {
+		spin_lock(&qp->mw_lock);
+		if (list_empty(&qp->mw_list)) {
+			spin_unlock(&qp->mw_lock);
+			return;
+		}
+
+		mw = list_first_entry(&qp->mw_list, struct rxe_mw, qp_list);
+		if (!rxe_get(mw)) {
+			list_del_init(&mw->qp_list);
+			spin_unlock(&qp->mw_lock);
+			continue;
+		}
+		spin_unlock(&qp->mw_lock);
+
+		spin_lock_bh(&mw->lock);
+		if (mw->qp == qp)
+			rxe_do_invalidate_mw(mw);
+		spin_unlock_bh(&mw->lock);
+
+		rxe_put(mw);
+		cond_resched();
+	}
+}
+
 struct rxe_mr *rxe_mw_get_mr(struct rxe_qp *qp, int access, u32 rkey,
 			     u64 *offset)
 {
@@ -349,6 +383,10 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem)
 	if (mw->qp) {
 		struct rxe_qp *qp = mw->qp;
 
+		spin_lock(&qp->mw_lock);
+		list_del_init(&mw->qp_list);
+		spin_unlock(&qp->mw_lock);
+
 		mw->qp = NULL;
 		rxe_put(qp);
 	}
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 311f285d78a6b..132d224a278b2 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -220,6 +220,8 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe, struct rxe_qp *qp,
 	}
 
 	spin_lock_init(&qp->state_lock);
+	spin_lock_init(&qp->mw_lock);
+	INIT_LIST_HEAD(&qp->mw_list);
 
 	spin_lock_init(&qp->sq.sq_lock);
 	spin_lock_init(&qp->rq.producer_lock);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 8553c8402c619..1f45e8bc53da5 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -650,6 +650,7 @@ static int rxe_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 static int rxe_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 {
 	struct rxe_qp *qp = to_rqp(ibqp);
+	unsigned long flags;
 	int err;
 
 	err = rxe_qp_chk_destroy(qp);
@@ -658,6 +659,13 @@ static int rxe_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 		goto err_out;
 	}
 
+	spin_lock_irqsave(&qp->state_lock, flags);
+	qp->valid = 0;
+	spin_unlock_irqrestore(&qp->state_lock, flags);
+
+	rxe_disable_task(&qp->send_task);
+	rxe_invalidate_mws(qp);
+
 	err = rxe_cleanup(qp);
 	if (err)
 		rxe_err_qp(qp, "cleanup failed, err = %d\n", err);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0f5ffd94643f9..d6585581e9c33 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -288,6 +288,8 @@ struct rxe_qp {
 	struct timer_list rnr_nak_timer;
 
 	spinlock_t		state_lock; /* guard requester and completer */
+	spinlock_t		mw_lock;
+	struct list_head	mw_list;
 
 	struct execute_work	cleanup_work;
 };
@@ -387,6 +389,7 @@ struct rxe_mw {
 	int			access;
 	u64			addr;
 	u64			length;
+	struct list_head	qp_list;
 };
 
 struct rxe_mcg {
-- 
2.43.0
