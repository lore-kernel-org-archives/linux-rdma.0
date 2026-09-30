Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7474E77FD
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792551; cv=none; b=DiSSODzcp0uA7Wq80PwLqwqdxjLVEaYt1z9wDUYyWezgeuN7FQkYRGPnussdeHp8R4z1qiO7HTkGUT6TwTKx7d5XRO2CGIdiSiSrLaQR5xcJgejLgfOs1m3DoQOlO7nfYUKRULzMJqTkZKHxrM7OEFELrA9gqWzwFsXvVdfOiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792551; c=relaxed/simple;
	bh=h53OxljJG62Yz+U16wmJOxE8ZQ6K1lJqf00lYq9upZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tT9y0qcvTqN7CMCmo3cZzzGQz6ERZwU2HPfOqM4Rt9Go1km+p33GQov/fHXu3CJ0YaeU3rIf0qftKpZ4nBgP8RtfkCtXtJxzDi1DgZycMCk0QCoXClFZ44I9AnLtFh0ihKDfQ/6wpTdJgmsjN4xw+V4V5KqNzvKLwYKJM63xlYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gy1dC3ww; arc=none smtp.client-ip=74.125.227.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gy1dC3ww"
Received: by mail-pj2-f38.google.com with SMTP id 98e67ed59e1d1-3a4c276e1c7so634365a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790792549; x=1791397349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OfZUsMsh9nADwmEX2TQ8lPQWLl3QIh1rJ/DiPrlYRVU=;
        b=Gy1dC3wwBxdeWv+5jYv0CkjFBU+aZ1bzk7xezVc6vBWoz6t8ML+nFHSQOaGnPb0i/N
         qYBS2p9WQHZyqYaFG+qWFDuA4zZm8ZahfyCqBN7oD+3IE1fs7+pyzj66CWjBrecxqZJJ
         Jp/RQw/jdWYbfyD+KlLULnEMY1/39oT/dy1xAxrCCukJ89NH4eOkGRGImqsf7ZXzY9Xk
         g8lpeG7brxOyxG3yV+4EZMCzb3zGp5EMiSw7uUYleKPhlQo1e75vfIyFy1r2pQWp0e6p
         LGRqW2+AjzCcpf/4j/L0PGscYGsH5H0suY1NqlcPk70CMWDUpTqTHQxz5RCxN/X3ZVoB
         F2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790792549; x=1791397349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OfZUsMsh9nADwmEX2TQ8lPQWLl3QIh1rJ/DiPrlYRVU=;
        b=jVnXI+NL7fOLNL9fF4v+7Slqu/xVbuIpFU80SRB1JelEp3GCbsF4GwwS22mPmwVG4B
         cPE3xVA2aJsKw/O0AlnlvuPzCTvQP5cE0rTxWooMGgWoElnVWErdGHKGDT5rMO9hV8pw
         eCy2moYDeDTPetIxB5SKSV+Kq16z7WsjAeA8UbQijvVvJno10RCZhl4zI2lidjQThsxu
         3A3J3N0+Tb1mxchNg73PVms+Gq90OEhkfzqjsuuuzsl6P5wLWaC4kxb2MyyJLJU87ZEX
         VJPtV4E4vyBLJae+Uxyvfd2Gri1kMDePP0hrpytJ/QShSpdO/225w5lrZvURaO6wMNxm
         h2/g==
X-Gm-Message-State: AFq9FYKDelNX9gbaZC+346uzLiqWCfqxhy5h6pqBpwRf4jLYvGq8+sdp
	glJhHkzrBZ7B/yypLEOJKB8Z0PO/ms0yVeNUaC298Izcf1kMrdZaiYX8
X-Gm-Gg: AYBFou3aDWEkOe9yE8M0BEGn/im4i30wg4DUdny+Semi3ljpg0xzF+fLOMLd2F4zy6d
	CLRPmhrz2lBlwZW1IdAZ+YIzKKQ/8uDz/k0t8U0kRGvNLeTCC8dvhcp6yJBRJNnj4+vIT93MkF/
	K198Vi8u8EQiJiagMBWH2gw770mKuSUw8ajijXv+X902n1OaeSUIem9vFN3XqP58/Ay92C7cAi2
	cMM1TdAfMoM6bMSvginscg4pzqIQ8k/un9v1Vy1R6mTBLBoVYo1XP9YERwKEHnspSv3FniIUEaj
	izy249pzaVcWJ/djzheLzUbyAb4DHadguQMiK8KOcSZlc8/QGbDV0+FrLjceNIDXzmCKOJVRN4O
	aM/StEw2ca1KJCv8k5ZOLbGmNzMvz6ok8Cdg6iWs737JTYD/rpktGdZD6eMq6E7kUUkbzGhTVxO
	1JSfw4ahXB2ok5iUCPV8UH/b+RifxuoZVtk2ujhixEoKfKWFMThPncbuzb2AjpIYZWtthpTqWiw
	twQIT8QEQ==
