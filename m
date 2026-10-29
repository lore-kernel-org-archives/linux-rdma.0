Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793298086;
	b=b+XACl41bbExLgcywM2gLa60Um7v6hTq6gHIwwdOs5K5s1f3K0OVnsxJ15q1mSTY3917
	 RlXGd62/KP4HjYeCsqcyPOHWmkDMrY0OWPDSRxBoKR7S7TZV84S6JKCkh6XkxYFTwZ3zA
	 4A+oTnBJ0UCSsIyzRlocS+ugkIE2TurKzkt1u71TvicfWIh1rvtXUc10/TV1ZSO/PC9P5
	 tHN+EuQvo8M8qQv57RYkR0Te700zy4+Pd1tnTKvO88wAuN8urb3tiP4I+YRAXosIWY5mT
	 sNQX4WU/m0c0PUuqAw3a/VajbBpEupG1KhjXYhEEGPHqY9a7QET7U/uxBQNRtKy9J8A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793298086;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=AYDsoERcoT8Z6CNBTHNA2asODH6ec5e6x0nABwyYthI=;
	b=F5DySqwy9VOLzkiz7TIwcDaPqKMUMP6SBHS+gionASIoIt7sO6jyeja+rQL7pLwfCP48
	 B3V378lfihDOIlNjgNVbK4nizjpbUzAfsMeFK0Kh2qduIEU1PEz/oje7kYQFwXb2vQlGe
	 nP1riNkQK7YLXia2K5I2w5JmXvzXLFyr/PmJZuZYbeRruUUuRjmgR0gD8pNSjVLOZY9v/
	 whDgVwylt5VUEKnlfCRNiqkd+oWj0WCIB7cXbVyydb9MEKxrYQkDlXpQbUxsR37V1nmsD
	 Ml4hqreUCzi7hokrBVet+nHosA9KERWsE2BajatJ7x/tilIPnuT0MjE3nNC8SnggZsw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z28f6gxw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77ED606A32D;
	Thu, 29 Oct 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z28f6gxw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298085;
	b=hdKZPMMS3dkiWxsSZEqYBRxH8cvzIsYZVtVmZyBCq7J5VjQSbANV+7QNpy37XLip9dnD
	 /tje9vW9w1sxo5MB2uH5AsE0cbOQH+dXxV/+vrWzwssAcuYc8TjNh17YIq6+tc+h+3Bgh
	 ZcmOnE0rIn6k4C9RzbGIKo5JY/YYUDkiTOOe7b71cO6HSDU3sAj24T/uRL0F8dRgXqwwp
	 NonClec1uvd3RvHXlBxmTzMT0n11lseSZkuw7NuRIecgTFG2AJDyNIunt66yZbaoNJv/J
	 MLdUzCOdIhzUPck9kXghNiB1eMdp7wvVgPfpNWcXrRxgAY4X8yHYjLFH7ydsQ23NBFg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298085;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=AYDsoERcoT8Z6CNBTHNA2asODH6ec5e6x0nABwyYthI=;
	b=VThhVw/5iJvW+BhJLeE0Q9tNZwNiZaKplNk87si+4scd6yFt1B6JJ/kqMLOrHpTg4l8G
	 qHJkXhXaZEAsCpfFxnLCf/1rLmKxDzzwOoeJmPtPafeRRVOwMGvDhKq14GtD94CGCyehM
	 HK/XztfVVEHK3Cxh7U4XXTPUOqnhu/fquiKjYod9AfhSAUrqx/26ySMkc7D0ddfVZ8nFY
	 rh8XlrPBq+QLmUgoCKPO23YseP0cyep1tFu653VSj4IyX9p3vgc6hfN0MLs1RO8opGrR1
	 uJ8VQ4sO0gK87YKVaC5Th/AXipfWLpJy29tMORWRhqrAb+lFVgSTl9VYVB9QaRbaRvA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4FEC51F01828;
	Thu, 29 Oct 2026 18:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298085;
	bh=AYDsoERcoT8Z6CNBTHNA2asODH6ec5e6x0nABwyYthI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Z28f6gxwRkNKvTex3Ld0G3F9Mw12vHzXBZWwj6ObBbaWz5Ui9/KjrSh54e+6anOq+
	 BC9cz1tTy8DkT6AAOK1Dgc8AYVQLCwv7itYWr3/d25Ml10wXrSEnJ9Abahpd5XyBEq
	 sk+97CAmsOuVrEmKD7dinKziMgrUjPmt+yZDeeB6iB24vgkz1WHxOTCwqM14oHeG7e
	 HB6NWBUcX6HggYk5FXCga+Tyga+lLDNlxtWzvdVnm2pmS4avvF6WrUBrpvaniWU2zo
	 0bUjAWdHnyBqvbfV3voZ5B2qy/R6vSCtFLifoD8ODmB8cD2QJBsDMn1VaG2t+ovUXk
	 TFIQK7MCFm2uQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CA89A4594B;
	Thu, 29 Oct 2026 18:21:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 29 Oct 2026 13:21:24 -0500
