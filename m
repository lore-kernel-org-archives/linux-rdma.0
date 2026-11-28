Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795875825;
	b=e4IZDvvNFqlQGNZYQn+VFc3TzFoXo/2Bjfu1YUNiLfcMbDVWxCW7iQevrvn/6dEVW71a
	 3RG0cJ3wVzwpOo+InNN8fYmgWWNFn6xdKlkJtGmtybnHFyPSxdkXkJvatQWzW2PDs1Htw
	 uzld89OFHLsaZ03SJZtEM1LEiidL6R7Kgr/7Qrg6TP7e62dXNYOCHgHHeYKGRtjpZ2qUO
	 wZefEEWuir41RyAAACJa5J99z+mOnRNd9afqYry9cxvPGS6bYXQq8vcLlPn6Cc2GbMTR5
	 xZg8RwSdGTVVkkT+YLKZGtFpLrEvaeW21S912hNWAbKCjZOQCv9iS+GuwwImtPJ5PiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875825;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6WavpcbGIkMg579M2AEaAzrW7M4pV/z+6EVYUJ9118I=;
	b=0aGscmUEXBZ29cUiysq4KkVh7NtyaQ//MFgGVoY7s8fBGJWM7qbFhSlP3Xhq3wMHA4sW
	 6JKYPsGpUFBaUBMeIhr/JNAjpRlNl3XNKemmbvHogCeOeuPOvdbP+KiHU3IKIYTC/AgQR
	 CfSD5BeXmRlziwSBk1ZRvLSyHHMNPL5W5UMi5meTDSwh+hCmLrOwmXKgoyQcIk1AiiYPg
	 3tEnBFT9PQ63dMfB4Z9cnFWHW4J99BWfgszunnjy6YzZo7UAxYBjgCGRpJNPmGVYYiNDG
	 ArLykuVb6dVrt4cP7x6/UZnasSpA+fS8VKinc2jNOlT80D8JPo/EedtTIVRgaYJmlUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpZj0qLL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C24606A31C;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kpZj0qLL
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795875824;
	b=TrAHSlsR/uVMjNlPhxjhqW1QSjYBLKS1/VDwAzYT+XGMihYW55+3qMQExOrrptKvyprN
	 eoaIHEMHJ5pR35VH/nzGlkrVZWGwJicaFiMLQvhXDJb1hT5LDG8RAa2RdGVz88rxOSlv7
	 dtVHPaw61tpQHYzRc+E7nX2c5Y2tx77hiLvZOMsJI7/W7z4oUUHNuujV9YPYxtANJ/M6s
	 Gv0955hSKJb/OLdSGxY1YQ0CJu1bxGiwCzmJiADT20SwjD5xmhA5JVcTk38JesenJf5Zh
	 c3QDkRMLKvwVxaVVofLlGQ0Cg06sy+H2HRjH3TS6RscOUlE8QBVmrosLeb8BW8RX8ag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795875824;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6WavpcbGIkMg579M2AEaAzrW7M4pV/z+6EVYUJ9118I=;
	b=FqB070GfAJDT52eUlaadblqpm8z76J45Jfa1Dbg7fQfhf18aivEZAVBFo9Tkinx3Verk
	 o17jQfmo+MsUQtT4D3LVCRO8nBz7jdq11NgBh1pLzuEOyT3qLPCY8YVc5tAt19ZzQrjle
	 LRi+uCf2O1OHcdcm+2Gi5z78qG9th7rahH3S+6ci86j5lY0TmpyDO9Hk7wlKKzvOQwa7n
	 1g5N6eYUrhJv/c2c8CQinP/MD6qw9vjoVt06oMOAC9bpOgKCZUecThsNmdtmOjcbZjtbP
	 w//6otfdYGc4KvDnUTtn7fT5nKmNAV/cWwoSxZ0WkszyfbJlgzGx5cWTFWlTYcyDLkg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 20D471F000C1;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875824;
	bh=6WavpcbGIkMg579M2AEaAzrW7M4pV/z+6EVYUJ9118I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kpZj0qLLErGr0QJOSUANO9x4nKSYmamYxK3cj40DaOm1kHpZsCQ4doTtqZyWnSPbw
	 MLfAJSZd573LWTv+xRqR6TCPJO4sJwqOTTN9V3sQSXPLs26r2CQSJHBm+Hf0159JF/
	 c0UKmA+MovbF+TaLDGlalFnLTpbH9rnOHyU0hsFot9qmXRGlYIkc34zubdb1Bl2NDy
	 XQTdop62jgjfbsSfCsGqDwjBdutaPir0tue2UY5cyMvTIpghH7k0Qpd9lR/7wa5L6g
	 ke5h7KtME5V9QKU/nOIJt6j21qw6KVVI1tDU8EabMQGL4LEH9LP+PqPjUclaFOrG9A
	 5eueTOz2GxeNg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9FA244E105;
	Sat, 28 Nov 2026 14:23:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 09:23:43 -0500
