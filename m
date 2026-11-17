Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905461;
	b=SX+uQNkxlAgp+EfwTXz+IPmtImWYfOZg8YDo9VHS0wlGtJHPIE9OOmdcrkUNhr4wzyzD
	 Orq8fHkCreoFz7TWiemfdHM4Z6d65geScHaqtGC5DBhFmSJWu5+ev5ApfEn+abLioKljI
	 VPiLVgHC9l51AJxa1f9RgyvaGKdDUZyK4SpBwbVfU00ra/WAVhxin9iFP2EMCu171JILz
	 uN8OR8WPbAY3NCcEscTLlqJgPSN8sDdMqeRa1hEeVyfT9iiKz+t5qqPU/k1zTroaacSm1
	 PAwKZHC/bGTHnbC1jZtGBwUrM/wvQUl5fewuYJ8INNWpUP9HgkHoN3GJiwHm+PMIwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905461;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=kktxErXVA9vzSuKDfU/GwRl9jfNN1q0kNJMaIMx7e2g=;
	b=z7l5YvjBbaehb84usCMhZJevsfABIVq0lmB/4aSY7/sy4eh2GGhzNwDz14wNiCAvp9tv
	 fTq4mlOsvtIyyziM5cG67dnT2ZnihFQZYO6CTK4oDOT+FQYIXVLa+JvQL9mPnMEsMPgO/
	 19hspYIHUbsOdM62TySpm4IasM5CCxCHax3AQnmlKZ5TLOLc3R5Xj99M1YtAkaexPSCqc
	 MT68Rhw0V4vAKV5UH3uDA9z+gzacGJk3Kka0aGQbDjv2U1mQNAcRlOo7IslR0NY2768iY
	 yVxoN6DhyiyYmlL2Lt+Z3kVGe5lniRHuuIlQltpKLbIDOZFx1efvUX2hF2eBlv2mDZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="iNTI1/jw";
	arc=none smtp.remote-ip=95.215.58.101
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B12606A32F
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 08:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0B12606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iNTI1/jw
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=frb27RcRWqYhKgZ/jRZ/7dmrrDCCd2Sc4xBQ+/xfsgo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794905457; v=1; x=1795510257;
 b=iNTI1/jwwxCNfYGWarUAmQmm3CnIp51Ytf7U2n3sLJFrtwSileU0NwsknG3ErZWt2F4H2x7B
 ZNovzud09h6JqoxUdYBodErZHnw6ULZKBhvI+uyU6n94Pgpos/rLhgnah0KoQYm6Mgf3u87GXFz
 yfXZE9OJNfsWj1B1V1PRXKWc=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 747235d7d1053b67;
	Tue, 17 Nov 2026 08:50:57 +0000
X-Mizu-Trace-ID: 747235d7d1053b67
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v1] net/mlx5e: TX, Do not open a multi-packet WQE for a single packet
Date: Tue, 17 Nov 2026 17:50:36 +0900
Message-ID: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

A multi-packet WQE (MPWQE, added by commit 5af75c747e2a ("net/mlx5e:
Enhanced TX MPWQE for SKBs")) lets several packets share one WQE, so the
control and Ethernet segments are fetched by the device once per batch
instead of once per packet. This saves PCIe bandwidth and CPU cycles, but
only if the WQE carries more than one packet.

With skb_tx_mpwqe enabled, which is the default, mlx5e_xmit() sends every
skb accepted by mlx5e_tx_skb_supports_mpwqe() through an MPWQE session.
A session stays open between two calls only while the stack sets
xmit_more. A packet without xmit_more closes the session and rings the
doorbell. Hence a packet that comes without xmit_more while no session is
open opens a session just for itself and closes it right away. Such a WQE
takes one WQEBB, as a regular WQE does for the same packet, and the
doorbell is rung for each packet either way, so nothing is saved.

This is the case for the IP fragments of a large UDP datagram and for
UDP request/response traffic, which reach the driver one packet at a
time. With pktgen and burst 1 every MPWQE carries one packet (mpwqe_blks
equals mpwqe_pkts, xmit_more is 0) and the packet rate is 15% lower than
with skb_tx_mpwqe turned off.

Use the regular WQE path for a packet that has no xmit_more and no open
session. Packets with xmit_more still open and extend a session, and the
last packet of a batch still closes it, so batching is unchanged.

The only visible change besides the performance is in the statistics:
tx*_mpwqe_blks and tx*_mpwqe_pkts no longer count a packet sent alone.
Such a packet is counted in tx*_packets, as any packet sent with a
regular WQE.

pktgen, 64 B packets on one TX queue, between two 10G ConnectX-5 hosts,
2-socket Hygon C86-4G 7490 sender on net-next, the patch switched at run
time by a temporary module parameter (not part of this patch) so that
before and after run in the same boot, mean of 3 boots x 3 rounds:

  test                              before    after   change
  pktgen 64 B burst 1, kpps           1494     1740   +16.5%
  pktgen 64 B burst 16, kpps          3236     3236    +0.0%

Batches do not regress: with burst 16, which uses xmit_more, the rate is
unchanged and 15% above skb_tx_mpwqe off, so the gain of MPWQE is kept.

The price is that the regular path runs a little more code for a packet
than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
mlx5e_accel_tx_finish()); the packet rate above shows that it is more
than compensated.

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
pktgen, 64 B UDP packets, one TX queue, 30M packets per run, sender and
IRQs pinned, interrupt coalescing fixed, before -> after, in pps:
  burst 1 (no xmit_more)  1493583 -> 1739855 (+16.5%)
  burst 4                 2578336 -> 2576508  (-0.1%)
  burst 16                3235640 -> 3235746  (+0.0%)

After vs before, 3 boots, paired t-test over the boots (2 degrees of
freedom, so a low power), the change of each boot in brackets:
- burst 1: +16.5% (p<0.001) [+16.2 +15.9 +17.3]
- burst 4: -0.1% (p=0.86) [+0.6 -0.4 -0.5]
- burst 16: +0.0% (p=0.99) [+0.3 -0.0 -0.3]

With the patch, burst 1 is within 1% of skb_tx_mpwqe turned off (1752020
pps). With burst 4 and 16 turning it off is 1% and 13% slower (2550781
and 2810510 pps), so the gain of MPWQE for batches is kept.

Single packet MPWQEs, counted with tx*_mpwqe_blks and tx*_mpwqe_pkts:
with burst 1, before the patch mpwqe_blks and mpwqe_pkts are both
29993000 for 29993000 packets, after the patch they are 0. With burst 4
(7519017 blocks, 29972000 packets) and burst 16 (1984750 blocks, 29888000
packets) the counters are the same before and after.

 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..7c1fcd8fb294 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -646,6 +646,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_accel_tx_state accel = {};
+	bool xmit_more = netdev_xmit_more();
 	struct mlx5e_tx_wqe_attr wqe_attr;
 	struct mlx5e_tx_attr attr;
 	struct mlx5e_tx_wqe *wqe;
@@ -678,11 +679,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
 
 	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
-		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
+		/* An MPWQE for a lone packet saves nothing, use a regular WQE. */
+		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr) &&
+		    (xmit_more || mlx5e_tx_mpwqe_session_is_active(sq))) {
 			struct mlx5_wqe_eth_seg eseg = {};
 
 			mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg, attr.ihs);
-			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
+			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, xmit_more);
 			return NETDEV_TX_OK;
 		}
 
@@ -697,7 +700,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	mlx5e_accel_tx_finish(sq, wqe, &accel,
 			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
 	mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs);
-	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
+	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
 
 	return NETDEV_TX_OK;
 }
-- 
2.43.0

