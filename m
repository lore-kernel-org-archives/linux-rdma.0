Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD124F96AF
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790959523; cv=none; b=fbA/C7DdGWNT1Yp8gCYO2JM7eq0GIKmNMA1K1MHb0hDpDoLRbIHEU3fRIGD0UKssY7hbTYeNDfcZnfaFgeIhaFNxM6G8jnOrCzpMP9yON10sRL/C6r3y09yCSGiYyOi6M7+rf3BsOCusIfWJI2+XZ45RJFRuZoNtPH34G/4JGaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790959523; c=relaxed/simple;
	bh=sSCLraC/5cEL/8V2+C2G1M7Jrr562eKLnO0CnRXUHZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msKEMucSwwbPC5p0WxWrchAjx7bmrVMLAZAB3yRuNVmjeiXv8Pk5wYFoQ7Kmj2G8y6QNV5m08M6CadeSyeOFl3dUj6NqoYsIIPCcOk0uJb0TY7gA0xUR/+cAxmXeiThOVwH4KHav5jGB4UTm6OQp1ubWpFwWVO42785gqV3+lEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kQg9S2pf; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQg9S2pf"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2caced6038eso9520005ad.0
        for <linux-rdma@vger.kernel.org>; Fri, 02 Oct 2026 09:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790959521; x=1791564321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HxYjZkbnEmk1VAu/l48bmmQQtbQ7BtbHESlEWJN2v6c=;
        b=kQg9S2pfLvrrFXz1DKen73dTUHNsfRosAj+w1ey8vLFjL6Gu1E5T+m5Te/R3WuLt86
         /ZFj+wllx/SbiGUxWwjhwFGJ/ieKvYw5DQN3U6EADFi2stERRHx9+iwsb9GikCdQaq+R
         vI2NEaQo+auy208+YDtJ3J0619Povy5srPpTctZfSIIT+tCH1DTKkxnlAUTqQZGgdp/E
         qEbzCJP9QiN/JRZbBy4+vv/PHTPrXD9UywDfyw5OkgZdNMyzBZmN+0cvXcaRHgbv0/gq
         d00XGTyiTEfFEjaKW068jQFi5SZ/fr0+kAjBqQE0OmVgfo78DDeZ7OBGQKzXZksWMsNX
         2P4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790959521; x=1791564321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HxYjZkbnEmk1VAu/l48bmmQQtbQ7BtbHESlEWJN2v6c=;
        b=jr+vJa2oSGarhgtCDcJhXYwDuPXKo1C7VaKfBDZzqGBZ1jYGQx87PSzw0GL6GUmbED
         8AsCnE6DxP1TTODRFRbadi6GYrkfYQaovZ0A6DZfGrPgnd61n+jd8cabSFMZq3Rrz6i3
         Msk80Ffe0uhZa3KQowSQHmBGrelcT0vWZFiyZOrHi4UCm+DSK+MbeSVOTsk5CLCbfjtu
         Ug08j1Eh5b8WI9OAZcN2CzBosSzJ35lrndLuWunbVk0ci6nDRMFW3jrG4o+wZM4k6t/z
         +n4AmqlfyyQvahmAqIDB5niAG4s1qrEMwnHHpPsxzHmF7cewfU+YafIi7eTyu+xHMMi7
         3YMw==
X-Gm-Message-State: AFq9FYI+BvloEvLEeac+EO4EDiUE1tgPfWUuHcjt1tAdeNRWJeVwe4lU
	jZ9mUF0UH5a82S4Qcg8DTLU6CuOUqUUsbC8XJwfNE09LnJhb25+seqYUdBrEOg==
X-Gm-Gg: AYBFou1DDmLxc0TLxjIYr4v6DI9+Hlgt4wZDvmBxRnwOG+LeEynZwTmkYbB+cnNVvku
	rRJZGecOx5tGn4LMkexcton8Rg+RMROATzW2xQzN8bEpiL1jRXxIcYzyYwoVTDepfKS4Bz88j7L
	LX4qApMnzn/j5A3dQq9SIbOhuRg1QhYwimgCXUrPMP2uN+0qRWadQar2VAOAIlqkZVBvZ10K+GD
	gr+7PlwKPELbseaqet/g3RRBxQo34nva5ZyrndOjEabM43kXJHTb41MtcaKP1CZqjPKyvQJ8sSm
	h6qF6gt589HR0SbqCEKWXsYFQSu1ZMpJiC45VLRKJun7FwChyW5bkydft5U+YBSeCNxg6ZsU20O
	J8BgtxgnTm1TElpZXZ1olH3XgREYtTnIYyrrs8qhu2qCPHxVkuwz3BUXZL6BGoc5NbBawEl1FGe
	450aKmezOy4NcksHi39ZeyzzxGwFIep0v8PnWda3ppKVgdCHeZ3ItDmnUXO0k1ROWJw44Fen3Cu
	GFU3/Wxtg==
