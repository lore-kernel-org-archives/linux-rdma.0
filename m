Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0A8423EB2
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169208; cv=none; b=PXMYmFTfqsngrr9bTsI9kj9HLyV+pHMWX+hka5RosTvwsGbxfr1BbNe0FChQ7hFTig5hiRZMRUeL/NfRItdOk7UqI/hOdEoHnWI0HlU+TSaNVw770AUfOWtnKHSCiyDLIjh2IYA0/QCbqCI3xY3vxQgwHeKZCv8TMLeKAK0UT9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169208; c=relaxed/simple;
	bh=KxeNp93pwCEuioO3uavxojOIQiFQPvELBNqJqMfdJsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7qqjKqRkDSiZ6rS7tzTre2UAAn0WV3iNJED5oExovs9YV/ICQF9oGXa2d1WgXbN8TF8MWW2tmi+mnVvdTRbo7ZEjrj8LpU9j5ZNYFEmwVZyUD3pysW7VV89MP8S3Xx6+F88+VI9MNvgRJmax3CYr1uZ21xCCO1E/ZLaBacypys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZBGawNOj; arc=none smtp.client-ip=74.125.227.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBGawNOj"
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-3896ccc93b5so1063392a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169205; x=1785774005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jOKl9cuatMBwnsyU1wJ+nM+sSfz+zrZVzuTsvqWf2Wk=;
        b=ZBGawNOj2gvc54mOMpfB6OPELSokkE8QrxVoUoMwLg+ljxAYCIvAwW05540efMqqOK
         l+/p8BEB8uNvvCPL6bZnYpMC9WQyQuhs4Zek1u7bl0mY13GTQnAxZiK/BBKSbycFAELr
         5u28pjTwzVh5HK4gbXj2/bUBx0ZBZdB99WyGlFc4Rvrcbgtl/RyRYB3JPYX50kLaTfBJ
         weEEldfthpavC6modoeAL2JeZlQC3fVER3I+s4UvA5BwWerfs0CnUt7aQWLswf/hwVWi
         bDulmZsJSXBRRaxVfK/h/jJgFGbkVvt5gp+RxretCXavftigB4vY6Uyg8tzMsvOB+4lD
         u0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169205; x=1785774005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jOKl9cuatMBwnsyU1wJ+nM+sSfz+zrZVzuTsvqWf2Wk=;
        b=oN/y7npM9H0T5dyNo3cjEzPIhKkmNJuBf42RiAGN36YBhFlyn8DKuXXCbdAQP+u3q/
         AWCUbcIhSR5zw/SqZ27h5Mc1c/W24tPdvuypK4IMgnYSQyH1e1pfKsDCO+Mi/23oODt+
         9LoP8y0GBF25nz798AbfwDX4u15GH2TftOk3GQppWzE7nGbEORaihXWNDOsvy0SFUX31
         XzoZP1xBZbxDwWHI9UM3eBFpuPIXOoBKfbBQfwU860h+jKcb0TRtMTpQ2WgpskPS9mm7
         4kJk19d3adTKa842obPAQfTufCI8NAoxMoye8JaSQmk2Wskwe16c555tWiVo4rppmGiA
         xmaw==
X-Forwarded-Encrypted: i=1; AHgh+Rql3gK0ZVatbKw2jK33IsGOC14WDCPSMt1PYXOtUiZbSTcP0ot5MgfkfATiYIZ0ll8RXf31Jrh1shnL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9lED3HiUE1azyu2AAHgfwv7wmYcU+pRMBKitFyAUDxhPogv7a
	TsYeueAZ5BC0e7u5v3NDj76q1KfZ+VGWhG4ul3U3nd7yLnNce1TGtmcy
X-Gm-Gg: AR+sD125ifKlpjNx9wEhPYbxwa4rpERLcuygXmYN4iXf+Or+YuLiESKTiL7yr2w+yJ8
	+ciDT0TEPxLaOlt2wEjSs87wzjixhk7uf8BqmZkmBRkd0jjxlurLec4308x3xpGqx6Z6/7Tzgo2
	A/ep4BV7WHKefPPpDfMvc5WmVgfdf5pN09BcIXWOruQLEsdOOwDyeaq2tntBsUG82Jldal5e0X6
	zzuvEKKEcQKH1al5V/SyXfMu4IH8nSeu6PbuzJ141h91OBpjkZkHLvcE7q0OahezoW+/Q+JcUtz
	xRiJ62TTDcj1HVy0nPRNZIpKWp9dRSK8xy+/kTMG6vT/rm5AA2Oew75RlE+SSwdbFvk67fAei+C
	FckTSvxuQS12nMCS3e2edMFS5vLwahxgd85A+7PiVamPwKPRcylL8bw/PsDbUZwrMaOBB22A=
