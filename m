Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793298086;
	b=MfMTUvEpItijolklrlRWXYCIWzj9eu50YdAeBJxkviIjcnNy8fwTzhlQW8c5owLwbWdh
	 IVns9tfKYbLV+kWR36xOdn2DP/4eahIO0H5/aLtO9qAWZps2PSG6fbJE3L3IDQJIwI5Zi
	 k7G3c5oaQWXLmX6uI630nk2vztv/7WSgTRqZ99TAAkQtUvme6yaA9KofNDwybJyMIhNa8
	 jeDIBGyuaxXlMYhD2Mwa+dF4vsUrtmm9zgdr/ECoW4AwZ45m8rb/su5dfL2abdm0UWG0p
	 vtrj1b/CwagzAxB/fEt7SFFph0uUS1HAlfSk8+rD0kKn2UxroePxE2PeHztHoFDNamw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793298086;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=L4mZo8MEyCVSdJpP8K1XtolPy5nG1XWXR2oO3v5th5E=;
	b=rJv984Qv8jrm7mwYOiPYTSSeC2pDDWA/W+jEZCDIu+FIIgSPDmmtubvilv1gfISlbfse
	 xCOcNUkKJNE/IDyQ13Y/P6bJyqmuEZ5hT7uNCIkMYGVsLET9rV7vkBcuFg+y/NqnsEOuD
	 3J/MXFWAy3WXmsgiuAL7xoC8uAICpn/JlG/0sPXJAVH+KYz6piRDfY8IWMOJmwyaTRND3
	 Ncc29R48Rop+R2BLBGbB6XbkRPSb2J1WhP4ufTUo3UcoPSLqd96/IrJQRLwjZS6PPGy3h
	 c+j6d49eMW2JQMUDd8cXxwzyFnDaHF5RqBFtfNWHjnoDgmehgOJ3oiCecvvcZAw62nQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VuXzEyvE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2AA606A333;
	Thu, 29 Oct 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VuXzEyvE
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298085;
	b=Iw3Hpy30MQHlA8MGuHhA+gbaQWsKBs/oPB7do69ViVwx8yByrkCV0vXjLRJGjlSpvq8Z
	 DzfpoM/WekCD/PiKf+5Doej8PrCznRoWzXNl1brbC/Caxwqaj+orSjfc5HRH3cfM25LlL
	 ru6d8nJegaeRJlDJeYVfmjLiZis1wBBR9fuhZQeaVi+bBrXDdedkyqcpq+44PDzwpZx62
	 HjIjdhaaF9jy0sdSQR4Fn6HdrJkqorgjAKq31cIk4XGNRANsJF+rHmGdTN8HZ2G/iuM4u
	 XEv7DEBXBNJ4OCl/tOvSS8pHTj1Rfk8x0D5K7KXKP9exS7SqTuUgE+q0jvAyinRaIMQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298085;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=L4mZo8MEyCVSdJpP8K1XtolPy5nG1XWXR2oO3v5th5E=;
	b=yNqE/6C2BAtYFE8zR7c+FH2qbQqavot0iFAW4V34lCOPOB62k4Buquqb+dyE4jzPE25G
	 Bov8QvoNmd4WcmO1cR+9BeonqsooTqvkO+wHzhlhWaEJaiGqi4PaQGUMWaBZ4gak2usPF
	 fv5RvEEZmt0vnJac/uRatPdvGNYQhSARqy/OtdV50rADOr7VnI2ujOsakks/RMnVmKndz
	 N0PELNWmBA796XZf0nrVrISR6MSuEwfF4Zd2u/OWfqCAibS6xoyOXX5sE867bWkJX2ux7
	 ScpQ5vLbrPWzruavnEZZNcqD3wCcKTIXYqkHfQkYDZ93WuzIHNxRp5j2ngIdEJQIGZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5E1E21F01829;
	Thu, 29 Oct 2026 18:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298085;
	bh=L4mZo8MEyCVSdJpP8K1XtolPy5nG1XWXR2oO3v5th5E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VuXzEyvEkO8BNSbPh3RpkFvWCt78l6RVVfr1LgE7m6xy9qZWuiDHIzvChbkt7hTUr
	 N4Tv9uzvBVP2vJpPbcvRvTVmAZ0i5AQFcdgSNPun8GFNHi1BwPNqDVpcw4P3ITH9Gl
	 fGu/ywId04epzECFyRkv1a8/VxxYpCbYeYjhdDVwJ1qTjjhgC/cqqlc5hRT0TYWhG6
	 27of71el8Tw2sy0dTWNDJDiEeVitIpdy6Ktw+LBC5rQXUUInRFPklG8glOoiEZ3XlE
	 JfoXrp/hB2gwykMBNnUquiziaal/Vkg0XPzoqkLgoiiqJFLBF59RWNp3QnUgoswPUY
	 5MO6fe8cvTeoQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D84524594F;
	Thu, 29 Oct 2026 18:21:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 29 Oct 2026 13:21:25 -0500
