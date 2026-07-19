Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5A13AFD12
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784484134; cv=none; b=VQ8RRLBx/arttycdEEn0dK9NdB4YshD7v1K8PSjoLva/H6o1d4RTbDrKYQKOMqo9YqmG3TadQZiQzUOqBOiup1XPCllV4urzGzut265ecsaR/CaI1b1ZB1f/dtMR8DS3Rs4mIeHfYPXkCSj0eKnqWTiVDT9PjmWqMqMKJANm18s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784484134; c=relaxed/simple;
	bh=9x+KxMip3DrZ2abMwha3hDKHh9v0LyqG+xlGpmM7+7s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRpVpxZpUB7Zez5PeQPIsVeaCuyhmNLtSWNtziLSWlMkABEYi9yHkReKtd3CveteZ9qSgZD5TsqBUqkQNm0WMntRJGoJGbN92SyYjdHwARcDRzfy7aDJ7Nt2wulq91eMkrXJmSwA7ralqnPHG/E30s2HLYCDYFOBr7/byNNi8qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rY+RQRwm; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rY+RQRwm"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cf50c6f235so9784855ad.0
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 11:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784484113; x=1785088913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/kzD1p6yL30PU6FFChKoKisLHf+QG0tGQ4P1mDlrkEk=;
        b=rY+RQRwm+Deo9laNwaLOgUpSG4troWaCbZFkDTZZRRgI1MJXP3Xik9CT27C3JFkIJA
         IeGneALsthSD8DXfFfdV6IxEZ9VPzunuAp/Y/hsu+yDjTTjqIJqQ1Xq+yhm6HuQ5GcOb
         A0ZihB0eIKqp8lvmhceCOA4Chmv82br6+uCYnLgTWPiGhdbKCKBjjWLzyhtpY/Zf6reB
         BdEcJjYwDKYCAYa25NOwznSf9r4dzyT6U3MsrsDqoTKiU+lv2Qd7nQXmPqdJ0U3FMuxJ
         PMIUeZVlcBkQjzw9gKGKlQwzM4Secj+kSKZtOUAkNcPOmTal7RMFMSIZ49/iLcg9bt9f
         EN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784484113; x=1785088913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/kzD1p6yL30PU6FFChKoKisLHf+QG0tGQ4P1mDlrkEk=;
        b=heXciVu61zovQXRW9NFr8NWHxXxy/DixcSMiFH+/HgxFiqSiTQT4MH+AS5UsBfV5jT
         8wSdQS6chxNZIn+K8pctUjEm2E96ustb5EHJnyxJq19A+NTifiAsCPdqkTYrK2N/1XhE
         0xpFjlUxbI0ZOyMQKFQIUHXGBQDhg1diGlR+Szb+83E1SHOI0OdWsN8Hj+Glr9WTY/S1
         gkqXFIsBJmnkUg9FV+370jlMXAwf1c6Qw4RGLeo34l/FdlzQzdB28gnvgnFgCV/q2rhY
         0chbXCfJUaQq1nnezNeGpuOBnTMxbDFV7ciRl1OkS7vDpf52f1BP3TODPkQcS+czNePK
         DgSQ==
X-Forwarded-Encrypted: i=1; AHgh+RozWMxOLpjDHBYfWae0qOpfKtDL9dvBG9jq9jrhJVyTWVH7cQun3WG0EtMdFVJKyoqGe0Ta/DQgG5Sg@vger.kernel.org
X-Gm-Message-State: AOJu0YxXSGRkvp6bmANGyb7aNOrfvRDP7VB6NPxvmmLp4dpDv8esw+ZT
	BkXXbHbWBpILHMuhn+xYefNj1mldXHM3jI3H0tMdMCD944aPyzirimmE
X-Gm-Gg: AfdE7ckQh7MvvawZwnx/OmRBhmeaVFvg5GGq7aBuAggoPxbGd+Syfihvtm8jaAT4FoY
	HlWWkAx9uVn4ZeDZD31uGnkNKHaji5lHiqiqgfYJnv8DqCY6udUna+7bmXH9JnhAnj7+cR2Zvs4
	SDQ/+Hi5nVtabWfl6PmpS95zmkjsZajhAfE9bOBjAomfUxOZDz2sV4EEzXMMVvgOobITveKE8ex
	NBRxNkUwdwbM7WDTLJCv8fhKsC3Z3bwhedkYG4ZXcugl9vTIwblaeTKejTH6mKI93nzk+/Ohuly
	NYrVuTxuBExQFu+zXpGIDia1hfefHEg8IY1Uyp0YvUnK06pEXnT1XSnj0ktKViZqsH+2CqYJkHw
	1E56+A1Du5CalKJBwSVIISoyF4akwmycSzgPNfJJAmMeIOcDED2LVYNElaP7NkWfxmiLYV5iJon
	OW
