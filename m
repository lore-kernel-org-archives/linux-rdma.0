Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795875835;
	b=A0kf4nFUH/nQHLLw0eFJsBHdM5y07fCZr2V03mhxM0Wa1eCOKdUusIcnY64nPH+upNe/
	 2FlWxlueHsPpCL/R7o2gdhB3b8xTkootCx0NQ1RBxYEXkIejExf7Dxy1lxbJmglpToJHD
	 05YXOft0PAVx4btptJdFfj1a1f2d7FbmBTU0CqVICTUJJbZ2fFeYCYBQ52OdtcMILW6lu
	 ZD8glLH4VpVE12IkSeEuUvAbdzJFgLqrru+HPJjg2OD5SfvcB9C+Sq4p4Jua+OJarubkH
	 yxO5q27+vZ3g+N0ShR8p9T7K2B/p4E+jcSLqrbO30Sqwo6TIQktt6Bmsk8GgDw1dQ0Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795875835;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/nYjM5DDmOgmKoEddV8+lQWvsl4XKzr+wuBptbJ69MA=;
	b=yrGJEDCpxDYsBMLHSUZhZEV/i1oKWVYPfe7eIQqnWsbxLvlLQ+zcKFjHiVQSM+uxjQIH
	 bPwRmqMgXeM9HTYgFsSn4MOJNNWnSZNWk7ege/9sA4vFe4H4wHfUUYKqHjamYE/PAsqdP
	 YhWTD+uRp2ndp1FWIcJVLiDSyGDyEPR+vmAtJN/Lf5HH/lRQdskw5VtGCMjQJvYQt22t2
	 og+AFionFmQ14jF9iYe0HsrNKvgUX2TiO/W2WxK0YQkWFoabO4yrtMnXqHpN4UW4d3y+y
	 zi2GpxIAz8064WPYox5LB1Nv2BIZefTKjUzD66RQDxY2NKfd3BPqYOYVolwktrhfmlw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H4vXCTqT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9F606A31C;
	Sat, 28 Nov 2026 14:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H4vXCTqT
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795875835;
	b=T80JM6GjFzmpAMWY0HVR1CVcKZ6L8w6fThCkQLurFY/n1z6UK2fffCY1Lns5FBEcUQex
	 bS2LQRV0HePIhzvjXlpWhQ+yadZ1Veh01gIZdyLNhQEyffN3RcRp3RfxlFFADrDacHfcl
	 Yl+UgKRABlI2Md0pfxIr3LYtmhnTJjMnkRdgoStoUGJjZeqFhoyHBVrzHttEbqLmYsKvj
	 Yr98jDStrfwcRuhP5S4rVIMNCSBp2BsbxSMiqiX447bDRC5jPbN1zFGucMcZ4bsfFBqqB
	 S2UfsU+6tHtmNYiknSE1/M7oqKKxJTShGopJVu+Ubh9wU+MeqHWO6SlbJipTtg6aqcw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795875835;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/nYjM5DDmOgmKoEddV8+lQWvsl4XKzr+wuBptbJ69MA=;
	b=nn1D9elqZeiKdTyhMKiq1LihDZgmThkn0EUnUKA+E+vv2SeY8gvaD9vsbU83qwGmPUqp
	 nyrzUwbtJFQXMrpZ7FqUdUsYEGPYcLj7FiFL5XYoMAxvcmY93A9Lc8IA39WUPcef+u8ps
	 GwwJ9RYwZZ5EvbdKoHOMQ4e9RjGHFrleYthjyk7zwsGI3ALaxW04/3YKYzxAhQDy5sj7q
	 DkniAvDya4JptKLDC6NBhC0je+zTca/xJggTmHLfdgqm4yELobE8VE91l6YxCIopcQKhK
	 pkHmJqyZmgQHtdcTkcs3VuoHAnkatDClMzs3VsolUYd7+0VhRc+ahXAjydt1zw4PMvg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9E0C41F0089A;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795875835;
	bh=/nYjM5DDmOgmKoEddV8+lQWvsl4XKzr+wuBptbJ69MA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=H4vXCTqT76OMI7VdC0Qk+7F4pDtNeu4vgikdecmIH5DcumHKUJtyzuchyH6Vs2WNh
	 NP4bXB8vlmK6L42QPr6rSy14xOUZIkqt+aHq/JEuXUEE+pkPBPdcfO781h/Gf5Mk7A
	 NxKJf598d3YcZRc5uSeSE7L57FYWTKsNmQEZkMrNGf3jRhiMjW9bvfITSc0sN/RIyf
	 f1TxRad6/rGWUjUYbIj+YT+RPfP0UP3GLUnnUkOTyoazYGeYtIJRdm7L/DsmHP25r/
	 SWzF77KIby+E4BFakwjWMbC1eaAP0nIdPJKYMBP2G5Xz4OhVqdC+qnqHVzGalnQ+hF
	 qPn20X8uOmbpA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2734F4E112;
	Sat, 28 Nov 2026 14:23:44 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Sat, 28 Nov 2026 09:23:46 -0500
