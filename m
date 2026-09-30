Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC74509F06
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791306; cv=none; b=hRZ0mcltM1+0HBKTTGpS5W6suJy+k9hy03OP7GdL4eOquhUfHR7v1LWHfsrc2gaw1uhxa2PP8U8fZBmXxQmOUvx+0Zr0m6675qy9Jxtxq6kxkdTl8+lT9nC2Swoyy9L/9GOeM6o0Rv7aqJKwzn0LlAAP0O6MLvJvKaIFizAcFjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791306; c=relaxed/simple;
	bh=C5hXqTxIv9SK8JGBiStM6GmrbVwOZhkqRFUv5QslzL8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KtiKOZbQQUb66P9q9urTNPrYTdwNlrDkTLOkrUae7OGuwfdHk9+RDjcP16rFm3PmAqUwLRtk+uSR/sUEXQ2cpzGgb1uuDc7AKE+WI+g/XCe5kmD4/gQS66Y4A1AHi//NAv5a2SDI1wS1vQFfVhS80yj1gknGy9ZE2oipFeQYQJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrCXUBna; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BrCXUBna"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0d2c37b0bso2256360a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790791304; x=1791396104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=krpNbmurRY3a2L4t3fOgccR8SuP9hcZirWdc5FPfbqc=;
        b=BrCXUBnaneQneDYZ/X8NIGWZowKPMJ4MxqGFSbV/gQrWpyTtOZsFSZuCC+5hDTunMG
         l++Cxn4lwJcU0sY3Jt0KXuiTrsHDkWc910t01FvzqVazVnrgUCC2BQUo5Ha1QzyXatTV
         RAlttryip4+rZdBi4oCUp2pwy1rPqjvYYuVo1+Eukm7XmYnajQwlEtEI6Qh1vlGf/cDz
         19uuXJC+BScooOVy9o8hDFqxjjA6CRI8T2hE47/7pjmmvVRLq8JH/0eGn9soNSS9BjVA
         sW05c+TiYMnz3kS/Vfno3w2fYpoM8IsZnbkWtMbdNZQXRA5YND0TGkJ4BBFP3HjyqvZK
         o7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790791304; x=1791396104;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=krpNbmurRY3a2L4t3fOgccR8SuP9hcZirWdc5FPfbqc=;
        b=RVtLmn2D8X/8ZuDpywEyN+pyQfJlV7QmaZlRFezFb0egrrZUYL0J/lxRFbjqGQ2aYm
         sETLAL92YpRDckWeZbRv/KTQguJN4kJ2GUIPvkU0yejFGURt1fbK37Q4P0klx3ZyqW11
         iOl9Wq7QNfHB2zLPmGwRH79la19Rfobr8tVnnGewHxj4NH41UzWsMujRPgnXVjLCY6h/
         5qyQWsloAXrJV3bBHLJQtz1ZYrDs4bEfW4lOF4nfiV+cpadEJrfeuSZKyUHBuOR4j9bz
         GAqRxegP76jKLRnBJzPMUWgcNhEnhic+iXxKjX7+ok8Ey1jlK0AwhfCEAQwFCujmgnFT
         5Asg==
X-Gm-Message-State: AFq9FYKzm9fBnpt0Oti7lEwwQ5lXAqtHISf58t305YzDKEst3ET3hQO1
	wqi8o+pVe1rFlmnntetdslqN6ZXiADWF0CVJ2FR8WBN6aCoVwg5i8CQPkTIHmQ==
X-Gm-Gg: AYBFou0/c9lidX1Eoxp4eOat/tmY/hJc0/l17J8FCIRKfpEcO6kxqAt4w1kHZjCwzrC
	2iqdVlBy1UWwgWuw4sBSeMQxaI6K97ZiyPpqzMLL+ZFXzfUnlFWTiGEkzdigEAZGNbFwkNWxsec
	SUMw2kyMJznSOS3Dx7szdBX5/kmozxvJSlGewd6Rcz10ZqXWGISRr/iJyADCAWy/pOUHT7Z1a6e
	i3l6bNCTzWhrXDFyiHDNFuSZQHS/jkXcU5aGhdpczLHmGJSyHsuqmVeAdGhNVJxjFqp8i8Ue1Jc
	nufoo9r2+E839mP6+BIk61WMNbONMVB75FDQT+fGzBFgabnmtIY5iefBYpPqj93n4j6HJVpVo11
	p+TaNkFkKf4WmrpCi1UKuLMz/uTJh/DxBxmrwhsMF3aXs/yyvXAyb56jFV4LWxqTm/ZOcVkuZ5B
	3+0HyhqEqCtoEKHZBRSTo1QVaAY3K4fWguAB5SgwcXlFKnqGCVAMa9ULC8p4Z6gFy6bh+FhrvB3
	0DbRc3qwQ==
X-Received: by 2002:a17:90b:584d:b0:3a0:ace4:d2a9 with SMTP id 98e67ed59e1d1-3a4f7309dbcmr12886a91.64.1790791304007;
        Wed, 30 Sep 2026 11:01:44 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f43a12c9sm501893a91.2.2026.09.30.11.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 11:01:43 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: [PATCH] RDMA/rxe: validate cur_sge on the receive path before indexing dma->sge[]
Date: Thu,  1 Oct 2026 03:01:19 +0900
Message-ID: <20260930180119.2497360-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user QP's receive queue is an mmap'd ring: the user provider
writes the WQEs and post_recv does not touch them, so every field of
struct rxe_recv_wqe is attacker controlled. When the responder takes
a WQE it validates only dma.num_sge (rxe_get_recv_wqe() /
get_srq_wqe()); dma.cur_sge, dma.sge_offset and dma.resid are copied
into qp->resp.srq_wqe unchecked.

copy_data() then uses cur_sge as an index immediately --
	struct rxe_sge *sge = &dma->sge[dma->cur_sge];
-- and dereferences it (sge->length) before the in-loop
"dma->cur_sge >= dma->num_sge" test, which only runs after the first
sge++. cur_sge is a u32, so this reads far out of bounds of the
RXE_MAX_SGE-entry dma->sge[] embedded in the kmalloc-2k struct
rxe_qp: an information leak (the out-of-bounds sge->length is
recoverable through the work-completion status) and a DoS. The send
queue already got this check in
commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]");
the receive path did not.

Reject an out-of-range cur_sge in copy_data() before the first sge
dereference. This also covers the send retry path and is harmless to
the kernel ULP path, which always sets cur_sge = 0.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000 (uverbs0 is 0666
after a one-time "rdma link add"), cross-checked via the CQE-status bit
oracle. Present unchanged in mainline 551c722f4080 (2026-09-29) and rdma
for-next. Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Found through
manual review; per security-bugs.rst this is public and a reproducer can be
shared on request.

 drivers/infiniband/sw/rxe/rxe_mr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..b9aff32fffad 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -437,6 +437,11 @@ int copy_data(
 		goto err2;
 	}

+	if (unlikely(dma->cur_sge >= dma->num_sge)) {
+		err = -EINVAL;
+		goto err2;
+	}
+
 	if (sge->length && (offset < sge->length)) {
 		mr = lookup_mr(pd, access, sge->lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
--
2.43.0
