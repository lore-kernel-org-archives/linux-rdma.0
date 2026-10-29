Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793298084;
	b=waUife1y1T5VcrD13eST+LWQ/gQWvvlal4P77WNTk0IDCrPDUSKojnoqCb8RUFaj1Lev
	 VPsWyytgD9QpCMdiy8RNWs44zqS1xHfv9P4aK1T4H+HjBilYFZ4t6VhubTE1gF43C2T//
	 kcqDXjElYRQRNq2zOIXe/Y3/Q9tKHlMEw8x+FOE6v2lxDACyBsCiKZ+TTImKNU38HB+Bk
	 5oh0Ze8atByRiWMz1UsLgMCgmbHujJP6g1lx3gF2JEWT3kXup0DJTyH6DuTgEpl1A9HGG
	 aTxANbHktnCMtIlHCU7w8V77Y4FryEfD/p9Bxtco1rlEAh1cuDckJbS0+z7skyvv1Dg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793298084;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	b=HL+4VeXj6xUkpLihGmuMgtWrBvlmmveqrt77QVNumallWXL9eELM1tkA641hNWKSHrxB
	 qEqbWaerGS2UPs5fJ7PxCmbLBbuLLtEL7ezDgFIs0jUwGIvTl9iVyr/K/UlgLgzRzAUo5
	 2RaJ/SjUEqgSV1Lw6emRg+rZsmv2QmsAV1EarGythaBfI0ffjg9/n9QERopDKAIeA9iKs
	 372hNQJacDtrm7WNfsGJls0ibKpGRDXg5enTYFG20E1xqAkeCheSJBJ50rvR4IXHuOaqy
	 W8r4DMfv++uz0T9j4vwN7lQiEBtlpLSOmSv7Y5BY6rnxlep0jPuZC6w2VsiveZT8HkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Er3BCzOW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C1D606A31A;
	Thu, 29 Oct 2026 18:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Er3BCzOW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793298084;
	b=hPNgZOwrA3dYiXGnF3tV6CYZy6cusEZ+g4jvj3UPuWtPzdyYqq/sQ5uoLJiY+tC2c0iN
	 sEnAb/ye+5cuyztmRKXKniGdziMwF7f2oGFcAVAjW7rg9hc+3Z6/0PYw9hAY0UN150vSa
	 KY24HNAUCuu+8AVplz9EGP7pDZoKVx4xbm0Cep81GRBvYCTqqxW49B4FblQ6VqRHeP3zw
	 aialVMfDD/VqaJ0kwHztCwNQdeW2nyRbr+KNbIYsTQGLUootLK02McVFOKlC1emuyszsP
	 RffiS/1DfG4aXpG4yYBdOq6hoocVjHFkCJzl4QeBHUu0+9WV5pZpXHfUHDTukHffEOQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793298084;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	b=tzyN9na+DoCAL4Ll2ZKaYt4Jo/HuN2zL6GHdO21+ubpQJkNT83vjdaZEPhDr5Up56dGA
	 pYecM0d2m08CqI80Y2p8sLp+tsVtpo8xcmf5QqDCx3OiqKGuVpvLccJJkUiqX4tZNPSz6
	 IQ95iS64/haqK+By+JLiSvIB12pXVoIhkzEFpPv8BnR+fmJCrHaxGP/qNIq/QRJrcpycf
	 TfJGxL5Y8qceqB2aZyQ6vhUZpBczbGDRg/UC4kbaGFp6lou7I4UFYUEIwm58ll5/RHwvX
	 6vIdy0j80oRxWjh3hpKvmhkynkhyRmJXzkNdG2oLOpYEMiFGHl997W4IIkW6SjBEHAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4F79D1F01824;
	Thu, 29 Oct 2026 18:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793298083;
	bh=QbHi+525zRunXNfIuuoUlB/V5+/jcI7PNq6aGsnXADY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Er3BCzOWButVvcFN63yPEHZNVjejiLfpQyKnax4dPbRAfPRBzS/WEvc1Yzd6x9GY8
	 k07WpzqLp07k0bDrHVysd2n8ntFBpff5jRDdkU0keouA3OKtCFhrKPmZexG05ygHmJ
	 QRU1+RyViPZ5gZAoKw4H101HOgODTl+T4Illr0PkK8lbWd3tn3EYnOAcnY3lwHeL7y
	 ebBJJbuS0S9UKUKWGMKXEWWAit7HKki55MNE1fDBFvEmvBRNC4f7il7j7Jxra0feDW
	 c4TurQqcWQFLET2DGgphzJrks7viEcdRoAKl66maZTkHgTDjYsifhAEgj0Y8JJ6kNz
	 46us+OY/1gnhw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id ACDDB4593E;
	Thu, 29 Oct 2026 18:21:22 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 29 Oct 2026 13:21:22 -0500