Subject: [PATCH net v8 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
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
Message-Id: <20261029-b4-disp-33001ace-v8-3-f9bb96e17827@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298082; l=3138;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=26qbT9a38XGyiyM4oXQL952q06VzFo3/aGCQruMi0r4=;
 b=9ey81+952ylbo9cm0EdcOIChDoBiFgXOq8AjHV7KbhzIeQmUk51J2iSFqYDgiX9mjWCmvIrwf
 loP2ZMGEV3iBRswNO9MrwZMIQZlaFg0brt/dCbEx5gVkZdXE7WscYzg
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

conn->sndbuf_space can run past the send buffer. After an SMC-R link
failover, a late completion from the old link can move tx_curs_fin back,
and the next completion credits the same bytes again; across the ring
end, smc_curs_diff() credits the step back itself as more than a whole
ring, so even with a conforming peer sndbuf_space can reach three times
the buffer. The failover catch-up and SMC-D DMB merge (only the loopback
device today) also credit it from the peer's consumer cursor without a
bound. smc_tx_sendmsg() takes it as the write space, and the second
chunk of its copy writes past the send buffer.

Clamp writespace, which sizes the copy, to sndbuf_desc->len, negative
values included, so the copy stays in the send buffer.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
This keeps the copy inside the send buffer but does not undo the
over-credit, so after such a failover send() can still overwrite data in
the buffer that the peer has not received yet (by inspection; not
tested). Fixing the credit in smc_cdc_tx_handler() needs a cursor
compare that survives the u16 wrap rollover, which smc_curs_comp() does
not do, so it is left out here. A negative value maps to len, not 0,
since 0 would make the send loop spin.
---
 net/smc/smc_tx.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 0f0c6df3bf2c..3913ef103b35 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		/* initialize variables for 1st iteration of subsequent loop */
 		/* could be just 1 byte, even after smc_tx_wait above */
 		writespace = atomic_read(&conn->sndbuf_space);
+		/* sndbuf_space can be out of range: late completions of an
+		 * old SMC-R link credit it again after a failover, and with
+		 * SMC-D DMB merge it follows the peer's consumer cursor.
+		 * Bound writespace, which sizes the copy; a negative value
+		 * would become huge in the size_t min_t() below.
+		 */
+		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
+			writespace = conn->sndbuf_desc->len;
 		/* not more than what user space asked for */
 		copylen = min_t(size_t, send_remaining, writespace);
 		/* determine start of sndbuf */
@@ -278,7 +286,7 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 		/* increased in send tasklet smc_cdc_tx_handler() */
 		smp_mb__before_atomic();
 		atomic_sub(copylen, &conn->sndbuf_space);
-		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
+		/* can be out of range, see writespace above */
 		smp_mb__after_atomic();
 		/* since we just produced more new data into sndbuf,
 		 * trigger sndbuf consumer: RDMA write into peer RMBE and CDC

-- 
2.56.0


