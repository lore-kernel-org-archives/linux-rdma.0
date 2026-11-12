Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488379;
	b=gbDl6GyVt0+842Xe7kKgEzFzu86RJar9/1+wBe1UEc/2JDqgPjNvgB45a1FJthkJG6hC
	 VfExgLVKeFGWuTzqHiTV63hWaUJH6PbZ6nbIl0mlEvQ69y1JYxnIolImaJz4ntL/FkUbD
	 1/xazeE2DGfgTWkBuVyGgzp74Ax6XBDrMpA5trKJv2kDpmybzLP82YU0SW9hyiuwauULa
	 v3G8nWnTX514R3ajQppKtkF6MZx6peWcwabkg1H0HImmubgXupfia2nBWT3OJFBJzdCkn
	 ynd1ZvQp765bs8v/FTOdVH3ZLQcb3RvFOupJnABhEZt+EvK0MjU9twJF6KE0WBGQl/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488379;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=tOkzJ7VMBcKazDEOFcyhu0vHJNJyobb4AhUu0aqQ2nQ=;
	b=n4asZmskcA06OtWImgl4L0kKlN9XXiy/S9htVYNwlZPuo869ZOwGH+blB+C2OwVT2gj5
	 LJA6ShJox2mlS5QkL7pkGgpZelnKemNu7a9cjlsybr2+PqYgxdz6TPYPMSuAw/Vv0dhEQ
	 ZPnNALIS7fzz82IgL0cfaGss/EQZBb6dNpzC1UigQ69uzcucpuyycJyf1diCZXVJNO5BR
	 fSo7uT2nBsWB9z/p3iVDf21MQ6zU+rCxhNuARXsRsCCsMryppyDlvtp5Df+hwpFQif9Eh
	 siM1PDgamz+fDTPNpXvwbZlFGgkyQ6EcJYAKTJzsn0BbCgVl/eE4KkGPYfmEggAbMig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RopZJ93S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A46606A8B7;
	Thu, 12 Nov 2026 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RopZJ93S
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488379;
	b=22ynhcovCHP/eeWOpVutLwBq1JW3CSke9miHjUjp5gunOzJjDnDMgWIhC/4U5/DzU0xz
	 jV/HqgQZ+udOpOZXSC5ornNmlzZRiVxuWH1OF9OelM74S6E2vKGpgjUun5Tcx/MyQFmoG
	 k4MnTWd0vKWMQxgDxrh+mNibuYm+ry/RL0HbWuZmJs3B9yWutEr1+HyZDTl9LusC8BDSk
	 /L66GRAVStWp92aIV9TLT2ELcRx5y3U8NxpJDBJDLOLugkfzW+Es4GFtZMCaAjVBo73tv
	 Wo09zyBtNEBiHh1dfh/QzCv9rWxrJb8PtO/hZV3lgi+GQzX4TAlSLkRWQItMF5L31vQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488379;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=tOkzJ7VMBcKazDEOFcyhu0vHJNJyobb4AhUu0aqQ2nQ=;
	b=lVNHoPf1j/qh+izUllAK5Gim71CxGIxdB+ldkAvPm7gzbJFnqxv1+qGZn+MxQ4LFRY0a
	 YB8Miq0y3pZFs+ScNzIOZt4cqSN/pXWp1aAznggxbDOZkYxVdOJ3iYMX3c5VeL2FVfmXe
	 ZaWDglHhTScjYNXAGcaiWOH4uIOra88zamnMwHDvF9+0JxOmebuwH+vqQADYXk7HWjS+K
	 0tGroWeBgGXi8veCPPMttbKh2N+tEY9uvQQfuhzke29GwKo9XqqgkDE1xenBJYkZvxHa/
	 AM+CFOhvZZqo1bL2JPbt52JGIToKAgXgsx6AOzefBbzbJfVzzyAWSr0XdYPDZcHVKxQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 055FA1F00A0C;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488379;
	bh=tOkzJ7VMBcKazDEOFcyhu0vHJNJyobb4AhUu0aqQ2nQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=RopZJ93Stlk5FijBuSpncuGjb54eu45EKb98TW49lY3PRfzkOLLubGBHQ1GJiwrHI
	 nkrcoogGT2pAf8VZIgwq5XesRKuShOQg5oBLV0yBj7QClUwpqK/qS55CgXeUhf/c83
	 Htav8QaEfY5kewsEL9p20tVQ19gue6YN421yfklyebrdZe00SJ5DnMTeEBJvb2mGdi
	 rpNTeiSZgsqlwFj9YFC+K8rprB6Sm8mWROmrtX+qD3AP/BhqceU5pYn9g/7sJJv899
	 mEjFjiYB45aHqrdmYmUarDM2xiBsQl9YZRau0xZCtsswyrxptkXyzFacBn7qFdjH8K
	 OJc63Y/fYXmDg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 691A1494EC;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 07:59:39 -0500
