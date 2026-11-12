Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488379;
	b=wBh41CI5TsA7aakpw9uPaD4w9Wh11TOCe4FZtk4gbF7J7kPk4/MQoSlp30VSEtt2G/7S
	 d0BO0XUbJy1w2kHClMQl8lWOCz83+TxcTuRFjLMxKRtkUERn+wgLtKyTHMlbp4179Sqyh
	 0dXtG7MxN4zfIxx6wHUDYG/qVHZSUXZX2dPxHz0MweDGtSrUf9UtxJVvhRlIQeboM8BcU
	 KtCEtlER2nhIN+wVM0tAM5lJB+4SKZhi0S0hQKcNQys3jTHREEI/uvMf7jcwwurUWcazG
	 7L4TRpSAYdC0Os9/lxF7sSKCujv/Lqfd9tD79ny4Uaw41BkIxVvZTRKFwqpmIQXA/pQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488379;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	b=vELvhL1sOSMNU+34BuXr1ghS4wOBY2cFzApov0r00g8oSeO/sA2ILfso9JTz9B4tNKQd
	 tZ/38UlNGGbUQBY5gpajbCVp8Rh7w82/c26pHGI9seImSDrgPRUZEL/ASNpidyAjpPBQ1
	 LMsc2kpUJbvy5p4Nbo5yp7uURMN1ZjB+5aUNIDGm35+ygvrdTOYIeyimkuwXpQ+H5f8/N
	 eimL2J8+WV6osItWFx8MVYYSPJt+A3aDr60VldXweL6zOMhEmpRUM9tM+QZ4ZhnArGi7p
	 QCK++c2D8bYubEeakFvEezlpXjeWGeS4sIqeUrtfY5b3fbCFyOfMocx/p3wC+RvQ5FQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRgTrpmF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DF4606A8A2;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HRgTrpmF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488378;
	b=ckv9n7lIzUu4nJ2iLDWd/empNTY31smuDwrl/JNQ7LRpo3nTBKMY11FqkSy8Nv6wnv17
	 l0cq11bHHtqxJ8KELOI/Pt1tDgrcy9S+8qrx6J/zxgNu0l8IpQhnfKTrpmUDI+yI8YLag
	 8P09M5mMrJRlv839I6XzLLuU+KCWJkZIsjCMeI/VszecSeQP1HIIwmPe//httdAWxlPZb
	 aPfxWZQbLc4PClG+6X5/bGSpMHdkHUd05O/Nu2RGrSMf+pkzNa4lwYTmhp7mdOkFzYXuo
	 Iw7KWR/MfDw2dKPH0UFHjEE2NPlWJhhUib0CUxWS8M1VNMR5Luzl4JOVRGCMuxIylxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	b=NzQMETrL21BpS8YPkdXm4WZtsk+N6/s9pydcGHzrispqShEJhvzUnC5dvhHqnowmLe9r
	 tNGom/SKPp7OIYkvQZkWNEYzwdWhrimrS6YdhsuS8oo6uGXlj53QjzS7cliiG+OVydUBL
	 jRQg0EIl6G/9sX1gcD0Ac9O7fUgDCzhbfiOV8Yi1rQdapo6vteVeFgupWEu/HoCq77Rvh
	 Rrltf+6INivnAkmxZMb8G8/V3sivI0muHdNj6KJPQr6hVItNDKN0F2uE/vr+EtObJJWOD
	 FfRTM1X1Fav6RB8BEIH4q8Y1CI+3aDx1GOBmXGOd3gtU8gYQtGXwCkjXqH7IbW99fNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A20CD1F00A07;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488378;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HRgTrpmF9HXWd/vcSrMg48KtDwCnA/+YJVRqaBT7O6/Rr8ORlFxEXkSrqpq1avpSO
	 vCv8JJEoGuAW24GKGKQW6bAa4ePi4GRXL9VA8CwOcVAocoEwpG0SZXZ8y4qXtsFLug
	 658q3tavvGzhBZRfrGzeSrmhCf7jCFKPq1YMyEAHQ2gSSS7DjxOk0BqNlMs46yHkJM
	 lu9zjucGZLdTmaxfOyZb+41AbE2gW2nXqjaOUuJiTmWb5YY025ITm7OnXzLe65oz8y
	 1ylimhnIHk3TAQAowLC04hvv7y3MwSOqdGR0mdO/nIGQxlTAxLuFrUUMvHGWVDy95O
	 aJoIEs6VfAKlA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 175CD4949B;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 07:59:35 -0500
Subject: [PATCH net v9 1/6] net/smc: bound the wire-controlled producer
 cursor to the RMB
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
Message-Id: <20261112-b4-disp-0287c16e-v9-1-e5e8fa688177@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=3046;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=9ja5JoT+O2VUsGXhvlsOd1Bx55l6YLeZkBRApwlhPSc=;
 b=BK996OxiMePiy0poiokFLsk4hlFCtR1AhzXkg4ZUawq4cbA2Jttg3YCn7cT2pGbopacW6AxC+
 wmlNjg+qlIYA+XT4dcuD3rV80W3jSXD8nRYGAtI+soEvQXMLExk3Jqk
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

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


