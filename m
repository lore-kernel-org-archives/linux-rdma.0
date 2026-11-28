Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795875827;
	b=PhXvIa/C1biW4WaQg2NI1ch3nSf6Xo7xAzF6S4QvT5vMMI5QK60tZA412D9g5wETTxYf
	 gWjN8BJKYHsNY9icsSA6Ofg7W6cMYEMfESE0o4DjmJRKbVX4ID5QP6eMLiwsx+eRbiXvO
	 fO33P4UL++1LOqbix+f3FdpWBgO91NN5Agt6dE/8tu2knBnDX3gONV95YMQyD30Zpqdfx
	 D2kuTyxwWe1CBgp2otx60qQWEE5cirD9xl/V3cJJhnkQMdAzOmKSUZpycJabW/jkBi6qA
	 +PMv22rUqIvQf6rL3L1qTXVlKdBX0KRTPuCocQGd85mm6qxzCZtEA/PT/ROYRW9n8cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875827;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0bEmuzzzhfklrLFHoKV4wLMwcm8h2DHXhrzVcu8jLIg=;
	b=C/XyGEyEPKrtOZOxRSVG8iH9Q/9nR2S7le1uo4eR0jofFtG1qYDgC9NnFWITWl7JnTg5
	 SlFBMIHTl4ObDx14BRwjlV7sbLPzxK5ycdypRSUhcoWRlVPkRP/OLZLCR4crI/T/p0zyt
	 ehw6N5xz1c6IVrdTbFEgSeW33KD06WooIOm5oMHZBYBcS2VZGIteWQ8Ju5HIOQCoHX+EB
	 yBY78HzB0EZyFMXO68WHd189peXF61wV6D5gKHNfE2AHzRDkeA1CpXMrqDahMZIKVt9yS
	 3cTxV3mCZ7G3emZxvl9/u4mL/ctgaeL3QVQBfUV9/WIsuBmllusKgrU+ZWv1+Qu98zQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUusjkAk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F336F606A325;
	Sat, 28 Nov 2026 14:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VUusjkAk
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795875826;
	b=okUgAs98k57Ms8e4TuCGunFYE0NU7y6K4Je3pzSgkdOtFxFGOO1YigkG46xI6lngIwGe
	 y2kq8lWbMCs/fZ3rZbr62reeUabE182o2JfbZDGtk3DlTE6skyZvkA3fhESVUutzwUNoZ
	 /nZxZO4SM9QSqzbweadsDPk8q21NtKuaCLnJtuiMui/iFkL2AgTcnumozATS7/rOFOLFe
	 bzUAmcacUams+U4HbGx4Oj4K7nCF/W5xpaR6wtGzdSu3tGlmIJSogmx1ukRTMnndcmEZT
	 kJb6PELlZepIcDku0hPgky5g6DALF3+JLK7iQXEZLq51fv5/QqWUkLL3BJTM+WZPKIA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795875826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0bEmuzzzhfklrLFHoKV4wLMwcm8h2DHXhrzVcu8jLIg=;
	b=2ApZedIE+cTSOkhbOmBK4b4BjaDhMyU9Z5wtZkZZncgGSIMmpY4TTG3n6Y5triS2goW/
	 V3MYIFuLbaVygZkPTYKNEf8HP7YlrPETHdma/saQmHqm1TM89nhjt3o3m/j4s5SmoyLvC
	 +Gx6zMVpr9edSzpA8LpCMDUjh66YT2JRllYypWGkESwo+FgQdbt/P4gGniXq5bwfv8HQi
	 n9cevpePyrffJunJZvnXVA2At3muioLWkV8NAPgZZYBn6yUCpxV1vM3UYwYCRpnOMSgbp
	 ot9PWULlkBKsI48M9Z3/TAIVBFjwy5GMBoPQnr+W+ZGjK49cJwrD4oeQISf9t0nAsXg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 792741F00899;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875826;
	bh=0bEmuzzzhfklrLFHoKV4wLMwcm8h2DHXhrzVcu8jLIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VUusjkAkBZhjmDRqiSyRbcSVz1o3D2V1gN3EV3U8x9HpUMafy5ncRRIES7IlKCD/C
	 KA21KGoPCZ8/8ICnZOj+tUr6cZqQyioOA8eQ/3cWytuCC0Grb/rahI2M87iBP3Qhrz
	 28pPxFxMoMMNheMP6maBYKXck/qOUgVmPNH8gWBU10Fgb2tgyo0NGcwS/QVbEG4fmn
	 mOSp3+wgpDXt9SKMIHmledhjPiNnol5TJ1vu7zDbQmmNrqz2xWyA+tK6QAAIVKYbeF
	 9I1Z06iUhh+i6+ACBPQZReBNUS7g2HTVMfQymv6G2XCUYbcrZLtZm+d7xjuY4y0fTL
	 VSqi/s9/FFxTA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EEBEE4E10E;
	Sat, 28 Nov 2026 14:23:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 09:23:45 -0500
