Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794529975;
	b=cWpjEMd3EfIS+iNMt2A8a15iIpZSdDd24aO5Mmj0WvCb99NAlcx5SUlPHMxMIFr3m3yI
	 xuppD1bB+6K9fwjI2Qfgp734+odBH1EL4VXf91DQmuTSmV5IUUC5xLSvLatgbDxr05HlO
	 7azbtJnjUnYm+Kl95LtXZgBe7FGEWE3vwc0bVsOproyX/mo3N8XI9OI/P4wnvAhow542n
	 fUjwz3G4eiOPyPuV+qil+Rb5lXxul8XAYFt8v6ESOfJPyQzasEESq8vVrbv6Qq2IbXCks
	 3DHq8Uvi4MbiqdW2gBS+0fn8nMCUIck0xPL0sMBrG6pn2aUiPzBJTEWjdhcj8u2dyJg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794529975;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Mtj30gCYayK+JwtzXHe1p2z7x7R9Wrp3nE5TVuAXld8=;
	b=U0kRlWxEkCnrn0yYlRKNXF/2uDBdfKI7gywt8JrdaxC0YX/Ao2mkmLubByGSGihcna6M
	 JoSu788mh8QoU7lYkvV3OI7uz+ZK2LmJWNXviX2j0qgVUHyUAP6+sH0gKiEwjEmNoUNIF
	 yOaL50ml64187Qmk6oz5eZX3TBO1M0Nb1hdCT1kW/AwJ/qn5escb4Wc8FuMPaw4EeP0qA
	 GV5/HQVUgraVtAJmBWVTXYBCOot1V9E9EM3JPvxmU0HbrwK8ApeGxQmE+WnAbsgej1B5D
	 DhD54S7+i9/DJXtHpZdf70cK9u4pdRl3QeFjTuHTI9NVXHfLE56xiWc/8jZ92VhyX+A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4FCOXAJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8929960A6F7F;
	Fri, 13 Nov 2026 00:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4FCOXAJ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794529975;
	b=UuS/Z2VoLEm2l/wWtFPS2xcieKc+ud7pdm7uO20FVemmdA95JW0HYTkh8Ta2aXPXDgdR
	 lI84XKFN1NY8ld/qhDElBEAjwvBB3fKK/csP3iYWXQwA+Y9KjzI+iTLgoLdc750sV6yfH
	 FS3hBDbr+Z7RuSjuFJVAs1jvDYgyLnrTcNCgrmAishkEClwZtYDF8tlPrhRQMmM0pTSP1
	 nWKHPEBCKF/lPpTznE4V0uSacsW+3FnC2FRKlZnYQvjL3MFDTLLQM++4BefzkETwIfb67
	 G7H1MBJP5yIpw9dZp/UG0Vk2oCIUCbPc0WglQyGT6tq8XjT/Of+rL4FhQIDT0ny87yg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794529975;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Mtj30gCYayK+JwtzXHe1p2z7x7R9Wrp3nE5TVuAXld8=;
	b=at0+P2PbQTCHojgA+6LAyPChI+c4d1thpJxCUjFFKjtrM4S+EW43amLadvGusRcGEWK2
	 FZF2wct6FQP1WpTogqLVvM9FgT8RlH1q9kJblxjd8rxTUNQbkXJfIv8WF3uc26NX48Z/h
	 dwRMNvoLJycf3BeuTW5bjigHj3DAriq5XG7xUh3VTVuvJhrjd2Y338JwlpPirvAYYnz0z
	 KYHZkDurMHkaWX2z35zMZCCCfrSzGUEiL83NhJYke5DXYX0YuQ4Qp7h8CMFHbG0orteQK
	 OPDl1E4OQCfMyHYA+s5JNDYbjzFo6kExWSkgcAgVggm9qvmG2EWI9xkesb9A9ypQRlQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 043511F01573;
	Fri, 13 Nov 2026 00:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794529975;
	bh=Mtj30gCYayK+JwtzXHe1p2z7x7R9Wrp3nE5TVuAXld8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X4FCOXAJjARl2yI0kl25AXmlYRvs30rN3mTw/+iuaC6iCcz7uwZ0hPC65iBwY3wHH
	 r9Vi7iVmtfO4IAgRQOCYn9xYqF6kVCg7lvBYYHcBhSJGpmYvTzUBefac+9knhBMlb2
	 fIEbc3Duh5SQ+fDDOy+RGJq9Nqmvto6WR5hKH8+mM2xkoL8DWNqJCLOZAzMfgFK6PX
	 I3N7vTz2TwcxSYW5EyHK5rQMsn3XehGA9J2MrXwxJ8DIzYyBhgo+o1ur1F/vWmJwle
	 BtBrwV3dNihd3HG4Xmt54t8blu3/6qP3ugl1ddgHkgV0xg8fjspmeI3/B8wdQHUpD4
	 62qFbQyt3qofA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 81F1A47579;
	Fri, 13 Nov 2026 00:32:48 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 12 Nov 2026 19:32:49 -0500
