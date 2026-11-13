Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794529974;
	b=HBJxnJvyWQhXyE1CpISh4gzCtSty7WfDRuyoUmxEPVYETImU3UYdiFU/hcf/OgQH+MCM
	 5IZOkHekAaTuNNLSNEi01KfE6flctKriZ1uh+y3oXVpAawBArpxG2WkpWwPOBju4i9UTV
	 WBWu1Xc9dGf3BA1LPDyoZNjnnsbLsVl201D/3tKkBYvIClqMjpnw0U6AA4/eO0tEJ8uzv
	 xnd8oOGon4pSD1ouI2PRM/P/qaZKyhgCaRmwqM4B0c9YS4QOChdO3aJcPYCH3Favg4v6r
	 5+XG86rPOjmz0ktZo0oy4kmzL2128JFVEk25p2eU5l/bC7jG5hRaUI9G4g87qHYSE/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529974;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yYu0eY1UZbsMmMAOZmc2pDgF48gbMDmIGtbneONALR8=;
	b=DdVVjxm+cIZHq2IBoVVjfE6FsOoUP9ScS8BkUSO66M3hObldSTdmWG7VTxpzsdpXckSg
	 q+9/wa+g+AJXa0blW1sYNJkyCF97bdEDWDarCbex4PvmVp3ugLIxm+TMouvNJqgRQ60zB
	 ayCQunmcrpoF/YqwEPG9zwBkbPEPbFABP9I46YecX9+rGcGFtDCGbqg9h7oYv/mRHxqs8
	 /mXT1VovLacO38zM92vnzWl+1MR8jh284TZoUcrWqZJoZLT5fXg5Hufo2CwW4K4yqbCn/
	 BVnRmOlpkqidpJ8qwJC61chQbePoUPSdFO9qwBbCPWFyCa3xG4t6fWL5UL0qyOsssPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YFfOXMr4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0060A6F70;
	Fri, 13 Nov 2026 00:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YFfOXMr4
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794529974;
	b=REdXUnsCdRwddekvuBeJo1oNirR5dTa1Lw2Q6fhGHp9FPnyoxq9IiGefuFmLi5zVOopL
	 wYWQIzr0f9UjSXwoZLq7J3taYvrEsEDmaRfo1IKoTmT80xvGxgw2SR+U0AvtfhM/8NwtH
	 B4R/NKSG56d8AozCDJhU+/lQdDR0cfEuLs6vEtmdWcmEIB8oRCAeAwTJH+42+neJlLWAL
	 rjQpi/t3SwYJV4/SrkIL8iAAXjG/lPPHqBh0be8ZtOg9wsFMYh+2/LzjNKDG3dd+j1Unc
	 L7L+QLsAB5dz3FxrhUo4kYjIl+xh6F3P0RP/m26ShgRds6u0qqd/OqS1IAF05KU+e6A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794529974;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=yYu0eY1UZbsMmMAOZmc2pDgF48gbMDmIGtbneONALR8=;
	b=VgnrsfR2TrzRcnNStSe6fd6DD5KvrUrzHG3BiQ4dE/n7nYayHNdfMl05KR/LuxJ+WSUL
	 F3d1CYkLsBGAQP0+sQg+RTNz6weF4L2UpMOKSiumFKaYe0UnTLB66T4W5m7eB6U5r18AC
	 jOPcsr1F7Tl4Muow4wIwPxGuEaU8Nfd0fvAlwxP64/HrLKk/asZMx2f99HzEIy7k4prBW
	 8CwL1tc+dpoF2sNnxeBxQ/ePAssTBZr7gvLQ68mWlTCztzzYZA5nWUowUaYXRVYS1PHkO
	 HUMqTz+VQYc92XmE0fJ0npotKBirVVydt3iKUbrnU1WFqaBCq5nRIO1SpLgO8M6yhFA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 230F41F000CD;
	Fri, 13 Nov 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794529974;
	bh=yYu0eY1UZbsMmMAOZmc2pDgF48gbMDmIGtbneONALR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YFfOXMr4sIsyojr9Uc4Zf08llU5lkvwJNRiwwAVrfjZSKfko4u8xyaGZtN3A2QLK8
	 q66lkJZGS/A5g1+7l199abP9/V4tOpJ/3q+cWbFELeRnSqK/WOs9y7Xt5WKNEI5sbm
	 o9UQHxzcn6Azp5E83mAoXzgjiQ3JtFvLXzR594kXMhggYbQckw+IoGK4dbcV47P2MJ
	 kogfUvETo4QBFxJ2fTpKr+gfe3LYfFKOO4blu+rPvt3D0UhSeBJtdD00UfplU9kbrK
	 cFdSG6IVZzh9SsHBoj/WZEME6PTLHcDgdMLLL0Qu3a5gwiyzBnePzW3hoPI3ert5Yv
	 yEcUm5XxmuV5w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 972764757D;
	Fri, 13 Nov 2026 00:32:48 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 19:32:50 -0500