Subject: [PATCH net v2 1/6] net/smc: take the socket spinlock across the
 failover cursor switch
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
Message-Id: <20261128-b4-disp-360e65c5-v2-1-d9c05004d430@proton.me>
References: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
In-Reply-To: <20261128-b4-disp-360e65c5-v2-0-d9c05004d430@proton.me>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, Dust Li <dust.li@linux.alibaba.com>
Cc: Stefan Raspl <raspl@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
 Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, linux-s390@vger.kernel.org, 
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, Hidayath Khan <hidayath@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795875822; l=2185;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=cCRiCnC+YxlLo6QXNZaXzgExyAfy7EI8Muf90INS40o=;
 b=C6qvcvFSAcXZffJqvFJgzwgIOhyM3GxuDlJEJ0VOW/BR2S1BtzC1u/HqPJhlBQCWHcWGbM1+0
 6n37hGBM5fGDIdIrDNYrIy733Uh2tByRn+tBjxQTWVCaERWBxIpJEh/
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_switch_cursor() rewrites the send cursors, sndbuf_space and
peer_rmbe_space under send_lock only. smc_cdc_tx_handler() updates
tx_curs_fin, local_tx_ctrl_fin and sndbuf_space, and
smc_cdc_msg_recv_action() updates the peer's consumer cursor and
peer_rmbe_space, under bh_lock_sock(). A CDC completion handled during a
link switch can credit its bytes twice and leave tx_curs_fin ahead of
tx_curs_sent, or leave tx_curs_sent and the producer cursor out of step,
so the resend writes at the wrong RMB offset. A CDC received at the same
time can be counted twice in peer_rmbe_space.

Take bh_lock_sock() around the link change and the cursor switch, in
the order the receive path already uses (the socket spinlock, then
send_lock).

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me?part=4
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..73e86100e6db 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1171,11 +1171,18 @@ struct smc_link *smc_switch_conns(struct smc_link_group *lgr,
 		/* pre-fetch buffer outside of send_lock, might sleep */
 		rc = smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL, &pend);
 		if (!rc) {
-			/* avoid race with smcr_tx_sndbuf_nonempty() */
-			spin_lock_bh(&conn->send_lock);
+			/* the CDC completion handler and the receive path
+			 * update the same cursors under the socket's spinlock,
+			 * smcr_tx_sndbuf_nonempty() under send_lock
+			 */
+			local_bh_disable();
+			bh_lock_sock(&smc->sk);
+			spin_lock(&conn->send_lock);
 			smc_switch_link_and_count(conn, to_lnk);
 			rc = smc_switch_cursor(smc, pend, wr_buf);
-			spin_unlock_bh(&conn->send_lock);
+			spin_unlock(&conn->send_lock);
+			bh_unlock_sock(&smc->sk);
+			local_bh_enable();
 		}
 		sock_put(&smc->sk);
 		if (rc)

-- 
2.56.1


