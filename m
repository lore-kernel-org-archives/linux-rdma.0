Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795325556;
	b=XRMIl7AILc9zVwaiPLlknoB6oBkYIS/kcUZZ7e+Xgv3UM8HKknSMsFvKSrZ4Az7YLu9t
	 XVYbneJOSS2nd1O378br8PFGiSsVwOAHwx8Qf/AC6EFLgrHevFMlmAyRuFbJRjk906e/B
	 x4VpBCInnEVaVWvd5uk330cQpaOwehEt2lU1SKoPLPri+ZJQXctVTP+xBNqdW7HNu0deR
	 pzOBBArDK8JLTDfXbXe1DS6YVMno8iPfnYx87POY56w3FKo1l0uebwWER62SmppkxDaYc
	 qI6wh92H+j8J9IadRVP4Z28+GrzfaRYYoBHDzTKFXByjKYGv7aFJV47LXTwEbK2y5Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795325556;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=me3WsNLpXOGi8AyO4bI1Q8J5wDfbd+89c9dLbnje7nk=;
	b=qnRtg1XEyWFZ1pe7mLUc9xwzkPvu/2kvkMkgFfobhlPfhDDA8EKD67q/utC5c8BjgmA6
	 81KOYuB/VTxPB0nYHsGt2BwYnmORs1bYKHs/0wSBAqo8sDFLvLu0HmzzqgWvesX0bI7Xv
	 WJzrWhn/4gxvfr7otMCwUCC6ZnV+WZfE+NE18zFLMicZls/j4VDWu0JIdWI+NyP45i+q+
	 GeUAV8YTw4WTem/Vdyk6x1AK2OYvwxPYv1ka7EZl7HIqNMKOCugw03hKyz+rFMEM5ucZN
	 9GTGYSu2ztYb9UmlO0JnOsw1gnCcrI0VScrgIPKkzAIACrtfr9z8bh1XH7PgCtuT+XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b="I0/L9b2N";
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D855606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 05:32:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D855606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=I0/L9b2N
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso849512a12.2
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 21:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795325555; x=1795930355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=me3WsNLpXOGi8AyO4bI1Q8J5wDfbd+89c9dLbnje7nk=;
        b=I0/L9b2NAEt9spob3UTfZkfqR7v0oKiQ3pwcYAoqWy/eyYJhdrShvSaa9i3f7TqQW8
         qVMEC0hzQhmJcnnWDIfjNwe3BuEw43U8pqnvODNXrs89EAZ9UGThfCVncEul77NQcZek
         VaQ0cWDFpdxNKnAWqAU+gtQAsNPvqr+ErR3OU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795325555; x=1795930355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=me3WsNLpXOGi8AyO4bI1Q8J5wDfbd+89c9dLbnje7nk=;
        b=Upqbz8sgvIGEuWrj5WIvMN3vhTKZ9KnK58djcDxGNwysQ0OE9b98SYEyuW2NDEU5cB
         y1US4U3b1/fUzs6wCJtU2XfbGZxmYe0g0PPyAwPCLSXqzvPvZr/QMIzDeo49mOGyulu3
         PCk5pzkAQezy1qzEb+c6FYas8suYBoqGcJey3XIJSOSg1ZCxMq/I5BGGExcj29Ifd2LA
         vTREPP4gRKxfDdL7LzrN0YMGePkNaytiWTKMErEiT8DxeMJmozdqQY0rOcR+Yre24Kxk
         b4QUWPaudtDCJWBXXWYKyE1tdDoUGDfjSZX7OACZF7BozMC8JYPC/xHRIpFjeX3t7GXH
         5Zjw==
X-Forwarded-Encrypted: i=1; AL+hErEMn0G+uucKPZRI+NWm0C0ONr3PJWfVOrjqPq/bI0LjhanHpKLd588yO0wc3ZhbSTBEeF7kQAhHAvY9@vger.kernel.org
X-Gm-Message-State: APuU4Z+18KkJ6Npb6W6VxrmhvTbG4wRaTy0ER+qJaNn/p44H5mAxr8Ig
	q3F5+NqTp2WlVjPrXLpNx1Z2DZeanYiS5Ef45J4lmu9oOsXfT7y6ZICc6ncYVwHUGUx2DtQBGyC
	T7dpcGFA=
X-Gm-Gg: AZFdTZdXAk1I55i90Jwd4yAMJEh/sgC6rvhTnMpqzYZzKOH9eNXGkPDAFix9hIyVWGl
	fPF4ftdM2z6WZnZsUa/jwF+DzHOnhSQTRyGupq9sKR1wrn6LBi3I1hBqxuDbHtAN0XDp8v+JDtT
	65GxUWqu97R6SfCDgNm9OMfaHqGBP8pvhv8In4kbx2d7aR8oaiujPALXXNGZkv8hS7Z0Jkgm6h4
	RgJzJJfQ3MErBGL79kXZapq5y0+seaSAF1LP9bRaE5L7pubymL9KS/Hw1X6aSMoQOOFmuGhpZzC
	TQ9v1bjJ6dOC3nwWDsbP1uKYmaspwfNSQQ6zb1jtTbsjbIm0pNGBghHZfINZ1YxGgzW6O8OJ128
	ktqBfXLTW5vaDYQLo4toFe5Yh1oMuagaCu1vusd6eN940KUAnhk9vZ43+CZBk/NtU4CS5A1Rcfy
	i6Y4Oh3fSv6D/hExZVLDEDhhuCdN+Q467UFJu7wcXzaeMgXlPbY+nrz76Q3QznqPBwxseYpmMyF
	RDs6KgX3tQVSKBWAeGdo2MoNg9OPsi0h3IZV1LcnfZymLI2cP0wuh2c17leihJPjKHOMxt1bEHh
	NdzyjbcdpeYUsqgRoeKL+wKGMUG7MG0m93Yv/QUwvXtFQA5elvf7slpB+tGo/hwvIjqmFojL+Wy
	HarjSWh9nHkanYHw9RpfAEQp4Sx6tOZG6DwPXLRDuRBQhFP0vmLGdagMWE6rXdnXi
