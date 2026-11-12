Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794488378;
	b=sElGGjVQYexDkWjLaHQnMAcJtaIGuLF5HnqGcUSIOkZd2nDEv/LM1WppYTTKbOuBDpn0
	 GrouOejQ625n2z/SoixrfbXeko7IKOzG70ZyEJ76OKYzWZPBFv2fKJIIhQ/xnKwVSORPb
	 K7c6BeRzpPyZ312K+XA2ih/ubMr8lRmQBWapc2DbBArnmhhRu+HRcLLTra+f7jpFWMJWH
	 DuM65jXc4EQCB199Aw8buyW7+ysqYv8xo49mr3ZJecJGBraUiPgMtAs27EUCgK+0FYOTp
	 YSAaC2hGHpv4C4MeA0zu9RtjjEWx5qaMMyzQ1GRqcjeJWOnHGvIyA8KunA9BHJftI2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488378;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0uShfIg81iZJK8hhCnfJcApGKUqA1kN1Jqwh/hJXTls=;
	b=J0AMdrY474rE2zgM1V5PHxHVmQCayIJ8bRz2bbu9/JyWnMEfTS/J3XeecM1Kh4nD5xvo
	 bpz9l9HfJkFNy4er2f3oKpniMFzpyEmwxInYMYg55pdEPpZ7jzuRdig+Ap3j8Qif+JPM6
	 orbNc5jA97CEeMwpcPqzpCjcs3XyeDsLYylENXbhijAm6/gByyBctGo/cfI3MVAfC3IZc
	 fdpUdw2Kot45hQauI4M0u15vYmHIHudiRv9SKfujW51+ztuOX9dEzJPprAGsKbjdnIGZZ
	 Eyctvq9io+dofa7wiQM9CueRit1nimVQBhsJr6CsYmoATwiWliRlIVxyblD1glw7xeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHuYVq4a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E45606A336;
	Thu, 12 Nov 2026 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHuYVq4a
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794488378;
	b=a+HdZ8y+a8xtpgiV7E6pjBL6MQfLeuXDLd+uZ/gT98Z4lFkna+jFCNNGFI+fBm1IV51A
	 e6Up0nuPrRvbsTLy+stfIPrACP1TRnDQ5lgeu7RrXzavCrx41Y+UB18Qmiez41WkFGaVN
	 5q4P5iwgFNAYWYAA8XJyFg2FjmUTI/EVUoUTIqg6FtgOjx5piJjN5CKvBxibzoMBqmF++
	 mCzExXPMIsJhS0hSS8uQIfku6VBn1AFyBHWJO5zLg7o3gIjzI2315+XfkeUnp7Dll5sDU
	 jtUbo5k9RjncZ1BDSFB3e5vDI/yTGGOg7AZcpaO1ZaCtBVW8jw5PDDcCbQok/b8ORkA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794488378;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0uShfIg81iZJK8hhCnfJcApGKUqA1kN1Jqwh/hJXTls=;
	b=TzPaR3D5Au+1oIWOR9gjcu+F2ycyR0AsKchUAztt+A08M15n3tP5spCLxfFrpoy41Unu
	 N0Lt5bZhHXeshzoUjh41ZOHIloskS62ma0EZgknyUU8Lf0+dl8pBbrpd8Ox+WKSQk5Q4I
	 e7UGOyqsTcoQI5HdU7ilFIAXGrSEHqADTtl9ayp8S4nO95u7EDNiv2kdpIDV03jk0mZ9+
	 kINYrQQQCy4gicJ8C9qaPccgkGU5zEhGCGUOPJ1QeTWTRfOfu5XUOOa9S/1AJ54DjSTOt
	 KhBcOUEVcwRuXqlIezmQK5bAGLoQ/H3FONO4NVidNVcmY06KKtTF5OeveQGIMpGx5fQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B37011F00A08;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488378;
	bh=0uShfIg81iZJK8hhCnfJcApGKUqA1kN1Jqwh/hJXTls=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SHuYVq4asakCW+34JVL4F+3EtPd32PguSQrsM31ldfT7jvoRMJGHKYBqc1T3kcgBI
	 WTMqda8q6Crr/7QOpNqYRmhodfqijDtDvvkqAgllqKu0U0QNM8ItGduoaqTxKir1uF
	 w0Xox64JBgV7gTP64rPu75L+APWgBhM5ogjIaODlAcSjXWyyVmaXXV8GJ3RqXlrrK7
	 hL+Qom/WXnNsF4VXRkAs5n+t4jINBQmBGE1hAb8yVvw4nRJr2cQNHCL2DgI0HfZ5XK
	 ZNc9b/eQt6mE01hYhQPWTtmg1AjVZ0rBRDNKczNNfJpaKI0qfEZf/KULEMUarlcjA2
	 8pLrze7Ww2OnA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3F26E494E4;
	Thu, 12 Nov 2026 12:59:36 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 07:59:37 -0500
Subject: [PATCH net v9 3/6] net/smc: bound the send length to the send
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
Message-Id: <20261112-b4-disp-0287c16e-v9-3-e5e8fa688177@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794488375; l=3799;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=ioWt2nFN8deKKR5Xb2UG2DAkkoZuzmKYXtUilMMIgkA=;
 b=ff6Z2RzXixcmmtuatiFKXxb3m30/JFoQZNnsf61UBEpoJoOC/NbrFVDwPQOA1qiQS2WCjCsmb
 IR12c1YbPFKDvIA8kz3zsUUVnni+GPhYA9bMmKZd8IZPNOtRbphBl22
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
values included, so the copy stays in the send buffer. The over-credit
itself is not undone: with sndbuf_space too large, send() can still
overwrite data in the send buffer that the peer has not received.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
The overwrite after an over-credit is by inspection; not tested. Fixing
the credit in smc_cdc_tx_handler() needs a cursor compare that survives
the u16 wrap rollover, which smc_curs_comp() does not do, so it is left
out here. A negative value maps to len, not 0, since 0 would make the
send loop spin.
---
 net/smc/smc_cdc.c |  2 +-
 net/smc/smc_tx.c  | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index e2c765ff2ba3..90a79a983b48 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -43,7 +43,7 @@ static void smc_cdc_tx_handler(struct smc_wr_tx_pend_priv *pnd_snd,
 		/* sndbuf_space is decreased in smc_sendmsg */
 		smp_mb__before_atomic();
 		atomic_add(diff, &cdcpend->conn->sndbuf_space);
-		/* guarantee 0 <= sndbuf_space <= sndbuf_desc->len */
+		/* can be out of range, see smc_tx_sendmsg() */
 		smp_mb__after_atomic();
 		smc_curs_copy(&conn->tx_curs_fin, &cdcpend->cursor, conn);
 		smc_curs_copy(&conn->local_tx_ctrl_fin, &cdcpend->p_cursor,
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


