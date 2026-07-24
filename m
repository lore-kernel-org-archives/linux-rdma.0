Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56A1F1537;
	Fri, 24 Jul 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852608; cv=none; b=AbzNr8xYM9CeBJxBcSX9LTUEPMu1VXBvcl///19bjfZdQcVG5X15h8NZxPhuPadjjliHgW66NPP5Kt1n/B+hrLGnSCdRgzvFgB+DP3FntjO9n4HsgZENDpXFQHt3ZOMaC0JAoxhK0Hd0+/2evy+1EOGPfzXOykzZRax8EUFIvXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852608; c=relaxed/simple;
	bh=4U931wxTAQmoZLnKF+f1/StB+kUujXXSkxuDOtR8rvs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=s9Yq7MCpD7bd3swEuce0/42j0RDso7EHCWF2Ql/qxMt+uMplywnKRxY1CiCEGQTjWs3OP6iQtxW4smTrcYJXPDzZKfxOaZ3G2YJhm02nsnuGaUVaUpxwXFeuwcobCZ41L+CHXRSt/qUqx3woCkDK/PMtp/0HR5bajpWAe9g6eJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEo1G+FR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEo1G+FR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE7BBC2BCC9;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784852607;
	bh=4U931wxTAQmoZLnKF+f1/StB+kUujXXSkxuDOtR8rvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HEo1G+FRo6pDKc0zcKK/b84USUFaWRY1ZpFIqGGdodnJ9cslb672BI1W7+VIvXovY
	 Ykzvd3MgF46QPRwfmEQdyNiHnRNLOX2d1yBgfoeA+fWVAcG9HjyiRXjYJPIjvRVPlT
	 SKyvabSH+8Q/qtuWXjnNErOTYZw5UeQaS/zx8chsKFScX1q87GwN7ZGQfM/pkeBpmA
	 5Ljd6bZYQqlH3Bf47uwGh8CzGMh3FJDKltUK+5mq6tny+3ia14JLPPEuLKSZk79y/Z
	 FSryf8SIRnPfoHJzC5y07FJmRkpaDOUZhH/e+2d1rm89V8cB7roUWg85aEbFSVf8iz
	 4OFCFYKqgF2YA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD86C531D0;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 23 Jul 2026 19:23:27 -0500
Subject: [PATCH net v5 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-b4-disp-0d07164f-v5-1-6a9e235dbc4e@proton.me>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
In-Reply-To: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me>
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Jakub Kicinski <kuba@kernel.org>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@google.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, 
 Ursula Braun <ubraun@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784852606; l=3711;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=evfdLZhJwQ6ZMPc4z0HkxIgfLkW4b4DY7F1ZY4ekk4k=;
 b=7Qw/oy853Ph9hvxtrZ0JZoIoX89s7qlGw+z+8M8wFc6WHh+oTRgnrlGwMCNSyJ1T2ix4sx16f
 nYmg/zXbcpFBcMyNn98z15C2UFQdO2lonmZ7S34wmVrM95bB+9wkEHc
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import a peer's
producer cursor from the wire into conn->local_rx_ctrl.prod without
bounding it against the receive buffer. The urgent-data path in
smc_cdc_msg_recv_action() then uses that count as a raw index into the
RMB, so a peer that advertises a producer cursor past rmb_desc->len
reads out of bounds of the RMB allocation in the receive tasklet and
can disclose adjacent kernel memory.

Bound the producer cursor count to rmb_desc->len at the wire-to-host
conversion, for both SMC-R and SMC-D. Bound only the producer cursor:
the consumer cursor indexes the peer's RMB and is bounded by
peer_rmbe_size, so clamping it to our rmb_desc->len would under-credit
peer_rmbe_space and stall transmit to a peer with a larger RMB.
Conforming peers are unaffected.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
---
 net/smc/smc_cdc.h | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..ca76ef630356 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -221,7 +221,8 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
 
 static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 					  union smc_cdc_cursor *peer,
-					  struct smc_connection *conn)
+					  struct smc_connection *conn,
+					  int max_count)
 {
 	union smc_host_cursor temp, old;
 	union smc_cdc_cursor net;
@@ -235,6 +236,15 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 	if ((old.wrap == temp.wrap) &&
 	    (old.count > temp.count))
 		return;
+	/* The peer producer cursor is wire-controlled and is later used as a
+	 * raw index into our RMB by the urgent path; bound its count to the
+	 * RMB.  max_count == 0 leaves the consumer cursor unbounded here: it
+	 * indexes the peer's RMB (bounded by peer_rmbe_size, not our
+	 * rmb_desc->len), so clamping it to rmb_desc->len would under-credit
+	 * peer_rmbe_space and stall transmit to peers with a larger RMB.
+	 */
+	if (max_count && temp.count > max_count)
+		temp.count = max_count;
 	smc_curs_copy(local, &temp, conn);
 }
 
@@ -246,8 +256,13 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 	local->len = peer->len;
 	local->seqno = ntohs(peer->seqno);
 	local->token = ntohl(peer->token);
-	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
-	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
+	/* bound the wire-controlled producer cursor to our RMB (used as a raw
+	 * index by the urgent path); leave the consumer cursor unbounded -- it
+	 * indexes the peer's RMB and is bounded by peer_rmbe_size.
+	 */
+	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
+			       conn->rmb_desc->len);
+	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
 	local->prod_flags = peer->prod_flags;
 	local->conn_state_flags = peer->conn_state_flags;
 }
@@ -260,6 +275,12 @@ static inline void smcd_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 
 	temp.wrap = peer->prod.wrap;
 	temp.count = peer->prod.count;
+	/* the peer producer cursor is wire-controlled and is used as a raw
+	 * index into our RMB by the urgent path; bound it to the RMB.  The
+	 * consumer cursor below indexes the peer's RMB and is left unbounded.
+	 */
+	if (temp.count > conn->rmb_desc->len)
+		temp.count = conn->rmb_desc->len;
 	smc_curs_copy(&local->prod, &temp, conn);
 
 	temp.wrap = peer->cons.wrap;

-- 
2.55.0


