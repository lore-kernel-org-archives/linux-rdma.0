Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821981;
	b=DDrmyzD5Ivs/Pdx8Fox7VfAR5ObFNANqLXAjcWc8ueO2Ktv18izEtCsRQvbmfQC0HP2p
	 ERlxXG+Ri0ZMw8t5ffHr1CVEcrMyl7URod9LyN4HMQfALYbF5w0JkZ0ATlBOwjon48prH
	 45PSBwRIPVUGomoS8Yxz3o615FaoAjzP9xrntu7HYM7045fUljj/ArdnlMFDst7yXXoE/
	 F2Y51ukNa/nKyvEmJNn85mmymNhlPBrVuKMZjofLEGU2j5sb5eOVB8gdN5y9+KkbY/5jF
	 m8VCSxEMbrmr+bPFbFzW/H48AFo1k8e+ZXMTwb+ZauEYk7IYAogBtbZ+vz2g5W9aSgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821981;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=bjNAE/sqW+6C7Fn4/hwxUDn8yEwHvj++UXJMUvq2N60=;
	b=Y7vpWoy5+wdnPaSMsoqZzW9KcSXRKIXCFkGQj+3tIovm6miNuqZmAoOng5ZyXTOhKy8E
	 RfemXw/C0wAIn8oCiKV71oaqZUEDD4FnZuLWgUReOJLeba3bEEd8yp1om107fT8zrcQTd
	 b6LEC4paSLtgKiULaqSCSYTB2ZJesipzlzD92EXMJd68qCq2XwUhjfwaoj+WSWlMGXRAe
	 Hmmp49+fnv/UW+R1yvz8BmUIccl8Qz/Np5/M/Bc6zrM0YLlYbPEacAb4Wd4fNX65BFvkS
	 qHbJU2YcRP3/Y3A2PUtvJJBn1HrLKlNE+eBGoA+rEx6Mvb7lby/6wfI6GyT/r8ZngKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	arc=none smtp.remote-ip=195.10.208.52
