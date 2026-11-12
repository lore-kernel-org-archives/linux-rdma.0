Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488379;
	b=ekC3U1L4DuRrD5C0ApPE1XOrmRcWXEvclGNo58pc8odIu0uroyhdFSvoNdwT9TH/o5c/
	 hkBKAcpFXZlTBsqbIob2k/acqz9VKpe5aJ4BnWcIslyNp5eB0mWYBXYt2xN21+wl24uIM
	 fy8J8jzXR+40yR60QQDGKLQ/MzsF3joxD88gUYJ8t5dwxyECKI8cA00TRALy/M9FrMVM9
	 zvHMtjhxidHPY/OiRBEQe2cIogdbv3WvF9VZBBt4s4mpnXg4TlQMUOqZA9uqLzxz+hKML
	 lPHXrUIiGlknUevMtB0UMUkB8fNImRZg1vXvlubuuRdW/BH44mgjDhem2wzH/lsQT1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488379;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fzxkb4/JV9OoSzG1fRaEZIFJr+6dWXOO29ubYb1uyPc=;
	b=GApgWfVMmMLpOctxzIjROOervLTmu0th5U2j9Sfu7LanuKpGJSIeafPPSA/2ivEz8h9J
	 s+nlRiZgWqO9jJ6tiIG+tabxBMQckue0BrPuaoAtqMdxfbjGJ29DxcYqsX8QG3J7aXaiy
	 siINPyvST6dc+cmkoINJlajZWyrJqz8Bz+yG81sjO1Ys1fneTb6vuoIm4ih5zANIIVFx5
	 6jMmY6kf7HLjN4zIxzTfuT7MsXNkTuRjeLuQ/3vvbvl7Z3XRl5/eio5PnLiL5zf0NNWxu
	 tKW2r+uSbufaN6ldXQPoxeDDhgac0CCFdbsLqiFsQ44uVQBHsCC6YG6P/guxedO9rsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCgGLfUL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1D2606A8B4;
	Thu, 12 Nov 2026 12:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCgGLfUL
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488379;
	b=c5UN3FQeRsCTqyBH8zpu20tuhIROA9xZLBc84GVGwyTThcPlZwIJwdiMCQlNTTQOWILZ
	 gGVG97WGY+PQDz1KNbKqwIaIbF2liyE8kLOV4ZqCHWTRZEZPpEwr0hLpeSNLzIN2bo0Kb
	 iZFX3sWQQWh0jhg+i4JYJYrBB1unytyE2TJ1W2iEx4FO6LsJuhLuKtxuBjQXMSPQs7FH6
	 0OsuZINHdRFJadwWPYwnWtalAk8V5Ei1RYytJ0CMsnzPN3he6/FC4cf/8u5BOS9Xm9jlQ
	 TqzpIn7CKSHCEs+y/vz6QgXdb0G9KC+gKZ59qDhffRXh2R8/WMc0HZgVlMB13n1qqbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488379;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fzxkb4/JV9OoSzG1fRaEZIFJr+6dWXOO29ubYb1uyPc=;
	b=zVBzH8b46o46Zpc8DYMrsQr/jbu128cTJSQCO2Idt+82NV3RI0Q06QwM6dEntV/CXRBY
	 vTI6T3JzEJBtuSYwWe5BETTInhc3RW/HZtBlLFBqar0tsjw26Y2WWDtciiFdXFmx7Srzj
	 7K0+gM6WHt5jy99bpVzed8qII1lm+7BJVfivVTIox6Tcx9zpBlWHtT3K06hHRwrcdGnOe
	 4j6emF+eR+vQKBkoslqsMocKHTEKys74bTrk9+IG+aD8hAKGQXfYH7bdjLgkmYDhfqbfR
	 PG6oyHeb0sNaivt1GgsZXu1CARlJLtdG+fmH6SqRGYoQplvmN2Bvqpy5AhZGYsaI5Mg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 05C591F00A0D;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488379;
	bh=Fzxkb4/JV9OoSzG1fRaEZIFJr+6dWXOO29ubYb1uyPc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kCgGLfULRKksFYgYfF2YgODvDIeP+yQ6oU38Ee70aJWehOSVLVTXAFKY/yxx/+/+p
	 I52p/JrYqYnam/TDRLmqExsflTAWRuFgsaRMUsZg+FLNUQETHu/pkfAYhHnUEXZog5
	 NqqAEZ4QX4A8QY1m2kSJO24e8qVLuyASpSIGbZpI+TTYI5d52JHnTBv43NaRMijFZp
	 cO4PhJirvZ8z60G7TP55yVyCwuMBhMqSDLSf94HMgvTte7pMI/BGQ10AefGd9KA3OH
	 qNZih/IpKKS6AsE7v4JSdAOBEZ+4WyV9fscaiK276s9vEdu07rMgeBVqKnpr6JrZSp
	 gJP685G/ggwwA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7D559494F0;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 07:59:40 -0500
