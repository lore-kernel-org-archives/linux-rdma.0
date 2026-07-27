Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F4442255C
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785169205; cv=none; b=Fg50bSEOdEtON8fZRj17MEyON87NLcw8ShJjxjcwMdmEVszSIdVJRzio3VpqhuXaWlv/pHSYlATfzf5Srr4rOHmQVh2J2RGpawmdg7xEczUmZjCe4mEsmTOkgH1R/c5aG74zmfzE6qjlF8xRODwbOl0ONeI5tPcaHMw3WEUQIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785169205; c=relaxed/simple;
	bh=ZqQ9Uw/Y50YV8AtDkt+7adMr8+1jDB1scctEEKirKpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfQ4B9bPvyV7f4mVvlji6bLKxlVrKMcLD4fbizf+R1gYYms6astaFOxD4eOm4bdeQcTF8YbAsgcXwDBKJ8LVRdv+pHG5iBEyZLOh7F+qoNG9WDbytvxm806mgZOcQIRm4RDO3CzkzIE7om8Nnq+9s1AzWrza5PdeeO7MALalQB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dzh/05Yz; arc=none smtp.client-ip=74.125.227.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzh/05Yz"
Received: by mail-pj2-f3.google.com with SMTP id d9443c01a7336-2ce7ac92dfcso26873075ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169203; x=1785774003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1XKcSH10NxhyObCdsXRn5dtH9ICKV5W4CaAB3/o++lY=;
        b=dzh/05YzIn6aW0D6RLWdhyTDq7o18x8RtJjzJV2JQII/BNK9Qk7ddEYWPAzyW3KSCf
         EF4dI3Jn8TRmnVD9AGa5EqWJjTXJCEBQ7Tpdv0TT1s2M5e4lQ31CCdgUWBnpdTZOTl1p
         MNkXMowDDcmwtBJ6S1HyDc76yuCI/bxvmAgobkKZmjtn7z9LnyfIFlWmsHviPKXEfTVe
         q5/37S6WSovJ6PLLNTRBgWGy7lvAnLgM7K61qwapf0ledd/Om0KeLZEw3fcCV2BXHtBj
         Nw++NhhudR569k6PtrOYuGsDrxfW+BusHyyuzJjauaweMFResx3RG6437Yt95ryzuMKL
         QEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169203; x=1785774003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1XKcSH10NxhyObCdsXRn5dtH9ICKV5W4CaAB3/o++lY=;
        b=Ps1Awjjume1pYeR11oO4TJlNBEHzI28+ksMwwRW8f1r02D0F5oGiT9NM597/dsvfNY
         AtNGC28ImifjCfgNVsOz7Whp1Pc3izhnffljQmpeLG+dptmaZ/KUrkV0vWH2YLoAwEEl
         bpj24FscBCUPV+kVElEFbyYOi5QNqwF/JebQhaHygcMqsu5HSvr5QlZ1VWzYLC8Ci1tI
         xkLnr3+4XLxDsEm1z549Q6CYeaq3aEbCKYF67UabxZ5z38AdrTpVNCLpzWmJJLLh+tmH
         YVit3TkjQygB2cVHvwQKDanAFAEGt8xzJQAx59Xne6/RlK3C4x2j1/hhfgVweE7TI12G
         63jw==
X-Forwarded-Encrypted: i=1; AHgh+Rr71SgCVvJWBaTma/GCET5BD6+2HcmfGGE5mnt+9/BlUzfxkQODOkugDMwEzaTtH5Ye8VnJvcPuNp/6@vger.kernel.org
X-Gm-Message-State: AOJu0YxYwwdn8deP/ukgeEWpfx3MlV9Qxwy1HXsaNfa/AYqnkArigKeM
	N90GTYQuX8Lj93v7QvJ2nHigDzWvl1t2oMYnazHPvVmj0HIOwMovUMXC