X-Received: by 2002:a17:90b:268f:b0:3b3:a421:7e00 with SMTP id 98e67ed59e1d1-3b41c8d4831mr6844074a91.16.1795325555557;
        Sat, 21 Nov 2026 21:32:35 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm14076748a91.4.2026.11.21.21.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 21:32:35 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>,
	Piyus Kedia <piyus@iiitd.ac.in>
Subject: [PATCH net] net/smc: bound a send by the send buffer, not by the peer's credit
Date: Sun, 22 Nov 2026 11:02:23 +0530
Message-Id: <20261122053223.2497832-2-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261122053223.2497832-1-piyus@iiitd.ac.in>
References: <20261122053223.2497832-1-piyus@iiitd.ac.in>
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

smc_tx_sendmsg() decides how much to copy from the sendmsg() iterator with

	writespace = atomic_read(&conn->sndbuf_space);
	copylen = min_t(size_t, send_remaining, writespace);

and then splits the copy into the two chunks of the ring.  The first chunk
is
clamped against the buffer:

	chunk_len = min_t(size_t, copylen, conn->sndbuf_desc->len - tx_cnt_prep);

but the second is not - it is simply the remainder:

	chunk_len = copylen - chunk_len;	/* remainder */
	chunk_off = 0;

and each chunk is written with memcpy_from_msg(sndbuf_base + chunk_off,
msg,
chunk_len).  So the write is bounded only by sndbuf_space.

That counter is not always a value this side computed.  On the SMC-D
DMB-nocopy path smc_cdc_msg_recv_action() credits it from the peer's
consumer cursor:

	diff_tx = smc_curs_diff(conn->sndbuf_desc->len, &conn->tx_curs_fin,
				&conn->local_rx_ctrl.cons);
	smp_mb__before_atomic();
	atomic_add(diff_tx, &conn->sndbuf_space);
	/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */

The comment states the invariant that smc_tx_sendmsg() relies on; the code
does not establish it, because local_rx_ctrl.cons arrives from the peer.  A
peer that reports an oversized consumer cursor therefore inflates
sndbuf_space, and the unclamped second chunk writes sendmsg() data past the
end of the send buffer - which under DMB-nocopy is the DMB the peer
published, so the overflow runs off the end of that mapping.

Clamp copylen to the buffer.  This bounds the write regardless of how the
credit was arrived at, which is the property smc_tx_sendmsg() needs and the
one a reader of the second chunk currently has to take on trust.  A correct
peer never credits more than the buffer holds, so this changes nothing for
one.

Capping the credit itself at the atomic_add() would also enforce the stated
invariant, and we would be glad to send that instead or as well; we chose
the
clamp because it bounds the copy at the point the copy is made.

Reproduced.  A hostile peer needs an ISM device we do not have, so the peer
was stood in for by a debug patch that overrides the consumer cursor after
validation, on an SMC-D connection over the loopback-ISM device.  The
credit then reads

  SMC2DBG diff_tx=1000000 space_before=65504 sndlen=65504 cons=1000000

- sndbuf_space 1065504 on a 65504-byte buffer - and one sendmsg() of 4 MB
turns that into an oversized copy, with the second chunk written at offset
0:

  SMCTXDBG chunk=0 off=0 len=65504  sndlen=65504  in bounds
  SMCTXDBG chunk=1 off=0 len=869056 sndlen=65504  past the end

  BUG: KASAN: use-after-free in _copy_from_iter+0x197/0xfd0
  Write of size 869056 at addr ffff888057980020 by task b/9467
   _copy_from_iter+0x197/0xfd0
   smc_tx_sendmsg+0x1011/0x12c0

With this patch applied and the same injected credit, every chunk stays
within the buffer (len 65504 or less, no second chunk past the end), KASAN
is silent, and an 8 MB transfer over the same connection completes with its
contents verified.  The injected cursor is the only thing the debug patch
changes; the fault and the fix are in the code above.

How this was found: by AI-driven fuzzing built on top of syzkaller, while
it was working on the receive-side cursor bugs fixed by "net/smc: validate
the peer's CDC cursors against our own buffers".  Its analysis was then
checked by hand against the code, and the credit inflation above measured.

Signed-off-by: Kapil Vaswani <kapil@presceralabs.ai>
Signed-off-by: Piyus Kedia <piyus@iiitd.ac.in>
---
 net/smc/smc_tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0f0c6df3b..5dc489bf6 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -235,6 +235,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		writespace = atomic_read(&conn->sndbuf_space);
 		/* not more than what user space asked for */
 		copylen = min_t(size_t, send_remaining, writespace);
+		/* and never more than the send buffer holds.  sndbuf_space is
+		 * credited in smc_cdc_msg_recv_action() from the peer's
+		 * consumer cursor on the SMC-D DMB-nocopy path, so it is not a
+		 * value this side computed, and the second chunk below is not
+		 * clamped against the buffer the way the first one is.
+		 */
+		copylen = min_t(size_t, copylen, conn->sndbuf_desc->len);
 		/* determine start of sndbuf */
 		sndbuf_base = conn->sndbuf_desc->cpu_addr;
 		smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
