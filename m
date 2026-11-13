Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794597105;
	b=GorvD5UjQP9lxPEwusrtbtqFaz5YKISc6sb6E6W+TuBBiUsYtel+h6aVNbc5c3sTgPv1
	 Fd4K47PvWA1dTBgmo019zraEbfvKhq8nJOzOtD+bG3h5HGOIVZoyCjn00osUjliCwt6yw
	 X1afF6bbTy9a85i1qN78ZgsNZvOXTMfvOxkEimRNICb4fD4uEUt0dbXagAEG66nR+fajb
	 BlVqwpOLtpByIauKqrzv4a8Q2jpCh9/ATpgBRrJiNHky3T97xkoXYbP1/GbCKzpXiyehB
	 7xA/ZSzXAgwymokD3dilO+HdchJjE4LEzaj69YdyP1QtrohGYQ0TI+TVDYMVf/TCRfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597105;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dbuGQgKLovVje7YOSzUv3Dn6YUR6iiM/N5TBcnt6L9s=;
	b=fKvCHO155z11uPoqR9W4tcXDm0ko6ReBoN6Z8S0rEUKl0G6Qu83Q7q1HYpy0ushTtmds
	 fQ2Mpp2tpTHW1fL/Xq+EKbnskhNSvfvYAUCEZ6M5gVNEmDNZzx7HeSFTM3v/3lpfe56g/
	 oBZYSO3qH3uuCU6Yftuf4VhNz/+TAI4sylgFkeFXwra+TPilkk9suSZuO4iqg+VZQkyaJ
	 UZvwhpyiZEM8thwGI3ejZPNQMkGOvGy7A0fQxOi9NJCfgcR6gdKZgq4NzBa3okfwq9rTx
	 +5/pIgCjtL5LxF0NYjLPzR7wHpJ9gRg1q1bIKvEtI71rs4Qthk9eOBX4gcgmU06JsoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lv+9tlQW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2923C606A330;
	Fri, 13 Nov 2026 19:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lv+9tlQW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794597105;
	b=efFysAMu6Nexgt0vTZpt3Z3GYwkzMgTCmZ8L0w5oBV+rCWE9ANSR531M9Qa531qQLSjN
	 TACc3jEX6FNqNm3Yfhh2OmNrbzw82grPAIJpEcM2c6fGOkDpWkRETkx73ABXrLKu/10c0
	 pZ/mZs/dd1LjSbB6aNOfP7QrwTXPwD+YDl/JgDlCcyY1wIucu/+lKakJonVCGcM4Qm5Qu
	 F3UzJ2CRtz10OMXYN/R87dJYyWSWCRLHeGy4xDO6kJlNjEO9Vl2JJxxEudhSnGL4IpJMC
	 i62+xghgIsd9SXDL4ePLE3EK+t+FN6kqdZicqiOv4X1EHrTIWXhjdz1jdzSUpa/h/Sg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794597105;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=dbuGQgKLovVje7YOSzUv3Dn6YUR6iiM/N5TBcnt6L9s=;
	b=eoWRfohtB6IZhjXPitdYsp3WmcsAMt81kNC/zVAwhTPhpaMSbYeL7itqjDxLH4L2ujHK
	 fG5+IrUGZgpUBB+gLOWOpoh88l4L+ZyB5idcc2yo8J5ey2wXxqDcld46EL2ylYHlcntw2
	 WLK/OytGIev3IEzylaxZsX12c9WQnrRN48+XHLYk3e7pyz5eEQqhcYKyZrVK0Iih8aS/I
	 INPkiNvhCJh8wg5xlcRObqQ5rX5vf5LKuuKjgCF3g10hFM1EiPVBpA8Mrb4Goog3wFXed
	 XLdxudnA2aXeQ5iM/fzPxUEY0X87oD9E5t9ohUZ81pfWMzlQodzj0nQ2fSGofCJBEew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 81D651F000C5;
	Fri, 13 Nov 2026 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597105;
	bh=dbuGQgKLovVje7YOSzUv3Dn6YUR6iiM/N5TBcnt6L9s=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Lv+9tlQWSIRCU8yUeTJEu4qwJLnh8qnncnmRS99sKr0RetWVDZXBpaBxth86eUHaL
	 BnnjHbGNLivRPSrvQJ7MlU+R5+NezHDIv/+xlnu2IeIUuSzdN9BTbzhb7EL43dg0U1
	 hhjkaXV9Wis2EbrhTUVcOudFLBquPKcHChxmEcTrQvIP6XJ8WmYqeUJzhhBlEHyV87
	 8DUdkKPhvvpT/SYiaUrSQIrE8DnuJbK87bTqSjAgn4YfwM2xYYKCbxTURTgCZMQGoc
	 rrmiz7R8A4ex8Owt9skI+it4NWpuOThBUiUS598OwLvvT+WaMfOdQ7zz9QRlmu+q5s
	 52I9rMC9WiYCw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D71DB49A7E;
	Fri, 13 Nov 2026 19:11:43 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 13 Nov 2026 14:11:44 -0500
