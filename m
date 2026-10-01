Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF4D52379B
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868232; cv=none; b=N4bD0IGdkbfuIWF123eInmC8daf+O+Q5F08M+5wtAxdexQXW3VfAvshr14JHFTdpvnzvzvp3HI8AM0BR1vx7TXBjwB5Dd3BVHl8EY/aOqej+WPLNzL3sXHxYLxPclTEtiOBmHhRmGHhVYR1aM710s/DwpH5HSjGKVWtI3NwTcJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868232; c=relaxed/simple;
	bh=xMEwJAJAlv9TTtHLrEel4f5+pmj6Bcx7ffyn43wf64o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBKxDvbFGNglF345tXKzT1VTwlwC7bYPLRSYXFf3xwBW7/NhaZdLF1IvkH6Ff84D8bfjy31Ak2sWOLLKnt4xaeZjw+qUdVpJc66k2Qv8SVdGBxZKizj1r0d4nHSxMNuFqWwofNBS6JxEAC0pqNVQgKmxxAo1Bz5K+uDAxdd6pq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KahSNWov; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KahSNWov"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so3789707b3a.3
        for <linux-rdma@vger.kernel.org>; Thu, 01 Oct 2026 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868229; x=1791473029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P4hKaeG34BRtgkE3jX44GSeOVayCHlDWIPkw8ynbEqo=;
        b=KahSNWovj9d8vhOc3/kk/JjsZpUz6Woy7kq3QI5gKgKujq8mzC/5rc80kAd3QfR0+N
         ppCRWWyZeQd9f8ZIOwsOLmYPs4jnc90M4UxewJAmjvIA4BMiP4AKshu0yfASXVBfxMx3
         iUHGynZIKtZGOaDsMQjND3b9Ro2pcHnC6LTIGQB/EfUhGQREw+0ycL//synezb9oqZO4
         vgMTWVpW55ZECBIrP3rpg4Mf88ETlicTvV4RGfI2rdT4NlmAs8oCVGWm3foJe8XQ/YTc
         SioRc/0uaRWz9W+FcGyEeOq65LL9N1jTwq01/nj5R6SawLIO0Pp38X/vSnELoJN0CfEd
         Wl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868229; x=1791473029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P4hKaeG34BRtgkE3jX44GSeOVayCHlDWIPkw8ynbEqo=;
        b=oUBemw49BXtS3bYEvJGLTJmtp7Yu7695Z53czBUIUTwW1tz1fl250OYQSLdTHsdTCs
         CWRMaICXI23LUrhAh1cYbxhHtj4obr+hH+/55AeFRrXnfIjxuUQyVkyEo2cb3Wh4ZBsU
         Lh7GESoiyDpfjvBGZ9evEliuhGPrMjqD1TeHuT6taUpXn8t2FEgG9pE28i9hFnSi9lCx
         M4l5XwkrT8OnOnTG/7s4G84gisYLYJNxUQYsOGlHKiaj8qr02dXDLMAasQ9hMt4ohC+s
         8jrDk+Ee4ts0BAMJ8Kz2LK1hw1ma0+jgFIC5x7qN9ckUAg3GsKSBhcyudke1egxWw6od
         I7nA==
X-Gm-Message-State: AFuF++nQdRNU4DHFVbarjvGYEZKA37jAOnPKltm0tkjVTbeMRsqKZLFg
	PUBtnOkuqL6u4EKdb9qxKWh99HqGa5hf1s9vP2fulnamO9bUEpLyWUdHvNW6icy4
X-Gm-Gg: AYBFou1a0nbrGfduYTbvzH5Y6qCXfHV9uMCi1t1AcVIdEhylaV9xI+JpfhPIuaYfJWo
	1Ore94aInZ6o7eYYGKiI7pJ3V0C/ydXPZFvamzMYUxVxrlFnTTHfHSoSCFfP56ikSOTiTtfq4Q9
	sYQoV7ggH2/Q+9AzDXfE+WXCQb/mwJ8atnvlz/+FdPgRgWfVLDo75h7aZ/uLgzoIe0upL9brpW2
	dLcVdXDlUD1EFs4BR6y3Vu7WCGZyrMMrE20lnXIjB2wfcNFJXt6K5O0sb2aas3KviaaZM0vI6T+
	TRnv4BeX4ohxv2c/FCpmPBdDfFe1sWyglpXYgzM/cAHMR1m46hb6GNVFsgNw9AJNdU6lARDLPh7
	A/vcwSGr91x76pi87PZjIYnQGp9/y9zEhU0WXf3EK5m7PPYPzhai03kGJ6k1AlfKjJ/I3hsipRl
	zQMs84EKOCOXt55URVs66Egc54etbJVa20i9n57K0uU8R3f/47vpFl0d3Owmjf6mLJttuFqzUrU
	v0UeKlJVg==
X-Received: by 2002:a05:6a00:3498:b0:886:9da0:8a79 with SMTP id d2e1a72fcca58-8874af6f4d5mr3949684b3a.23.1790868229345;
        Thu, 01 Oct 2026 08:23:49 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8881871a46bsm1238234b3a.9.2026.10.01.08.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:23:48 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org,
	Youngsung Ahn <ays511.kr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] RDMA/rxe: validate cur_sge on the receive path before indexing dma->sge[]
Date: Fri,  2 Oct 2026 00:23:45 +0900
Message-ID: <20261001152345.3259024-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930180119.2497360-1-ays511.kr@gmail.com>
References: <20260930180119.2497360-1-ays511.kr@gmail.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Assisted-by: LLM
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000 (uverbs0 is 0666
after a one-time "rdma link add"), cross-checked via the CQE-status bit
oracle. Present unchanged in mainline 551c722f4080 (2026-09-29) and rdma
for-next. Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Per
security-bugs.rst this is public and a reproducer can be shared on request.
The responder works on the kernel-side copy in qp->resp.srq_wqe, so there is
no TOCTOU on cur_sge here.

v2: no code change. Fixed the author/Signed-off-by mismatch (v1 went out via
Gmail with the display name "AYS"), resent as plain text via git send-email,
and added Cc: stable@vger.kernel.org and Assisted-by: LLM per Greg KH's review.

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
