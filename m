Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601808;
	b=DHha/7igbyCrWMLokSDh36EsUvrmZAmkARoA2/rfDiORLpwpUjgbuHe47k8rd0keISna
	 3ZJDkcZxCBXE2WDbjPi6WZuagujW1GkpLfaO7Lnh+Y5pzehn4btfXEiAdoEVOzoVh0y7N
	 lGnshGrccyIwN/Niu/ZOBr43JSW4oNKBFlvIyP5SuNRgfqXPjtsXiHNzH30BBmDh0KlUZ
	 keJVPn8NmB/abh8uiLfeswNCm+bIo6XN8ShNS9c1oolnpETjSckzB6gZAmzdAVVA7lVJ3
	 rSEpu2NfYSoLbKChxwAudlFlNj6J3wcor6XxE97Xnfs+5/jzVCcwtxF8SqLM6AwBevQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cch0bi9+NbFtuaXErBFOK272My4N6BW/oY3L9VqLD5s=;
	b=3eqAIsTFu7CyYRpYUVczhFs4eLxZQnfBMm28/ZaH4MUOj274WZGKoVDlPz9x269Upl9o
	 7cr720MINc1zjdcDVJitBVbo7Xztoj181lO6ejQ6Krb2ISEwwKcTFVftXN+qk6yTBvPDQ
	 TNNzY5wYV4nQwJVYGvhOlgp/qQI9OqaspiH1UOGy4vairYL6SOmryrH+JHMnIINU8uAT/
	 wPo2EWeOIdxsVARuaqjzSOzzwSkHdTOlUWwZiy7+3Kl7K4kmacrM1hYXOC2kNVPoBEmkv
	 nR0BmujzsfJLWGVLjwlxWsRh41g45GiED3nRLCRa4pSaqS7YjzVv9eW9EIwxF51Lrtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fd2IgLOb;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD7606A329
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 06:43:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DECD7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Fd2IgLOb
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so2125000f8f.1
        for <linux-rdma@vger.kernel.org>; Sun, 01 Nov 2026 22:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793601806; x=1794206606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cch0bi9+NbFtuaXErBFOK272My4N6BW/oY3L9VqLD5s=;
        b=Fd2IgLObu+O8EIDuwqEXSbT+Lmt6lkFZ1vGgxdrQyksTyVsALvAxVk34TZsr8GH3zz
         PPGYvfq9SYbmsff5dWp45lus2GhoaISJMbYsdnZha8HNfZaY34MB7FP0S9OMebo1SWRX
         DoZF3bkpBFxfSpvqhRT/elcXplgxaCDqUPOLsR5JfJ+kwObifDHqlgAW3lFxdoR+JXMG
         7iv8IfRgEQZAI6nuskgCXTsP0D6+pudlZ15AW8IZRduFDjfUP3farFxaB5Dj48LMEr6C
         OpMyu699mFDJR+dwZcmew/L6JtiMvIfDKLHz6EzHcMUAcYMf9OZc5gDZovNxBxaXPG7p
         z0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793601806; x=1794206606;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cch0bi9+NbFtuaXErBFOK272My4N6BW/oY3L9VqLD5s=;
        b=LUdZq3KSGbJthjfKOrqFXrqhQtgw/STrjfuuqQmCUrGuSmdEA7yJuQCBW3q6zeT3cb
         e6eWTHvLu4/Lcx2DnenqA5sAGateWq7kcP2J2d1i7vCqX8XXf++q/bUuUmm9PNZAifeL
         BeExtE9llKXDdI3YS4Zze+TvgFE5tEMuE3GNPST8oCgyLZNm84xeCLkGdjMas6lLEsIt
         cHy8EuZvQdp6OldhEdLn+AQ5grq8N8KETN3dHQGn80YGeucChqqWLjl6Wm+r0G1cz4TX
         X7LJEGNVdnB5kVIVHT6EDGYjHWpUd9KTzgZ149FCSDWlND2APfwtmjIrgp4ECxoA0lza
         kCdQ==
X-Forwarded-Encrypted: i=1; AKwUvByyUeWHn0Zcwq+DfN5pqU7xLmgYKP2/ZseZfN9SNUU2NYI6nv+JUaB81XXC+qjw30wJvv/HApf9/qMC@vger.kernel.org
X-Gm-Message-State: APuU4Z/izQi/6kM1RbI2B1a2nyaLyZ+DQI4lcOa6fyM2B/lMhv4h/PWD
	4kVZyqi6YVyjE680acWZh48naO5PkFYODw3soR5HPwFsPtQpTFszi6uE