Received: from mout-b-203.mailbox.org (mout-b-203.mailbox.org [195.10.208.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAEC60960A5;
	Wed,  4 Nov 2026 19:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8EAEC60960A5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-b-203.mailbox.org (Postfix) with ESMTPS id 4jKbhD6bLczLmWY;
	Wed, 04 Nov 2026 20:52:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1793821964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bjNAE/sqW+6C7Fn4/hwxUDn8yEwHvj++UXJMUvq2N60=;
	b=yUhujfsOWWBMMBcPYAduvPg6sBeDchIrJo4Lvbu4XcVkfjNv0IIaPRCGRZczweJ679nBiM
	MMqAF/MSm/NlAGgr3WL1Bmk/v6OVoX3s6zURHcibMxtJASJTgh6GAJ5ipoEs5y4XhTTrYG
	snqp/i3OYGN5pqOQUIBkJCqg9qUQcTUNXXjlWSmScZymhJ0jcvP80rnCe3m5lu3aXkw/RQ
	P+xvETRGjGX3GISDOnitTH1mWzZywrrc4jwoTXyCP4QP6IEZdFHtfABBLM8gr1dnDjpuyN
	qumxqqwKd+eX4GrIIcGJp7MSAeKB0yn6L0OlOMSejWhf1r572KfpwzYAkcByvw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	dtatulea@nvidia.com,
	cratiu@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides ahead in the linear MPWQE path
Date: Wed,  4 Nov 2026 20:52:41 +0100
Message-ID: <20261104195241.1883539-1-antonio@mandelbit.com>
X-Mailer: git-send-email 2.56.0
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
X-Rspamd-Queue-Id: 4jKbhD6bLczLmWY

Without cache injection (DDIO/SDCI), the first accesses to a received
packet's headers and skb_shared_info are DRAM misses, and the
net_prefetch() in mlx5e_skb_from_cqe_mpwrq_linear() is too late to hide
them. This caps the packet rate of a queue.

In the linear striding RQ path a packet takes one stride and the device
fills the strides in order, so the packet MLX5E_RX_PREFETCH_DIST (4)
strides ahead is known without its CQE: prefetch its headers and page,
and the line its skb_shared_info will use if it has the length of the
current packet, as in bulk flows. That line matters when every packet
becomes its own skb: TCP inside an ovpn UDP tunnel gains 34% with it and
4% without.

AMD Ryzen 9 9950X, ConnectX-5 Ex, one RX queue on a dedicated CPU,
MTU 1500, mean of 3 runs:

                                   before       after
  UDP 512B flood, pktgen         2.52 Mpps    3.44 Mpps   +36%
  TCP, 1 stream                  44.6 Gb/s    48.0 Gb/s    +8%
    NAPI CPU cycles/packet            1334          715   -46%
  XDP_DROP reading the packet,
    NAPI CPU cycles/packet             409          280   -32%
  XDP_TX, NAPI CPU cycles/packet       829          554   -33%

With the change, the XDP packet rates were limited by the sender, so
cycles per packet are compared.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
v2:
- prefetch the packet MLX5E_RX_PREFETCH_DIST strides ahead instead of
  looking at the CQE ahead (Alexei); no CQE peek, RQ state bit or wq.h
  helper any more, and it also works with CQE compression (with it on:
  UDP floods +26%, TCP +6%, where v1 did nothing)
- also prefetch the skb_shared_info line, guessing the length from the
  current packet: without it, TCP inside a VPN tunnel (one skb per
  record) gained 4% instead of 34%
- XDP numbers added; XDP_DROP without touching the packet is unchanged,
  and the XDP packet rates were capped by the sender (12-16 Mpps), so
  cycles per packet are quoted
v1: https://lore.kernel.org/netdev/20261103235823.536706-1-antonio@openvpn.net/

Notes:
- Distance: with v1, 4, 6 and 8 were within 3% of each other.
- The prefetches are issued before the stride ahead is synced for the
  CPU; if the device hasn't written it yet (low rate), they are wasted.
- No prefetch for the first 4 strides of a WQE.
- Measured on one system only (Zen 5 desktop, no cache injection,
  CX-5 Ex); numbers from DDIO/SDCI systems and CX-6/CX-7 would be
  welcome.

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea4739a2c..57da30b1bffe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2094,6 +2094,36 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	return skb;
 }
 
+#define MLX5E_RX_PREFETCH_DIST	4
+
+/* A packet that fits the MTU takes one stride of a linear MPWQE, and the
+ * device fills the strides in order: prefetch the packet
+ * MLX5E_RX_PREFETCH_DIST strides ahead, and the line its skb_shared_info
+ * will use if it has the length of the current one, as in a bulk flow.
+ */
+static void mlx5e_mpwrq_linear_prefetch(struct mlx5e_rq *rq,
+					struct mlx5e_mpw_info *wi,
+					u32 head_offset, u32 page_idx,
+					u16 cqe_bcnt)
+{
+	struct mlx5e_frag_page *frag_page;
+	void *va;
+
+	head_offset += MLX5E_RX_PREFETCH_DIST << rq->mpwqe.log_stride_sz;
+	page_idx += head_offset >> rq->mpwqe.page_shift;
+	if (page_idx >= rq->mpwqe.pages_per_wqe)
+		return;
+
+	head_offset &= (1 << rq->mpwqe.page_shift) - 1;
+	frag_page = &wi->alloc_units.frag_pages[page_idx];
+	va = netmem_address(frag_page->netmem) + head_offset;
+	prefetch(netmem_to_page(frag_page->netmem));
+	net_prefetch(va + rq->buff.headroom);
+	/* with XDP the packet may not become an skb */
+	if (!rcu_access_pointer(rq->xdp_prog))
+		prefetchw(va + SKB_DATA_ALIGN(rq->buff.headroom + cqe_bcnt));
+}
+
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
@@ -2114,6 +2144,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}
 
+	mlx5e_mpwrq_linear_prefetch(rq, wi, head_offset, page_idx, cqe_bcnt);
+
 	va             = netmem_address(frag_page->netmem) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
-- 
2.56.0