X-Received: by 2002:a17:903:15c7:b0:2df:34c0:7302 with SMTP id d9443c01a7336-2e3002d5e02mr39451965ad.39.1790959520372;
        Fri, 02 Oct 2026 09:45:20 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f67df67sm10466285ad.29.2026.10.02.09.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 09:45:19 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Sat,  3 Oct 2026 01:45:05 +0900
Message-ID: <20261002164505.293920-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <9977c651-2e54-4f94-b971-e9929351a06e@linux.dev>
References: <20261001152407.3259261-1-ays511.kr@gmail.com> <9977c651-2e54-4f94-b971-e9929351a06e@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> However, for req_retry(), it is less clear to me what the subsequent
> control flow is when wr_opcode_mask() returns 0. In particular, I would
> like to understand whether returning 0 for an out-of-range opcode is
> sufficient to safely handle the invalid WQE in this path.

I checked the code again. req_retry() does not reject the WQE. It only
re-posts it. The rejection happens later, on the next requester pass.

Of the three callers, only validate_send_wr() rejects a zero mask.
req_next_wqe() just stores the mask into wqe->mask.

In req_retry(), the mask is used only in "mask & WR_*" tests. So when the
mask is 0, all of them are false (abridged, 7.3-rc4):

	for (wqe_index = cons; wqe_index != prod;
			wqe_index = queue_next_index(q, wqe_index)) {
		wqe = queue_addr_from_index(qp->sq.queue, wqe_index);
		mask = wr_opcode_mask(wqe->wr.opcode, qp);

		if (wqe->state == wqe_state_posted)
			break;
		if (wqe->state == wqe_state_done)
			continue;

		wqe->iova = (mask & WR_ATOMIC_MASK) ?
			     wqe->wr.wr.atomic.remote_addr :
			     (mask & WR_READ_OR_WRITE_MASK) ?
			     wqe->wr.wr.rdma.remote_addr :
			     0;

		if (!first || (mask & WR_READ_MASK) == 0) {
			wqe->dma.resid = wqe->dma.length;
			wqe->dma.cur_sge = 0;
			wqe->dma.sge_offset = 0;
		}

		if (first) {
			first = 0;

			if (mask & WR_WRITE_OR_SEND_MASK) {
				...
				retry_first_write_send(qp, wqe, npsn);
			}

			if (mask & WR_READ_MASK) {
				...
			}
		}

		wqe->state = wqe_state_posted;
	}

So with mask 0 the WQE gets iova = 0, and the DMA cursor is reset to the
start. retry_first_write_send() and the read fix-up are both skipped. The
WQE stays in wqe_state_posted. With the bound in place, no array is
indexed here, so nothing from the ring is dereferenced. But the WQE is
still in the queue. It is not completed yet.

The next requester pass completes it with an error:

 - req_next_wqe() stores the same mask 0 into wqe->mask.
 - wqe->mask & WR_LOCAL_OP_MASK is false, so rxe_do_local_ops() is not
   called.
 - next_opcode() gets the raw wqe->wr.opcode. It matches no case in
   next_opcode_rc(), next_opcode_uc(), or the UD/GSI switch, so it
   returns -EINVAL.
 - rxe_requester() has this:

	opcode = next_opcode(qp, wqe, wqe->wr.opcode);
	if (unlikely(opcode < 0)) {
		wqe->status = IB_WC_LOC_QP_OP_ERR;
		goto err;
	}

   Then err: advances qp->req.wqe_index, sets wqe->state =
   wqe_state_error, and calls rxe_qp_error(). So the QP goes to
   IB_QPS_ERR, and the completer posts the completion. After my test run
   the ring shows state = 4 and status = 2.

So I think returning 0 is enough for this path. The invalid WQE never
reaches the code that uses the mask to choose an operation. It is
completed with a local QP operation error, not retried forever.

There are two exits before next_opcode(), but I do not think they change
this. rxe_wqe_is_fenced() can delay the WQE by one pass. If the QP is
already in IB_QPS_ERR, the WQE is flushed with IB_WC_WR_FLUSH_ERR. Neither
of them reads the array again.

req_retry() still needs the bound. wr_opcode_mask() is called at the top
of the loop body, before the wqe_state_posted and wqe_state_done checks.
So the out-of-bounds read happens even for WQEs that the loop skips.

About IB_WR_REG_MR instead of ARRAY_SIZE(): rxe_opcode.h only has
"extern struct rxe_wr_opcode_info rxe_wr_opcode_info[]", so the size is
not visible where wr_opcode_mask() is. IB_WR_REG_MR (32) is the highest
index that rxe_opcode.c initialises. On x86-64 the object is 1320 bytes
and the stride is 40 bytes, so there are 33 elements, and the valid
indices are 0 to 32.

> You mentioned that you were able to reproduce the issue on your local
> host. Would you be able to share the reproducer with us? It would help
> us better understand the failure path and verify the fix, especially for
> the req_retry() case.

The fix is not merged yet, so I am not posting the reproducer on the list.
I am sending it to you directly in a separate mail. It is a small C
program and it does not need libibverbs:

	gcc -O1 -o rxe_opcode_oob rxe_opcode_oob.c
	rxe_opcode_oob <opcode-as-u32>