X-Gm-Gg: AYBFou3JXxNBYBZ8FJOYcozMa6/ffy+vVn8XVOi2mb7bqIiApyUAl28YlCIMjSQLcQH
	WnRkG+ZEAu66k5RZn5pjx59x1Utlmvlf6zrArAsszgpvj6wOByioWjMmc9CHOs+tHlYxJUovrvr
	TFPTG9VFQvtgM7cW2rLDH3ACNaY/pwfD4Ip6ZFeRDCNUYuKEoIJwU+4fzpHvFQDKwqM8Cj1+dz2
	Zvmr4D76gOs5mnFO46hNKJAaLUchl2I+rS6dz+52kwfVEm2x924cImtexU2gYcrAB9f+xwnaiFL
	0+fhKl+P1GpG7Y23VkCx/guX9I+7mb7fPIknlvBfA69EKRVWQ/1Kcy0t9jHFEiDTUPOwrBcqTMQ
	2Bp8Pdibg24gY02zjZZYZDdNK4Gz2H6roZ6bS0OZ4Cr+9BWpfSfU2KGZxPz9SIf1/P8tEdOLTEF
	3FEmJt4xoQzC+FWY5aFdM08CkMEtO+kRvbzAP8H4Fn0AdJ4+OnLNnIAKCduGFA+k4/qk87RDBsV
	jf5RzShjpQ7eZpz2V1q0xZE9hvnANNXDdP9e4mC0i7fZZXsIv5qI/ja42VFw984ODrcgWAM7YBH
	cS4VlcXZMLtLGDWTU2LdAqwyWVuJwcof9Q4KCszkSQTQKShBNRZi6Id+52ihQVKKnxHA9Y8Vip4
	Kw6PdttKeryEXeQUpr/J05HNGVbafreJMM9asCXHDJ0EOYwQi7tzIhun9GOHs71loNaCp
X-Received: by 2002:a05:6000:26ce:b0:48a:f454:3d4 with SMTP id ffacd0b85a97d-48e6e52a7e3mr19310220f8f.53.1793601805912;
        Sun, 01 Nov 2026 22:43:25 -0800 (PST)
Received: from center.jhjvjihww5qejoy14qwv1cc4td.frax.internal.cloudapp.net ([131.189.143.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba4ac6sm19305747f8f.52.2026.11.01.22.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 22:43:25 -0800 (PST)
From: Orgad Shaneh <orgads@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Hu <weh@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Long Li <longli@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Muhammad Falak R Wani <falakreyaz@gmail.com>,
	Jesse Brandeburg <jbrandeb@kernel.org>
Subject: [PATCH net] net: mana: fix XDP_REDIRECT of pre-allocated RX buffers
Date: Mon,  2 Nov 2026 06:43:24 +0000
Message-ID: <20261102064324.806414-1-orgads@gmail.com>
X-Mailer: git-send-email 2.47.3
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

mana_pre_alloc_rxbufs() fills the RX rings with plain pages from
dev_alloc_pages() (from_pool == false), but the rxq is registered with
MEM_TYPE_PAGE_POOL and mana_run_xdp() builds every xdp_buff with that
rxq info. mana_rx_skb() frees a !from_pool buffer correctly on
XDP_PASS, XDP_TX and XDP_DROP, but a redirected buffer is freed through
its memory model: __xdp_return() hands the plain page to
page_pool_put_full_netmem(). This triggers the WARN in
include/net/page_pool/helpers.h, breaks the page refcount, RX refills
fail and the queue stops receiving.

The pre-allocated buffers fill the whole ring of every rxq created by
an MTU change, by ethtool -L / -G and, since
commit 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers
instead of full pages to improve memory efficiency."), by every XDP
attach and detach. So on current kernels the first ring of redirected
packets after attaching an XDP program always hits this.

Reproduced on 7.2.11, and on 6.12.113 after ethtool -L, on an Azure
MANA VF: an XDP program that redirects UDP to an XSKMAP with an AF_XDP
socket in copy mode gives WARNINGs at __xdp_return+0x249 (stack
__xsk_map_redirect, xdp_do_redirect, mana_run_xdp, mana_poll), then
the queue stops.

Give each rxq a second xdp_rxq_info registered with
MEM_TYPE_PAGE_SHARED, the model these buffers had before the page pool
was added, and use it for buffers that are not from the pool. Those
buffers are already DMA-unmapped by mana_refill_rx_oob() before XDP
runs, and page_frag_free() frees them whatever their order. Allocating
the pre-allocated buffers from the page pool instead would need the
pools to exist before the rxqs and to outlive them, a much larger
change.

Found, fixed and tested with an AI coding assistant (Claude Code).

Fixes: b1d13f7a3b53 ("net: mana: Add page pool for RX buffers")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
---
Tested on an Azure D2s_v6 MANA VF, net at cb284914e749 with and
without this patch (same config), XDP program redirecting UDP to an
AF_XDP socket in copy mode on queue 0, 25k pps offered right after
attach:
- without: 41 WARNINGs at __xdp_return+0x252, 0 packets relayed,
  hc_rx_discards_no_wqe 301470.
- with: no WARNING, 25k of 25k pps relayed, 0 loss; also over three
  more attach/detach cycles, two ethtool -L combined 1/2 cycles and an
  MTU 4000/1500 change before attach. MemAvailable unchanged.
W=1 build of the mana directories: no new warnings.

 drivers/net/ethernet/microsoft/mana/mana_bpf.c |  9 +++++++--
 drivers/net/ethernet/microsoft/mana/mana_en.c  | 11 ++++++++++-
 include/net/mana/mana.h                        |  5 ++++-
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_bpf.c b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
index 7c55f8724441..494267b3069a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_bpf.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_bpf.c
@@ -78,7 +78,8 @@ int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 }
 
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
-		 struct xdp_buff *xdp, void *buf_va, uint pkt_len)
+		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
+		 uint pkt_len)
 {
 	struct mana_stats_rx *rx_stats;
 	struct bpf_prog *prog;
@@ -90,7 +91,11 @@ u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
 	if (!prog)
 		goto out;
 
-	xdp_init_buff(xdp, PAGE_SIZE, &rxq->xdp_rxq);
+	/* A redirected buffer is freed by its memory model, so a buffer not
+	 * from the page pool must not claim MEM_TYPE_PAGE_POOL.
+	 */
+	xdp_init_buff(xdp, PAGE_SIZE,
+		      from_pool ? &rxq->xdp_rxq : &rxq->xdp_rxq_shared);
 	xdp_prepare_buff(xdp, buf_va, rxq->headroom, pkt_len, true);
 
 	act = bpf_prog_run_xdp(prog, xdp);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6b7c027e497e..7547aeb3235d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2157,7 +2157,7 @@ static void mana_rx_skb(void *buf_va, bool from_pool,
 		return;
 	}
 
-	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, pkt_len);
+	act = mana_run_xdp(ndev, rxq, &xdp, buf_va, from_pool, pkt_len);
 
 	if (act == XDP_REDIRECT && !rxq->xdp_rc)
 		return;