Subject: [PATCH net] net/smc: check every link before skipping the RMB
 registration
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
Message-Id: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMwQ6CMBAFf4W8s5tQSkv1V4wHShddD5V00ZgQ/
 t2qx5lkZoNyEVacmg2FX6LyyBXMocF0G/OVSVJldG3njTGWYk9JdKE2BOvm4IkHfxytS/3gImq
 2FJ7l/VuekXnF5S/1Ge88rd8Z9v0DTX9F43kAAAA=
X-Change-ID: 20261113-b4-disp-08835f86-e769a35d475b
To: Eric Dumazet <edumazet@kernel.org>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org, 
 Wen Gu <guwen@linux.alibaba.com>, netdev@vger.kernel.org, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tony Lu <tonylu@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794597103; l=2617;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=mxIkZpcGP0ojXYjGzeyRwrFvn8NYY3W/U2JZTVq6wpo=;
 b=Wq4dO2nn7dqxjzQGkG1W+5WLAT2QT6qVHDcnLQLSZHqmURL+8bNwq6UwLvKkf/Kgoqo+FiLPD
 YVSR1SRlvJfDRkdYuHo1J9A8kCqdVX3u8DGSuRyErpBZydisJOodaRs
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me
Content-Transfer-Encoding: 7bit

From: Bryam Vargas <hexlabsecurity@proton.me>

smcr_lgr_reg_rmbs() skips the MR registration (its fast path) when the
RMB is registered on every active link, but the check reads is_reg_mr[]
at the index of the connection's link for each link it walks. An RMB
that sits unused in the pool when a link is added is not registered on
that link. A later connection on the older link that reuses it takes
the fast path, never registers it on the newer link, and its
CONFIRM_RKEY still gives the peer an rkey for that link. After a
failover to the newer link, the peer's RDMA writes into the RMB fail
with a remote access error, that link goes down too and, with no other
link left, the link group is terminated.

Read is_reg_mr[] at each active link's own index, so the fast path is
taken only when the RMB is registered on all of them.

Fixes: 4da687448de7 ("net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
Repro on SMC-Rv2 with soft-RoCE (rxe) over two veth pairs between two
namespaces. The link group starts with one link, and the second link
comes up only after the first connection is closed and its RMBs are
back in the pools. A second connection on the first link then takes
those RMBs, and the server's rxe device for the first link is removed.

Unpatched, the client's first RDMA write over the second link completes
with IB_WC_REM_ACCESS_ERR, the second link goes down and the link
groups on both sides are terminated; the server reads EOF. Patched, the
connection survives the failover and the data checks out in both
directions. A connection that gets a new RMB survives the failover with
and without the patch, and one placed on the second link that reuses
the RMBs takes the slow path in both builds (read from debug counters
added to smc.ko for the test). No KASAN splat in any run.
---
 net/smc/af_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bfc0c7e71a12..53ee0f4afc11 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -581,7 +581,7 @@ static int smcr_lgr_reg_rmbs(struct smc_link *link,
 	for (i = 0; i < SMC_LINKS_PER_LGR_MAX; i++) {
 		if (!smc_link_active(&lgr->lnk[i]))
 			continue;
-		if (!rmb_desc->is_reg_mr[link->link_idx]) {
+		if (!rmb_desc->is_reg_mr[lgr->lnk[i].link_idx]) {
 			up_read(&lgr->llc_conf_mutex);
 			goto slow_path;
 		}

---
base-commit: ead6fa9a0ab194f02a2f36d634b193e9c5f9a1c6
change-id: 20261113-b4-disp-08835f86-e769a35d475b

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>