It creates a user RC QP, mmaps the SQ, writes one rxe_send_wqe with
wr.opcode = <opcode> into the ring, and rings the legacy POST_SEND
doorbell. It memsets the WQE to 0 first, so wr.reg.mr is NULL and
wr.ex.invalidate_rkey is 0. Please use an opcode whose low byte is not
0x20 (IB_WR_REG_MR). Otherwise the run also reaches the rxe_reg_fast_mr()
problem, which is a different patch.

My results on 7.3-rc4 (93f51579e7df), KASAN x86-64, with the program run
as uid 1000:

 - KASAN global-out-of-bounds in rxe_requester, "Read of size 4" at
   rxe_wr_opcode_info+0x538. The splat shows the rxe_wq kworker, because
   the WQE is consumed there, and wr_opcode_mask() is inlined into
   rxe_requester().
 - For larger opcodes I get an Oops or a GPF instead. RIP is in
   wr_opcode_mask (rxe_loc.h:187) [inline], then req_next_wqe
   (rxe_req.c:196) [inline], then rxe_requester+0x66c or +0x68d.
 - The loaded mask is written back into the ring slot, so the program
   prints the value it read. For opcodes past the redzone (34, 36 and 174
   in my runs) it is a kernel dword. For 33 it reads 0, and the KASAN
   splat is the signal.

One limitation. This reproducer only drives req_next_wqe(). It does not
drive req_retry(). For that path the completer has to ask for a retry
first (rnr_nak_timer(), or the COMPST_RETRY path in rxe_comp.c). So what I
wrote about req_retry() above comes from reading the code, not from a
test. If it is useful, I can extend the reproducer to force the retry
path.

I will resend the patch as a standalone message, not as a reply to this
thread, as you and Leon said.

Youngsung Ahn

---8<--- KASAN evidence (7.3-rc4 93f51579e7df, CONFIG_KASAN=y, uid 1000) ---8<---

$ ./rxe_opcode_oob 33
=== opcode=33 (0x21)  uid=1000 ===
wqe @0x7ff84f128180  wr.opcode=0x21  pre-mask=0xdeadbeef
doorbell rung

[    5.487092] ==================================================================
[    5.487107] BUG: KASAN: global-out-of-bounds in rxe_requester+0x2a5/0x1d00
[    5.487170] Read of size 4 at addr ffffffff845513b8 by task kworker/u8:1/32
[    5.487184] CPU: 1 UID: 0 PID: 32 Comm: kworker/u8:1 Not tainted 7.3.0-rc4 #3
[    5.487201] Workqueue: rxe_wq do_work
[    5.487214] Call Trace:
[    5.487226]  dump_stack_lvl+0x53/0x70
[    5.487271]  print_report+0xd0/0x630
[    5.487387]  kasan_report+0xce/0x100
[    5.487416]  rxe_requester+0x2a5/0x1d00
[    5.487555]  rxe_sender+0xe/0x30
[    5.487565]  do_work+0xb6/0x250
[    5.487576]  process_one_work+0x3d1/0x790
[    5.487649]  worker_thread+0x296/0x500
[    5.487671]  kthread+0x194/0x1e0
[    5.487691]  ret_from_fork+0x2ac/0x3c0
[    5.487751]  ret_from_fork_asm+0x1a/0x30
[    5.487770] The buggy address belongs to the variable:
[    5.487772]  rxe_wr_opcode_info+0x538/0x19e0
[    5.487847] Memory state around the buggy address:
[    5.487851]  ffffffff84551280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    5.487857]  ffffffff84551300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    5.487863] >ffffffff84551380: 00 00 00 00 00 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
[    5.487868]                                         ^
[    5.487872]  ffffffff84551400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    5.487879]  ffffffff84551480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    5.487883] ==================================================================
RESULT opcode=0x21  leaked_mask=0x00000000  state=4 status=2  sq(prod=1 cons=1) cq_prod=2

$ ./rxe_opcode_oob 34       # past the redzone: silent 4-byte leak, no splat
RESULT opcode=0x22  leaked_mask=0x83c15aa0  state=4 status=2  sq(prod=1 cons=1) cq_prod=2

$ ./rxe_opcode_oob 174
RESULT opcode=0xae  leaked_mask=0x8353d9c0  state=4 status=2  sq(prod=1 cons=1) cq_prod=2

rxe_wr_opcode_info is 1320 bytes (33 entries, 40-byte stride), so the valid
indices are 0..32. For opcode 33 the load is at

	base + 33*40 + offsetof(mask) + IB_QPT_RC*4 = base + 0x538

and ffffffff84550e80 + 0x538 = ffffffff845513b8, which is the address in the
splat -- one entry past the end. KASAN only catches the first entry past the
array (the f9 redzone above); opcodes 34 and 174 land in unpoisoned memory, so
they return a kernel dword silently and the mask is written back into the
user-visible ring slot, which is what the program prints.