Subject: [PATCH net v2 4/6] net/smc: fix the failover catch-up across the
 cursor wrap rollover
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
Message-Id: <20261128-b4-disp-360e65c5-v2-4-d9c05004d430@proton.me>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795875822; l=3940;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=q6yzVhoWdbn0tEnEe3VJrfFDCgfbXJKEGJz8IQcFsjQ=;
 b=crUA3JbW0g7b1fnp0KpgBheQxsYZcii6NmXK2y0TVCiVtwb3au2LiwL6R75/QhGoHgbsrE/IK
 Mt7Mbsw/S9PBpmN9m+re1pfHZJgBk/iqHWY7mGnz36YOvHqYYApCE5y
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smc_switch_cursor() orders the peer's consumer cursor against
local_tx_ctrl_fin with smc_curs_comp(), which misorders them across the
65535 -> 0 rollover of the u16 wrap. A consumer cursor that is behind
reads as ahead: the catch-up can credit sndbuf_space for bytes never
sent and tell the peer they are in its RMB, so the next send() can copy
past the end of the send buffer. One that is ahead reads as behind and
the catch-up is skipped. With a send buffer larger than the peer's RMB,
the catch-up can also be short once the peer is more than one RMB past
local_tx_ctrl_fin, and the connection then stalls.

Use the signed cursor distance, advance the RMB cursors across any
number of wraps, and bound the catch-up by tx_curs_prep: a conforming
peer has read no further, and unlike tx_curs_sent no failover rewinds
it. The bound also caps what a forged consumer cursor, which is taken
off the wire unchecked, can add to sndbuf_space.

Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261029-b4-disp-33001ace-v8-0-f9bb96e17827%40proton.me?part=4
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 net/smc/smc_cdc.h  | 10 ++++++++++
 net/smc/smc_core.c | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 597acb2e123f..4b586a20dfc2 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -97,6 +97,16 @@ static inline void smc_curs_add(int size, union smc_host_cursor *curs,
 	}
 }
 
+/* smc_curs_add() for a value that may span more than one ring */
+static inline void smc_curs_advance(unsigned int size,
+				    union smc_host_cursor *curs, u32 value)
+{
+	u32 count = curs->count + value;
+
+	curs->wrap += count / size;
+	curs->count = count % size;
+}
+
 /* Copy cursor src into tgt */
 static inline void smc_curs_copy(union smc_host_cursor *tgt,
 				 union smc_host_cursor *src,
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 4ee9e6f0d659..22a9a818a046 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1054,9 +1054,9 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 			     struct smc_wr_buf *wr_buf)
 {
 	struct smc_connection *conn = &smc->conn;
-	union smc_host_cursor cons, prod, sent;
+	union smc_host_cursor cons, prep, prod, sent;
 	int rc = 0;
-	int diff;
+	s64 diff;
 
 	conn->tx_switch_gen++;	/* completions of earlier sends: no credit */
 	/* The cursors of the connection have readers outside send_lock and
@@ -1065,14 +1065,20 @@ static int smc_switch_cursor(struct smc_sock *smc, struct smc_cdc_tx_pend *pend,
 	smc_curs_copy(&sent, &conn->tx_curs_fin, conn);
 	smc_curs_copy(&prod, &conn->local_tx_ctrl_fin, conn);
 	smc_curs_copy(&cons, &conn->local_rx_ctrl.cons, conn);
+	smc_curs_copy(&prep, &conn->tx_curs_prep, conn);
 
-	if (smc_curs_comp(conn->peer_rmbe_size, &cons, &prod) < 0) {
+	/* cons comes off the wire: go no further than tx_curs_prep, which
+	 * a conforming peer has not read past and no failover rewinds. That
+	 * also keeps diff within one send buffer for smc_curs_add().
+	 */
+	diff = min(smc_curs_sdiff(conn->peer_rmbe_size, &prod, &cons),
+		   smc_curs_sdiff(conn->sndbuf_desc->len, &sent, &prep));
+	if (diff > 0) {
 		/* cons cursor advanced more than fin: the peer has read
 		 * that far, so resend from there and count it as confirmed.
 		 */
-		diff = smc_curs_diff(conn->peer_rmbe_size, &prod, &cons);
 		smc_curs_add(conn->sndbuf_desc->len, &sent, diff);
-		smc_curs_add(conn->peer_rmbe_size, &prod, diff);
+		smc_curs_advance(conn->peer_rmbe_size, &prod, diff);
 		smc_curs_copy(&conn->tx_curs_fin, &sent, conn);
 		smc_curs_copy(&conn->local_tx_ctrl_fin, &prod, conn);
 

-- 
2.56.1