X-Received: by 2002:a17:90a:fc4e:b0:3a0:cde8:1dd6 with SMTP id 98e67ed59e1d1-3a4d0f037f4mr897676a91.6.1790792549155;
        Wed, 30 Sep 2026 11:22:29 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f446867asm536543a91.12.2026.09.30.11.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 11:22:28 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: [PATCH] RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound
Date: Thu,  1 Oct 2026 03:22:23 +0900
Message-ID: <20260930182223.2511145-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Youngsung Ahn <ays511.kr@gmail.com>

Binding a type 2 memory window takes a reference on the QP:
rxe_do_bind_mw() does rxe_get(qp) and stores it in mw->qp. That
reference is released only when the window is invalidated
(rxe_do_invalidate_mw() on IB_WR_LOCAL_INV) or the window itself is
destroyed (rxe_mw_cleanup()).

rxe_qp_chk_destroy() does not account for those references -- it only
refuses when qp->mcg_num is non-zero. So an unprivileged user can bind
a type 2 MW to a QP and then destroy the QP while the binding is still
live. __rxe_cleanup() cannot drop the QP refcount to zero (the MW still
holds a reference), hits its -ETIMEDOUT path, and frees the QP anyway;
mw->qp is left dangling. When the MW is later invalidated or
deallocated, rxe_mw_cleanup()/rxe_do_invalidate_mw() do rxe_put(mw->qp)
on the freed struct rxe_qp -- a use-after-free write (refcount_dec, and
complete()/list work if it reaches zero) reachable from userspace.
IB_WR_BIND_MW is a local operation, so no peer is required.

Track the number of type 2 MWs bound to a QP and refuse to destroy the
QP while that count is non-zero, returning -EBUSY exactly as the
existing multicast-attachment check does. The window must be
invalidated or deallocated, which drops the reference and the count,
before the QP can be destroyed.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000: deterministic
KASAN slab-use-after-free write via rxe_mw_cleanup() -> rxe_put() on the
freed struct rxe_qp (bind a type 2 MW to an RTS QP, destroy the QP, then
deallocate the MW). Present unchanged in mainline 551c722f4080
(2026-09-29) and rdma for-next. This patch is compile-tested
(KASAN+RDMA_RXE); the counter-based fix itself has not been runtime-tested
in this form. Found through manual review; per security-bugs.rst this is
public and a reproducer can be shared on request. The Fixes: tag points at
the base driver and should be refined to the type 2 MW bind support commit
when preparing for merge.

 drivers/infiniband/sw/rxe/rxe_mw.c    |  3 +++
 drivers/infiniband/sw/rxe/rxe_qp.c    | 10 ++++++++++
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index bddb7a25..a2e3a6ce 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -161,6 +161,7 @@ static void rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 
 	if (mw->ibmw.type == IB_MW_TYPE_2) {
 		rxe_get(qp);
+		atomic_inc(&qp->mw_bind_num);
 		mw->qp = qp;
 	}
 }
@@ -245,6 +246,7 @@ static void rxe_do_invalidate_mw(struct rxe_mw *mw)
 	/* valid type 2 MW will always have a QP pointer */
 	qp = mw->qp;
 	mw->qp = NULL;
+	atomic_dec(&qp->mw_bind_num);
 	rxe_put(qp);
 
 	/* valid type 2 MW will always have an MR pointer */
@@ -332,6 +334,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem)
 		struct rxe_qp *qp = mw->qp;
 
 		mw->qp = NULL;
+		atomic_dec(&qp->mw_bind_num);
 		rxe_put(qp);
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index 311f285d..fea55bc3 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -858,6 +858,16 @@ int rxe_qp_chk_destroy(struct rxe_qp *qp)
 		return -EBUSY;
 	}
 
+	/* An attempt to destroy a QP while it still holds references for
+	 * bound type 2 memory windows will fail immediately.  Otherwise the
+	 * QP is freed with those references outstanding and the windows are
+	 * left pointing at freed memory (use-after-free).
+	 */
+	if (atomic_read(&qp->mw_bind_num)) {
+		rxe_dbg_qp(qp, "Attempt to destroy while type 2 MWs are bound\n");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0f5ffd94..80df376e 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -261,6 +261,7 @@ struct rxe_qp {
 	struct rxe_av		alt_av;
 
 	atomic_t		mcg_num;
+	atomic_t		mw_bind_num;
 
 	struct sk_buff_head	req_pkts;
 	struct sk_buff_head	resp_pkts;
--
2.43.0
