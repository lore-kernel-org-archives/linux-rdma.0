Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25215420E89
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169205; cv=none; b=J+pMPDslvY2qbugwy/dP73MMBynk4upTVYNebgzeyeAy/VHkI4lYtv4NtxMJoZFtwt2zYzVGin5L9uH1QTGbT6GaWLv0/7j3WUUhKnOYwcpK/ctxU1MBiknVr0/TXzVu+5ZgtH3ZwW2BZvN868mOOOLU/W8euknCJMRwe+BFyFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169205; c=relaxed/simple;
	bh=EAmjWNL6BA2eTwilraaK48crzuw30ArFm7BW8AnoMNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch2eLM6Y493skRnkQyRY+EhNbBK0CXqGkVxUAmS7h/ii64fVTEXZSjufrf6x5L0qpJyj/RuKdXjUl7AN16iyl4JcHbpAblYRDFMkYYNya5NbU6cZeB9Ig9YhPXLyr8AaXPHqCurAr6qnbih2EOmhILGYbtVa85LgP9JUhd1fGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aGo4lCDy; arc=none smtp.client-ip=74.125.227.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aGo4lCDy"
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-37fb1883f59so978129a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169202; x=1785774002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c9LHDNlHqE6dohf7NQwt3shVRUrKsU4ONudBOweUDy0=;
        b=aGo4lCDyIRUdrZ+bR4A75f2u9IC++lBdPX0/6qOXLienyrvMBkNeTP/ykBQWVHcRHV
         3YkKhoXso9nYMAfNlHw9DzDdFw4X9fju5DtcLBiy6rOh7yusoFoubjB3t1g+bI9cc1/G
         O6DD5Lx1Xk00xt5YX+F95aL6thtNllu0Z3aJWJoc3InqjXtMPRHgvs+hZF2IDF9rGMXg
         ZZQ377xFvxMKM3cHdkAgi79LnvhM4I/PXqm8ml/+R8621bWedPFJj+tl3tNouWKKw2Xi
         ERndIlaxOYHO5gmojGmgurvVYXnGCWkGLLlWhpL9yKSMjVs99y4PmF0EGebRdzFduJYg
         lXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169202; x=1785774002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c9LHDNlHqE6dohf7NQwt3shVRUrKsU4ONudBOweUDy0=;
        b=brPt3BilO6PLbgFM31v5LrMJz783ifuhtZRF+G/GBxCVHgGPEq36vaCO0jujEWX5Fi
         sdkqxQxruxMlWd79CEtMw/gEdTlH7Ehv0uBOQsHk/Ew/MeIMXdFF3H51WDYut6x78ZwN
         SYFA4hAIJYkMU2zBIMSjTixKq55nepuDLiuJoHTUgvAgd1eWVR08UBZ3Nc8TY96jDLO5
         f43DNErx1WXaNUuBpwMy5frB8dcvHOod6kS3AISxliMirV9jwRqf5RGpHNW1uo6yg9WW
         YB8vychIDdzHSBUaNpj0AwkGMY/SAYY5iyNi1qvdtvL8kl7IGsCvOvble2/eqR8su0+u
         Z+EA==
X-Forwarded-Encrypted: i=1; AHgh+RqqVowSogUt0A0a1JvgBtXktJskq8CgNxLpoaaUIddB1jc0wEvzzndpn+Q0F7rC6qTbjGETCpl3djc8@vger.kernel.org
X-Gm-Message-State: AOJu0YyM/zmkIa7R7R7PgXsd2r0TAL2uqtcl1pgAtO0NG/hO6D8WDvF2
	FU1Yv5NywvZuJJWTECtqIrc4fVhmPPBBlQU+Rg6+VwFqDKuaGBn+bMxC
