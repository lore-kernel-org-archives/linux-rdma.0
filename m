Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A2357D08;
	Sun,  5 Jul 2026 07:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783238046; cv=none; b=iZHXELYXtN7uiyqPakWbEZwP2c4yIhjK21nIXKtNqigboQwd6gzL5z/e2rolntA4UWEGMrU4YbZWkmq1HUM/92gLtHxEG+5U8NLW5GodVPp48PFiPsf1/SUgKHQIABiRb/ko9pDIbROtMgyClOOVaO4S7UzSdLrPgL+j3gQI41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783238046; c=relaxed/simple;
	bh=2yJZrJYlSOvTD9TMN8O7XgxA6O99PvYUYtZXpHmawP4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lW8Bl8/Xv5wZrHIid0XtAZs4Mu7eAI7kpXj6jvXruEiJnup+gLZBJiWfyq3zMoy+EVb3I228TRBfyYPSWvTgQKHnrJVJSLEN974exCDy0J7CBnBrAEcT4wX5WSYrkg/ha/73Ppi+BzIQVAXFPmBD55y9Z3uZEgaI+xlJ8TQIAGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FML+4ysF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FML+4ysF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36EABC2BCF6;
	Sun,  5 Jul 2026 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783238046;
	bh=2yJZrJYlSOvTD9TMN8O7XgxA6O99PvYUYtZXpHmawP4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FML+4ysFiW8H/Bl56urjLZpoh2QNCtYzL8YCUCngDLZjSCbvKYMZ5326KnQ4evDAO
	 pNgxJIiw/r5MGQFkN/yD/HTMrfZ2Rq0fuy2asittQj5tscXEyt96Jl0lMGW/RnH3fP
	 L+yVsNV6skw3XT8GbLrNEQsddIb7xPNUIAtKk3NmZUzg6+yEvqXiqWBrA1D0dKKNsj
	 /GruKHooZQ/BtDCIa9iqorU+L09qJ2TURHBmwTcnEsRI4PU4LYoRPDljXbYDRVCkMT
	 LrhYwyDQ0v0aUAVkueBKQeMIoCUX7W613kUXPhf5Z4kIs/l2r7mCKe6BjaI4ORV6+S
	 28qsYl44gJeFA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A14CC43602;
	Sun,  5 Jul 2026 07:54:06 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sun, 05 Jul 2026 02:54:07 -0500
Subject: [PATCH net v4 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-b4-disp-28a1bbca-v4-3-be089b98acc6@proton.me>
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
In-Reply-To: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Eric Dumazet <edumazet@google.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783238044; l=2608;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=gofZShwJohwDaGHsZ6HI9Oy7+YnKIapqK8UzB5SRSUM=;
 b=wYZ0lUVj4rs4m7pA47NnwlkJnZ1zBq1lfAkulVbUwivC1vGL8Fh62x0DUJ7cwtp/3kIC2x1kq
 eDtoT02N+ojBWl41IBJ9sTeOAJE1QpzpRi9ybnX5gCCymefhYfI+CxM
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
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
2.43.0