Subject: [PATCH net v6 2/3] net/smc: clear the buffer pointers before
 registering a connection
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
Message-Id: <20261112-b4-disp-1c8d3a53-v6-2-36a38ae35021@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794529967; l=4207;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=bG+MdtaWg2DbS51xfN4NR/c6TdcQBHG7qU+o+c2GvIg=;
 b=JFCZVpCVOyTE6TV+qBWePlJO5xSk/u6QKeZzP2ZohBWsv7te65w/rzwDU2V1sTeP/wi7khLjN
 xzZb1KEuz5kAmS6MqbAL2L0qasxJONmalyy7B8fD87UL4Vi7KZRDYNY
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_conn_abort() releases the buffers of a failed handshake attempt
and leaves conn->rmb_desc and conn->sndbuf_desc pointing at them.
When the SMC-Rv2 attempt of the listen worker fails in
smc_listen_rdma_reg(), which a peer forces with a negative
CONFIRM_RKEY response, the SMC-Rv1 retry registers the connection
under a new token with the stale pointers; a client can do the same
with further connect() calls after a failed non-blocking one. A CDC
with that token then passes the rmb_desc test in
smc_cdc_rx_handler() and is handled on a buffer the connection no
longer owns, and a retry that cannot create its buffers releases the
stale ones a second time.

Clear both pointers in smc_conn_create(), which every registration
goes through, under the socket spinlock, and let
smc_cdc_msg_recv_action(), which runs under it, return while
rmb_desc is unset: a handler that found the connection before the
clear then does not dereference NULL.

Fixes: 35112271672a ("net/smc: Reset connection when trying to use SMCRv2 fails.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/179241208347.3135.18021879529736748765@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
The Fixes tag names the listen retry, which a remote peer reaches.
The connect() re-entry needs the local caller and is older (by
inspection); I have not dated it.

The clear takes the slock with spin_lock_bh(): smc_conn_create() runs in
process context with the socket owned, and the CDC handlers take the
same lock with bh_lock_sock(). Lockdep is silent on it, and reports an
inconsistent lock state with spin_lock() there.

After the second test the function loads rmb_desc plainly: the clear
needs the lock it runs under, so a pointer seen set stays set. The
SMC-D tasklet loads rmb_desc before that lock and the clear cannot
meet it: the connection is unpublished from the device, and its
tasklet killed or the connection marked killed, before a retry
reaches smc_conn_create().
---
 net/smc/smc_cdc.c  | 7 ++++++-
 net/smc/smc_core.c | 9 +++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index ee5ba6c7a5b4..b3bcc206efe3 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -334,6 +334,10 @@ static void smc_cdc_msg_recv_action(struct smc_sock *smc,
 	struct smc_connection *conn = &smc->conn;
 	int diff_cons, diff_prod, diff_tx;
 
+	/* smc_conn_create() can have cleared rmb_desc */
+	if (!smp_load_acquire(&conn->rmb_desc))
+		return;
+
 	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
 	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
 	smc_cdc_msg_to_host(&conn->local_rx_ctrl, cdc, conn);
@@ -484,7 +488,8 @@ static void smc_cdc_rx_handler(struct ib_wc *wc, void *buf)
 	read_lock_bh(&lgr->conns_lock);
 	conn = smc_lgr_find_conn(ntohl(cdc->token), lgr);
 	/* The connection is in the token tree before __smc_buf_create()
-	 * sets its RMB: drop a CDC that comes earlier.
+	 * sets its RMB: drop a CDC that comes earlier. rmb_desc is cleared
+	 * under the socket spinlock; smc_cdc_msg_recv_action() tests it there.
 	 */
 	if (!conn || conn->out_of_sync || !smp_load_acquire(&conn->rmb_desc)) {
 		read_unlock_bh(&lgr->conns_lock);
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 02269cede641..9ef9019bc497 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -2024,6 +2024,15 @@ int smc_conn_create(struct smc_sock *smc, struct smc_init_info *ini)
 	spinlock_t *lgr_lock;
 	int rc = 0;
 
+	/* A retried handshake comes back with the buffer pointers of the
+	 * failed attempt still set: clear them before the connection is
+	 * registered. smc_cdc_msg_recv_action() tests rmb_desc under this lock.
+	 */
+	spin_lock_bh(&smc->sk.sk_lock.slock);
+	WRITE_ONCE(conn->rmb_desc, NULL);
+	WRITE_ONCE(conn->sndbuf_desc, NULL);
+	spin_unlock_bh(&smc->sk.sk_lock.slock);
+
 	lgr_list = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_list :
 				  &smc_lgr_list.list;
 	lgr_lock = ini->is_smcd ? &ini->ism_dev[ini->ism_selected]->lgr_lock :

-- 
2.56.0


