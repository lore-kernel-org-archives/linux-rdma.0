Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB3D331ED7
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791128018; cv=none; b=ikaUruE2J7QgLw8zxiFa7J3Fs1k5nE4HYLDUGXRm7whYMiINufPB4EY6Jxal+2upb1Yc5sy6XhUC6Zxx7NRkhuojSQOChZrwZ+k66VXIdoWfx6mf9A3DPBtD5hMBPQBHejMbz2bOnso/ZOYEXZMg9TZt7OyQVladr+xY2Il1GsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791128018; c=relaxed/simple;
	bh=+aWDV+3i8d84MGSwCXMxxYkiI3P/D1+5+nRd6YrFCbA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=to27ysrDqd9NxcDObdiVWgbUX3PQOcz/bPy6Rdfk4y27kIKlxWiZfa3f+THvuEA/S7YH3p9V5N7YQ29Y1oiC7On9oHkt3D+IK9YsCJynB8ClLx5uPxEJs7QF7eOKWvx3sVrCVntetbFX4+fplpspMhhDa+duGB2UCBbNu82XUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zy1rqnB5; arc=none smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zy1rqnB5"
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-881a3a28e72so191230b3a.2
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791128016; x=1791732816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RawzNlFLUeN3ZVSblJSFdNt+fFTr55IA65m1ZA+aKCc=;
        b=Zy1rqnB5Dv4xfFErLUUEOiV0IVWZyhjW3Z/Pi2OFWt+mf48MW8BErkWv2OSurpg4Ms
         x7fqorDK0BpMlv206qpVEoXaG5vs0LeOfZXbwf8eX+laycXeNcvEwIHq2jAbcmshYVbr
         h7y1jsMEAXAguwujZ2EXKRQAad7YWWE+i1/NcJTUNhqM3GZFAYoxdiKkRQaB2/bCv6ML
         spi1ilMwP6v5Pg4Tgn5cMitd5QhfXAz6PfF88eBHUuLp/qfOVXZl2vY7hpg7rTdsRGYe
         6Uvx0AFVclf2xtnpGAr5rrChNjQ8sjIjaqfn/NXeVbA/sQoOFUFuUQS/T2IbzCEWu6/7
         JTuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791128016; x=1791732816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RawzNlFLUeN3ZVSblJSFdNt+fFTr55IA65m1ZA+aKCc=;
        b=oiXeR9BkqNvKcg9uSOUsnpQrgRENvbrUBb5qn5JiF+mqCfp4a6CKdE50xB57sVSP/P
         RFQxfu1DsQhU/t4kDsbsv7QKEE/2uVoJx99PxdOma74/zvW6vGQAbXKvAqv3X/GG+0Ko
         T+HR0o0wzWk6NPXbpq50InxMrlHS7jYLDSpOPObHP45/l+FXKC85SOZoXy7A90vBoMix
         kVAs1uSqO7o2YSBYGy3KIoVGdPFYXIMdbnT8PUibuGmeMEWiL2qR0kVPht0IfFML+vQC
         CX3QHL9GAiNjbX5Q1Cbhdji2/SwL2rdT9XsOPmh6FxmqgiWuCZlE+xERDmjCcmiADdRD
         et8g==
X-Gm-Message-State: AFuF++lIPv6DLEaxcQjvicoCBUe66cpV8af7XVt8WTxkJytuLUNqE95I
	gwuQ+sYh9JtnuemLSqhHNbKbfx7ufllQIyano3E56lo1uPSfROHvkjA3SnL/rQ==
X-Gm-Gg: AYBFou22dygJ6aMg2NV3uRPaI4e/wYHTVEklZpMNQ0aj1nqZhO7znjXnsk6CJWAbksl
	zwgXLor31X1Pds8Z4g5MyIiuR7IlSlgQX42Ki3M0ykh8eNF1kgFrdh5rmP7TPSsWx0+TwOb3ivb
	hEnIhHF26DNrg/IL14VemIQ/6GJ+Nxhj3ZOGecJQWbUVavZssROwIkONpXq/msyXwIi/QSpQpWm
	udC0vb/Bog5Bp6ODFqsv+rqvQijq0GbnqB8TVEBrNY5aycgpVEEfI9v9RVEDY/ZK5ihzYDrWCov
	nRYCaLnd6mNQSoDlViQK/T50QWBZjvFU/ZCgLRfgdmJ56XzZWVx1S9M1dPGJ/JTUGEHHasqrWpt
	/Qh+BfVLT/BOE35SxN0f9BIHG1cenSaFw5uV5ka+iLlHkJiPvqhvvMbs8nbjsD3vRmHPBhi4PTQ
	mGeCSHifs7tTDvGpFN12IktLWVE+zrzyz/cFH+sZdLBLRAovwAGUoLrHYpABQ7onZLTpYS2Dtt4
	Un/AMbqWaUE9RBy/vHy
X-Received: by 2002:a05:6a00:451b:b0:86a:c062:8af2 with SMTP id d2e1a72fcca58-88af249500emr7439424b3a.3.1791128016100;
        Sun, 04 Oct 2026 08:33:36 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0d04ed92sm2582414b3a.51.2026.10.04.08.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 08:33:34 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
Subject: [PATCH v3] RDMA/rxe: validate cur_sge on the receive path before indexing dma->sge[]
Date: Mon,  5 Oct 2026 00:33:25 +0900
Message-ID: <20261004153325.2952372-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A user QP's receive queue is an mmap'd ring. The user provider writes
the WQEs into it and post_recv never touches them, so every field of
struct rxe_recv_wqe comes from user space. When the responder picks up a
WQE it only checks dma.num_sge (in rxe_get_recv_wqe() and
get_srq_wqe()). dma.cur_sge, dma.sge_offset and dma.resid are copied
into qp->resp.srq_wqe without any check.

