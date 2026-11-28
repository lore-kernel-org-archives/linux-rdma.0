Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795875836;
	b=rTh2PcUJOnhOkeK/NsBrpKk9wzH0ruQZN/c27jqImR1KXOk7I/3Efa18TtPMvM4wYtWx
	 jdg2tCPSNQnvZKokF4ZYeLyJDuqdGYOAMKjCllLfmw24o6xNTd4OGJhYbauixa7MqbHQg
	 GuLpVhwuPzFZ+YOKiTqhlaVXy9TwAiwjc4T9Dz/0KcPZ6uDXS+nGj652HNzOPolLJyaGt
	 xPhFIA2yeF7r9hv+qISoSeHz0KHBkaGQ95TYf+CqZ0fPvP6FPH5veWNZlOCkj3oMuxFSJ
	 Gl+VEzHAAhvPrkhPGGTSZw41yyprUrgUMq99tH38kSvMBGiGNcTEbjA5r6RGupv7WaA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875836;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Kv7pdAIuxaJIEPokEi6ey+MAceVbmrIyDVFIOKizjlc=;
	b=yBcvH7/PywrbHx14uXRaPEufYO4mWZ48VleK28vPi2yhq7BnuAjz0iIUT+amxIHeCI2I
	 EK5uXEcDznBzuF9LsK7UtMUGXOuR/y8I4aAqEFaTtnA6BJflL6XtWyRwYXpW74f9+/aBq
	 hem63VdRgsqHaMqpNRK8bJNSxRh6+n42YrJj9msbe8BvNA35U+qBiSyNIxKAN76nlyqXS
	 Q1Xams4QP95HkdWufMT1gLLNpbTyOytuEV5IhVMT73J2NDj5HA08g0U9xR5K3hxuK+lue
	 UQLg1/WygIScrUHO5UbTnFWItOQIg10ASrSVkyfIHhBnrgKU2UIez6m8LRBWOkhLymQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OX5IZgus;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF33606A331;
	Sat, 28 Nov 2026 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OX5IZgus
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795875835;
	b=HSBO1w+O2CrSbC3KG0M6ReAPTvT+y6+wXHYPWYTML/1h1RNHF1c7dx+U7NDR5cX3NaU0
	 QcGCDBQqro1OHVxMCX/roA6k11+Ml0ITWUOuBix44QXTHm2NOAslLaNmH68tZ07FUS9ZH
	 jvEBhHfWVNj6FNsCKcC8+tKLcr1jo7FNX5FR8CITN7cKvktKOv7CZT3jFfoljEMtCzmOf
	 jtxbAv04YF2CN+/Car0uWqikOyUEaNidmRpTeaDnwfAgLqviR+b9zugUdIMtLNfAf39bm
	 uDujsQXJY+VHoq0pJA+mGDp5z1o3Rj0TS+rSVkSLEe9oTjcObMITxujsnMjr6pp8eog==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795875835;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Kv7pdAIuxaJIEPokEi6ey+MAceVbmrIyDVFIOKizjlc=;
	b=1mo3sBWkJ16ickCNavcFu3XM7ho0dpZbYSenJrRivEo5FxiovxByLqJ79S0qdEpC0SxP
	 prmg6WW9MxflZHE8wtOTRfLoSqsIXl+kNrvgqnrP2LkI6PwbqXpXvRwAG0cBnttrFl/4n
	 5DGFYZey88/NF0RYFCg7qyBQ/xNpyKWC+zgswdMe05rehHYLHWrVlw7fxWDdOEcdGJnCU
	 +xdoCeyvOVFdTSmAHoi3eijeA39pferiKkEoi93CHmR0iE/h2sPRiRIyG/qKCVuq/RqIe
	 RpFJvT7mbey5oWF5bCIPNQsTjJWyLBNt9d1f+yYK218NwZXipb2bMn+KMrYkxbnes4w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3B8F41F000C1;
	Sat, 28 Nov 2026 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875835;
	bh=Kv7pdAIuxaJIEPokEi6ey+MAceVbmrIyDVFIOKizjlc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OX5IZgus2lOAJOLtuoHXPrgTCt/cMa8xoxm1zynVqWTpQOwDGKXPk+ExF3DHzPPov
	 pbVogSr8GL1PPN/VvZaZxnAArDASjSwDTw+ePPG+8ayLHuCFMFXey7BVgYCahojAne
	 fci+R4kFydegOmaoWCUr2YmWwlX6aX4Ye9gv6npcO7FLSbFeXFnVrX5KQVxWDpbkUU
	 IbtVoWqvz6I3hLIAiDU6gp0vpbYnCWjmUm88d4sD5JU9tewGbfx8CyFAP6w4cl6q6v
	 3Lalv/wmPvs4glABtl/WGURZ6XAB/2+Iq7rttT08Q8e9jnqziFnTBsAb0bEINLajOW
	 MCy4tOlFEUtTw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 586234E116;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 09:23:47 -0500
