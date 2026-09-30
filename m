Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D53850AC0D
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 15:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781376; cv=pass; b=gQx+qNOsgZdFARrqJ87FcYXhQ/WECo2XtQUAy0vMwSXUYD1/8tFmAY4wIXgOrc+4mYw4XRsifuvqWp6n3dnbX4j/ylDbKFTql69OQrkp1XYXLlpuI7W3FcJ5ViiY71IZkEtv3CAplwLG155QQrmiF/GDPiLMfkJenAYvvtAjbpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781376; c=relaxed/simple;
	bh=akUCFzeK7fJ8oay68pF5xtIK/gE5KsImywlIWQSsxEQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qBmgtd3nRDncDkuCV7TqYmYH7O2OxisdfcquR0jCuOJkfng0Uon1cIEKXQ+C99Ozi+E02rO5e7CfT5UiRsdixLG4o3HuefbMFnEnla/PIF99cI6kQmAKbkYu8lfDvhWnbtCpCT37+X9CaGdSJOoZO0ugIRKEbCVqcOMbxcveT9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SlJFWzgy; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SlJFWzgy"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba41be3417so422616e87.1
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 08:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790781364; cv=none;
        d=google.com; s=arc-20260327;
        b=kAmvWXna/W11ZaiOo3zByWg3eSY4qDxi+AAm1SUTkDuwSr9JuUy0Iel2xc9C5WqgyJ
         HylN7bqdDWzyyZit/McVnMiKM320e9gR82wzxVQaJdSOf+MHK0CznxxkV/o/xhbL734/
         Sj6+T8ZxAVH7Ndol7Q6EzBgUPlL3AkIosU4usEemSuh0Q0eSh1bziM/VvP0w0pKG2rX7
         GlsIkmqZQi2Xw6lpZPTNwMopKjA2bSsinhu++5caEEy79XYjgLn6R+qHjF3++iw6HfAU
         BPYfqLfRbC/RnfwBeGwsZMq8+cFZAbrn0tHsyZOFKANr6Fng2OTSxe+4XdfCyoilY3bj
         +HfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xGm5rF67BTFBRKi7ftssWgIBGtofr8Xj6UJZATJE+k8=;
        fh=jOQ2dI0DLE+gA+fZGEGejm8TuKLDaC8w0DggHq4U5ds=;
        b=XE2qb68zbAeSHlN+04ksDGz6r0GRdRX7uHudPQtyxP/+s79lihGi+aG9d+C0Tbkwue
         zVTqLBALbNSi/q15Zwa5KMXOKUhRssAr33nbgeh0BhOixHu8bfiekeDCJkaJEcioF4St
         WBrY0sp35BRoAG6p8VsvfKjUbswzGvTkLaTxVdfVHWJEavORQ33mNNQgUpCD2fVI7V1v
         g0LBMERrazWa7LuhR1QdNBZGuxo0e/q9ApOKwseTqfKNYwN98XaKJsAymXfqTXEFWj8O
         R0Kdnwqyb7S3c6Hg6S3lUIDpNa5gFvBZmSOBxyVoBNB8Zi9kf725ov38CVgR7W1rccE1
         D8lA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790781364; x=1791386164; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xGm5rF67BTFBRKi7ftssWgIBGtofr8Xj6UJZATJE+k8=;
        b=SlJFWzgypaFUQ8wkJvlaGlJv6AMuqzei7J+K319uEjnrl8fsa04slmpy72p6ewyZT/
         4YC9HUeMaEp/z22YF7VjtmTKuknSV8X3TBPAs1OeXSxu6rKeebgKWQz086tNeJXXnZWH
         lOq+vuQGozl/sxqsm2P64rv6mD4srq2sKaoK9YZ51Mc0EobyPSqGW/BxtdCLhyiGxaKx
         04rqwJMOgVzggi+qYYPBEOBOjxRUlrhWzjtd2lvGIBL/FrQZrE+dIWqfhhOskpu+8F6K
         ql0drPzGMNuNnDYIvHzK7qe6vIjdV83wgHP4E631FEqlPdreU2AyXp3ZJpAq8jPXUtjo
         CF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790781364; x=1791386164;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xGm5rF67BTFBRKi7ftssWgIBGtofr8Xj6UJZATJE+k8=;
        b=a2OqPgP1tKkphgVGPjgSkBtCcWcUYmh8KrNIRhKvcnKa1ol8j4QvbBTg/wYkSkAfET
         X3JwKyP7jtw3vwskJIebs3UuUk39rszLypSWQuka1ohrjhLxVySt+rBaAAq4jDpgG0CX
         z4KB4rOyTnUSqfzZ/xCFnN+R9DA+ec68zc35LsxAxo7K183vgddwvBFw2Weo21FJdGKj
         TPxvk4nWIpmqopCK+GeE/kUG2wNJ75OLnuvvzikEjPL5Wj+5wQ5Sqbkv94kqWStZBmtY
         YyqAH0p85vwIjMEzqZK9ZyV+tC9M1glnzgltAfg95cqKicbAzgSN+eYENxWyw9ZB5jPF
         9iTQ==