copy_data() then uses cur_sge as an index right away:

	struct rxe_sge *sge = &dma->sge[dma->cur_sge];

It dereferences that pointer (sge->length) before the in-loop
"dma->cur_sge >= dma->num_sge" test, which only runs after the first
sge++. cur_sge is a u32, so the pointer can land far outside
dma->sge[], which has RXE_MAX_SGE entries and sits inside the
kmalloc-2k struct rxe_qp. That gives an information leak, because the
out-of-bounds sge->length can be recovered from the work-completion
status, and it also gives a DoS. The send queue already got a
num_sge/cur_sge check in commit 126c757e4cd4 ("RDMA/rxe: Validate
num_sge/cur_sge before indexing wqe->dma.sge[]"). The receive path did
not.

Reject an out-of-range cur_sge before the first dereference. Read the
field once with READ_ONCE() into a local, then check and index that
same local. This matters because copy_data() also runs on the send path
(finish_packet() -> copy_data(&wqe->dma, ...)), and there dma points
straight at the mmap'd ring instead of the kernel copy the responder
makes. So the value that is checked must be the value that is used. The
kernel ULP path always sets cur_sge = 0, so it is not affected.

This is not a complete bound for the send path, and I would rather say
so than imply otherwise. num_sge is read from the ring as well, and the
retransmit path reaches dma->sge[] through advance_dma_data(), which
still has the same unchecked index. I will send those separately.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Assisted-by: LLM
---
v3: read dma->cur_sge once with READ_ONCE() into a local, then check and
index that same local, so the value that is checked is the value that is
used. Automated review pointed out that v2 read the field twice. I am
also sending this as a standalone mail and I dropped the Cc: stable
trailer.

As the commit message says, this is not a complete bound for the send
path. num_sge also comes from the ring, so a concurrent write can still
widen the window, and the retransmit path reaches dma->sge[] through
advance_dma_data() instead of copy_data(). A complete fix would pass the
queue's max_sge into copy_data(), instead of comparing two fields that
both come from the ring. I did not want to change the function signature
in a fix patch without asking first. Please tell me if you prefer that.

Test results. The kernel is an unpatched KASAN x86-64 build of 7.3-rc4
(93f51579e7df). The reproducer runs as a normal user (uid 1000), against
an rxe link on lo. It writes a recv WQE straight into the mmap'd RQ ring
with dma.cur_sge = 0x30, then posts a 64-byte SEND to the same QP:

  BUG: KASAN: slab-out-of-bounds in copy_data+0xa5/0x2d0
  Read of size 4 at addr ffff88810164c858 by task kworker/u8:1/32
  CPU: 1 UID: 0 PID: 32 Comm: kworker/u8:1 Not tainted 7.3.0-rc4 #3
  Workqueue: rxe_wq do_work
  Call Trace:
   kasan_report+0xce/0x100
   copy_data+0xa5/0x2d0
   rxe_receiver+0x20a6/0x3cb0
   do_work+0xb6/0x250
   process_one_work+0x3d1/0x790
   worker_thread+0x296/0x500
   kthread+0x194/0x1e0
   ret_from_fork+0x2ac/0x3c0
  The buggy address belongs to the object at ffff88810164c000
   which belongs to the cache kmalloc-2k of size 2048
  The buggy address is located 96 bytes to the right of
   allocated 2040-byte region [ffff88810164c000, ffff88810164c7f8)

The 2040-byte kmalloc-2k region is the struct rxe_qp from the commit
message. A second report follows at copy_data+0xda, which is the
sge->length read inside the loop. The report names the rxe_wq kworker
because that is where the responder consumes the WQE.

With a larger cur_sge (0x40000) the same read lands outside any live
object, and KASAN reports use-after-free instead. So the index is not
just off by a few entries:

  BUG: KASAN: use-after-free in copy_data+0xa5/0x2d0

The code is unchanged in mainline 551c722f4080 (2026-09-29). This patch
itself is only compile-tested (KASAN + CONFIG_RDMA_RXE). I have not run
the reproducer again on a patched kernel.

The reproducer is a small C program. It uses the legacy uverbs write ABI,
so it does not need libibverbs. The fix is not merged yet, so I am not
posting it on the list. I can send it to you off-list, as I did for the
wr_opcode patch.

 drivers/infiniband/sw/rxe/rxe_mr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..6c7d6919e5d5 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -422,7 +422,8 @@ int copy_data(
 	enum rxe_mr_copy_dir	dir)
 {
 	int			bytes;
-	struct rxe_sge		*sge	= &dma->sge[dma->cur_sge];
+	struct rxe_sge		*sge;
+	u32			cur_sge	= READ_ONCE(dma->cur_sge);
 	int			offset	= dma->sge_offset;
 	int			resid	= dma->resid;
 	struct rxe_mr		*mr	= NULL;
@@ -437,6 +438,16 @@ int copy_data(
 		goto err2;
 	}
 
+	/*
+	 * dma may live in a user-mapped queue, so read cur_sge once and
+	 * validate the value that is actually used to index sge[].
+	 */
+	if (unlikely(cur_sge >= dma->num_sge)) {
+		err = -EINVAL;
+		goto err2;
+	}
+	sge = &dma->sge[cur_sge];
+
 	if (sge->length && (offset < sge->length)) {
 		mr = lookup_mr(pd, access, sge->lkey, RXE_LOOKUP_LOCAL);
 		if (!mr) {
-- 
2.43.0