X-Gm-Gg: AR+sD12Hvgs7+hIG7DZF2wy8jiwgpLL75jkc1i36aSy4jlU7JhOMGlYyej99CnL8l1K
	AuSIQ1DscOJQJB1Jcwbo1xHqjpwRofGMX2u20F7FSuoS0ESSF4/L1XUlVfZ2ZF9B3BHTn1Rz2X0
	kwuws72kcveFVuMNpC5a4yUv2Tdyn2emXSux36vODZ8VuKhzPrDf2pJdYysexZ5ffloGpA8Njbi
	U/sGRWhAB9Fw19JFiSORf4xjZRsTtXaUx0c0KrVhzqulSUrahZikqUj+npAqkNRawKtxbhVH/3Y
	YAhlnpMDTwezLUU1VrKLOLoRcqZWG391Ua2nTPv82q4oTnuW7LGm8UOin6kXlRoyCYRwBLcXS2V
	5K7CP/5HrSqVlobRvy26M7fgbG5oK3ZNg/pdjHTdY7WebsWxAj1wzXDPAgya3CIQ3QA8=
X-Received: by 2002:a17:90a:e7c2:b0:36a:c4b:76cf with SMTP id 98e67ed59e1d1-38f295bd06fmr8359252a91.23.1785169202185;
        Mon, 27 Jul 2026 09:20:02 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6411189bsm74325a91.3.2026.07.27.09.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:20:01 -0700 (PDT)
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
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	maxime.chevallier@bootlin.com,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	aleksander.lobakin@intel.com,
	horms@kernel.org,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	witu@nvidia.com,
	alice.kernel@fastmail.im,
	dtatulea@nvidia.com,
	yoong.siang.song@intel.com,
	martin.lau@kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	leon@kernel.org,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Subject: [PATCH net 2/6] xsk: pass TX metadata pointer by reference
Date: Mon, 27 Jul 2026 09:19:55 -0700
Message-ID: <20260727161959.885642-3-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727161959.885642-1-sdf@fomichev.me>
References: <20260727161959.885642-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Completion handling needs to know whether a timestamp was requested when
the metadata was processed. Let xsk_tx_metadata_request() update the
caller's metadata pointer so that decision can be carried forward without
rereading user-controlled flags.

This only changes the interface; behavior remains unchanged.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/ethernet/intel/igc/igc_main.c          |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   | 14 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  2 +-
 include/net/libeth/xsk.h                           |  2 +-
 include/net/xdp_sock.h                             |  8 +++++---
 8 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2c9e2dfd8499..5a18d00deb4f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3082,7 +3082,7 @@ static void igc_xdp_xmit_zc(struct igc_ring *ring)
 		meta_req.tx_buffer = bi;
 		meta_req.meta = meta;
 		meta_req.used_desc = 0;
-		xsk_tx_metadata_request(meta, &igc_xsk_tx_metadata_ops,
+		xsk_tx_metadata_request(&meta, &igc_xsk_tx_metadata_ops,
 					&meta_req);
 
 		/* xsk_tx_metadata_request() may have updated next_to_use */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d507289096c2..e12cb41c4b97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -483,7 +483,7 @@ typedef int (*mlx5e_fp_xmit_xdp_frame_check)(struct mlx5e_xdpsq *);
 typedef bool (*mlx5e_fp_xmit_xdp_frame)(struct mlx5e_xdpsq *,
 					struct mlx5e_xmit_data *,
 					int,
-					struct xsk_tx_metadata *);
+					struct xsk_tx_metadata **);
 
 struct mlx5e_xdpsq {
 	/* data path */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index d8c7cb8837d7..dac5e9d4c8bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -452,11 +452,11 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     int check_result, struct xsk_tx_metadata *meta);
+		     int check_result, struct xsk_tx_metadata **meta);
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-			   int check_result, struct xsk_tx_metadata *meta)
+			   int check_result, struct xsk_tx_metadata **meta)
 {
 	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
@@ -504,7 +504,10 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptx
 		 * and it's safe to complete it at any time.
 		 */
 		mlx5e_xdp_mpwqe_session_start(sq);
-		xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, &session->wqe->eth);
+		if (meta)
+			xsk_tx_metadata_request(meta,
+						&mlx5e_xsk_tx_metadata_ops,
+						&session->wqe->eth);
 	}
 
 	mlx5e_xdp_mpwqe_add_dseg(sq, p, stats);
@@ -535,7 +538,7 @@ INDIRECT_CALLABLE_SCOPE int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq)
 
 INDIRECT_CALLABLE_SCOPE bool
 mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
