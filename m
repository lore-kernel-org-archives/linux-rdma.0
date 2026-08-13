Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C716C42314F
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 19:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786648086; cv=none; b=ABKVrG0flvESAcTiOUuQHt8F/PYWXsWbmaqMyhfwmQEr2rH3921cFJiu6zYCYmJmQyE+AyE+4m6xAuoupm/zl/qRz4gjAqhz3Km6vQPMu4omFKZ2eR4mD0HoC3KJX6ZMtWxD0NNCifcWzHhdZ5p2G0cWcijA56TKmEuk6X0emqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786648086; c=relaxed/simple;
	bh=h/yRTy+q/aTNWgdAyARpnxO02skNFXM6ZPvX24ue7RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB2+9yqVSPee6Qm+4a2LucJ/v/yygYCPU/uZCFNI3Y+L2FTJ+Id3cUhcwTqebkEWiErxHO3wMOq6wpDZ5yapUk6BpEgJImTkhjyQtL1VIOAxXv+dbMOjEBs8imtiCLtPp14nSydZqnVRAfwnxbGAmO6iIF8iq3Gy88CLIVJ/25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxxA8BdM; arc=none smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxxA8BdM"
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38dbe53179bso67810a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 12:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786648084; x=1787252884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=knHPZ2hqDlF6r7lICpyiSankCSnQUl1ZecmnK0yjr1w=;
        b=BxxA8BdMs621XLpRrcXBmzwifHSG5UoNWkE9d1ppbJJmCvlcQNfzCILo6OtbA6/rpx
         jJ7V++l+PCvsfceYjzSoimTKX7yYIkdD9yEuaMnaVYs9/hi5BNkb87TZqjZvj158xh81
         wIOEKIyw76iRW9ZSbc9/QIWfKdc6dyurCA+4GSEfXYVou/n+GrfiF8GYO9EnVJW0I52e
         ju2u0htng1cTYWMKi4WP0j2JIpMig2/Cyjuhlx5RatWq6t/q2MoCYgszSEoYUEsquZ3t
         MwxWfn+m09MHQG+OfrMQAB+uVMnRZANMnrxjwfYRub97hHG/umOz9Oyp68nwtjxwcHub
         ZAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786648084; x=1787252884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=knHPZ2hqDlF6r7lICpyiSankCSnQUl1ZecmnK0yjr1w=;
        b=b/guDNxmY5fXTpmCjgMETw3SoxcMbJLAMf4LI6NWXvBWljRngbxvzLH48nfRUbUoin
         RLGaiaA+J0bRdUzNZbm7EviEpTqh0Kr1Pea2y/zT1tU8TID5Jg5Bc8V8EmSHfYtBdpiZ
         HLYkg+WL0wS7z3UbDFUcHY5ZCb2eoMGLXxr9vp7xZZcEdtwUpcsn7ho/t6LhBjAMMW2s
         HFDPL/znQlK6UPytVfl7DqVMoZwFYMTNSfdGV2wtw4nOOf2RfiKXmIltd/lioG6QQGA8
         gMVkzhaRE0NO3VX1t6+8zjzIuWeYI/R3uokfZ8AtSjh5g4zY1/4Sia4L3fTErhRCcuc6
         +HJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrw9TRFtihznR11wBokaYuk+XKva9lRcTo/6fpAXLG6MPF3p9kPwrMdbjB0cQXudC2cmBIjxiThSsgT@vger.kernel.org
X-Gm-Message-State: AOJu0YyM6pM1Otx8XSbhMf9h/ge6GpAHNhfueTQ9IHeWFuF4PcCs+Rle
	RcjZZKzaQvNfLcJEcltMs3q89cMQId2yqUfYD8RWGPaF/8BUrfQXo69m
X-Gm-Gg: AR+sD10cLBZkSnV7xhIY6K6v2DrMkizrLCkwxVpoN3irjyTDckPg5rhmbZdnP8m+QNF
	nW0sYRXRW++9GaVPn+oKifpTskOQ7lnI405+kVIN+oXEBjGl2tGdOQAOwcRtGwxOPffcnJpAakw
	YWpSxJ+x+4N6Q0b7VpD0a2Ql88NvUFm4hPJ3jz3dzYmXySjGjjDu18lcO5m/0gPpByx0n4MqwPI
	zX30OTE/pJbKrlDF62xmgBlCbTFWMIxMe/bMm8v8YBRpUTayiSlMtKzbfUxleMi7wCYNs5QMxLc
	2DEKFnA1AyrkmbMb1jTqqueVRgxoMo10OrnCp2iI2Q8fHh5fARTVzekH0Ziib82K9iO5M/brF4R
	8h5laveRQOBnYUiH0n8SgEVOpdiBi7nCkF+bwBMIXDITNl7TQtzB1obQPoYOv9O76zCKs0Ja+CC
	NmfnbiqDC/npuYA2uQWSh48jaEa73SYTQAP2ty8bSK5nbil+cAzH2TFQ==
X-Received: by 2002:a17:90a:da8f:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-3933b95e327mr167852a91.14.1786648083852;
        Thu, 13 Aug 2026 12:08:03 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931cf25e5dsm4535692a91.17.2026.08.13.12.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 12:08:03 -0700 (PDT)
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
	witu@nvidia.com,
	martin.lau@kernel.org,
	yoong.siang.song@intel.com,
	rohan.g.thomas@intel.com,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	bpf@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net v2 2/3] xsk: honor XDP_TX_METADATA in zero-copy path
Date: Thu, 13 Aug 2026 12:07:59 -0700
Message-ID: <20260813190800.222527-3-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260813190800.222527-1-sdf@fomichev.me>
References: <20260813190800.222527-1-sdf@fomichev.me>
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

