Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4D01F12F8;
	Fri, 24 Jul 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852608; cv=none; b=PXphK+T84lF7KNZRyCUTrc82BJJ39Rc3lxtsoxzUOVAp8iLmudsc2CDKrYW/MB0XKnfw/Wb0ULLi2jnkIc7v7yBFvJVe6lxIY1Ae8EjZsENP3YIUsH+ia2pMBm+emd/OR5U3f4qwCN2dD6CRZIDTYufyDZ4LN48JFbwAws/pGCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852608; c=relaxed/simple;
	bh=wtIBtTyP/+rwa75zuMxIQgpfe6IECDYlolre7EIzHWY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=I5p/axDkWIyoyNOys3yJ4vTXl2W0gs0jZSbk+AVErJZe5+0bdw5Jv45QdruMKOAu517MYzPNDeH9VU36j8g9vgfWOF0/+ekvnAnUUXiDfo8sH6MtJIEEgm12GKu+RhDuWmq3GEAuKoFLPz0ADkvmJJ4uX/TLvawc7px5/8UfHzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TetauBhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TetauBhM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD3A5C2BCC7;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784852607;
	bh=wtIBtTyP/+rwa75zuMxIQgpfe6IECDYlolre7EIzHWY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TetauBhM7nd3lLfgT967nfKOdpNvFizey+JP8P0Hoy9uh9x9U0UPnI9Zqnw3yjAsE
	 NSeQ043mFMVYOtZzr+v7Sm6thnl1KMYmZQ+gpaFVjqKfTnRbzt4PjQ/mxTdJgLUc4i
	 B+yi2Dd1DvhosRnwNRZs9ndxRW8XRdjZI9smFU8/gU44DMOVNfyjy1s8D9qo3Q5KQ1
	 wWcOnkf5yMM78quTL2yq3mD9jBH5QOmS/B2do2nkueWczZ+acjDOlK4bp5nj791mye
	 XEtmHAF53VxUBq0O5JZrlJ08dxDhZ6r31VWtsGQgq+ZsKzceYOac70r6jHMO952MC9
	 G8oeigE34MmZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE884C531CC;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 23 Jul 2026 19:23:28 -0500
Subject: [PATCH net v5 2/3] net/smc: bound the receive length to the RMB in
 smc_rx_recvmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-b4-disp-0d07164f-v5-2-6a9e235dbc4e@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784852606; l=2495;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=zm+DwFi/hrFlsMaixwWDBBXKLevUgGKVa9KJqBjGNh8=;
 b=1jKt0ih0NXm8Ad9+veJJYvSZ2OkqjzWmQHosnqe+bTJKHQ2WmWBmNifIbvfTRWtCWE3fZQgP8
 mWwjS5BIA8kCL2hQWENk1XVnk/1MFhjx8IuilEXmGOS8QqRffLCF1Nm
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

conn->bytes_to_rcv is accumulated in the receive tasklet from the
peer's wire-controlled producer cursor via smc_curs_diff(), whose
differing-wrap branch can exceed rmb_desc->len; a forged cursor drives
bytes_to_rcv past the RMB, and over many CDC messages overflows the
signed counter negative. smc_rx_recvmsg() reads it as the readable
length and does a wrap-around copy whose second chunk is not re-bounded
to rmb_desc->len, reading past the RMB into adjacent kernel memory and
disclosing it to the peer. The nearby readable >= rmb_desc->len test
only feeds SMC_STAT_RMB_RX_FULL on a separate earlier read; it does not
bound the copy.

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
---
 net/smc/smc_rx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index c1d9b923938d..f461cf10b085 100644
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
2.55.0