Subject: [PATCH net v6 3/3] net/smc: skip the DMB nocopy accounting until
 the send buffer is set
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
Message-Id: <20261112-b4-disp-1c8d3a53-v6-3-36a38ae35021@proton.me>
References: <20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me>
In-Reply-To: <20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Hans Wippel <hwippel@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, netdev@vger.kernel.org, 
 Hidayath Khan <hidayath@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 Simon Horman <horms@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794529967; l=3196;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=nt/R23dT6xDo9Kn8+8jVzh2IwHUKALEJsmXM6ZDy9BQ=;
 b=HzbPDA+YBBZlmDLCZNEqGeHNImMERgtKIKu+RQ4NThQ/oEpwpqGqMSwI6y5Fx8DGQhXBMN/y9
 CcDJ+EVvKd9BvlMFFWrYRHcjBL1o1Eq60+xvoOuPJr/aJGAINtpjKNr
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

With SMC-D DMB nocopy (the loopback device), smcd_buf_attach() sets
conn->sndbuf_desc after the connection can already receive a CDC. When
a DMB is reused, the peer of its previous connection can still hold
the DMB token, and its next consumer update makes
smc_cdc_msg_recv_action() dereference the NULL sndbuf_desc in the
nocopy accounting.

Set sndbuf_desc with a release store after sndbuf_space, and skip the
nocopy accounting while sndbuf_desc is unset. Nothing of ours can have
been consumed before the attach, so the skipped accounting has nothing
to credit. The update's cursors and flags are still applied to the new
connection, as those of a CDC that leaves the consumer cursor alone
already are. The rest of the receive path handles an unset sndbuf_desc
since commit b395dd319cea ("net/smc: do not dereference an unset send
buffer on the SMC-D teardown path").

Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer DMB are merged")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_cdc.c  | 10 +++++++++-
 net/smc/smc_core.c |  7 ++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index b3bcc206efe3..4a4a279b405b 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -333,6 +333,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 	union smc_host_cursor cons_old, prod_old;
 	struct smc_connection *conn = &smc->conn;
 	int diff_cons, diff_prod, diff_tx;
+	struct smc_buf_desc *sndbuf_desc;
 
 	/* smc_conn_create() can have cleared rmb_desc */
 	if (!smp_load_acquire(&conn->rmb_desc))
@@ -357,12 +358,19 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 		 * peer RMB, then update tx_curs_fin and sndbuf_space
 		 * here since peer has already consumed the data.
 		 */
+		sndbuf_desc = NULL;
 		if (conn->lgr->is_smcd &&
 		    smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
+			/* NULL until smcd_buf_attach(), but the old peer of
+			 * a reused DMB can already signal us.
+			 */
+			sndbuf_desc = smp_load_acquire(&conn->sndbuf_desc);
+		}
+		if (sndbuf_desc) {
 			/* Calculate consumed data and
 			 * increment free send buffer space.
 			 */
-			diff_tx = smc_curs_diff(conn->sndbuf_desc->len,
+			diff_tx = smc_curs_diff(sndbuf_desc->len,
 						&conn->tx_curs_fin,
 						&conn->local_rx_ctrl.cons);
 			/* increase local sndbuf space and fin_curs */
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 9ef9019bc497..982cfc79ee1c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2654,9 +2654,10 @@ int smcd_buf_attach(struct smc_sock *smc)
 	buf_desc->cpu_addr =
 		(u8 *)buf_desc->cpu_addr + sizeof(struct smcd_cdc_msg);
 	buf_desc->len -= sizeof(struct smcd_cdc_msg);
-	conn->sndbuf_desc = buf_desc;
-	conn->sndbuf_desc->used = 1;
-	atomic_set(&conn->sndbuf_space, conn->sndbuf_desc->len);
+	buf_desc->used = 1;
+	atomic_set(&conn->sndbuf_space, buf_desc->len);
+	/* Set last; pairs with the acquire in smc_cdc_msg_recv_action() */
+	smp_store_release(&conn->sndbuf_desc, buf_desc);
 	return 0;
 
 free:

-- 
2.56.0


