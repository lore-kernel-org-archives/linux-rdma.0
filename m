Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF833484226
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.0
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787155543; cv=none; b=jOU4S042zkSii6KgoFO0xS/eN34eoWR50WIZ5YXYDB/9a92vLOP/cHvZ+GzIEj9omovO0BG90Oj7oweRzYJ9F1Xg+avNgnX4PoOHcCQYnzwOmdxRn2wRDk8iA3duTFbVFbEmJ8pTKJ14UPDzlznsM20pccfzlWx9Jb5CSpURnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787155543; c=relaxed/simple;
	bh=h/yRTy+q/aTNWgdAyARpnxO02skNFXM6ZPvX24ue7RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSrXLAfzBusBniiHH9+3t76aUFZsPoy8xs8xJCZVb4hs1wPeQGxJ4TgexRoORdbX+bUthKfHT7amu7iYzynpH4uIk56nXqTY1+rzaF76ep3cZ4FIdC6aPYn6WN8/yxTlt06BUl1mGBNm3MiHLvKYKLnsClbnHMCb4g++6WX3a8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SqKnIAEV; arc=none smtp.client-ip=74.125.228.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqKnIAEV"
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-ca7fcfe1669so388118a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787155540; x=1787760340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=knHPZ2hqDlF6r7lICpyiSankCSnQUl1ZecmnK0yjr1w=;
        b=SqKnIAEVzE6ey1YH6WKmKdq8rqQVdIJ82Zu8D/ppptSaaf18B6po5czRgTNQ8FMYAS
         bjx3QNg91iHQ19+oz0q/qOVzuy2flTwPjrBtrjhUonc0doeAet3vAAIgr/8qnngn9Jiw
         OlfHAtXMNbAmZJRhY1BVHtfSr9/6KX4r2j2MXatRTg7pSR7HBnB4eC700bH3mSS1JVWf
         IunyYKl2gkewa+WFuhJQjtQYYzJU6Pa1JA2OZCF9hfmFoDYxdMEWRNCwCfxCEdyqJmct
         DaCC8hXQ6If10Ko/o/39jxsCf/NZoFAGoE4tE/Yez3SPcSDO7zWttMt6Cl5juPUUqp0F
         tfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787155540; x=1787760340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=knHPZ2hqDlF6r7lICpyiSankCSnQUl1ZecmnK0yjr1w=;
        b=dAKjtcaoIYaBvS2Xb1mEQs4ELcAd9PduvdJBdszstqFub/4f43Om26x0Jw8w3GyobG
         t0pRwP4ubQAvJbP/cdYtYEa423GsgE3vONJAnV22GIn1Mln3+21/Ep9EmfYgoSLIHcrC
         PoV9mzGa8tuCZxgt7l/uO4lIQHI/1HD6tJhZB+uwzNJOblxeIJ8qUSv3vZElUpqqIvVy
         5aVCIlXuRk4xJxoPOtKI3IU1azzpd4NkSlQe+gtTCNIFoTHlTKsmhuG3qdYVLhASxvmP
         JNQEI1N+aKhAvww4O+pAf0F0cXlnEXu/zmVlewLkNc+9JpyRc1k+aMmycLmhc1vU1mBq
         Houg==
X-Forwarded-Encrypted: i=1; AHgh+RrCZ64FVy4RZhm/StFHGdxc0HSWpGuz+0SeHVRx0P9tHUMT4NkRfkD8DG4HQvbIxX8ngGVR1OUjL5oi@vger.kernel.org
X-Gm-Message-State: AOJu0YwavwWTF6yjNJTRUZPYJtTEEuKGj4DbJQVa1oCud19FzyYIgi0T
	+u2PR4wCislhIF1dddLiCqit7Dykr4TiDdyF0j8f4sL9/W88wVbzztD4