Subject: [PATCH net v9 6/6] net/smc: bound the link failover cursor advance
 to the send buffer
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
Message-Id: <20261112-b4-disp-0287c16e-v9-6-e5e8fa688177@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=7639;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=uAbSDIRlrWBelymt5BrgkkgeH3WfRs3rAFudHlXVEr8=;
 b=pt0Gwsz1IrVUDmy4uj2+rgftHh2Lk9VLJDqJK1JPJWspsQpm90zoFjtczKxAOtQ+bl9yj2WjB
 pE9lhpul7eaAkLfVZwDEZHrvyR5X91kMkudLuS1zoJNdpKIKhvY7Rlh
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

On SMC-R link failover, smc_switch_cursor() rewinds the send and
producer cursors to the last completed CDC send, then advances them by
the distance the peer's consumer cursor is ahead. That cursor comes
from the wire: a forged one adds an arbitrary amount to sndbuf_space
and to the cursors, and the next RDMA write takes its source past the
send buffer.

Advance only for a count inside the peer's RMBE, and no further than
tx_curs_prep; a conforming peer's cursor is inside both. For any other
count the write that follows can end past the peer's RMBE and needs
"net/smc: keep an RDMA write inside the peer's RMBE" to bound it. Set
tx_curs_fin and local_tx_ctrl_fin from the advanced cursors instead of
adding to them: smc_cdc_tx_handler() can rewrite both while the switch
runs. The switch is still not serialized against the handler: a
completion handled inside it is still credited more than once and can
make the next write hand the peer bytes it has already read.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Cc: stable@vger.kernel.org # see patch description, needs another patch
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
v9: tx_curs_fin and local_tx_ctrl_fin are copied from the advanced
tx_curs_sent and local_tx_ctrl.prod, which change only under send_lock,
instead of being added to (second point of [1]). The write past the
peer's RMBE that v8 introduced for a count past the RMBE is bounded in
5/6. The cap is tx_curs_prep and not the pre-failover tx_curs_sent: an
earlier failover may have rewound that one below the peer's cursor.

rxe, two links (v7.4-rc2 plus d7900fa51642, KASAN), send buffer 64K,
peer RMBE 16K: one byte and then 4096 confirmed; 12000 and 5000 sent and
not confirmed, the 5000 in two writes, 287 up to the end of the RMBE and
4713; all read by a conforming peer. A hook holds the pending
completions and hands the first one to smc_cdc_tx_handler() inside
smc_switch_cursor(), after it has read tx_curs_fin and
local_tx_ctrl_fin: unpatched and v8 leave local_tx_ctrl_fin at count
16713 (the RMBE is 16384 bytes) and tx_curs_fin 12000 bytes past
tx_curs_prep; v9 leaves tx_curs_fin on tx_curs_prep and
local_tx_ctrl_fin on prod. Without the hook, v8 ends the same run with
the cursors v9 leaves.

The first case of the note under v8's 4/4 (cursor forged one wrap
ahead at count 64, with 4096 bytes unconfirmed in one run and corked
in another) gives on v9 what that note reports for v8: the advance
stops at tx_curs_prep and nothing is written after the switch. v8 and
unpatched were not rerun for it.

