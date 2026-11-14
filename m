Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794629682;
	b=TD+sRjIWFhrIjTb+A+5zB3fIChkVo+dEzJCJHi1Fc9hmxre9yFkbq2xzDcyUkIRbQDOh
	 4+RUA/bCP9wRNJL8QozThM8aMM6F76b9YLVcxYAjLozqCrKRXt0ezYgTcRgX8fwMpfKj4
	 tqwajcy4MToUIKD+p1myCTkWB20EGzHjPR3j8KVX3EE1wuupJaAErtjM9xXFCvcu9ST68
	 gmzx7+VcJtaricy8vJhz0AFxFGIsJVPpwTtVM7dgauS3tX+3UtQ2dRaTKHQrVSWv5jRg0
	 zfoD+bkUK7Rg8rHLaq0SK8BvZcUSuJc/rg4Uz19aaNDiCMyN5B4U66QfM1bHIlOUejw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794629682;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DxLo/33eFXZw7atidgQlq9a08WT1M7jfi2dyXiRzBAQ=;
	b=NlLu1flMbaVm2goUAJTXcutU3sjp1nTfbjgPig8skEPxaNKFoE9f4IjpPGEAwUbyoLQ5
	 1B9CPS+xAbkhEP/Vm+LPBK6iwGFOxqHK3sgZxYwyRojN1ITz9whUsy1cfb9PV1vRyZ1+a
	 VU3CavPfK68wF3+3nJXnWhXyQAEd+BvbDxd4Y/QLikLfi9UqLp4OReylF1eBfMo57xaZY
	 +XPNwneyxHCdejAbHrvE8fGqv9dvc80SxYtCAIR+RFI1tOgy3bvTvtJJ1ppt/BrfdNIEd
	 7pBskJxP8DZk5o2qrNt/Xt3cllPOyM3EaPBvSxNHbz5t8+5ghX7lYBBC80Tp7bsa08Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX80SQYF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8BE606A331;
	Sat, 14 Nov 2026 04:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX80SQYF
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794629682;
	b=EadXSiKuXPrsT/Fp4PZCGlezW4Xn+GwTayMnN2OLr8Gj2Sg9zQwANBIcUdiW/Na7vdUX
	 jElx1YMsaKMeU4eFNIvHftjlE/V5jVv+56VcOfDsfQJFvC102ZpJcp6bDH8If9LzWdCtW
	 mY6Tu89QxmfYMyVIvwrMMhi7YB6dnQfF59uSOofuKluyzXhM5EzmH/qirtSNn2ld8Uz9k
	 Eap53YAm605gw9v3yhqdYnqDMJht1096iazuG1/eI8KosNBCh91A8AVqFi98ZHlh9dlr3
	 X/sOVXW00q5IjYgkEnE8DVBm1vQ1e98+Jxh5QW+C6mm+Uh9t7dzh1bojvX5HFOCAotQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794629682;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DxLo/33eFXZw7atidgQlq9a08WT1M7jfi2dyXiRzBAQ=;
	b=lHxtfSjNYwKc+EEj7jcSRcchYw7Skb3GpngdiX7mDKlTlWJywcUJWdmyvs2xL8zB5NEq
	 5ux3PveCx/Dtjw7x3yHYe4TYvki08kXO/QcHqpgyYv4hCU8am7byYzqCJG947RoQ13rq+
	 U35R6gIlH2ltH3ONzcJPX2vehLx9WPK6Ar4OhbjfOroIRlknVX6m/ZwZ1SXjNTyKcGkOV
	 WefeXd5UNYpBxjGgf5PQXWKUqCzeNeCZVinrteJQXp3hLvvhSM545yTgv0DftMB5sIXpE
	 U1Y8NihBKOKxzbWCLPtQbXP+W/enoPwXd+fSs9QCnOIJiNqRS7DlkVaIXs1o9eXjR+g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 97F801F000C5;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794629682;
	bh=DxLo/33eFXZw7atidgQlq9a08WT1M7jfi2dyXiRzBAQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LX80SQYFDlwWn6jepVQeX5PumoTx1xr/Z5CV47bRHxYlcQVkQaWlH8u+B5k5PuzgX
	 MheYLVfD/xjgf8OKZ6t/Gjja/aj4bsPBt+hJbf4wexVhmNLyBmwq8R4khWj/eK6g70
	 PusDcv8Vq7ab7n8GzFML2BGNrwYGrgAJZusNCjlXk58D3u4WT7HyoI4qEl7xPuX5Rz
	 oEBCHTW+7XFTXfQBCr5VYpI445H8RneGTGI94gXyDywrWyAwkx1WkI8LjXCfSgOtfO
	 wblvItkNKIgQdSDCOQg7E9TvjeH8gC66cOPUiB+K8UTZDzaSwPLAiXSfSZhssSx1j4
	 5gHtBTFbK8oQw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2601249C79;
	Sat, 14 Nov 2026 04:14:41 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 23:14:40 -0500
Subject: [PATCH net 1/4] net/smc: take the socket spinlock across the
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
Message-Id: <20261113-b4-disp-1a9ab9b0-v1-1-4a7c8d85d849@proton.me>
References: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
In-Reply-To: <20261113-b4-disp-1a9ab9b0-v1-0-4a7c8d85d849@proton.me>
To: Dust Li <dust.li@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Jakub Kicinski <kuba@kernel.org>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Paolo Abeni <pabeni@redhat.com>, Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Guangguan Wang <guangguan.wang@linux.alibaba.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, netdev@vger.kernel.org, 
 Wenjia Zhang <wenjia@linux.ibm.com>, Ursula Braun <ubraun@linux.ibm.com>, 
 Hidayath Khan <hidayath@linux.ibm.com>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Simon Horman <horms@kernel.org>, 
 Wen Gu <guwen@linux.alibaba.com>, Stefan Raspl <raspl@linux.ibm.com>, 
 linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794629679; l=2185;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=37BN2RSRyNVISAdMhu9n+tShj+W04N891tvq1vKJV+g=;
 b=5LRDNp6vYOhJa6/IMBrS0OG2KlkbSab4J5qV2/36bqF9pkHNS0hXMJhzwQOpBN6jgbZMFuyYY
 4OyNeH447zFBTKsymUsm8DiSeaZsvoMg2k7wgsoheL/FHEe5JYjTOhu
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
2.56.0