Subject: [PATCH net v8 1/4] net/smc: bound the wire-controlled producer
 cursor to the RMB
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
Message-Id: <20261029-b4-disp-33001ace-v8-1-f9bb96e17827@proton.me>
References: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
In-Reply-To: <20261029-b4-disp-33001ace-v8-0-f9bb96e17827@proton.me>
To: Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Jakub Kicinski <kuba@kernel.org>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Paolo Abeni <pabeni@redhat.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Dust Li <dust.li@linux.alibaba.com>, Eric Dumazet <edumazet@kernel.org>
Cc: Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-s390@vger.kernel.org, Wen Gu <guwen@linux.alibaba.com>, 
 linux-kernel@vger.kernel.org, Hidayath Khan <hidayath@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793298082; l=3046;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=9ja5JoT+O2VUsGXhvlsOd1Bx55l6YLeZkBRApwlhPSc=;
 b=tmPpqdp1479Q7JwlNqfE2rUFso9Yl1TQhJQwyiTQV0bniSMiS5GLLpJ7Xdugel5nWEAgczlOT
 EJJmBNc/4eKAxegnQv6wRiqyL729iCWaU5OonKJnJ4t6UIRt0WX3Cv6
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() import the peer's
producer cursor from the wire into conn->local_rx_ctrl.prod without
bounding it to the RMB. smc_cdc_handle_urg_data_arrival() then uses its
count as a raw index into the RMB, so a producer cursor past
rmb_desc->len makes the receive tasklet read past the RMB, and
recv(MSG_OOB) hands that byte to the application.

Bound the producer cursor count to rmb_desc->len when it comes off the
wire, for SMC-R and SMC-D. Leave the consumer cursor alone: it indexes
the peer's RMB, which can be larger than ours, so clamping it to our
RMB would under-credit peer_rmbe_space and could stall sending to that
peer. Conforming peers are unaffected.

Fixes: de8474eb9d50 ("net/smc: urgent data support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
---
 net/smc/smc_cdc.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 696cc11f2303..4d630a305118 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -221,7 +221,8 @@ static inline void smc_host_msg_to_cdc(struct smc_cdc_msg *peer,
 
 static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 					  union smc_cdc_cursor *peer,
-					  struct smc_connection *conn)
+					  struct smc_connection *conn,
+					  int max_count)
 {
 	union smc_host_cursor temp, old;
 	union smc_cdc_cursor net;
@@ -235,6 +236,12 @@ static inline void smc_cdc_cursor_to_host(union smc_host_cursor *local,
 	if ((old.wrap == temp.wrap) &&
 	    (old.count > temp.count))
 		return;
+	/* The urgent path uses the producer count as a raw index into our
+	 * RMB, so bound it. max_count == 0 leaves the consumer cursor alone:
+	 * it indexes the peer's RMB, which can be larger than ours.
+	 */
+	if (max_count && temp.count > max_count)
+		temp.count = max_count;
 	smc_curs_copy(local, &temp, conn);
 }
 
@@ -246,8 +253,9 @@ static inline void smcr_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 	local->len = peer->len;
 	local->seqno = ntohs(peer->seqno);
 	local->token = ntohl(peer->token);
-	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn);
-	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn);
+	smc_cdc_cursor_to_host(&local->prod, &peer->prod, conn,
+			       conn->rmb_desc->len);
+	smc_cdc_cursor_to_host(&local->cons, &peer->cons, conn, 0);
 	local->prod_flags = peer->prod_flags;
 	local->conn_state_flags = peer->conn_state_flags;
 }
@@ -260,6 +268,9 @@ static inline void smcd_cdc_msg_to_host(struct smc_host_cdc_msg *local,
 
 	temp.wrap = peer->prod.wrap;
 	temp.count = peer->prod.count;
+	/* as in smc_cdc_cursor_to_host(): bound prod, not cons */
+	if (temp.count > conn->rmb_desc->len)
+		temp.count = conn->rmb_desc->len;
 	smc_curs_copy(&local->prod, &temp, conn);
 
 	temp.wrap = peer->cons.wrap;

-- 
2.56.0


