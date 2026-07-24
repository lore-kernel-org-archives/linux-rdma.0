Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4721F09AD;
	Fri, 24 Jul 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784852608; cv=none; b=JO3rU8dFiAbZhFeFUIlVeTEyzkLE8lWggGW1j9/UaerOIipILhu6jUDeecSVuGm5W/EVHSu1lTt/gmdU+xgFco2oWOmk3jN6fyM5hVRfkcDsXX6o+0/ZQV4Nw8y7GVKSykv9iTr1pQ3NSFhRhg7TCsa6VOhCURUNrREosZcjntE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784852608; c=relaxed/simple;
	bh=lFbH1CCvij/4i9LKAdaYnKbFIWlJgCM95xj9koGcN2Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RzPdOHQbYxdXE2piVhr22Bt2Km8PSZlJWwlzIK1MvJyHHedqhwljVSyCNEsiZZolLYjqWkFLLvJvo8fPsFqm0ko0c9yhVzFt/IgecMqSlzHHgLhWGaPBs42b3US/prIeSl1/dFz4w+yQjNvXhg8zTbXN8n5hMKUs+ACsBTHZasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFuk8oda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFuk8oda"
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9C98C2BCFC;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784852608;
	bh=lFbH1CCvij/4i9LKAdaYnKbFIWlJgCM95xj9koGcN2Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cFuk8oda5P6rog7Fx07nz874DDh53uLOvVC84pwqQACoHA2nTknE84X296sbP1HeM
	 H/nk5/P6ta9SjBiaJ6Ok+m+f3GhP/Bs/2O9vdJLB1fnVdb7qXPgPOqJeOZotk5CeTZ
	 FbDiAC3TFdH77+qraOlnEsG7Idi/92anaKgyoigu39+mZiY5H+4vUoo4E9vRlKUcZM
	 5gBZNvALxLsNInS5dTnzIoSPppdRcVQQmk4Vi7O2OqaPC85u/KNL8xlJENvKo2KV3n
	 16A94wUqVFZ0a6PX54PQeAHQVX/EXwrLNDREkWLanj5ZvReLhE0HcfYT5D+zL74I0z
	 vQQl3H/coDVwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF231C53200;
	Fri, 24 Jul 2026 00:23:27 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 23 Jul 2026 19:23:29 -0500
Subject: [PATCH net v5 3/3] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-b4-disp-0d07164f-v5-3-6a9e235dbc4e@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784852606; l=2658;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=8C3EH0KfsseVdj0wFDorSSLeXucgic78NU8CwLD1UGY=;
 b=2mSEnlOyc3Atj5qvzKHW+F9fZj1VNtAgW6zuSNokT8fhXO1Dc3GNz0knM819b1+j/3aQmZJ3j
 FA0ny6jpKjACzMFFaf6urMjbGvgMUvxBZtZbNVMp+DGaNyEDAt5Lni2
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
2.55.0


