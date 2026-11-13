Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794529975;
	b=37kVcfplPjEJ43R6vDS/EmEDZpRGp0yB82ajw9oXaIeg74FX4W1kaeMf+Cx0VeaFubp4
	 M0tf/fbr/OnypUlK40DLjKPGhst3W/P46gN2Tn9CHv9CbEt9n0GWquZcvkCIlCJZ+F2Va
	 aLN9JGqK7T+uFAd6XX1pUtzUhTSgXqLjpCNuaoKOjHVnSU5XVwy+INHStdL/Eqr5DvKyX
	 gLUJxOGtxwxRqhEFVwNufMLLJUl/yr0kv9IyJUCLsQRk22eBIyqhyAaxjNyHHys3bc4r6
	 qoPr88KuufO8yIBWeqCa5ZmoUNPNlMGntN9iGktl5G8sXOcGASlgJfjH6EVtcGcQ8eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529975;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SYf2QT8mXgitJrAtfBYV5ej4Bnof56pnlLuqMVHVyEU=;
	b=A6+pbJUF2rWpKNBlWgUy4PmyrUG3nTyvPtr4o0mT9I2fzDbb3BxidvyVeWOgRopJtG2e
	 hRmGsleo4pjasS9uPvqY1sfik5XhktcShMp21lenMC7MsMMfWAi8EuIE45DaAfUtoFSW3
	 ZSenPGUbTc42bWEQPES2UGfvRauCH2qMSBDlEocQ6bwNljyEgnw9sm8P+ayDMi+sixUzL
	 EtItDtmwlcfz51Qjhet0+t29/kGYQLbxIQJ/t5U0m0peMcEu80PtzDkuJ0km76P+DQDej
	 DxiSFZHhe4a+wSiQjBLGDRDsLGZMCGqahRDd9qvo9ZFXmgTrk3ekr+HzoTDTVycGuzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WN1z+kDD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF1606B7CA;
	Fri, 13 Nov 2026 00:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WN1z+kDD
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794529975;
	b=mBW+4vNT4T8ZkLp5RLDa+XomZOpsnIKHUE5Q2BwEFUPWf6tCV2Y/E7bAbYeYrFiFV3Vl
	 nwidZ/N6gFt25qS87JOHqnq/6Ow19QZgniPacxmcBPvMklDY+jWijnJuBJh7LWP8xaewH
	 rVH9OejQVINt/ojJX5XMFnSeN4xWCArASNbPCBUpOLy6HmE5dSaYj1wCZgJAm9goILtjl
	 e5AHo7r9IfUou0VCL5HIToZv2rEw4ai8VyOIcHpJpHrBNOmHL+HqCSAmpvwM5PRvVIGHS
	 EpfRp1UAvt31JQ1EKUoTQXT5gdskwKivFX4HC7WxKR3wqeHYWMQoMDrpe4vGVIDnU0Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794529975;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SYf2QT8mXgitJrAtfBYV5ej4Bnof56pnlLuqMVHVyEU=;
	b=PIk87AyJE2eqXhZZpUh9NkOHJWz0+UPSSBkOuT//MPTX7/J1tRP2kRYdGz3yW30cPFxt
	 ikRWrRilgEENNL0I8LmBuitgg+VAoC3oeV/ZzPJ/Ko5Rx0xNKn943G6gApBOmndvzYfc3
	 ndNxh0vYrpAuU90mdcuKzhdkV05U84miRb9pOuBYctgiYvOyfMvw24t/jKGuNQC+uIypt
	 6MlMoZqTXlcYwi+l8s4n1vsIqwinm9+aQFaylfHtgD/P/ySvUUArBp7JhuGbaj+FNS1lW
	 ZrfYqVT62FRDF2GwpiDmhrPHy3GN3jjcFj1CTeXB9duuGamfVgrBo7LT/dJu7HbX1uw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0569E1F0092A;
	Fri, 13 Nov 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794529975;
	bh=SYf2QT8mXgitJrAtfBYV5ej4Bnof56pnlLuqMVHVyEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WN1z+kDD9dJiM4sFSKLrHjwHtXTEs1Ea/PH5iCIFx5fcn1zpyTTgVXRi/GZ2GtlLH
	 0nCoJWkI+ne9Xo8QE7V9iVUq5QebqAc7OHWKz9vUDuTn2palfusZnthxPYdyY3MqTm
	 yBL5ikZCY8FH3P4VrTJiGZIoHwUL/SHPjEoCdX7hVaim7M+/j2NBnmXftjyFbb8ayT
	 1aiYTWpScLcJx9hIBSTT1dxUl8wE8FAFsq55OLki8Ol0ZXZ/7T+7EpmffRh8ChYeNJ
	 0XObh+Gtf7YB833NtPVhbWC1HE6Vmfp+GZbfCFB9SHH+mABQ69obFsmVxvlJXilnTm
	 LlXMCvmMuYQ7Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6C23247569;
	Fri, 13 Nov 2026 00:32:48 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 19:32:48 -0500