X-Received: by 2002:a17:903:46c3:b0:2cf:4c0f:5129 with SMTP id d9443c01a7336-2cf4c0f5449mr64949115ad.17.1784484113118;
        Sun, 19 Jul 2026 11:01:53 -0700 (PDT)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf34769bd6sm43511065ad.74.2026.07.19.11.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 11:01:52 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	Alexei Starovoitov <ast@kernel.org>,
	amd-gfx@lists.freedesktop.org,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrii Nakryiko <andrii@kernel.org>,
	Bill Wendling <morbo@google.com>,
	bpf@vger.kernel.org,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Hoyeon Lee <hoyeon.rhee@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	linaro-mm-sig@lists.linaro.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Michael Chan <michael.chan@broadcom.com>,
	Nathan Chancellor <nathan@kernel.org>,
	netdev@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Simon Horman <horms@kernel.org>,
	Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [RFC PATCH net-next 11/13] bnxt_en: add knod XDP offload support
Date: Sun, 19 Jul 2026 17:58:55 +0000
Message-ID: <20260719175857.4071636-12-ap420073@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719175857.4071636-1-ap420073@gmail.com>
References: <20260719175857.4071636-1-ap420073@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let bnxt_en act as a knod NIC: register with the knod core, feed
received packets to the accelerator over the per-queue SPSC ring, and
transmit accelerator verdicts back through the XDP TX ring.  Restricted
to page-mode MTU.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
(cherry picked from commit c9ef892dd5859cc71b0f8a546d87032cf70bb442)
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 155 +++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 274 +++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  12 +-
 4 files changed, 442 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7513618793da..6ddf4bafc3d4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -993,11 +993,36 @@ static inline u8 *__bnxt_alloc_rx_frag(struct bnxt *bp, dma_addr_t *mapping,
 	return page_address(page) + offset;
 }
 
+static int bnxt_alloc_rx_off_netmem(struct bnxt *bp,
+				    struct bnxt_rx_ring_info *rxr,
+				    u16 prod, gfp_t gfp)
+{
+	struct rx_bd *rxbd =
+		&rxr->rx_desc_ring[RX_RING(bp, prod)][RX_IDX(prod)];
+	struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[RING_RX(bp, prod)];
+	unsigned int offset = 0;
+	dma_addr_t mapping;
+	netmem_ref netmem;
+
+	netmem = __bnxt_alloc_rx_netmem(bp, &mapping, rxr, &offset, gfp);
+	if (!netmem)
+		return -ENOMEM;
+
+	mapping += bp->rx_dma_offset;
+	rx_buf->data = (void *)netmem;
+	rx_buf->data_ptr = netmem_address(netmem) + bp->rx_offset;
+	rx_buf->mapping = mapping;
+
+	rxbd->rx_bd_haddr = cpu_to_le64(mapping);
+	return 0;
+}
+
 int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		       u16 prod, gfp_t gfp)
 {
 	struct rx_bd *rxbd = &rxr->rx_desc_ring[RX_RING(bp, prod)][RX_IDX(prod)];
 	struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[RING_RX(bp, prod)];
+	unsigned int offset = 0;
 	dma_addr_t mapping;
 
 	if (BNXT_RX_PAGE_MODE(bp)) {
@@ -1012,6 +1037,16 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
 		rx_buf->offset = offset;
+	} else if (BNXT_RX_OFFLOAD_MODE(bp)) {
+		netmem_ref netmem = __bnxt_alloc_rx_netmem(bp, &mapping, rxr,
+							   &offset, gfp);
+		if (!netmem)
+			return -ENOMEM;
+
+		mapping += bp->rx_dma_offset;
+		rx_buf->data = (void *)netmem;
+		rx_buf->data_ptr = netmem_address(netmem) + bp->rx_offset;
+		rx_buf->offset = offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, rxr, gfp);
 
@@ -1250,6 +1285,25 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	return skb;
 }
 
+static struct sk_buff *bnxt_rx_offload_netmem(struct bnxt *bp,
+					      struct bnxt_rx_ring_info *rxr,
+					      u16 cons, void *data,
+					      u8 *data_ptr,
+					      dma_addr_t dma_addr,
+					      unsigned int offset_and_len)
+{
+	u16 prod = rxr->rx_prod;
+	int err;
+
+	err = bnxt_alloc_rx_off_netmem(bp, rxr, prod, GFP_ATOMIC);
+	if (unlikely(err)) {
+		bnxt_reuse_rx_data(rxr, cons, data);
+		return NULL;
+	}
+
+	return NULL;
+}
+
 static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 				   struct bnxt_rx_ring_info *rxr, u16 cons,
 				   void *data, u8 *data_ptr,
