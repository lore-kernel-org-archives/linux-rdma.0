Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1014B2F3C0E;
	Sun, 14 Jun 2026 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781425411; cv=none; b=bYEbm48pBKWSZBkqNww5f7qfIn0Mr1OCTnHHg8H+Z83pLq1Etg2oN0zFZi+b/azxBNuMgW/FU+4YvoJbZmb9HCT9zzQkgDs5qmc9xt7dYjkgFsuRM7BEMUG3kopG6bLCTPSUmAnkZKnUe8R+d0mFUZSpiWQfTuetfYs0fb3obN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781425411; c=relaxed/simple;
	bh=ymNAAb8fzK+dW/h8VM7c41dvOOZKJqXiAFCQzJ22aas=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MecC3bd3m5P7hVTAk2K2KE8XWVCfjq3c+Z5DyWhKXEEJlq92RUQRCUi78mWvisO7ir/TJ1i5RRuhnN2zJ0zQFXQb2lzssKPfbgL8/X2srVOU8YleJG/l2ZRy+7IHpTl9xLqswu0mh5XO/zlX0B0bnwg0CB1esNZJ2rKuy9viEtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0QJXngM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0QJXngM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A86A5C2BCB0;
	Sun, 14 Jun 2026 08:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781425410;
	bh=ymNAAb8fzK+dW/h8VM7c41dvOOZKJqXiAFCQzJ22aas=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=P0QJXngMYQ4QC318FsT08z3Lvg1prBaG+QbjIxmE3Opn3F+AmYCLRXh87MBemS51a
	 gfG0amxTtnL/UyEwHmQinWnLzPHeyUAr4PKpVokGiyorFjCwqUcDFFbStnyTTEuttf
	 ZTmXGO1h7JREt7ikogHX+qESTPnn5vlB94I5BXIZlwNlfeHrSDpu1Fh2DhZa1a+KL4
	 3ipZVopZnRrdAjNtvBhJK1rOfZbK+zImDv32PwgvPmZCL2lUzqK6cCOfBp5270ivxC
	 s2uuBX+EV0ctpVZbvlXcAARsrWxPjx+CWRAT7gymdVXBFt0QNtsXyB1FMqbfVdE5iW
	 8HlEW0RaOPLlQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1A1CD98C7;
	Sun, 14 Jun 2026 08:23:30 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH v3 0/3] net/smc: bound wire-controlled CDC cursors against
 the local buffers
Date: Sun, 14 Jun 2026 03:23:29 -0500
Message-Id: <20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAFlLmoC/x3MMQqAMAxA0atIZgNVQ6VeRRxsk2oWLS2IIN7d4
 viG/x8oklUKTM0DWS4teh4VQ9tA2NdjE1Suht701tiO0BOyloTCbMmLQ28chWjHyMJQs5Ql6v0
 v5+V9P7Q4T6BiAAAA
To: Wenjia Zhang <wenjia@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Eric Dumazet <edumazet@google.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, 
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-s390@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Jakub Kicinski <kuba@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781425409; l=4054;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=ymNAAb8fzK+dW/h8VM7c41dvOOZKJqXiAFCQzJ22aas=;
 b=Sq1Lt5oYCPGfJBXndHAyJ84bHQFVqUmZc4kNdNiv2j7PBvgSdnK6+FMQVRwNzDEwCHhhzBVWZ
 lZL+LURD10YBte0BxPEjfo70u5mBR+hMrbuFSownL/tflclglcFeOqA
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

A peer's CDC producer/consumer cursors are copied from the wire and used,
without an upper bound against the local buffers, as (a) a raw index into the
RMB on the urgent path, (b) the receive length in smc_rx_recvmsg(), and (c) the
send length in smc_tx_sendmsg() on the SMC-D DMB-merge path.  A malicious or
buggy peer can forge a cursor so each of these runs past the relevant buffer:
an out-of-bounds read of adjacent kernel memory (disclosed to the peer) on the
receive/urgent side, and an out-of-bounds write of attacker-influenced length
and content on the send side.

This series bounds each wire-controlled value at its point of use against the
local buffer, enforcing invariants the code already documents
("0 <= bytes_to_rcv <= rmb_desc->len", "0 <= sndbuf_space <= sndbuf_desc->len").
Conforming peers always keep these values in range, so the bounds are no-ops in
normal operation.

  1/3 bounds the producer cursor count to rmb_desc->len at the SMC-R/SMC-D
      conversion boundary (the urgent-path raw index).  The bound is applied to
      the producer cursor only -- the consumer cursor indexes the peer's RMB and
      is bounded by peer_rmbe_size, so clamping it to our rmb_desc->len would
      under-credit peer_rmbe_space and stall transmit to a peer with a larger
      RMB.
  2/3 bounds the readable count in smc_rx_recvmsg() so the wrap-around copy
      cannot read past the RMB.
  3/3 bounds the write space in smc_tx_sendmsg() so the wrap-around copy cannot
      write past the send buffer.

This supersedes two separately-posted patches and folds them into one series
together with the producer-cursor fix, after review feedback that they share a
root cause:
  - net/smc: bound peer producer cursor and bytes_to_rcv on SMC-D CDC receive
    https://lore.kernel.org/netdev/20260610084803.186516-1-hexlabsecurity@proton.me/
  - net/smc: bound sndbuf_space on the SMC-D DMB-merge receive path
    https://lore.kernel.org/netdev/20260610090928.192177-1-hexlabsecurity@proton.me/

Changes since those postings (addressing the review):
  - The receive/send bounds were previously applied in the CDC receive tasklet,
    after the atomic_add().  As the review noted, that read-then-set is not
    atomic, and a recvmsg()/sendmsg() on another CPU can observe the inflated
    value in the window between the atomic_add() and the clamp: recvmsg() runs
    under lock_sock(), which leaves the slock free, so it is not serialized
    against the bh_lock_sock() CDC tasklet.  The bound now lives at the consumer,
    where the value is used to size the copy, which is race-free.
  - The bounds now also reject a negative value (if (x < 0 || x > len)): across
    many forged CDC messages the signed accumulator can wrap negative, which a
    plain "> len" check misses and min_t(size_t, ...) then turns into a huge
    length.
  - The SMC-R producer-cursor bound is applied only to the producer cursor at
    the call site, not in the shared smc_cdc_cursor_to_host() helper, so the
    consumer cursor (bounded by peer_rmbe_size) is no longer truncated.

Verified with an in-kernel KASAN A/B matrix on x86-64 (SMC-D loopback,
CONFIG_SMC_LO; no special hardware): each sink produces a slab-out-of-bounds
read/write for a forged cursor and is clean with the patch, and both the
cross-CPU race and the negative-accumulator case are reproduced and closed.
Logs available on request.

---
Bryam Vargas (3):
      net/smc: bound the wire-controlled producer cursor to the RMB
      net/smc: bound the receive length to the RMB in smc_rx_recvmsg()
      net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

 net/smc/smc_cdc.h | 27 ++++++++++++++++++++++++---
 net/smc/smc_rx.c  | 12 ++++++++++++
 net/smc/smc_tx.c  | 13 +++++++++++++
 3 files changed, 49 insertions(+), 3 deletions(-)
---
base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
change-id: 20260614-b4-disp-edd64be9-b094cf67fded

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