X-Gm-Message-State: AFq9FYIMDNiTxTbpL3+aDDv3oyrK2TetTJQ5oMwKYD1GmtxX1EXaBJLK
	3hAdTdTxs656uPaCbAcNM/g1UP0eX9U3H2PQaodYVhtVyZvtqQ6t9fwBb+R9YUvb7FtTOK7LM9h
	inBMf5fC8a73pkXRZbW3ZXwlKjPusq9DKxY6Q
X-Gm-Gg: AYBFou1OgenDkOCdqmVGC3uxdj84xpPTid0Riz4wEsYKWRoR74V4o9AlosMgQTETWQg
	oiv/Ce/jiDEDkYIgSy6LrcrgnaJc7pasUueF5Q+KrvTWestfKcs5H27wGFfN9njkKP18l1cC6bu
	FiAUbr9E6iELfv7Ad4PvrrBtD4apxLVhjICIwBhdEvY0Fgn7MFQb+/gDY/Tknucb/wLuV/N62Q1
	lpRJX+NP88slwwf3IOS2yuoVILkeyjcQa//04LUpUb3AHY8Zb7P1Oamz1HZF4QJ7uMtRQ+WAbXN
	oHSXyzkypF+P7GBh67EbgqCl7P+l0gfmFHi41+gQZfweBNeCnQ0x4HD4bA==
X-Received: by 2002:ac2:4839:0:b0:5b8:d9b9:9573 with SMTP id
 2adb3069b0e04-5ba405f57dfmr546925e87.45.1790781363890; Wed, 30 Sep 2026
 08:16:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: AYS <ays511.kr@gmail.com>
Date: Thu, 1 Oct 2026 00:15:52 +0900
X-Gm-Features: AclHuK_yIWDoY6QMkoa3pUedShiDe5EJn8q3RrMzQZXDOacnCDz2z-cUPD39Z94
Message-ID: <CAPAqSgbjxGEJ5PketUCyUNu8Zcs5yrbSjSD7NVgPpJ3GGQWRsA@mail.gmail.com>
Subject: [PATCH] RDMA/rxe: validate cur_sge on the receive path before
 indexing dma->sge[]
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"

A user QP's receive queue is an mmap'd ring: the user provider writes the
WQEs and post_recv does not touch them, so every field of struct
rxe_recv_wqe is attacker controlled. When the responder takes a WQE it
validates only dma.num_sge (rxe_get_recv_wqe()/get_srq_wqe()); dma.cur_sge,
dma.sge_offset and dma.resid are copied into qp->resp.srq_wqe unchecked.

copy_data() then uses cur_sge as an index immediately --
struct rxe_sge *sge = &dma->sge[dma->cur_sge];
-- and dereferences it (sge->length) before the in-loop
"dma->cur_sge >= dma->num_sge" test, which only runs after the first sge++.
cur_sge is a u32, so this reads far out of bounds of the RXE_MAX_SGE-entry
dma->sge[] embedded in the kmalloc-2k struct rxe_qp: an information leak (the
out-of-bounds sge->length is recoverable through the work-completion status)
and a DoS. The send queue already got this check in commit 126c757e4cd4; the
receive path did not.

Reject an out-of-range cur_sge in copy_data() before the first sge
dereference. This also covers the send retry path and is harmless to the
kernel ULP path, which always sets cur_sge = 0.

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

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c
b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..b9aff32fffad 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -437,6 +437,11 @@ int copy_data(
  goto err2;
  }

+ if (unlikely(dma->cur_sge >= dma->num_sge)) {
+ err = -EINVAL;
+ goto err2;
+ }
+
  if (sge->length && (offset < sge->length)) {
  mr = lookup_mr(pd, access, sge->lkey, RXE_LOOKUP_LOCAL);
  if (!mr) {
--
2.43.0