Subject: [PATCH net v2 3/6] net/smc: store each cursor once in
 smc_switch_cursor()
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
Message-Id: <20261128-b4-disp-360e65c5-v2-3-d9c05004d430@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795875822; l=3574;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=98ffgvy6neDZFGK0/AHk8UeD5iToECyiXrfIc5npmQM=;
 b=7voRKV6I2RqIJjCN0B2kkIJsk9oq+a1Q9cKIjmN+BCnqvA0eUiPD1JS0DBh5lhQphagPWtqlI
 LbhZJhciWmAC0ZX9DetgMXaM6+K2oSH9LH+05AUaMatOXeGCyBWclR8
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_switch_cursor() rewinds tx_curs_sent and local_tx_ctrl.prod, then
advances them and the two fin cursors in place with smc_curs_add(),
which updates count and wrap in separate steps. smc_tx_prepared_sends()
reads tx_curs_sent without send_lock or the socket spinlock, e.g. from
smc_close_stream_wait(): a cursor caught between the wrap increment and
the reduction of the count reads as nothing left to send, and close()
stops waiting while data is still queued.

Compute the cursors on local copies and store each of them once with
smc_curs_copy(), as smc_tx_rdma_writes() does.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-215218@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_core.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index fb9f6a4eb683..4ee9e6f0d659 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1054,36 +1054,37 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 			     struct smc_wr_buf *wr_buf)
 {
 	struct smc_connection *conn = &smc->conn;
-	union smc_host_cursor cons, fin;
+	union smc_host_cursor cons, prod, sent;
 	int rc = 0;
 	int diff;
 
 	conn->tx_switch_gen++;	/* completions of earlier sends: no credit */
-	smc_curs_copy(&conn->tx_curs_sent, &conn->tx_curs_fin, conn);
-	smc_curs_copy(&fin, &conn->local_tx_ctrl_fin, conn);
-	/* set prod cursor to old state, enforce tx_rdma_writes() */
-	smc_curs_copy(&conn->local_tx_ctrl.prod, &fin, conn);
+	/* The cursors of the connection have readers outside send_lock and
+	 * the socket spinlock: work on copies and store each cursor once.
+	 */
+	smc_curs_copy(&sent, &conn->tx_curs_fin, conn);
+	smc_curs_copy(&prod, &conn->local_tx_ctrl_fin, conn);
 	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
 
-	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &fin) < 0) {
-		/* cons cursor advanced more than fin, and prod was set
-		 * fin above, so now prod is smaller than cons. Fix that.
+	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &prod) < 0) {
+		/* cons cursor advanced more than fin: the peer has read
+		 * that far, so resend from there and count it as confirmed.
 		 */
-		diff = smc_curs_diff(conn->peer_rmbe_size, &fin, &cons);
-		smc_curs_add(conn->sndbuf_desc->len,
-			     &conn->tx_curs_sent, diff);
-		smc_curs_add(conn->sndbuf_desc->len,
-			     &conn->tx_curs_fin, diff);
+		diff = smc_curs_diff(conn->peer_rmbe_size, &prod, &cons);
+		smc_curs_add(conn->sndbuf_desc->len, &sent, diff);
+		smc_curs_add(conn->peer_rmbe_size, &prod, diff);
+		smc_curs_copy(&conn->tx_curs_fin, &sent, conn);
+		smc_curs_copy(&conn->local_tx_ctrl_fin, &prod, conn);
 
 		smp_mb__before_atomic();
 		atomic_add(diff, &conn->sndbuf_space);
 		smp_mb__after_atomic();
-
-		smc_curs_add(conn->peer_rmbe_size,
-			     &conn->local_tx_ctrl.prod, diff);
-		smc_curs_add(conn->peer_rmbe_size,
-			     &conn->local_tx_ctrl_fin, diff);
 	}
+	/* set the sent and prod cursors to the resend's start, enforce
+	 * tx_rdma_writes()
+	 */
+	smc_curs_copy(&conn->tx_curs_sent, &sent, conn);
+	smc_curs_copy(&conn->local_tx_ctrl.prod, &prod, conn);
 	/* recalculate, value is used by tx_rdma_writes() */
 	atomic_set(&smc->conn.peer_rmbe_space, smc_write_space(conn));
 

-- 
2.56.1