@@ -2947,6 +2947,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq_shared))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq_shared);
+
 	if (rxq->rxobj != INVALID_MANA_HANDLE)
 		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
@@ -3225,6 +3228,12 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
 					   rxq->page_pool));
 
+	/* The pre-allocated buffers (mana_pre_alloc_rxbufs) are plain pages */
+	WARN_ON(xdp_rxq_info_reg(&rxq->xdp_rxq_shared, ndev, rxq_idx,
+				 cq->napi.napi_id));
+	WARN_ON(xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq_shared,
+					   MEM_TYPE_PAGE_SHARED, NULL));
+
 	/* Initialize the DIM work before enabling NAPI, so that a poll
 	 * cannot reach net_dim() with an uninitialized cq->dim.work.
 	 */
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 71d726b1f784..11ceb5946ee0 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -420,6 +420,8 @@ struct mana_rxq {
 
 	struct bpf_prog __rcu *bpf_prog;
 	struct xdp_rxq_info xdp_rxq;
+	/* For buffers not from the page pool (from_pool == false) */
+	struct xdp_rxq_info xdp_rxq_shared;
 	void *xdp_save_va; /* for reusing */
 	bool xdp_flush;
 	int xdp_rc; /* XDP redirect return code */
@@ -695,7 +697,8 @@ void mana_xdp_tx(struct sk_buff *skb, struct net_device *ndev);
 int mana_xdp_xmit(struct net_device *ndev, int n, struct xdp_frame **frames,
 		  u32 flags);
 u32 mana_run_xdp(struct net_device *ndev, struct mana_rxq *rxq,
-		 struct xdp_buff *xdp, void *buf_va, uint pkt_len);
+		 struct xdp_buff *xdp, void *buf_va, bool from_pool,
+		 uint pkt_len);
 struct bpf_prog *mana_xdp_get(struct mana_port_context *apc);
 void mana_chn_setxdp(struct mana_port_context *apc, struct bpf_prog *prog);
 int mana_bpf(struct net_device *ndev, struct netdev_bpf *bpf);

base-commit: cb284914e749388eef402938bdb3115fe1f6d337
-- 
2.52.0