X-Gm-Gg: AR+sD10HQe5TO3/ZrASrMPObDMrd4X5BNiEnGCm6Z+Zz9z/2ShzB+Bz9kcpwJmP+RY7
	JujdVQm9El3nBbLNFRbA6OyOYScKYYF3PVWTVkrkFoBjAAVd9XfEDSr0r5pJWa8/jk2IxYLOcB/
	WxeFo61hGyh60RGekGlYFdb4a8CVMjeVcMhgPyvhUuhenLWADvzKDNygN3PlDzyR61PLK2odwMh
	I9R47OLpqVIZRb0YXjmvUl8yg9WTHBd3UTSzJ2kKHfosyiVdD8tWyrxSCzx17rvELvXbJcHCiEZ
	3zgFeN5CumtkINff3mivGod2Ux8jnZqCGEcmXA+WkwfTiwdqZV0kAk5Egn/siLsX5q/oIUID65h
	lSFVAITNVy6ZBNSX+DtVUUNI5mv9YFUolUQQBcBluX5mLWi2BhcIk57SkyMCAZCFUPkv3DEPimX
	HDHXrW
X-Received: by 2002:a17:903:3808:b0:2ce:9439:59a5 with SMTP id d9443c01a7336-2cfde878665mr86179875ad.36.1785169203061;
        Mon, 27 Jul 2026 09:20:03 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:51::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d00599b631sm8906615ad.42.2026.07.27.09.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:20:02 -0700 (PDT)
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
Subject: [PATCH net 3/6] xsk: clear metadata pointer when no timestamp is requested
Date: Mon, 27 Jul 2026 09:19:56 -0700
Message-ID: <20260727161959.885642-4-sdf@fomichev.me>
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

User space can change metadata flags after request processing. Rereading
them during completion can therefore make the kernel write a timestamp
that was not requested when the packet was submitted.

Clear the metadata pointer during request processing unless timestamp
completion is requested. Completion handling can then use the pointer
itself instead of rereading the flags.

On the mlx5 multi-packet WQE path metadata is evaluated per batch:
xsk_tx_metadata_request() runs only for the descriptor that starts a
session, just like the checksum offload that is applied once through the
shared WQE. Only that descriptor's pointer is reset, so completion
handling can record a timestamp for the other descriptors of the session
regardless of their own XDP_TXMD_FLAGS_TIMESTAMP bit. The write stays
inside the metadata area; the single-WQE, other zero-copy, and generic
paths reset the pointer per descriptor and are unaffected.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 include/net/xdp_sock.h | 14 ++++++++++----
 net/xdp/xsk.c          |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index 06c081feff42..2b2eb9b9d580 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -141,13 +141,16 @@ INDIRECT_CALLABLE_DECLARE(void xsk_destruct_skb(struct sk_buff *));
 static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 					    struct xsk_tx_metadata_compl *compl)
 {
+	compl->tx_timestamp = NULL;
+
 	if (!meta)
 		return;
 
-	if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
-		compl->tx_timestamp = &meta->completion.tx_timestamp;
-	else
-		compl->tx_timestamp = NULL;
+	/* we can only arrive here if the completion timestamp has been
+	 * requested via XDP_TXMD_FLAGS_TIMESTAMP, see xsk_tx_metadata_request
+	 */
+
+	compl->tx_timestamp = &meta->completion.tx_timestamp;
 }
 
 /**
@@ -182,6 +185,9 @@ static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
 			ops->tmo_request_checksum(meta->request.csum_start,
 						  meta->request.csum_offset, priv);
+
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		*pmeta = NULL;
 }
 
 /**
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f906d51b6699..fcc6f17f3576 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -998,6 +998,8 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 
 	if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
 		skb->skb_mstamp_ns = meta->request.launch_time;
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		meta = NULL;
 	xsk_tx_metadata_to_compl(meta, &skb_shinfo(skb)->xsk_meta);
 
 	return 0;
-- 
2.53.0-Meta