@@ -2249,6 +2303,36 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	len = flags >> RX_CMP_LEN_SHIFT;
 	dma_addr = rx_buf->mapping;
 
+	if (BNXT_RX_OFFLOAD_MODE(bp)) {
+		if (bnxt_alloc_rx_off_netmem(bp, rxr, rxr->rx_prod,
+					     GFP_ATOMIC)) {
+			bnxt_reuse_rx_data(rxr, cons, data);
+			bnapi->cp_ring.sw_stats->rx.rx_buf_errors++;
+		} else {
+			struct knod_work_priv *wpriv;
+			struct spsc_bd *bd;
+
+			if (bnapi->index >= KNOD_SPSC_MAX) {
+				rc = 1;
+				goto next_rx;
+			}
+
+			wpriv = &bp->knodev->wpriv[bnapi->index];
+			if (spsc_produce(&wpriv->spsc_bds, (void **)&bd)) {
+				bnxt_reuse_rx_data(rxr, cons, data);
+			} else {
+				bd->netmem = (netmem_ref)data;
+				bd->len = len;
+				bd->off = bp->rx_offset;
+				bd->page_idx = net_iov_binding_idx(
+					netmem_to_net_iov((netmem_ref)data));
+				spsc_produce_commit(&wpriv->spsc_bds);
+			}
+		}
+		rc = 1;
+		goto next_rx;
+	}
+
 	if (bnxt_xdp_attached(bp, rxr)) {
 		bnxt_xdp.rxcmp = rxcmp;
 		bnxt_xdp.rxcmp1 = rxcmp1;
@@ -3272,6 +3356,11 @@ static int bnxt_poll(struct napi_struct *napi, int budget)
 		napi_complete(napi);
 		return 0;
 	}
+
+	if (BNXT_RX_OFFLOAD_MODE(bp))
+		work_done += bnxt_rx_offload_act_handler(bnapi,
+							 budget - work_done);
+
 	while (1) {
 		work_done += bnxt_poll_work(bp, cpr, budget - work_done);
 
@@ -3296,6 +3385,7 @@ static int bnxt_poll(struct napi_struct *napi, int budget)
 				  &dim_sample);
 		net_dim(&cpr->dim, &dim_sample);
 	}
+
 	return work_done;
 }
 
@@ -3363,6 +3453,11 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 		cpr->has_more_work = 0;
 		work_done = __bnxt_poll_cqs(bp, bnapi, budget);
 	}
+
+	if (BNXT_RX_OFFLOAD_MODE(bp))
+		work_done += bnxt_rx_offload_act_handler(bnapi,
+							 budget - work_done);
+
 	while (1) {
 		u16 type;
 
@@ -3427,6 +3522,7 @@ static int bnxt_poll_p5(struct napi_struct *napi, int budget)
 				  &dim_sample);
 		net_dim(&cpr->dim, &dim_sample);
 	}
+
 	return work_done;
 }
 
@@ -3458,6 +3554,13 @@ static void bnxt_free_one_tx_ring_skbs(struct bnxt *bp,
 			tx_buf->xdpf = NULL;
 			i++;
 			continue;
+		} else if (tx_buf->action == BNXT_NETMEM_TX) {
+			page_pool_recycle_direct_netmem(
+				netmem_get_pp(tx_buf->netmem),
+				tx_buf->netmem);
+			tx_buf->action = 0;
+			tx_buf->netmem = 0;
+			continue;
 		}
 
 		skb = tx_buf->skb;
@@ -3551,6 +3654,10 @@ static void bnxt_free_one_rx_ring(struct bnxt *bp, struct bnxt_rx_ring_info *rxr
 		rx_buf->data = NULL;
 		if (BNXT_RX_PAGE_MODE(bp))
 			page_pool_recycle_direct(rxr->page_pool, data);
+		else if (BNXT_RX_OFFLOAD_MODE(bp))
+			page_pool_put_full_netmem(
+				netmem_get_pp((netmem_ref)data),
+				(netmem_ref)data, false);
 		else
 			page_pool_free_va(rxr->head_pool, data, true);
 	}
@@ -3905,7 +4012,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	struct page_pool *pool;
 
 	pp.pool_size = bnxt_rx_agg_ring_fill_level(bp, rxr) / agg_size_fac;
