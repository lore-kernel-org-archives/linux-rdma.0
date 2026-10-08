Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8CD3C061D;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439962; cv=none; b=Uotr6/QcNywm1/Dih4latT2FHu1mfgo+WbiMPrp1w3nIDjk3V51QXv9880t0HZG0A+SMm1/F0tFx7aM7/DNe67ohh5D2zdI34JcxDh3x/yG05brfQcboaColzPAHh/9OkW8Myj+VyfmjuEkHTBV6yyZL7wrr2/qxLLcGcNL97aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439962; c=relaxed/simple;
	bh=NOH/+b/wT3w7k9Awy+XZ3D0MdqqaJxwJ1VpmPcpJ8dI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hjiNgibAi0YOq+hiCuuif9T9eY0ozW/kWNXKizsdwzwuWd+XLdh5ihqnWetiRXxHnVDWstMQz+W4uRO9GPi0NzGdRwzmgyb1cQHQo0eX4EjwkaEcFrCQFfRW89BqBu+7alVIdG844L0fgXI+QcJdzauhy0hq77J3l772Nno0iC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVhrULpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVhrULpe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13737C2BCF5;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791439962;
	bh=NOH/+b/wT3w7k9Awy+XZ3D0MdqqaJxwJ1VpmPcpJ8dI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qVhrULpeh4h+MO8MXRmrjuC6xHzPtt60RcV4TcvHBzESDGh76LUmpUyEtPiCFbCfJ
	 qpi4p+Aa0NRCZ5lq3athwygEVgBBRnkTFYei3dyugD/3rk+ZuoBnJYmT+BY814aJB/
	 vm4S2EACfB1CezfI9ncP44rJmkdj9oQc97AheJb4/KuNZoYqYoSa2WjiT00nnl/cdD
	 pGcYotbKLYlR5GgHaxLQFdoC4nLllmr9BU8rgUQX5bZ1mQOgNfo5ZBjFFWGAkW/glq
	 oYxopp3VtvUnIcHiU6vAGP1rSP7iKqb4MtrHFQtblm3ybkNFLhMcBuCx5bgCWIfGY0
	 ymqLxT5DWkytg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F55CA600D;
	Thu,  8 Oct 2026 06:12:41 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 08 Oct 2026 01:12:41 -0500
Subject: [PATCH net v6 1/3] net/smc: bound the wire-controlled producer
 cursor to the RMB
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-disp-f7cd3d96-v6-1-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, 
 Hidayath Khan <hidayath@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org, 
 linux-rdma@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791439960; l=3766;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=1BDYD5ToutxgSIvObJyWl5RpOt3eIit6fHCV4Vi1b0I=;
 b=Jn78WCdxW/a76dAdbN/0bH20zBvLVUcOz1kSwwusGigyRFbb4r6anFiFED4UWj4x0Co6akUki
 yWZaiOUErf6ADmI0SAbfjnR/wsMYBR2eauRulME97cV5Kn/VjPzW6g9
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
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
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
2.56.0