X-Gm-Gg: AR+sD13wEBmx07mK58UREMhZZQBfsqt3Rcu/IGbbWb9xxxBZf+C79K7nmpBiE4dSnpS
	vl+Z/PwNz1JIZ9YCntkCrUtWdmDFSJCKsmhKkIRC3TRwgHvup3kBpAR68vG7nm+4xzIR6nk0D/0
	GXU14kDl9sOOlqufnm9SFOsSOBuIunWcFq1LnVrDBwiUBiJoXvaWfvWccxcG9IaV2e1/McXbX08
	7n/o5vpE8LfsQV5exwBS1mEHX0iYNshh+NshCnA7Sxo513HaUzlm3yfVj+cAqyB7sZkk/MxoRXw
	jNLg9GnYJEsrXilrSiCWsyzgVzhkEwo/H1h3L4GH/uY46VXD8XSjCnWQHV53PZVAs6NW4bpWpaZ
	gjCvGkrBhawX71zYrJyzerisNbrgXZCUgQ8Yf4jukclxSNYhnP7b6hWY9nbngZ+7vFlVLBpkXRK
	b5MkX1rmcCX3fQJQVxe2sB13DAlWq09sM/p4WUoECc8uF94U8Cu0kmXjl7K9WovAv1
X-Received: by 2002:a05:6a00:bd90:b0:848:2e7e:353a with SMTP id d2e1a72fcca58-851d3481104mr8568063b3a.0.1787155540004;
        Wed, 19 Aug 2026 09:05:40 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:46::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851d33b82bbsm857116b3a.24.2026.08.19.09.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 09:05:39 -0700 (PDT)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	andrew+netdev@lunn.ch,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	maxime.chevallier@bootlin.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	aleksander.lobakin@intel.com,
	horms@kernel.org,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	sdf@fomichev.me,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	guoren@kernel.org,
	dtatulea@nvidia.com,
	witu@nvidia.com,
	martin.lau@kernel.org,
	yoong.siang.song@intel.com,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	bpf@vger.kernel.org,
	linux-csky@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net v3 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
Date: Wed, 19 Aug 2026 09:05:34 -0700
Message-ID: <20260819160535.1472459-3-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819160535.1472459-1-sdf@fomichev.me>
References: <20260819160535.1472459-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zero-copy path reads TX metadata whenever the UMEM has metadata space,
even if the descriptor does not set XDP_TX_METADATA. Pass descriptor
options through the metadata helpers and ignore metadata unless the option
is set.

This does not fix the existing per-WQE metadata handling for mlx5 MPWQEs.
Only the descriptor that starts a session passes through
xsk_tx_metadata_request() and configures offload state shared by the batch.
Metadata on descriptors joining an open session is therefore not validated
and does not configure its requested offloads. In addition, a non-NULL
metadata pointer from such a descriptor is treated as a timestamp
completion request even when XDP_TXMD_FLAGS_TIMESTAMP is not set, so its
metadata union can be overwritten with an unrequested timestamp. Fixing
mixed metadata states within one MPWQE requires a separate change.

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/ethernet/intel/igc/igc_main.c     |  3 ++-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
 include/net/libeth/xsk.h                      |  2 +-
 include/net/xdp_sock_drv.h                    | 22 +++++++++++--------
 include/net/xsk_buff_pool.h                   |  3 ++-
 net/xdp/xsk_buff_pool.c                       |  7 ++++--
 7 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 39043d8ca1bf..59067939a586 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3074,7 +3074,8 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		olinfo_status = xdp_desc.len << IGC_ADVTXD_PAYLEN_SHIFT;
 
 		dma = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
-		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
+		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
+					     xdp_desc.options);
 		xsk_buff_raw_dma_sync_for_device(pool, dma, xdp_desc.len);
 		bi = &ring->tx_buffer_info[ntu];
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 3d19dad8f868..d194eeddd7b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -99,7 +99,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool, desc.addr);
 		xdptxd.data = xsk_buff_raw_get_data(pool, desc.addr);
 		xdptxd.len = desc.len;
-		meta = xsk_buff_get_metadata(pool, desc.addr);
+		meta = xsk_buff_get_metadata(pool, desc.addr, desc.options);
 
 		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a71f0df26378..62de03e65a90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2719,7 +2719,8 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 		tx_desc = stmmac_get_tx_desc(priv, tx_q, entry);
 		dma_addr = xsk_buff_raw_get_dma(pool, xdp_desc.addr);