-	if (BNXT_RX_PAGE_MODE(bp))
+	if (BNXT_RX_PAGE_MODE(bp) || BNXT_RX_OFFLOAD_MODE(bp))
 		pp.pool_size += bp->rx_ring_size / rx_size_fac;
 
 	pp.order = get_order(rxr->rx_page_size);
@@ -3923,8 +4030,10 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 		return PTR_ERR(pool);
 	rxr->page_pool = pool;
 
-	rxr->need_head_pool = page_pool_is_unreadable(pool);
-	rxr->need_head_pool |= !!pp.order;
+	if (!BNXT_RX_OFFLOAD_MODE(bp)) {
+		rxr->need_head_pool = page_pool_is_unreadable(pool);
+		rxr->need_head_pool |= !!pp.order;
+	}
 	if (bnxt_separate_head_pool(rxr)) {
 		pp.order = 0;
 		pp.max_len = PAGE_SIZE;
@@ -4673,6 +4782,9 @@ static int bnxt_init_rx_rings(struct bnxt *bp)
 	if (BNXT_RX_PAGE_MODE(bp)) {
 		bp->rx_offset = NET_IP_ALIGN + XDP_PACKET_HEADROOM;
 		bp->rx_dma_offset = XDP_PACKET_HEADROOM;
+	} else if (BNXT_RX_OFFLOAD_MODE(bp)) {
+		bp->rx_offset = NET_IP_ALIGN + XDP_PACKET_HEADROOM;
+		bp->rx_dma_offset = XDP_PACKET_HEADROOM;
 	} else {
 		bp->rx_offset = BNXT_RX_OFFSET;
 		bp->rx_dma_offset = BNXT_RX_DMA_OFFSET;
@@ -4961,12 +5073,14 @@ void bnxt_set_ring_params(struct bnxt *bp)
 /* Changing allocation mode of RX rings.
  * TODO: Update when extending xdp_rxq_info to support allocation modes.
  */
-static void __bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
+static void __bnxt_set_rx_skb_mode(struct bnxt *bp, int page_mode)
 {
 	struct net_device *dev = bp->dev;
 
-	if (page_mode) {
-		bp->flags &= ~(BNXT_FLAG_AGG_RINGS | BNXT_FLAG_NO_AGG_RINGS);
+	if (page_mode & BNXT_FLAG_RX_PAGE_MODE) {
+		bp->flags &= ~(BNXT_FLAG_AGG_RINGS |
+			       BNXT_FLAG_NO_AGG_RINGS |
+			       BNXT_FLAG_RX_OFFLOAD_MODE);
 		bp->flags |= BNXT_FLAG_RX_PAGE_MODE;
 
 		if (bp->xdp_prog->aux->xdp_has_frags)
@@ -4982,15 +5096,24 @@ static void __bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
 			bp->rx_skb_func = bnxt_rx_page_skb;
 		}
 		bp->rx_dir = DMA_BIDIRECTIONAL;
+	} else if (page_mode & BNXT_FLAG_RX_OFFLOAD_MODE) {
+		bp->flags &= ~(BNXT_FLAG_AGG_RINGS |
+			       BNXT_FLAG_RX_PAGE_MODE);
+		bp->flags |= (BNXT_FLAG_RX_OFFLOAD_MODE |
+			      BNXT_FLAG_NO_AGG_RINGS);
+		dev->max_mtu = min_t(u16, bp->max_mtu, BNXT_MAX_PAGE_MODE_MTU);
+		bp->rx_skb_func = bnxt_rx_offload_netmem;
+		bp->rx_dir = DMA_BIDIRECTIONAL;
 	} else {
 		dev->max_mtu = bp->max_mtu;
 		bp->flags &= ~BNXT_FLAG_RX_PAGE_MODE;
+		bp->flags &= ~BNXT_FLAG_RX_OFFLOAD_MODE;
 		bp->rx_dir = DMA_FROM_DEVICE;
 		bp->rx_skb_func = bnxt_rx_skb;
 	}
 }
 
-void bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
+void bnxt_set_rx_skb_mode(struct bnxt *bp, int page_mode)
 {
 	__bnxt_set_rx_skb_mode(bp, page_mode);
 
@@ -5663,6 +5786,12 @@ static int bnxt_alloc_mem(struct bnxt *bp, bool irq_re_init)
 					BNXT_RING_TO_TC(bp, txr->txq_index);
 				bnapi2->tx_ring[txr->tx_napi_idx] = txr;
 				bnapi2->tx_int = bnxt_tx_int;
+			} else if (BNXT_RX_OFFLOAD_MODE(bp)) {
+				bnapi2 = bp->bnapi[j];
+				bnapi2->flags |= BNXT_NAPI_FLAG_XDP;
+				bnapi2->tx_ring[0] = txr;
+				bnapi2->tx_int = bnxt_tx_int_xdp;
+				j++;
 			} else {
 				bnapi2 = bp->bnapi[j];
 				bnapi2->flags |= BNXT_NAPI_FLAG_XDP;
@@ -11958,6 +12087,8 @@ static void bnxt_del_napi(struct bnxt *bp)
 	if (!bp->bnapi)
 		return;
 
+	bnxt_rx_offload_clear_napi(bp);
+
 	for (i = 0; i < bp->rx_nr_rings; i++)
 		netif_queue_set_napi(bp->dev, i, NETDEV_QUEUE_TYPE_RX, NULL);
 	for (i = 0; i < bp->tx_nr_rings - bp->tx_nr_rings_xdp; i++)
@@ -11997,6 +12128,8 @@ static void bnxt_init_napi(struct bnxt *bp)
 		bnapi = bp->bnapi[cp_nr_rings];
 		netif_napi_add_locked(bp->dev, &bnapi->napi, bnxt_poll_nitroa0);
 	}
+
+	bnxt_rx_offload_set_napi(bp);
 }
 
 static void bnxt_disable_napi(struct bnxt *bp)
@@ -13356,6 +13489,7 @@ static int bnxt_open(struct net_device *dev)
 						   BNXT_RESTART_ULP_SP_EVENT);
 		}
 	}