Subject: [PATCH net v9 5/6] net/smc: keep an RDMA write inside the peer's
 RMBE
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261112-b4-disp-0287c16e-v9-5-e5e8fa688177@proton.me>
References: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
In-Reply-To: <20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Ursula Braun <ubraun@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, 
 Simon Horman <horms@kernel.org>, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 Hidayath Khan <hidayath@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=8896;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=AouuOv6hleOcymBLYNFRRGYbka4qvSS1/VHLRubUqs0=;
 b=vC9ofnngrCEtc8IUa4LUNcd/AQ2tprBZLC/l32L3uH9GMekHI/0q/VEYOlvmrKe2mO5OBP+4i
 Ut8g82apEg8AgXtNyOLAc60pDzmyyycQkLrxxbVL2Fu6nJchZ9Nn6zU
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_tx_rdma_writes() takes the length of a write from peer_rmbe_space
and decides from the cursor wraps whether the destination is one chunk
or two. Both follow the peer's consumer cursor, which nothing bounds: a
forged one takes a one-chunk write past the peer's RMBE, and so does a
conforming peer that keeps reading across the end of its RMBE before
the resend after an SMC-R link failover. With one RMBE per RMB, as
Linux allocates them, the peer's HCA refuses the write and the link
goes down.

Write at most one RMBE per call and end the first chunk no later than
the RMBE, whatever the wraps say. A conforming peer outside failover
gets the chunks it got before. A write that was one chunk can now be
two, which needs "net/smc: keep the source of an RDMA write inside the
send buffer"; the first chunk needs prod.count inside the RMBE, which
"net/smc: bound the link failover cursor advance to the send buffer"
keeps at failover.

Fixes: e6727f39004b ("smc: send data (through RDMA)")
Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68%40proton.me?part=4
Cc: stable@vger.kernel.org # see patch description, needs two other patches
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
New in v9, for the first point of Sashiko's review of v8's 4/4 [1]: v8
skipped the failover advance for a consumer count past the peer's RMBE,
but the window for this write was still sized from the same cursor. A
check in smc_write_space() is not enough: smc_cdc_msg_recv_action()
credits peer_rmbe_space from the next cursor, and the differing-wrap
branch here then writes the whole length from prod.count as before. The
review of v7's 4/4 [2] had already pointed out the one-chunk write and
the window larger than the RMBE, both in the unpatched code, hence the
Reported-by and Closes tags.

rxe, two links (v7.4-rc2 plus d7900fa51642, KASAN), send buffer 64K,
peer RMBE 16K, test hooks forging the peer's cursor and making the
timing deterministic. Every connection carries one byte first; the
counts include it. "With the patch" is the whole series.
  - consumer cursor forged one wrap ahead at 3 * RMBE, then send(40000):
    unpatched and v8 post 40000 bytes in one chunk from offset 1, rxe
    refuses the write and the link goes down. With the patch the first
    write is 16383 + 1 bytes, neither chunk ends past the RMBE and both
    links stay up.
  - 40000 bytes sent and read, the consumer count then forged a million
    bytes ahead with the wrap unchanged, then send(30000): unpatched and
    v8 post 9152 + 20848 bytes. The second chunk is longer than the RMBE
    and its source SGE is 20848 bytes from offset 49152 of the
    65536-byte send buffer, 4464 past its end; rxe refuses the write.
    With the patch: 9152 + 7232, every source SGE inside. Same result
    with 4/6 reverted; with this patch's length bound reverted the
    second chunk is still longer than the RMBE and its source stays
    inside (4/6).
  - conforming peer: 12001 bytes sent and confirmed, then 9000 whose
    completions are lost with the failing link, the failover, the resend
    held until the peer has read them, then 2000 more. Unpatched and v8
    post 11000 bytes in one chunk from offset 12001 of the 16384-byte
    RMBE; the surviving link goes down and the peer's read fails. With
    the patch the write is 4383 + 6617 bytes and the peer reads the
    stream intact.
  - conforming peer, send buffer and RMBE 64K: 60000 bytes sent and
    read, then 600 and 6000 that the peer reads only after the switch;
    the completion of the 600 handled between the first two cursor
    copies of the switch, as in the first case under 4/6, which leaves
    tx_curs_sent 600 bytes behind prod; the resend held until the peer
    has read; then send(400). Unpatched and v8 post 7000 bytes in one
    chunk that ends 2064 past the RMBE, rxe refuses the write and the
    connection is lost. With this patch and not 4/6 the write is
    4936 + 2064, inside the RMBE, and the second chunk's source ends
    1464 bytes past the send buffer: the peer reads bytes from outside
    it. With 4/6 the source is inside too, the link stays up and the
    peer gets 600 bytes twice (see 6/6; the run reads 400 of them).
  - the second case of the note under v8's 4/4 (consumer cursor forged
    two wraps ahead at count RMBE + 4096; 40001 bytes sent and read, the
    completions of all but the first held): unpatched moves prod onto
    the forged count and writes nothing more, 3137 bytes stay queued
    (SIOCOUTQ); v8 posts 16384 bytes from offset 1, rxe refuses the
    write and the link goes down; with the patch the write is 16383 + 1
    and the link stays up.
  - 600001 bytes of a conforming stream across a failover, with the
    patch: 39 writes, 18 in two chunks, each chunked as the two removed
    branches would chunk it (compared in the kernel, write by write).