-		meta = xsk_buff_get_metadata(pool, xdp_desc.addr);
+		meta = xsk_buff_get_metadata(pool, xdp_desc.addr,
+					     xdp_desc.options);
 		xsk_buff_raw_dma_sync_for_device(pool, dma_addr, xdp_desc.len);
 
 		/* To return XDP buffer to XSK pool, we simple call
diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
index 5dcc0d7f65b7..a452b7828ce4 100644
--- a/include/net/libeth/xsk.h
+++ b/include/net/libeth/xsk.h
@@ -196,7 +196,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct xdp_desc *xdesc,
 	struct libeth_xdp_tx_desc desc;
 	struct xdp_desc_ctx ctx;
 
-	ctx = xsk_buff_raw_get_ctx(sq->pool, xdesc->addr);
+	ctx = xsk_buff_raw_get_ctx(sq->pool, xdesc->addr, xdesc->options);
 	desc = (typeof(desc)){
 		.addr	= ctx.dma,
 		__libeth_xdp_tx_len(xdesc->len),
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index b344789f5df8..d94aeb506379 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -240,6 +240,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
  * xsk_buff_raw_get_ctx - get &xdp_desc context
  * @pool: XSk buff pool desc address belongs to
  * @addr: desc address (from userspace)
+ * @options: desc options (from userspace)
  *
  * Wrapper for xp_raw_get_ctx() to be used in drivers, see its kdoc for
  * details.
@@ -248,9 +249,9 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
  * pointer, if it is present (initialized to %NULL otherwise).
  */
 static inline struct xdp_desc_ctx
-xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
+xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
-	return xp_raw_get_ctx(pool, addr);
+	return xp_raw_get_ctx(pool, addr, options);
 }
 
 #define XDP_TXMD_FLAGS_VALID ( \
@@ -318,18 +319,20 @@ xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
 }
 
 static inline struct xsk_tx_metadata *
-__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
+__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
+			unsigned int options)
 {
-	if (!pool->tx_metadata_len)
+	if (!pool->tx_metadata_len || !(options & XDP_TX_METADATA))
 		return NULL;
 
 	return data - pool->tx_metadata_len;
 }
 
 static inline struct xsk_tx_metadata *
-xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
+xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
-	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool, addr));
+	return __xsk_buff_get_metadata(pool, xp_raw_get_data(pool, addr),
+				       options);
 }
 
 static inline void xsk_buff_dma_sync_for_cpu(struct xdp_buff *xdp)
@@ -510,7 +513,7 @@ static inline void *xsk_buff_raw_get_data(struct xsk_buff_pool *pool, u64 addr)
 }
 
 static inline struct xdp_desc_ctx
-xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
+xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
 	return (struct xdp_desc_ctx){ };
 }
@@ -530,13 +533,14 @@ xsk_tx_metadata_request(const struct xsk_buff_pool *pool,
 }
 
 static inline struct xsk_tx_metadata *
-__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
+__xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data,
+			unsigned int options)
 {
 	return NULL;
 }
 
 static inline struct xsk_tx_metadata *
-xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr)
+xsk_buff_get_metadata(struct xsk_buff_pool *pool, u64 addr, u32 options)
 {
 	return NULL;
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 2bb1d122b1bc..a7df573784fd 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -154,7 +154,8 @@ struct xdp_desc_ctx {
 	struct xsk_tx_metadata *meta;
 };
 
-struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr);
+struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr,
+				   u32 options);
 
 static inline dma_addr_t xp_get_dma(struct xdp_buff_xsk *xskb)
 {
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 78c14f106395..9d2d94f1fb75 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -763,6 +763,7 @@ EXPORT_SYMBOL(xp_raw_get_dma);
  * xp_raw_get_ctx - get &xdp_desc context
  * @pool: XSk buff pool desc address belongs to
  * @addr: desc address (from userspace)
+ * @options: desc options (from userspace)
  *
  * Helper for getting desc's DMA address and metadata pointer, if present.
  * Saves one call on hotpath and double calculation of the actual address.
@@ -771,14 +772,16 @@ EXPORT_SYMBOL(xp_raw_get_dma);
  * Return: new &xdp_desc_ctx struct containing desc's DMA address and metadata
  * pointer, if it is present (initialized to %NULL otherwise).
  */
-struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
+struct xdp_desc_ctx xp_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr,
+				   u32 options)
 {
 	struct xdp_desc_ctx ret;
 
 	addr = __xp_raw_get_addr(pool, addr);
 
 	ret.dma = __xp_raw_get_dma(pool, addr);
-	ret.meta = __xsk_buff_get_metadata(pool, __xp_raw_get_data(pool, addr));
+	ret.meta = __xsk_buff_get_metadata(pool, __xp_raw_get_data(pool, addr),
+					   options);
 
 	return ret;
 }
-- 
2.53.0-Meta