Subject: [PATCH net v6 1/3] net/smc: order the CDC receive path against RMB
 publication
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
Message-Id: <20261112-b4-disp-1c8d3a53-v6-1-36a38ae35021@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794529967; l=2887;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=2rv6B0D/pQPP0IMQU/D54a72ysNQDMpYUG+Lt+SivGA=;
 b=sgG6hWAl3Na+CyT1IqdbjAOCV7bhuNGI1OMumuUojRDCCkeZ5m7U2H/FgLCvK1TGhYUIoF/PX
 CrLBKzcQ7rnAOs6QSYNwpp/Xnz5xDdHY7tKHkBFGTKGOJZNuLS03WFV
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_conn_create() adds an SMC-R connection to the token tree before
smc_buf_create() sets conn->rmb_desc. Tokens come from one global
counter, so a peer in the link group can predict the next one. A CDC
with that token, arriving in the window, makes
smc_cdc_msg_recv_action() dereference a NULL rmb_desc in softirq.

Set rmb_desc with a release store after the receive fields that go
with it, and drop a CDC in smc_cdc_rx_handler() while rmb_desc is
unset. A conforming peer learns the token only from the CLC accept or
confirm, sent after smc_buf_create(), so nothing it sends is dropped.
The SMC-D receive tasklet needs no check: smc_ism_set_conn() publishes
the connection under smcd->lock, which smcd_handle_irq() also takes.

Fixes: 69cb7dc0218b ("net/smc: add common buffer size in send and receive buffer descriptors")
Closes: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
The Closes tag is Sashiko's report of this window, in its review of
v6 of the cursor series. v9 of that series is at
https://lore.kernel.org/all/20261112-b4-disp-0287c16e-v9-0-e5e8fa688177@proton.me/
and its 2/6 conflicts with this patch in __smc_buf_create(): keep
its rmb_len store at the top of the is_rmb block, before the release
store. The tree is the same in either order.
---
 net/smc/smc_cdc.c  | 5 ++++-
 net/smc/smc_core.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 32d6d03df321..ee5ba6c7a5b4 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -483,7 +483,10 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 	lgr = smc_get_lgr(link);
 	read_lock_bh(&lgr->conns_lock);
 	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
-	if (!conn || conn->out_of_sync) {
+	/* The connection is in the token tree before __smc_buf_create()
+	 * sets its RMB: drop a CDC that comes earlier.
+	 */
+	if (!conn || conn->out_of_sync || !smp_load_acquire(&conn->rmb_desc)) {
 		read_unlock_bh(&lgr->conns_lock);
 		return;
 	}
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index a3164201c142..02269cede641 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2544,12 +2544,13 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
 	}
 
 	if (is_rmb) {
-		conn->rmb_desc = buf_desc;
 		conn->rmbe_size_comp = bufsize_comp;
 		smc->sk.sk_rcvbuf = bufsize * 2;
 		atomic_set(&conn->bytes_to_rcv, 0);
 		conn->rmbe_update_limit =
 			smc_rmb_wnd_update_limit(buf_desc->len);
+		/* Set last; smc_cdc_rx_handler() tests it with an acquire */
+		smp_store_release(&conn->rmb_desc, buf_desc);
 		if (is_smcd)
 			smc_ism_set_conn(conn); /* map RMB/smcd_dev to conn */
 	} else {

-- 
2.56.0