Subject: [PATCH net v8 4/4] net/smc: bound the link failover cursor advance
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
Message-Id: <20261029-b4-disp-33001ace-v8-4-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
In-Reply-To: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Jakub Kicinski <kuba@kernel.org>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Paolo Abeni <pabeni@redhat.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>
Cc: Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298082; l=3862;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=pYvkTNfmgfYrChtl4QYbezukLNrDt2+mNDHk+pdZyKE=;
 b=QL6rWqrPTQJK5V3L71fhYkkY904avKa6++vytE2wVeuMzY/+PDyCEq7EeSIk8D93QKbpxDrUk
 MYUB2XWaREfDhHQyJNAAMOUfCx6+voiw9yvqv9v+b1IA/vVe3HWhha2
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

On SMC-R link failover, smc_switch_cursor() rewinds the send and
producer cursors to their values at the last completed CDC send, then
advances them by the distance the peer's consumer cursor is ahead. That
cursor comes from the wire, so a forged one adds an arbitrary amount to
sndbuf_space and to the cursors. smc_curs_add() wraps them only once, so
the next RDMA write takes its source past the send buffer.

A conforming peer keeps its cursor count inside its RMB and cannot
consume past the data in the send buffer. Advance only for such a count,
and no further than tx_curs_prep. The pre-failover tx_curs_sent cannot
be the bound: an earlier failover may have rewound it below the peer's
cursor. The destination side is not bounded here: smc_write_space()
still sizes the window from the peer's cursor, so a forged one can take
the next write past the peer's own RMB, where its HCA refuses it and
the link goes down.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Bounding the copy in smc_tx_sendmsg() (3/4) does not cover this: the
RDMA write takes its offsets from the cursors. Measured on rxe, send
buffer 16K, peer RMB 32K, 4096 bytes sent and unconfirmed, the consumer
cursor forged one wrap ahead at count 64: unpatched, tx_curs_sent lands
64 bytes past the send buffer and the next write takes its source from
there (rxe refuses that WR); with the patch the advance stops at
tx_curs_prep, nothing is pending, and nothing is written after the
switch. The destination side, with the consumer cursor forged two wraps
ahead at the peer's RMB + 4096 (send buffer 64K, peer RMB 16K): with the
patch the catch-up is skipped, the window is the whole RMB and the first
write after the switch, from prod.count 1, ends one byte past the peer's
RMB; its HCA refuses the write and the link goes down. Without the patch
the catch-up lands prod on the forged count, smc_write_space() is 0 and
nothing more is written.
---
 net/smc/smc_core.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fe6e4a2f7935..42d83a002ffb 100644
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
 
@@ -1043,12 +1043,18 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
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
+		 * above, so now prod is smaller than cons. cons comes off the
+		 * wire: catch up only for a count inside the peer's RMB and no
+		 * further than the send buffer holds, else that peer stalls.
 		 */
-		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
+		diff = min(smc_curs_diff(conn->peer_rmbe_size, &fin, &cons),
+			   smc_curs_diff(conn->sndbuf_desc->len,
+					 &conn->tx_curs_sent, &prep));
 		smc_curs_add(conn->sndbuf_desc->len,
 			     &conn->tx_curs_sent, diff);
 		smc_curs_add(conn->sndbuf_desc->len,

-- 
2.56.0