Subject: [PATCH net v2 5/6] net/smc: order the urgent mark across the
 cursor wrap rollover
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
Message-Id: <20261128-b4-disp-360e65c5-v2-5-d9c05004d430@proton.me>
References: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
In-Reply-To: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795875822; l=3361;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=Rc4x6htG50veeFexiJAu4UvukFo13BH1Sck0r9zaQTY=;
 b=j4YK2CVd4P1ZR5Zj0nEBlLM12vRNgq6xNEgx/lFQebYHO6m3RflBXw0d942nMmqCSUIIRNfaa
 BI5CIUtZRVkDNogPrXIx9megx8qC5C9pfDV1GU/oJFTpRIHu7dmiwDM
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_rx_update_consumer() orders the consumer cursor against urg_curs
with smc_curs_comp(), which misorders them across the 65535 -> 0
rollover of the RMB wrap. Without SO_OOBINLINE, with the reader on wrap
65535 and the urgent byte on wrap 0, the mark reads as already passed:
urg_state becomes SMC_URG_READ before the byte is reached and
recv(MSG_OOB) fails with -EINVAL. The urgent byte, which bytes_to_rcv
leaves out, is then never skipped. The sender waits for its urgent data
to be consumed before it sends more, so the connection stalls.
smc_rx_recv_urg() compares the same two cursors with smc_curs_diff(). A
consumer cursor that is past the mark on the RMB's next wrap reads as
far behind it, and urg_rx_skip_pend is set with nothing left to skip.

Use smc_curs_sdiff() in both, which orders the two cursors whatever
their wraps. smc_curs_comp() has no other user; remove it.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_cdc.h | 13 -------------
 net/smc/smc_rx.c  | 11 ++++++-----
 2 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 4b586a20dfc2..eecd0cc5bb79 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -167,19 +167,6 @@ static inline int smc_curs_diff(unsigned int size,
 	return max_t(int, 0, (new->count - old->count));
 }
 
-/* calculate cursor difference between old and new - returns negative
- * value in case old > new
- */
-static inline int smc_curs_comp(unsigned int size,
-				union smc_host_cursor *old,
-				union smc_host_cursor *new)
-{
-	if (old->wrap > new->wrap ||
-	    (old->wrap == new->wrap && old->count > new->count))
-		return -smc_curs_diff(size, new, old);
-	return smc_curs_diff(size, old, new);
-}
-
 /* signed distance from old to new; the wrap difference is taken as s16,
  * so it holds across the u16 wrap rollover, for cursors less than 32768
  * rings apart
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 63c178c10bf1..564b976426ca 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -62,14 +62,15 @@ static int smc_rx_update_consumer(struct smc_sock *smc,
 	struct smc_connection *conn = &smc->conn;
 	struct sock *sk = &smc->sk;
 	bool force = false;
-	int diff, rc = 0;
+	int rc = 0;
+	s64 diff;
 
 	smc_curs_add(conn->rmb_desc->len, &cons, len);
 
 	/* did we process urgent data? */
 	if (conn->urg_state == SMC_URG_VALID || conn->urg_rx_skip_pend) {
-		diff = smc_curs_comp(conn->rmb_desc->len, &cons,
-				     &conn->urg_curs);
+		diff = smc_curs_sdiff(conn->rmb_desc->len, &cons,
+				      &conn->urg_curs);
 		if (sock_flag(sk, SOCK_URGINLINE)) {
 			if (diff == 0) {
 				force = true;
@@ -330,8 +331,8 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 				rc = memcpy_to_msg(msg, &conn->urg_rx_byte, 1);
 			len = 1;
 			smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
-			if (smc_curs_diff(conn->rmb_desc->len, &cons,
-					  &conn->urg_curs) > 1)
+			if (smc_curs_sdiff(conn->rmb_desc->len, &cons,
+					   &conn->urg_curs) > 1)
 				conn->urg_rx_skip_pend = true;
 			/* Urgent Byte was already accounted for, but trigger
 			 * skipping the urgent byte in non-inline case

-- 
2.56.1


