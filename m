Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772923C09F7;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439962; cv=none; b=oI6R3rmRoA5Qi+rOHk9foIZG/dzdd2pOKR8IgsA2lz4jJUThGiojRLipRei+vYKw2+BMd6T9zP0i6DMryVfWej0Wvz1oeQ57xq3x9GxnJodeQYQ/5tZ2n5SP1GRdk38H0ad+RmqDJmqYxzC06BGNwW8biOw9Tsdgavbgra4ncwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439962; c=relaxed/simple;
	bh=wVgw6MgnqhuAqJzcIMxhEvWHWG4MGEqnFpCeqww/sno=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G3uCimY9bvZ638t1RK+Xkm5djSbC0ZEIG29qx8g9kvo4kLJmwrRQq4FEt007t1m0hFCI1awSM015pmfpazQo7nTQObJ3n98K7THXs/zowbZaK2d9gfEsPoomfNhGOqyVhVuutOPOaegS2YqXjfBZap72Nu9U4elbMeRjPoIPen8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLkzRBOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLkzRBOo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E5C5C2BD01;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791439962;
	bh=wVgw6MgnqhuAqJzcIMxhEvWHWG4MGEqnFpCeqww/sno=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KLkzRBOodR/YiN2jd7umarEyyVRTDm0o9sKOE2yAZxIlLApth6QdgG2HlkHLlEMR+
	 WJn5Qjf9rg5AHpXHLsXEaJUPq0gKmUHveddRr6gbazJFrkRcml4QNKHkDhwKNQeWy1
	 +nmf/q9ZWV6Rdtc+0L3I1Ku/JpK4qs8vgPKM2Y57tSoJ7Jmqlnp353hJMZNqkFTvPE
	 0az7OGHfZRBSq+dA7M0vjuhNBZSoXZQUGEtKn5+n4Y8+jhwgYXNcUgyK1Xo9b5M0St
	 hWY/8WXTkq5QxqIrnWaOgV9jP5nBENuKAzIUcgVzgl1xwKQrkoHTU6gHzvddXXVGg0
	 /LeQuHDSokQ1g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A201CA600F;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 08 Oct 2026 01:12:43 -0500
Subject: [PATCH net v6 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-disp-f7cd3d96-v6-3-fba616c0920c@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791439960; l=2713;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=+UWz4RnbsfnjdjjNnL0rN+svl5IB0IA82htmZazO1pY=;
 b=HUrVLlQ+khCgaX+3tcihGGm2d+//WvKJsK2f8aYHOIwdGJuGxm2V9VX98NBPUtxrT566CP0+R
 Mvgv9LSjiVuD1vkNZJ1NUUETjv05rQ0ubGQjadyI53whn3IUpQ1RvVV
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

On the SMC-D DMB-merge (nocopy) path, smc_cdc_msg_recv_action()
advances conn->sndbuf_space from the peer's wire-controlled consumer
cursor via smc_curs_diff(), which can return more than sndbuf_desc->len;
a forged cursor drives sndbuf_space past the send buffer, and over many
CDC messages overflows the signed counter negative. smc_tx_sendmsg()
reads it as the write space and does a wrap-around copy whose second
chunk is not re-bounded to sndbuf_desc->len, spilling the local
sender's outbound data past the send buffer at a peer-controlled
length: a heap out-of-bounds write. The nearby len > sndbuf_desc->len
test only feeds SMC_STAT_RMB_TX_SIZE_SMALL on the user length; it does
not bound the copy.

Bound the write space to sndbuf_desc->len at the consumer, treating a
negative (sign-overflowed) value as out of range too, so the copy can
never exceed the ring. This enforces the documented
0 <= sndbuf_space <= sndbuf_desc->len invariant where it is race-free
against the CDC tasklet; conforming peers are unaffected.

Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
 net/smc/smc_tx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3144b4b1fe29..5916f02060fb 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -233,6 +233,19 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		/* initialize variables for 1st iteration of subsequent loop */
 		/* could be just 1 byte, even after smc_tx_wait above */
 		writespace = atomic_read(&conn->sndbuf_space);
+		/* sndbuf_space is advanced from the peer's wire-controlled
+		 * consumer cursor on the SMC-D DMB-merge path; a forged cursor
+		 * can inflate it past the send buffer, or overflow the signed
+		 * accumulator to a negative value across many CDC messages
+		 * (which a plain "> len" check would miss before the size_t
+		 * cast below turns it huge).  Bound it to the send buffer in
+		 * either case so the wrap-around write cannot run past
+		 * sndbuf_desc->len.  This enforces the documented
+		 * 0 <= sndbuf_space <= sndbuf_desc->len invariant at the
+		 * producer, race-free against the CDC tasklet.
+		 */
+		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
+			writespace = conn->sndbuf_desc->len;
 		/* not more than what user space asked for */
 		copylen = min_t(size_t, send_remaining, writespace);
 		/* determine start of sndbuf */

-- 
2.56.0