Without the length bound the first two cases fail; with the chunk
decided from the wraps again, the first, third, fourth and fifth do.

The comment on the credit in smc_cdc_msg_recv_action() still claims
0 <= peer_rmbe_space <= peer_rmbe_size: the lines after it exist only
since v6.10, and a hunk there would not apply to 6.6.y and older.

The first chunk needs prod.count inside the RMBE.
smc_tx_advance_cursors() keeps it there and, with 6/6, so does
smc_switch_cursor(); without 6/6 a forged cursor can still leave it
outside at failover, and the write then starts where it started before
this patch (by inspection).

On SMC-D the same lines size the ISM write. On loopback
smcd_tx_rdma_writes() returns before it writes; not tested on ISM
hardware.

[1] https://lore.kernel.org/all/179364387382.3131.13471253186660322977@kernel.org/
[2] https://lore.kernel.org/all/179209532452.434549.6588379141939967966@kernel.org/
---
 net/smc/smc_tx.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index d37c74754461..c90bdc77f82d 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -362,7 +362,7 @@ static inline void smc_tx_advance_cursors(struct smc_connection *conn,
 	smp_mb__before_atomic();
 	/* data in flight reduces usable snd_wnd */
 	atomic_sub(len, &conn->peer_rmbe_space);
-	/* guarantee 0 <= peer_rmbe_space <= peer_rmbe_size */
+	/* can be out of range, see smc_tx_rdma_writes() */
 	smp_mb__after_atomic();
 	smc_curs_add(conn->sndbuf_desc->len, sent, len);
 }
@@ -480,7 +480,7 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 			      struct smc_rdma_wr *wr_rdma_buf)
 {
 	size_t len, src_len, dst_off, dst_len; /* current chunk values */
-	union smc_host_cursor sent, prep, prod, cons;
+	union smc_host_cursor sent, prep, prod;
 	struct smc_cdc_producer_flags *pflags;
 	int to_send, rmbespace;
 	int rc;
@@ -503,31 +503,23 @@ static int smc_tx_rdma_writes(struct smc_connection *conn,
 		return 0;
 	}
 	smc_curs_copy(&prod, &conn->local_tx_ctrl.prod, conn);
-	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
 
 	/* if usable snd_wnd closes ask peer to advertise once it opens again */
 	pflags = &conn->local_tx_ctrl.prod_flags;
 	pflags->write_blocked = (to_send >= rmbespace);
-	/* cf. usable snd_wnd */
-	len = min(to_send, rmbespace);
+	/* cf. usable snd_wnd. The window follows the peer's consumer cursor,
+	 * which comes off the wire: write at most one RMBE per call.
+	 */
+	len = min3(to_send, rmbespace, conn->peer_rmbe_size);
 
 	/* initialize variables for first iteration of subsequent nested loop */
 	dst_off = prod.count;
-	if (prod.wrap == cons.wrap) {
-		/* the filled destination area is unwrapped,
-		 * hence the available free destination space is wrapped
-		 * and we need 2 destination chunks of sum len; start with 1st
-		 * which is limited by what's available in sndbuf
-		 */
-		dst_len = min_t(size_t,
-				conn->peer_rmbe_size - prod.count, len);
-	} else {
-		/* the filled destination area is wrapped,
-		 * hence the available free destination space is unwrapped
-		 * and we need a single destination chunk of entire len
-		 */
-		dst_len = len;
-	}
+	/* at most 2 destination chunks of sum len; the 1st ends no later than
+	 * the peer's RMBE. The cursor wraps do not decide that: the peer's
+	 * cursor comes off the wire, and after a link failover prod can be
+	 * behind it.
+	 */
+	dst_len = min_t(size_t, conn->peer_rmbe_size - prod.count, len);
 	/* dst_len determines the maximum src_len */
 	if (sent.count + dst_len <= conn->sndbuf_desc->len) {
 		/* unwrapped src case: single chunk of entire dst_len */

-- 
2.56.0


