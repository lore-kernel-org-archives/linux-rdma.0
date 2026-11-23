Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.215
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795424538;
	b=H9fLbyl9GLZ8oijUJbNJbK8lu8+jA7GQM9oYh6zOK9fQoG1CGFH1uNipCuxoDt5bHVhF
	 hegxCFsELt+NKN2GNL1zRHcWD3HI39Ad0Fzq67PqZwJlM+FmE6kakQ4mc0rD/KPxgth+z
	 NpIk/1vbm2sKro4RIHCyDajF9xTP8vVyhJW0AASAY5xB/FS1s3y85htExlv14/iDXF1Vq
	 aLFeVLnVHO20HpLWIW18HYlIiuPxWYpyNLgmMrOook3UyN6+8mM9hpJdOBCxuCGppV7mX
	 4wWoO66QP2qfESMJukpKzluPjqGRG+fWIlsulmnXcdfK3Yi4lhly71r8vJ9bOVW/vuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795424538;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Kz/WeYWTkRBkgARC8Rr4+yrZNQ8k1MIDWWfsVImsn28=;
	b=Nx3c6h0WOyg2Vv1t5/3sDVw2zvJkIdpxdHDXW9BTU4a4bz8Zor2OoDbKEQgFGYx/vyen
	 XANoVUENZ/XKjRq2KxA9nG9dh/qj6WNg2fW4BgSvMvISYzsGH0HjTZS8TlgRsoDNg3dUm
	 ARgpzFmqQJ0kQ6QQr+49yBSU1UBBIpRPdz1EYezuelVC7bwHok7fdqHyWWF4o8fvMvm6N
	 DB7TPyHDHWKmWc6DLbnTktRyHfROdFIGRwm6Ra1rXBwt5Z50eoVfApC7Qw/lMtTEKC8GJ
	 9CJXBrg2lUFW1ezdx8NBMACf7X7s8T96zWg5Vje+mx1dwmUmcMYIhoPKjYcUolDQbkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="VF82/Jev";
	arc=none smtp.remote-ip=95.215.58.215
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE548606A32D
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 09:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE548606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VF82/Jev
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T5OWg7LERcGWKGnCk5JE+7blmKJIrMPN4iidLxTf5Lc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795424534; v=1; x=1796029334;
 b=VF82/JevBb1t224HAAO+zHzJj+42iU1JZd0ELL0yz8e0yW/+iyWXflxwZZ9vyf74o3r3qL9D
 q0NhWrbZahPJQNE+cnwTedCVT/HY6SEnBXURA3SDRLvrBaDWGZvSZk9tei9VdINANSeM07r5DJC
 3VImKEKJns+fo0oCXxldClhQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ade3eca2258fcfa0;
	Mon, 23 Nov 2026 09:02:14 +0000
X-Mizu-Trace-ID: ade3eca2258fcfa0
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org,
	tariqt@nvidia.com
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v2] net/mlx5e: TX, Do not open a multi-packet WQE for a single packet
Date: Mon, 23 Nov 2026 18:02:00 +0900
Message-ID: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
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

netperf and pktgen between two 10G ConnectX-5 hosts, 2-socket Hygon
C86-4G 7490 sender on net-next, the patch switched at run time by a
temporary module parameter (not part of this patch) so that before and
after run in the same boot, mean of 3 boots x 2 rounds. "far" is a sender
on the other socket than the NIC, "near" one on the NIC NUMA node:

  test                                 before    after   change
  UDP_STREAM 65507, far, Mbps            3255     3815   +17.2%
  UDP_STREAM 65507, near, Mbps           5619     5870    +4.5%
  UDP_RR 1 B, far, trans/s              57667    60688    +5.2%
  UDP_RR 1 B, near, trans/s             70538    71230    +1.0%
  TCP_RR 1 B, far, trans/s              56822    57124    +0.5%
  TCP_RR 1 B, near, trans/s             70048    70011    -0.1%
  pktgen 64 B burst 1, kpps              1487     1748   +17.5%
  pktgen 64 B burst 16, kpps             3192     3194    +0.1%

Batches do not regress: with burst 16, which uses xmit_more, the rate is
unchanged. TCP_RR does not change beyond the noise, its skbs carry the
data in page fragments and cannot use MPWQE.

The price is that the regular path runs a little more code for a packet
than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
mlx5e_accel_tx_finish()): the instructions per byte of UDP_STREAM 65507
go up by 0.3-0.4%, which the gains above outweigh.

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
Changes:
v2:
  - Check xmit_more and the open session first, so that a lone packet
    skips the skb checks. (Suggested by Tariq.)
  - Run the tests again with the new code and add netperf results to the
    commit message. (Suggested by Tariq.)
  - Rebase onto the latest net-next/main.

v1: https://lore.kernel.org/all/20261117085036.3138779-1-xuanqiang.luo@linux.dev/

 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..5b5651c14750 100644
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
+		if ((xmit_more || mlx5e_tx_mpwqe_session_is_active(sq)) &&
+		    mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
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