+	bnxt_rx_offload_start(bp);
 
 	return rc;
 }
@@ -13443,6 +13577,7 @@ static int bnxt_close(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
+	bnxt_rx_offload_stop(bp);
 	bnxt_close_nic(bp, true, true);
 	bnxt_hwrm_shutdown_link(bp);
 	bnxt_hwrm_if_change(bp, false);
@@ -13643,6 +13778,8 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_errors = BNXT_GET_TX_PORT_STATS64(tx, tx_err);
 	}
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
+	if (BNXT_RX_OFFLOAD_MODE(bp))
+		knod_dev_get_stats64(bp->knodev, stats);
 }
 
 static void bnxt_get_one_ring_drv_stats(struct bnxt *bp,
@@ -16518,6 +16655,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 
 	bnxt_aux_devices_del(bp);
 
+	bnxt_knod_uninit(bp);
 	unregister_netdev(dev);
 	bnxt_ptp_clear(bp);
 
@@ -17080,7 +17218,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	dev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-			    NETDEV_XDP_ACT_RX_SG;
+			    NETDEV_XDP_ACT_RX_SG | NETDEV_XDP_ACT_HW_OFFLOAD;
 
 #ifdef CONFIG_BNXT_SRIOV
 	init_waitqueue_head(&bp->sriov_cfg_wait);
@@ -17198,6 +17336,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
+	bnxt_knod_init(bp);
 
 	return 0;
 init_err_cleanup:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6335dfc14c98..d99590db6efa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -29,6 +29,8 @@
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
 #include <net/xdp.h>
+#include <net/knod.h>
+#include <net/spsc_ring.h>
 #include <linux/dim.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/bnxt/ulp.h>
@@ -884,10 +886,14 @@ struct nqe_cn {
 #define BNXT_REDIRECT_EVENT	8
 #define BNXT_TX_CMP_EVENT	0x10
 
+#define BNXT_NETMEM_ACT		0xf0
+#define BNXT_NETMEM_TX		(XDP_TX + BNXT_NETMEM_ACT)
+
 struct bnxt_sw_tx_bd {
 	union {
 		struct sk_buff		*skb;
 		struct xdp_frame	*xdpf;
+		netmem_ref		netmem;
 	};
 	DEFINE_DMA_UNMAP_ADDR(mapping);
 	DEFINE_DMA_UNMAP_LEN(len);
@@ -2300,6 +2306,7 @@ struct bnxt {
 	#define BNXT_FLAG_TX_COAL_CMPL	0x8000000
 	#define BNXT_FLAG_PORT_STATS_EXT	0x10000000
 	#define BNXT_FLAG_HDS		0x20000000
+	#define BNXT_FLAG_RX_OFFLOAD_MODE	0x40000000
 	#define BNXT_FLAG_AGG_RINGS	(BNXT_FLAG_JUMBO | BNXT_FLAG_GRO | \
 					 BNXT_FLAG_LRO | BNXT_FLAG_HDS)
 
@@ -2324,6 +2331,7 @@ struct bnxt {
 				 (bp)->link_info.phy_state == BNXT_PHY_STATE_ENABLED)
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
+#define BNXT_RX_OFFLOAD_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_OFFLOAD_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
 				 (!((bp)->flags & BNXT_FLAG_CHIP_P5_PLUS) ||\
 				  (bp)->max_tpa_v2) && !is_kdump_kernel())
@@ -2748,6 +2756,8 @@ struct bnxt {
 #define BNXT_DUMP_LIVE_WITH_CTX_L1_CACHE	3
 
 	struct bpf_prog		*xdp_prog;
+	struct knod_netdev	*knetdev;
+	struct knod_dev	*knodev;
 
 	struct bnxt_ptp_cfg	*ptp_cfg;
 	u8			ptp_all_rx_tstamp;
@@ -2964,7 +2974,7 @@ u32 bnxt_fw_health_readl(struct bnxt *bp, int reg_idx);
 bool bnxt_bs_trace_avail(struct bnxt *bp, u16 type);
 void bnxt_set_tpa_flags(struct bnxt *bp);
 void bnxt_set_ring_params(struct bnxt *);
-void bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode);
+void bnxt_set_rx_skb_mode(struct bnxt *bp, int page_mode);
 void bnxt_insert_usr_fltr(struct bnxt *bp, struct bnxt_filter_base *fltr);
 void bnxt_del_one_usr_fltr(struct bnxt *bp, struct bnxt_filter_base *fltr);
 int bnxt_hwrm_func_drv_rgtr(struct bnxt *bp, unsigned long *bmap,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 9e5009be8e98..a264a2cf8302 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -156,6 +156,11 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 				tx_buf = &txr->tx_buf_ring[RING_TX(bp, tx_cons)];
 				page_pool_recycle_direct(rxr->page_pool, tx_buf->page);
 			}
+		} else if (tx_buf->action == BNXT_NETMEM_TX) {
+			page_pool_recycle_direct_netmem(rxr->page_pool,
+							tx_buf->netmem);
+			tx_buf->action = 0;
+			tx_buf->netmem = 0;
 		} else {
 			bnxt_sched_reset_txr(bp, txr, tx_cons);
 			return;
@@ -423,7 +428,7 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		bpf_prog_put(old);
 
 	if (prog) {
-		bnxt_set_rx_skb_mode(bp, true);
+		bnxt_set_rx_skb_mode(bp, BNXT_FLAG_RX_PAGE_MODE);
 		xdp_features_set_redirect_target_locked(dev, true);
 	} else {
 		xdp_features_clear_redirect_target_locked(dev);
@@ -441,19 +446,123 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 	return 0;
 }
 
+
+static int bnxt_xdp_offload_set(struct bnxt *bp, int enable)
+{
+	struct net_device *dev = bp->dev;
+	int tx_xdp = 0, tx_cp, rc, tc;
+
+	netdev_assert_locked(dev);
+
+	if (!(bp->flags & BNXT_FLAG_SHARED_RINGS)) {
+		netdev_warn(dev, "ethtool rx/tx channels must be combined to support XDP.\n");
+		return -EOPNOTSUPP;
+	}
+	if (enable && dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {
+		netdev_warn(dev, "MTU %d larger than %d for single-page RX offload.\n",
+			    dev->mtu, BNXT_MAX_PAGE_MODE_MTU);
+		return -EOPNOTSUPP;
+	}
+	if (enable)
+		tx_xdp = bp->rx_nr_rings;
+
+	tc = bp->num_tc;
+	if (!tc)
+		tc = 1;
+	rc = bnxt_check_rings(bp, bp->tx_nr_rings_per_tc, bp->rx_nr_rings,
+			      true, tc, tx_xdp);
+	if (rc) {
+		netdev_warn(dev, "Unable to reserve enough TX rings to support XDP.\n");
+		return rc;
+	}
+	if (netif_running(dev))
+		bnxt_close_nic(bp, true, false);
+
+	if (enable) {
+		bnxt_set_rx_skb_mode(bp, BNXT_FLAG_RX_OFFLOAD_MODE);
+		xdp_features_set_redirect_target_locked(dev, true);
+	} else {
+		xdp_features_clear_redirect_target_locked(dev);
+		bnxt_set_rx_skb_mode(bp, false);
+	}
+	bp->tx_nr_rings_xdp = tx_xdp;
+	bp->tx_nr_rings = bp->tx_nr_rings_per_tc * tc + tx_xdp;
+	tx_cp = bnxt_num_tx_to_cp(bp, bp->tx_nr_rings);
+	bp->cp_nr_rings = max_t(int, tx_cp, bp->rx_nr_rings);
+	bnxt_set_tpa_flags(bp);
+	bnxt_set_ring_params(bp);
+
+	if (netif_running(dev))
+		return bnxt_open_nic(bp, true, false);
+
+	return 0;
+}
+
+void bnxt_rx_offload_set_napi(struct bnxt *bp)
+{
+	struct knod_dev *knodev = bp->knodev;
+	int i;
+
+	if (!BNXT_RX_OFFLOAD_MODE(bp))
+		return;
+
+	for (i = 0; i < KNOD_SPSC_MAX && i < bp->cp_nr_rings; i++)
+		WRITE_ONCE(knodev->wpriv[i].napi, &bp->bnapi[i]->napi);
+}
+
+void bnxt_rx_offload_clear_napi(struct bnxt *bp)
+{
+	struct knod_dev *knodev = bp->knodev;
+	int i;
+
+	if (!BNXT_RX_OFFLOAD_MODE(bp))
+		return;
+
+	for (i = 0; i < KNOD_SPSC_MAX; i++)
+		WRITE_ONCE(knodev->wpriv[i].napi, NULL);
+}
+
+void bnxt_rx_offload_start(struct bnxt *bp)
+{
+	if (!BNXT_RX_OFFLOAD_MODE(bp))
+		return;
+
+	knod_dev_start(bp->knodev);
+}
+
+void bnxt_rx_offload_stop(struct bnxt *bp)
+{
+	if (!BNXT_RX_OFFLOAD_MODE(bp))
+		return;
+
+	knod_dev_stop(bp->knodev);
+}
+
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	struct bnxt *bp = netdev_priv(dev);
+	struct knod_dev *knodev;
 	int rc;
 
+	knodev = bp->knodev;
+
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		rc = bnxt_xdp_set(bp, xdp->prog);
 		break;
+	case XDP_SETUP_PROG_HW:
+	case BPF_OFFLOAD_MAP_ALLOC:
+	case BPF_OFFLOAD_MAP_FREE:
+		if (!knodev)
+			return -EOPNOTSUPP;
+
+		rc = knod_dev_xdp_install(knodev, xdp);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
 	}
+
 	return rc;
 }
 
@@ -528,3 +637,166 @@ int bnxt_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 	*rss_type = hash_type;
 	return 0;
 }
