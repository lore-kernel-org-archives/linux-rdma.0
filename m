Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794629683;
	b=NNOomSUZXH2s11yMiZwAo+MHhk1NK4AnVLszAV/KQKsNurTlaB7f+nGJ/+VYpEAR6vZ0
	 +lYvHoT9hgH7LZe3xQbHqibgPQeBK38g1mxKP4HF68lTBJ0o1ScTxr3bBNaq7vKzGdEia
	 NbFbdjScLYqtLxyx/vGjIXlpWW4Ui0hmCFv8PpqPVj0nncvJCkEDage+cW0rCXVDTp03G
	 uHpZhaD1tXq60Uz357VdjxIFZFJHyRXraalrUBVRCk7Bi6f08VHpYC78o9gX8QbFsehAv
	 QnadzCpSFtySW4AGCl+zN0nK8IhahVbigKDbJhV6CBmRunlW0pUk/DgJLc774YSBntw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629683;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CVwzZWJvemgk17AWrU0DUj2CaQ/fEJaJ3wW6uMJrMnM=;
	b=f4P/r8WA0vtXxLatooAMXGrZeSKaHy230CEM56IvUyCCCg849k3OV8eRMSadWoj6fjEg
	 6NEEfsB7bLiFcCLaYnhMiGG7sA00+0BAVlR2+xLWQJtxCAHxc81pTVDaD3GU1JD0O/U3f
	 9oQAGldq/HELq3ADprATX444iYRAaDrZgo1kNYif7hMMag8TYdGiFNn7BLPCL26G8LmKJ
	 ZAkZSYhiOor/TFMI2ShGfaVASNY9lfp+K+dOCAPtnwYPWP7F4+VDnMXAQTv0zG2FLI/Km
	 yGE8imk3lZ1XFEzh5RiWDoPk98b8MA9dr81MWPdZtrH//DZyV8Bn6hxZnk26Sgc8Hpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jszqxbfy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020C7606A327;
	Sat, 14 Nov 2026 04:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jszqxbfy
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794629682;
	b=BISghUVzUiQpkBdTHQz0AOBg1C9xHmmAnHVf85mxbi2eBhXq7pjXLB343M/dvgb9GYZC
	 kGPT6DEi4OQ7SA+YXtcYlw8e5/RwJCbHlzTPH0EymTyV5OOIx4KsGRV3NKs72ZAfyDgSt
	 k735oAIt/jyiOrNpgu7E/hHxQUdhnvg/9QzGEpNj8stMlu4JcSBptCSjkPg3VBlYUh5wF
	 +ExJuLu1pPr5lRdZ9vZ2UcFPd03UiPRdYR+c4Zbn4Sy/vVO9xggCPZo4IOIKzy2lkfNSs
	 bGci/qH/GseFiF8k590ZszmaLM23W+MKccwd7V8jfHXOb0sY2CSwRi1T9sGHjPXzD5w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794629682;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CVwzZWJvemgk17AWrU0DUj2CaQ/fEJaJ3wW6uMJrMnM=;
	b=rB8gg5tPrXqXHra8Ol2NZlVNVwR6Mgw+aBEu6/EvbF8PgtJiLQeWD4lWthYMK59UMFu8
	 8/IkE0e4sy5IWCK8lhlnnx5eXbvA9ZJskQ+9QuBP/FZjawP5T56dilJw9N7qXrvvbe0+L
	 IFwtXquMQCgCKzOIAeKQuBGKT/O246+nkeeGGfyfA7Z8JVcH/d9iwoI7wQE9zbRrmVhd9
	 g/u+V2sfz6j6gBAJHksFiCboX4es79Gsl6Cn0JVIBo3LtpoDAWO5Y422lan0CUzKKZqks
	 whJiwqBD5/xjnZmCmtAWB26yQDmXK08I+GCUwu0kXMWWvRt1sV5khFRW7z+7IVAyvBQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D5DDE1F000C8;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794629682;
	bh=CVwzZWJvemgk17AWrU0DUj2CaQ/fEJaJ3wW6uMJrMnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jszqxbfysQYyl+XtUMKd/X4Q64mOtRaV6ASXfJPxjCVKLMvdAzWGNONMAviVKKCtp
	 UUln8/TobxJsiF5ZErHTguzAGNEhqJ9jWe0dicI81ziWS8TBfxGdMVxo593SMRO+SE
	 a4MBjr0SDTnP+2zaI6mld3h77CfCdMgDNQbF24V8R/cKa4+rEE/W4ITo/u7XKjL8b4
	 GFWdQEZO+NbjN/k+ZVJABiut0xImRI54Mi5zBMUYAdEwrbLXfFzQPLw3XfQRO6ItVC
	 wTWv+oLOfkEv9mrr3GIL9hTzVWQYJKu9T0hb+Jipg7tq9dQEjIyPkPO3cIzC23di3z
	 oLwcYWfLxe6sg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6456949C85;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 23:14:43 -0500
Subject: [PATCH net 4/4] net/smc: order the urgent mark across the cursor
 wrap rollover
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
Message-Id: <20261113-b4-disp-1a9ab9b0-v1-4-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Paolo Abeni <pabeni@redhat.com>, Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794629679; l=2415;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=H0cDzBMU5jnWhuir5b0Y+uamDOQJx9v7YnLHHqnWujU=;
 b=alisxctGY78SwE7oHxLyUorWTGmWoZBmYFTPJ7GI45VR5SB/8i0kWOibNF6J7f4E+tArli1n2
 Lz/ru3MfW06AG4Oar/5Hyqm71sIY1CnsCs2ed4wib0RTDUhShCTI8WV
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
leaves out, is then never skipped, and the sender, which waits for its
urgent data to be consumed before it sends more, sends nothing more:
the connection stalls.

Use smc_curs_sdiff(), which orders the two cursors across the
rollover. smc_curs_comp() has no other user; remove it.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_cdc.h | 13 -------------
 net/smc/smc_rx.c  |  4 ++--
 2 files changed, 2 insertions(+), 15 deletions(-)

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
index 63c178c10bf1..0345167cdc0d 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -68,8 +68,8 @@ static int smc_rx_update_consumer(struct smc_sock *smc,
 
 	/* did we process urgent data? */
 	if (conn->urg_state == SMC_URG_VALID || conn->urg_rx_skip_pend) {
-		diff = smc_curs_comp(conn->rmb_desc->len, &cons,
-				     &conn->urg_curs);
+		diff = smc_curs_sdiff(conn->rmb_desc->len, &cons,
+				      &conn->urg_curs);
 		if (sock_flag(sk, SOCK_URGINLINE)) {
 			if (diff == 0) {
 				force = true;

-- 
2.56.0


