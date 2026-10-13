Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C906B5476F1;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791922369; cv=none; b=bq2LHG6rRhldX1NlSIohi0IhPbjEWSFFV/0HNZLAk8Z4FnuYghS3XJ2pcj0pXcu6gxnvTyEWuB+hE9k+632BM+h4bsKZ+IqUx9lOF3KhCpY7eWeQMPxpW6+nf1/aGDQM/BIgS9cT5hzk4jXZqRshl+sfAi7+KVy0SHXX7bMgzaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791922369; c=relaxed/simple;
	bh=xNb4HR1SSJK+4fbIYQIcFAbHNxwUdPjA4ionyGzqQGA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=feyF4FcwemYEFa/LwD4WyiyrSXQpxeY3LnywH24sC5z06X1TLrX7QV7DHYQ/xm4CuIPynznBfTi4rIWDNHIyrYTSYBfU8uMgIB3vi0x4spTmtVrOfSkOyJzjSbpQRw/MKj4QmWKvB48gbVjSfNbyiP93lkG8DWUqOYKWbUQFthE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRwnErIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRwnErIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7317AC2BCF4;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791922369;
	bh=xNb4HR1SSJK+4fbIYQIcFAbHNxwUdPjA4ionyGzqQGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GRwnErIZQiDrwWon6iRPSkWGd/oOf0ka3GxsJwih81m3psGcCDcXcSDn9M8/hrdt0
	 5GksBFkCmHxmmVdBX3w12MDw6Cm0qSO/8XcpOSBBP9GeZ4rEpgDwNrkz238vPA6D8e
	 QO188rh8Oc2SM7AscO6esNHKqQY0TYgG0aVGteK1CdUEydZ+s+pDcxAJtvkMoewwUs
	 0l9k+kdBpXl7VhLQw27dr1WbtVmRdOS4R/018ixuUyYJPkJUn+fyKIRdvBk3YlETLX
	 2VPpv3Q5X3NTKKaWETZB57LNhwDg3G9VvEvCWDDXEr7N52If/rbeoFxo1GFuqyPdT4
	 FnhcNtFD630RQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6FCCC6B12;
	Tue, 13 Oct 2026 20:12:49 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Tue, 13 Oct 2026 15:12:48 -0500
Subject: [PATCH net v7 1/4] net/smc: bound the wire-controlled producer
 cursor to the RMB
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-b4-disp-f345196c-v7-1-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
In-Reply-To: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
To: "D. Wythe" <alibuda@linux.alibaba.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, Dust Li <dust.li@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 linux-kernel@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, linux-rdma@vger.kernel.org, 
 Stefan Raspl <raspl@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791922368; l=3046;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=9ja5JoT+O2VUsGXhvlsOd1Bx55l6YLeZkBRApwlhPSc=;
 b=rVYcu4i4oTyDRLtwHGtEjq2DjTHtK80IgFrn7b5X+ZoM5nM630eyXVJvGwmEfj8XrGkYIgnGW
 bvnALUCmsOTBeGkQlTjfaeEVmS5YcBhwnF2hIsCNki/nNTHkpT5yDEp
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import the peer's
producer cursor from the wire into conn->local_rx_ctrl.prod without
bounding it to the RMB. smc_cdc_handle_urg_data_arrival() then uses its
count as a raw index into the RMB, so a producer cursor past
rmb_desc->len makes the receive tasklet read past the RMB, and
recv(MSG_OOB) hands that byte to the application.

Bound the producer cursor count to rmb_desc->len when it comes off the
wire, for SMC-R and SMC-D. Leave the consumer cursor alone: it indexes
the peer's RMB, which can be larger than ours, so clamping it to our
RMB would under-credit peer_rmbe_space and could stall sending to that
peer. Conforming peers are unaffected.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
 net/smc/smc_cdc.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..4d630a305118 100644
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
@@ -235,6 +236,12 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 	if ((old.wrap == temp.wrap) &&
 	    (old.count > temp.count))
 		return;
+	/* The urgent path uses the producer count as a raw index into our
+	 * RMB, so bound it. max_count == 0 leaves the consumer cursor alone:
+	 * it indexes the peer's RMB, which can be larger than ours.
+	 */
+	if (max_count && temp.count > max_count)
+		temp.count = max_count;
 	smc_curs_copy(local, &temp, conn);
 }
 
@@ -246,8 +253,9 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 	local->len = peer->len;
 	local->seqno = ntohs(peer->seqno);
 	local->token = ntohl(peer->token);
-	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
-	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
+	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
+			       conn->rmb_desc->len);
+	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
 	local->prod_flags = peer->prod_flags;
 	local->conn_state_flags = peer->conn_state_flags;
 }
@@ -260,6 +268,9 @@ static inline void smcd_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 
 	temp.wrap = peer->prod.wrap;
 	temp.count = peer->prod.count;
+	/* as in smc_cdc_cursor_to_host(): bound prod, not cons */
+	if (temp.count > conn->rmb_desc->len)
+		temp.count = conn->rmb_desc->len;
 	smc_curs_copy(&local->prod, &temp, conn);
 
 	temp.wrap = peer->cons.wrap;

-- 
2.56.0