+
+int bnxt_rx_offload_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
+			u16 cons, void *data, unsigned int len, int index,
+			u8 *event)
+{
+	struct knod_dev *knodev = READ_ONCE(bp->knodev);
+
+	return knodev->accel_ops->xdp_ops->rx_netmem(bp->knodev, (netmem_ref)data, len,
+					  bp->rx_offset, index);
+}
+
+static int bnxt_rx_offload_xdp_attach(struct knod_dev *knodev)
+{
+	struct bnxt *bp = netdev_priv(knodev->netdev);
+	int rc;
+
+	WRITE_ONCE(bp->knodev, knodev);
+	rc = bnxt_xdp_offload_set(bp, true);
+	if (rc)
+		WRITE_ONCE(bp->knodev, NULL);
+
+	return rc;
+}
+
+static int bnxt_rx_offload_xdp_detach(struct knod_dev *knodev)
+{
+	struct bnxt *bp = netdev_priv(knodev->netdev);
+
+	WRITE_ONCE(bp->knodev, NULL);
+	bnxt_xdp_offload_set(bp, false);
+
+	return 0;
+}
+
+static void __bnxt_xmit_netmem(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+			       dma_addr_t mapping, u32 len,
+			       netmem_ref netmem)
+{
+	struct bnxt_sw_tx_bd *tx_buf;
+
+	tx_buf = bnxt_xmit_bd(bp, txr, mapping, len, NULL);
+	tx_buf->action = BNXT_NETMEM_TX;
+	tx_buf->netmem = netmem;
+	netmem_dma_unmap_addr_set(netmem, tx_buf, mapping, mapping);
+	dma_unmap_len_set(tx_buf, len, 0);
+}
+
+struct knod_nic_ops nic_ops = {
+	.attach = bnxt_rx_offload_xdp_attach,
+	.detach = bnxt_rx_offload_xdp_detach,
+};
+
+int bnxt_rx_offload_act_handler(struct bnxt_napi *bnapi, int budget)
+{
+	struct bnxt_tx_ring_info *txr = bnapi->tx_ring[0];
+	struct bnxt_rx_ring_info *rxr = bnapi->rx_ring;
+	struct spsc_bd *bds[NAPI_POLL_WEIGHT];
+	u32 tx_avail, cnt, i, nxmit = 0;
+	struct knod_dev *knodev;
+	struct knod_work_priv *wpriv;
+	struct napi_struct *napi;
+	struct bnxt *bp = bnapi->bp;
+	dma_addr_t mapping;
+
+	knodev = bp->knodev;
+	if (!knodev)
+		return 0;
+
+	if (bnapi->index >= bp->dev->real_num_tx_queues) {
+		this_cpu_inc(knodev->stats->tx_dropped);
+		return 0;
+	}
+
+	wpriv = &knodev->wpriv[bnapi->index];
+	napi = READ_ONCE(wpriv->napi);
+	if (!napi)
+		return 0;
+
+	tx_avail = bnxt_tx_avail(bp, txr);
+	cnt = min_t(u32, NAPI_POLL_WEIGHT, tx_avail);
+	cnt = min_t(u32, cnt, budget);
+	if (!cnt)
+		return 0;
+
+	spsc_release(&wpriv->spsc_bds, (void **)bds, cnt, &cnt);
+	if (!cnt)
+		return 0;
+
+	for (i = 0; i < cnt; i++) {
+		switch (bds[i]->act) {
+		case KNOD_ACT_INFLIGHT:
+		case KNOD_IPSEC_INFLIGHT:
+			goto stop_release;
+		case XDP_TX:
+			mapping = netmem_to_net_iov(bds[i]->netmem)->desc.dma_addr +
+				  bds[i]->off;
+			__bnxt_xmit_netmem(bp, txr, mapping, bds[i]->len,
+					   bds[i]->netmem);
+			nxmit++;
+			break;
+		case XDP_ABORTED:
+			fallthrough;
+		case XDP_DROP:
+			fallthrough;
+		case XDP_PASS:
+			fallthrough;
+		case XDP_REDIRECT:
+			fallthrough;
+		default:
+			page_pool_recycle_direct_netmem(rxr->page_pool,
+							bds[i]->netmem);
+			this_cpu_inc(knodev->stats->tx_dropped);
+			break;
+		}
+	}
+stop_release:
+	if (nxmit) {
+		wmb();
+		bnxt_db_write(bp, &txr->tx_db, txr->tx_prod);
+	}
+	spsc_release_commit(&wpriv->spsc_bds, i);
+
+	/*
+	 * Device->host delivery: drain the framework pending ring for this NIC
+	 * RX queue and push the built skbs up the stack.  Covers all features
+	 * (bpf/none deliver directly, ipsec via knod_dev->post_copy); no-op
+	 * when nothing is attached.
+	 */
+	knod_dev_xdp_drain_pass(knodev, napi, bnapi->index, budget);
+
+	return i;
+}
+
+int bnxt_knod_init(struct bnxt *bp)
+{
+	struct knod_netdev *knetdev;
+
+	knetdev = kzalloc_obj(struct knod_netdev, GFP_KERNEL);
+	if (!knetdev) {
+		pr_debug("Failed to allocate knetdev\n");
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&knetdev->list);
+	knetdev->dev = bp->dev;
+	knetdev->priv = bp;
+	knetdev->nic_ops = &nic_ops;
+	knetdev->owner = THIS_MODULE;
+	knetdev->flags |= KNOD_FLAGS_XDP;
+	knod_netdev_register(knetdev);
+	bp->knetdev = knetdev;
+
+	return 0;
+}
+
+void bnxt_knod_uninit(struct bnxt *bp)
+{
+	knod_netdev_unregister(bp->knetdev);
+	kfree(bp->knetdev);
+	bp->knetdev = NULL;
+	kfree(bp->knodev);
+	WRITE_ONCE(bp->knodev, NULL);
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index fb4f9143929f..7f2a850e4787 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -24,9 +24,14 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   dma_addr_t mapping, u32 len,
 				   struct xdp_buff *xdp);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int budget);
+void bnxt_tx_int_offload(struct bnxt *bp, struct bnxt_napi *bnapi, int budget);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 struct xdp_buff *xdp, struct page *page, u8 **data_ptr,
 		 unsigned int *len, u8 *event);
+void bnxt_rx_offload_stop(struct bnxt *bp);
+void bnxt_rx_offload_start(struct bnxt *bp);
+void bnxt_rx_offload_set_napi(struct bnxt *bp);
+void bnxt_rx_offload_clear_napi(struct bnxt *bp);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		  struct xdp_frame **frames, u32 flags);
@@ -43,5 +48,10 @@ struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
 				   struct xdp_buff *xdp);
 int bnxt_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
 		     enum xdp_rss_hash_type *rss_type);
-
+int bnxt_rx_offload_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
+			u16 cons, void *data, unsigned int len, int index,
+			u8 *event);
+int bnxt_rx_offload_act_handler(struct bnxt_napi *bnapi, int budget);
+int bnxt_knod_init(struct bnxt *bp);
+void bnxt_knod_uninit(struct bnxt *bp);
 #endif
-- 
2.43.0

