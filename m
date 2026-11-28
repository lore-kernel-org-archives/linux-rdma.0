Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795875837;
	b=LTQc7ZH1REED/BVrO2OGmt9Xn+EaENUb1eeD32MnMpRzqga2ckyL/8EGIu1Q0NNfMuCz
	 jRyvPH+MxXy+ZxcXWhRlIhh//bOu8mmOq2jVXXYJQbtml2Rl9dGyXMcAP8phm1aS4C1lX
	 nwryyJgdmlmfpdnC3WWhlWzEiNqycclgry27MgcKkAuMe6/y8z+zFTda1szGwWrp+mpyZ
	 xVIvwNv4YM9W7JRcuIA49L0gApG2SfFyNP5wkqoqp9kE/ZdIOD7h8L9zo11bVCq2cEWNj
	 WiyI41O//fox2z/Y7QPCUOatnrC4KEV9wUPqIV9aZHCAs+9Fa+ulmerH59U5PokxE0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875837;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iOdlr+hAudjJtdZCZwaNvwXRL9n65jjtLwRHKgG6moQ=;
	b=DUH6tXlW6oF43bz57ezV2+nv+9NzLf79lCiH/v02pE5itaAR/BOKsmughJkvPKHIFuCa
	 YWWXrvOaNA6M1B6dsgCy1wYq6XTUmdPuzQu/0KfUbwFWOThU6wAkZ4flTlq71YQmWZt9d
	 xlrudi/7IsfMo9Xo1pWKQsCDGmxmmDc89CgvTMVebkRIaNzEX3yPlu/WFkEC05qkvLaI0
	 PrjG04ZVUMIDYaa2vBlMJH7S2Cykvvw5rqx2Yf8prTXiORuV3R7HrB1/BU6ev2/GQpwXH
	 zfo4Ve4qGatRz4hRZ5XEEZ2A4qt2KcpeVpCftVsolbjVtQ70AMJGVtj+a3M5vfQSu8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bbcz5UtF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE2606A338;
	Sat, 28 Nov 2026 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bbcz5UtF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795875836;
	b=m8rARjpVCbwGhg9FQhOhlVZ0vrlf+z8458LMxtmq2Ng0VkFW1l1pTh/3h2ZUJLq4m+2v
	 5sGBqPaBe3t9imCfJHEqDxuWRI1eU4pO0mxT8sj8O97c5Awg0WSDVlYvUbzLyBNRaiBGy
	 OGRZaHsxON4Ryq/DA0YUAZBdfHh5gnHEDmwrMP3DE7A/rTkn8LsCkKlUTfPeTgNTo13m+
	 M12m6O8vau4+taJ4dHrE/0aNfnwdUxtrtI5zlU3o2VuWC4jxMlhWK4jQfHf7bD8o4hwvy
	 jG33HhTiRpmz7sNK/4PEKH7rNZxqbrI9Xrhat/H0hmjqmcygDAOJlCCcymF8zPvdJ6A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795875836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iOdlr+hAudjJtdZCZwaNvwXRL9n65jjtLwRHKgG6moQ=;
	b=fdN8eAO6mrquPGz+EFO6LjgvNDcqDEJ2BkYailiZWOhdURC4SZPDOiqLmKhOpOa+8Jld
	 vmMrcPoxUJ/HHjPQUhngCHolQmsgftdW5Y5MvMmj8n45/cSuEXzHW9AgEIb4CgoXuq1Gh
	 lG8uEGuEkwmgr0n/oOWtY9sjOzeXp1yf/ze6Q9Tmg10GhUdi6aTiTs0wpklW7JJlfoMy5
	 48e0tTanOcJed2/LJSzWZG9562b03V5lWNXyZoiUW8/49VzXGXOAZxXXZr/q+0O0Lzg4d
	 Fdmmy4tMjkpCXAD8U2DIvQrtbIwjQ6o+q4TlzMMYMJITPez3/ReMOONuajzgvR7i6Ow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 40B961F00893;
	Sat, 28 Nov 2026 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875836;
	bh=iOdlr+hAudjJtdZCZwaNvwXRL9n65jjtLwRHKgG6moQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Bbcz5UtFQS3FhIAS8SfqGXrEckQ43Yhxm2Fp7Z3NuIcMLPvaBd6QG4mx0snYMoWcp
	 L6AWLWe95BvS0ChGK+EI9voNaH75JxqnkRqxTkMzs8ZpsVlqa2LwW6mUWLr07hNzaG
	 GC17VTlpixPau0EyDzTPjhWwsEkbIGpRz7/Ie0zRySdWRebr9FO4WS7YJNWUtw3cN1
	 +QVi0w04P9Cc0znNLzm/jgMC9a3q0ZNrPNLisjJ6IwQGTn3qqZJrphvvb1GkJne4jQ
	 kYK65Awf8k9uSri0PgzEgnCicO7grInmwKUEcDnAqbf0ghyv55nq7ytZFyAwaICZ91
	 8BP3P1QuPr9TA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8BF164E11A;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 09:23:48 -0500