X-Received: by 2002:a17:90b:5826:b0:38e:7268:220c with SMTP id 98e67ed59e1d1-38f2966033emr8517144a91.32.1785169204964;
        Mon, 27 Jul 2026 09:20:04 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:53::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f64150874sm75066a91.16.2026.07.27.09.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:20:04 -0700 (PDT)
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
Subject: [PATCH net 5/6] xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
Date: Mon, 27 Jul 2026 09:19:58 -0700
Message-ID: <20260727161959.885642-6-sdf@fomichev.me>
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

xsk_tx_metadata_request() must validate metadata with
xsk_buff_valid_tx_metadata(), which is defined in xdp_sock_drv.h. Move the
helper there before adding that dependency. All callers already include
the destination header, so this has no functional effect.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/net/xdp_sock.h     | 43 --------------------------------------
 include/net/xdp_sock_drv.h | 43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 2b2eb9b9d580..6e70b320b399 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -153,43 +153,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 	compl->tx_timestamp = &meta->completion.tx_timestamp;
 }
 
-/**
- *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
- *  and call appropriate xsk_tx_metadata_ops operation.
- *  @pmeta: pointer to pointer to AF_XDP metadata area
- *  @ops: pointer to struct xsk_tx_metadata_ops
- *  @priv: pointer to driver-private aread
- *
- *  This function should be called by the networking device when
- *  it prepares AF_XDP egress packet.
- */
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
-{
-	const struct xsk_tx_metadata *meta = *pmeta;
-
-	if (!meta)
-		return;
-
-	if (ops->tmo_request_launch_time)
-		if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
-			ops->tmo_request_launch_time(meta->request.launch_time,
-						     priv);
-
-	if (ops->tmo_request_timestamp)
-		if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
-			ops->tmo_request_timestamp(priv);
-
-	if (ops->tmo_request_checksum)
-		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
-			ops->tmo_request_checksum(meta->request.csum_start,
-						  meta->request.csum_offset, priv);
-
-	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
-		*pmeta = NULL;
-}
-
 /**
  *  xsk_tx_metadata_complete - Evaluate AF_XDP TX metadata at completion
  *  and call appropriate xsk_tx_metadata_ops operation.
@@ -239,12 +202,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 {
 }
 
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
-{
-}
-
 static inline void xsk_tx_metadata_complete(struct xsk_tx_metadata_compl *compl,
 					    const struct xsk_tx_metadata_ops *ops,
 					    void *priv)
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 68a787601357..f87c4215673e 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -271,6 +271,43 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 	return !(*flags & ~XDP_TXMD_FLAGS_VALID);
 }
 
+/**
+ *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
+ *  and call appropriate xsk_tx_metadata_ops operation.
+ *  @pmeta: pointer to pointer to AF_XDP metadata area
+ *  @ops: pointer to struct xsk_tx_metadata_ops
+ *  @priv: pointer to driver-private aread
+ *
+ *  This function should be called by the networking device when
+ *  it prepares AF_XDP egress packet.
+ */
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
+					   const struct xsk_tx_metadata_ops *ops,
+					   void *priv)
+{
+	const struct xsk_tx_metadata *meta = *pmeta;
+
+	if (!meta)
+		return;
+
+	if (ops->tmo_request_launch_time)
+		if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
+			ops->tmo_request_launch_time(meta->request.launch_time,
+						     priv);
+
+	if (ops->tmo_request_timestamp)
+		if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
+			ops->tmo_request_timestamp(priv);
+
+	if (ops->tmo_request_checksum)
+		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
+			ops->tmo_request_checksum(meta->request.csum_start,
+						  meta->request.csum_offset, priv);
+
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		*pmeta = NULL;
+}
+
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
@@ -483,6 +520,12 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 	return false;
 }
 
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
+					   const struct xsk_tx_metadata_ops *ops,
+					   void *priv)
+{
+}
+
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
-- 
2.53.0-Meta