-		     int check_result, struct xsk_tx_metadata *meta)
+		     int check_result, struct xsk_tx_metadata **meta)
 {
 	struct mlx5e_xmit_data_frags *xdptxdf =
 		container_of(xdptxd, struct mlx5e_xmit_data_frags, xd);
@@ -649,7 +652,8 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	sq->pc += num_wqebbs;
 
-	xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
+	if (meta)
+		xsk_tx_metadata_request(meta, &mlx5e_xsk_tx_metadata_ops, eseg);
 
 	sq->doorbell_cseg = cseg;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 3c54f8962664..5b8f4094d553 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -114,11 +114,11 @@ extern const struct xsk_tx_metadata_ops mlx5e_xsk_tx_metadata_ops;
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
 							  int check_result,
-							  struct xsk_tx_metadata *meta));
+							  struct xsk_tx_metadata **meta));
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq,
 						    struct mlx5e_xmit_data *xdptxd,
 						    int check_result,
-						    struct xsk_tx_metadata *meta));
+						    struct xsk_tx_metadata **meta));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5e_xdpsq *sq));
 INDIRECT_CALLABLE_DECLARE(int mlx5e_xmit_xdp_frame_check(struct mlx5e_xdpsq *sq));
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 8aeab4b21035..3d19dad8f868 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -105,7 +105,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 
 		ret = INDIRECT_CALL_2(sq->xmit_xdp_frame, mlx5e_xmit_xdp_frame_mpwqe,
 				      mlx5e_xmit_xdp_frame, sq, &xdptxd,
-				      check_result, meta);
+				      check_result, &meta);
 		if (unlikely(!ret)) {
 			if (sq->mpwqe.wqe)
 				mlx5e_xdp_mpwqe_complete(sq);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 151c77713025..3f5111969c41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2747,7 +2747,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		meta_req.set_ic = &set_ic;
 		meta_req.tbs = tx_q->tbs;
 		meta_req.edesc = &tx_q->dma_entx[entry];
-		xsk_tx_metadata_request(meta, &stmmac_xsk_tx_metadata_ops,
+		xsk_tx_metadata_request(&meta, &stmmac_xsk_tx_metadata_ops,
 					&meta_req);
 		if (set_ic) {
 			tx_q->tx_count_frames = 0;
diff --git a/include/net/libeth/xsk.h b/include/net/libeth/xsk.h
index 82b5d21aae87..e2fa6bf6b1b3 100644
--- a/include/net/libeth/xsk.h
+++ b/include/net/libeth/xsk.h
@@ -205,7 +205,7 @@ __libeth_xsk_xmit_fill_buf_md(const struct xdp_desc *xdesc,
 	BUILD_BUG_ON(!__builtin_constant_p(tmo == libeth_xsktmo));
 	tmo = tmo == libeth_xsktmo ? &__libeth_xsktmo : tmo;
 
-	xsk_tx_metadata_request(ctx.meta, tmo, &desc);
+	xsk_tx_metadata_request(&ctx.meta, tmo, &desc);
 
 	return desc;
 }
diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 8b51876efbed..06c081feff42 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -153,17 +153,19 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 /**
  *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
  *  and call appropriate xsk_tx_metadata_ops operation.
- *  @meta: pointer to AF_XDP metadata area
+ *  @pmeta: pointer to pointer to AF_XDP metadata area
  *  @ops: pointer to struct xsk_tx_metadata_ops
  *  @priv: pointer to driver-private aread
  *
  *  This function should be called by the networking device when
  *  it prepares AF_XDP egress packet.
  */
-static inline void xsk_tx_metadata_request(const struct xsk_tx_metadata *meta,
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 					   const struct xsk_tx_metadata_ops *ops,
 					   void *priv)
 {
+	const struct xsk_tx_metadata *meta = *pmeta;
+
 	if (!meta)
 		return;
 
@@ -231,7 +233,7 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 {
 }
 
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata *meta,
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 					   const struct xsk_tx_metadata_ops *ops,
 					   void *priv)
 {
-- 
2.53.0-Meta