Subject: [PATCH net v2 6/6] net/smc: update the urgent state under the
 socket spinlock
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
Message-Id: <20261128-b4-disp-360e65c5-v2-6-d9c05004d430@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795875822; l=5552;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=cKpQorhXG1R2EN46yHv6FFpnAnjJofWItGyhdXnydh0=;
 b=52EUOOBVkeHj+JcivLB6j18Lkd0sR+ndlUwrnY10S/5+FMUFasZ8e86P7S1tW4YaceKCl57zI
 AjySuahXMNJD8vTzUUnmN6riZ2jncGCSxYKbSfVBTt5aedvm3zL4FCy
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_cdc_msg_recv_action() sets a new urgent mark, byte and state under
the socket spinlock, even while a reader owns the socket, and the
reader tests and changes urg_state under the socket lock only. In
smc_rx_recv_urg() a second urgent byte that arrives after the state was
set to SMC_URG_READ is returned in place of the first, and the next
recv(MSG_OOB) returns it again. In smc_rx_update_consumer() a mark set
after the test is overwritten with SMC_URG_READ: its byte is neither
returned nor skipped, and the sender, which waits for its urgent data
to be consumed, stalls.

Take the socket spinlock around both test-and-set sequences.
smc_rx_update_consumer() takes it only after a test without the lock
finds a mark or a pending skip, so a read with no urgent data is
unchanged. The lines of smc_rx_recv_urg() after its SMC_URG_VALID block
could only be reached through this race; drop them.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-215220@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_rx.c | 102 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 62 insertions(+), 40 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 564b976426ca..2680b91e882b 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -67,26 +67,38 @@ static int smc_rx_update_consumer(struct smc_sock *smc,
 
 	smc_curs_add(conn->rmb_desc->len, &cons, len);
 
-	/* did we process urgent data? */
+	/* did we process urgent data? smc_cdc_msg_recv_action() sets a new
+	 * mark under the socket spinlock, even while we own the socket:
+	 * test again under it. A mark set after the first test is left to
+	 * the next call, like one set after the unlock.
+	 */
 	if (conn->urg_state == SMC_URG_VALID || conn->urg_rx_skip_pend) {
-		diff = smc_curs_sdiff(conn->rmb_desc->len, &cons,
-				      &conn->urg_curs);
-		if (sock_flag(sk, SOCK_URGINLINE)) {
-			if (diff == 0) {
-				force = true;
-				rc = 1;
-				conn->urg_state = SMC_URG_READ;
+		local_bh_disable();
+		bh_lock_sock(sk);
+		if (conn->urg_state == SMC_URG_VALID ||
+		    conn->urg_rx_skip_pend) {
+			diff = smc_curs_sdiff(conn->rmb_desc->len, &cons,
+					      &conn->urg_curs);
+			if (sock_flag(sk, SOCK_URGINLINE)) {
+				if (diff == 0) {
+					force = true;
+					rc = 1;
+					conn->urg_state = SMC_URG_READ;
+				}
+			} else {
+				if (diff == 1) {
+					/* skip urgent byte */
+					force = true;
+					smc_curs_add(conn->rmb_desc->len,
+						     &cons, 1);
+					conn->urg_rx_skip_pend = false;
+				} else if (diff < -1)
+					/* we read past urgent byte */
+					conn->urg_state = SMC_URG_READ;
 			}
-		} else {
-			if (diff == 1) {
-				/* skip urgent byte */
-				force = true;
-				smc_curs_add(conn->rmb_desc->len, &cons, 1);
-				conn->urg_rx_skip_pend = false;
-			} else if (diff < -1)
-				/* we read past urgent byte */
-				conn->urg_state = SMC_URG_READ;
 		}
+		bh_unlock_sock(sk);
+		local_bh_enable();
 	}
 
 	smc_curs_copy(&conn->local_tx_ctrl.cons, &cons, conn);
@@ -314,42 +326,52 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	struct smc_connection *conn = &smc->conn;
 	union smc_host_cursor cons;
 	struct sock *sk = &smc->sk;
+	bool valid;
+	char byte;
 	int rc = 0;
 
-	if (sock_flag(sk, SOCK_URGINLINE) ||
-	    !(conn->urg_state == SMC_URG_VALID) ||
-	    conn->urg_state == SMC_URG_READ)
+	if (sock_flag(sk, SOCK_URGINLINE))
 		return -EINVAL;
 
-	SMC_STAT_INC(smc, urg_data_cnt);
-	if (conn->urg_state == SMC_URG_VALID) {
-		if (!(flags & MSG_PEEK))
-			smc->conn.urg_state = SMC_URG_READ;
-		msg->msg_flags |= MSG_OOB;
+	/* smc_cdc_msg_recv_action() sets a new mark and byte under the
+	 * socket spinlock, even while we own the socket: take the byte
+	 * together with the state it belongs to.
+	 */
+	local_bh_disable();
+	bh_lock_sock(sk);
+	valid = conn->urg_state == SMC_URG_VALID;
+	if (valid) {
+		byte = conn->urg_rx_byte;
 		if (len > 0) {
-			if (!(flags & MSG_TRUNC))
-				rc = memcpy_to_msg(msg, &conn->urg_rx_byte, 1);
-			len = 1;
 			smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
 			if (smc_curs_sdiff(conn->rmb_desc->len, &cons,
 					   &conn->urg_curs) > 1)
 				conn->urg_rx_skip_pend = true;
-			/* Urgent Byte was already accounted for, but trigger
-			 * skipping the urgent byte in non-inline case
-			 */
-			if (!(flags & MSG_PEEK))
-				smc_rx_update_consumer(smc, cons, 0);
-		} else {
-			msg->msg_flags |= MSG_TRUNC;
 		}
-
-		return rc ? -EFAULT : len;
+		if (!(flags & MSG_PEEK))
+			conn->urg_state = SMC_URG_READ;
 	}
+	bh_unlock_sock(sk);
+	local_bh_enable();
+	if (!valid)
+		return -EINVAL;
 
-	if (sk->sk_state == SMC_CLOSED || sk->sk_shutdown & RCV_SHUTDOWN)
-		return 0;
+	SMC_STAT_INC(smc, urg_data_cnt);
+	msg->msg_flags |= MSG_OOB;
+	if (len > 0) {
+		if (!(flags & MSG_TRUNC))
+			rc = memcpy_to_msg(msg, &byte, 1);
+		len = 1;
+		/* Urgent Byte was already accounted for, but trigger
+		 * skipping the urgent byte in non-inline case
+		 */
+		if (!(flags & MSG_PEEK))
+			smc_rx_update_consumer(smc, cons, 0);
+	} else {
+		msg->msg_flags |= MSG_TRUNC;
+	}
 
-	return -EAGAIN;
+	return rc ? -EFAULT : len;
 }
 
 static bool smc_rx_recvmsg_data_available(struct smc_sock *smc, size_t peeked)

-- 
2.56.1


