Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773243C1088;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791439962; cv=none; b=iwtg6f92dfKFwtFlbkdl3XijfaymgkwYs1j1IBt2ZtZyF1t5G/2uiR3rrvEhuCGBi5uO6afLIqoLO2omgNz+vEyW7AP+WQq15+PZmsQnZUvwag9nYPMzwT+imHsetMKy3E11CrPDSGzod51NG7aBs5FR43UErlz+Y0/GTp8T0KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791439962; c=relaxed/simple;
	bh=9sb3j3MlhI0GXEAtbssH32/WOziSoMeZuZFq9cSq3U8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZOeNenaI62UaMNIusCvfkeBzc5gYoox4yAFH9T7SnzFibs5ldAdmSbBTP3tXb+cqhD/9Eub20ulf7rdmxqKoe1FrUAwncqdKrnVS1NM6Ie85PNwtM+0JHIt9m4PXH+tf/Mf6u7VCBuj6CnOTAAXVfoIHSRE1nCurHSYXzJTJL4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m9cCiZHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m9cCiZHr"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25D43C2BD04;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791439962;
	bh=9sb3j3MlhI0GXEAtbssH32/WOziSoMeZuZFq9cSq3U8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m9cCiZHr7TZ4cSMR2s0tnX37zsuQRn/avwcmGmQZGHIhmZd1SbJSc/dVUTsUDc52y
	 SUCx1iHIK9RGbBfP4cqe6mgYy4ByfVJjeOJZZdh+mVzEvw/ir8b4CdbbVXWyeIkFX4
	 w3pbYmMmIjK8zGhwatbsKBS/3bywnQ4bUAapOFDHQ5CaufTKuzREiW1NRxY5pGuLPQ
	 4IwjobXutZfXOV7niD9EDGmN1LXTa/imJumO5HnXZhTJfRMPrZS75FuhegUrrP/9mz
	 BL6x3jqKTQJ3/Z5e/49CFp9Dis2I7U0lDfyVAy3qo4sQ+j85coxJjob+36ZzuI6H/C
	 pqcAlmziF05OQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084AFCA6007;
	Thu,  8 Oct 2026 06:12:42 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 08 Oct 2026 01:12:42 -0500
Subject: [PATCH net v6 2/3] net/smc: bound the receive length to the RMB in
 smc_rx_recvmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-disp-f7cd3d96-v6-2-fba616c0920c@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791439960; l=2562;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=8XnjAPiFNgdxFiS0DFFOhcMxeDcy1z+lQn/0VQ9GuIY=;
 b=7I7kwu5NazfzNT6J+sdQKH/rCbJKAYALX6Kh2/y9XgWtGogF+WOYCotdJ7zVI5v3xtQ9kdhGJ
 xTPyJKcNHT/CR0wSYh/fIIcDRG4C6f9qHCGOkz6v8ULmVAaqID7qj48
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

conn->bytes_to_rcv is accumulated in the receive tasklet from the peer's
wire-controlled producer cursor via smc_curs_diff(), whose
differing-wrap branch can exceed rmb_desc->len; a forged cursor drives
bytes_to_rcv past the RMB, and over many CDC messages overflows the
signed counter negative. smc_rx_recvmsg() reads it as the readable
length and does a wrap-around copy whose second chunk is not re-bounded
to rmb_desc->len, reading past the RMB into adjacent kernel memory and
returning it to the receiving process. The nearby readable >=
rmb_desc->len test only feeds SMC_STAT_RMB_RX_FULL on a separate earlier
read; it does not bound the copy.

Bound the readable length to rmb_desc->len at the consumer, treating a
negative (sign-overflowed) value as out of range too, so the copy can
never exceed the ring. This enforces the documented
0 <= bytes_to_rcv <= rmb_desc->len invariant where it is race-free
against the producer update in the tasklet; conforming peers are
unaffected.

Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
 net/smc/smc_rx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 197fddc6271f..f781d7229185 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -442,6 +442,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		/* initialize variables for 1st iteration of subsequent loop */
 		/* could be just 1 byte, even after waiting on data above */
 		readable = smc_rx_data_available(conn, peeked_bytes);
+		/* bytes_to_rcv is accumulated from the peer's wire-controlled
+		 * producer cursor; a forged cursor can drive it past the RMB,
+		 * or overflow the signed accumulator to a negative value across
+		 * many CDC messages (which a plain "> len" check would miss
+		 * before the size_t cast below turns it huge).  Bound it to the
+		 * RMB in either case so the wrap-around copy cannot run past
+		 * rmb_desc->len.  This enforces the documented
+		 * 0 <= bytes_to_rcv <= rmb_desc->len invariant at the consumer,
+		 * race-free against the producer update in the receive tasklet.
+		 */
+		if (readable < 0 || readable > conn->rmb_desc->len)
+			readable = conn->rmb_desc->len;
 		splbytes = atomic_read(&conn->splice_pending);
 		if (!readable || (msg && splbytes)) {
 			if (splbytes)

-- 
2.56.0