Not changed: the switch is not serialized against the handler. The
handler takes send_lock inside the socket spinlock (smc_tx_pending())
and the switch holds send_lock only, so keeping it out means taking the
socket spinlock around send_lock in smc_switch_conns(). What remains,
on unpatched, v8 and v9 alike unless noted:
  - a completion handled inside the switch is credited to sndbuf_space
    by the handler and again by the advance: in the run above
    sndbuf_space is 77536 after the switch, for a 65536-byte send
    buffer. The old-link completions that follow set tx_curs_fin back
    and credit 4713 bytes once more: 82249. 3/6 keeps send() inside the
    buffer, but send() can then overwrite data the peer has not received
    (by inspection).
  - a completion between the first two cursor copies of the switch
    leaves tx_curs_sent behind local_tx_ctrl.prod. The next write starts
    at tx_curs_sent and lands at prod, that far past its place in the
    RMBE, so the peer is handed that many bytes a second time. In the
    first case under 4/6 the peer reads 600 bytes twice on all three. In
    the fourth case under 5/6, where the peer has read across the end of
    its RMBE before the resend, unpatched and v8 have the write refused
    and the connection lost; v9's goes out and the peer gets 600 bytes
    twice there too.
  - v9 only: the first case under 4/6 ends with sndbuf_space 1200 bytes
    over the buffer, against 600 on unpatched and v8. v9 sets
    tx_curs_fin back to tx_curs_sent, and the next old-link completion,
    when it is handled before the validation message's, credits those
    600 once more. Handled after it, all three end 600 over (by
    inspection).
  - the completion of the switch's validation message carries
    tx_curs_sent and steps tx_curs_fin back to it whenever a completion
    handled before it left tx_curs_fin ahead; across the end of the ring
    that step is credited as more than a whole ring (the mechanism is in
    3/6's message). In the fourth case under 5/6 it is credited 124472
    bytes for a 65536-byte send buffer on every variant, and on v9,
    where the last write goes out, sndbuf_space ends at 3x the buffer.
    v9's smc_curs_copy() removes one route to that state, the switch
    itself leaving tx_curs_fin ahead (by inspection); late old-link
    completions are still one.

[1] https://lore.kernel.org/all/179364387382.3131.13471253186660322977@kernel.org/
---
 net/smc/smc_core.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 0edbe6106c1a..b5625f1a8792 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1034,7 +1034,7 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 			     struct smc_wr_buf *wr_buf)
 {
 	struct smc_connection *conn = &smc->conn;
-	union smc_host_cursor cons, fin;
+	union smc_host_cursor cons, fin, prep;
 	int rc = 0;
 	int diff;
 
@@ -1043,16 +1043,22 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	/* set prod cursor to old state, enforce tx_rdma_writes() */
 	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
 	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
-
-	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
-		/* cons cursor advanced more than fin, and prod was set
-		 * fin above, so now prod is smaller than cons. Fix that.
+	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
+
+	if (cons.count < conn->peer_rmbe_size &&
+	    smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
+		/* cons cursor advanced more than fin, and prod was set fin
+		 * above: catch up. cons comes off the wire, so only for a
+		 * count inside the peer's RMBE and no further than
+		 * tx_curs_prep. smc_cdc_tx_handler() is not excluded and can
+		 * rewrite the fin cursors meanwhile: set them, do not add.
 		 */
-		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
+		diff = min(smc_curs_diff(conn->peer_rmbe_size, &fin, &cons),
+			   smc_curs_diff(conn->sndbuf_desc->len,
+					 &conn->tx_curs_sent, &prep));
 		smc_curs_add(conn->sndbuf_desc->len,
 			     &conn->tx_curs_sent, diff);
-		smc_curs_add(conn->sndbuf_desc->len,
-			     &conn->tx_curs_fin, diff);
+		smc_curs_copy(&conn->tx_curs_fin, &conn->tx_curs_sent, conn);
 
 		smp_mb__before_atomic();
 		atomic_add(diff, &conn->sndbuf_space);
@@ -1060,8 +1066,8 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 
 		smc_curs_add(conn->peer_rmbe_size,
 			     &conn->local_tx_ctrl.prod, diff);
-		smc_curs_add(conn->peer_rmbe_size,
-			     &conn->local_tx_ctrl_fin, diff);
+		smc_curs_copy(&conn->local_tx_ctrl_fin,
+			      &conn->local_tx_ctrl.prod, conn);
 	}
 	/* recalculate, value is used by tx_rdma_writes() */
 	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));

-- 
2.56.0


