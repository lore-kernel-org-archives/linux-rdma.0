Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDB548550F
	for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787155544; cv=none; b=HT9bXYhSZxztH5pRODqVN6C76yZVpZbIE3+CMR2uxVY5Z2FJ6zkICwvIXOLjBuPojlnQIAAs4fmobnfjBpcnzS4V3qRQMfYoRRnWTtlUHs+uqXRlR41CdwORk9yBvYtM0SaPQzTiE9P5imqaSSjddZtP1tPKphUGBJ1aDp1stCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787155544; c=relaxed/simple;
	bh=cQTwj67zy7Laq/EhHZBENAZnhoe0otCikzM/pbJIwzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQc2ct1sDQ5dYfuxY8pyaWqA0759HLCtsyggfqAogp+PLa60u3opL8Nd1OwOG+ruCrGQRCfCr8iwF8zcEm37OaXuwclP8LOdz0tuaIqcnDRFJMDpa0pam/v3P4WEiDJgkw8b4UgtGnoeZ5JGxaaCklgotMCF/uD6wvfRCaEqkpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nTESn9Xd; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nTESn9Xd"
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2cabfb70501so3289095ad.1
        for <linux-rdma@vger.kernel.org>; Wed, 19 Aug 2026 09:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787155541; x=1787760341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CKdPBJAuwbKNHRSj/o9wx9GTRe/KKjDR+X94RAURNcg=;
        b=nTESn9XdI2bnT31A6rjMNe8XOps2FXnK2IdAMHwlZb66qHA9q//IzNOCds//X13m4B
         B6M533AYGYZn7B6ZkSBwBY9bk79Qb9qtedfroxLfFnL/9mHVtkh0SBqanWw/qRCcyhbx
         PXbKjmjmLfw3hYUAabnJ9NCcDg/zAD+yGlBwfKsC6ECinw5bcm5N/+w6otEJNGeXFyHk
         iy4JDjS4WVwRVSbIp3NF8XzH9D2dP7UC3Z3G6SOWW03oeRyohkMixfQ5oA/YFtEw01Dw
         K8sxUreEQBJ4EuFDNL/6tFJa9WEblqVFlaJh0DsQt+AdpXWsobqDoFgcMwwe8JqPJWwb
         CiXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787155541; x=1787760341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CKdPBJAuwbKNHRSj/o9wx9GTRe/KKjDR+X94RAURNcg=;
        b=K333SRIH8PDhlaa4OeKdXJeK7jIQ7PtkrsvpxcHEUMznMZgqARvnYI6nbVOIuBDcfZ
         kGF0AkxrLhu6zwBXLfsFjVla+Y0tLm7WAyFpd5Qdn1u+dAaldVJpQQOXQxADyT+vFkVR
         G5/JWL1yzCdP6w2mDxNusQh9YjcqMfMW2v9XzJ1gQLaQHARTyd+vNmoAhIZmWHO7GnYl
         8Pct3giV0hrq4iaK3mFq5BMThjkkBX61NJQNz5FJ4GkDwVf0SnJd0DycOtsQQF8yoUhW
         MEJHUCZonnG8NRAqMYceBJhAlU6yppgewQtlPUtb71QNHnND/QWx2ZvSVOJ8SVQSuxyR
         o+SA==
X-Forwarded-Encrypted: i=1; AHgh+Rqt0fJorAWEpB0U6xXaIh1XPownPbZVA6F2dIz9mZthJS0prSZoOvAcTSO0yqNoGPZSFykNHn2xIruN@vger.kernel.org
X-Gm-Message-State: AFuF++knzCsr200KCD1ECcTPgIruYpQFSWPhTJ+RzJrYx6716v0DII/8
	BQolrxG3XhK8XtZZvVtyE+ADoUvkV0znn6bZScapS1T+RURDqzg+/4RC
X-Gm-Gg: AR+sD12ddORUeCI37JHhIgOGTMGVX/hR8FzgoVAdZyjg0Sd66pG3Uan26TQt5uGA1/b
	i7LNTXpX3BVFDvIigCkV8Iy+9dA9KfItJ07BV9Hi1qcr1wtX3UyVDmKc0FBlkI+Oj0XAWkiAULh
	1PAFyEtN1vI9JcDOCE8+SY7zNIi0L+zFYcSlCR3t5IPo4q8nnEsQPiaZZWv/wQ97CUoLthkLsdU
	C/D2ZPBiJZHYZHWDlDnIsSjElr/yOIDpXq4ygyXWfrQ871hnmX8cXkkvz3YKJEkwuI6d8VTuNoL
	f/BiGF0KgVgePc5KR0iM3Hg7FE6yXKAwAczIl1rcEMJVPTEQy/SC5f6IcwaBtXYS5NuhAQ/Afpp
	39amFO4+X9XA6C6IbKI5hDVoMzwPJHagmsiXEOqhCENjeI9swHDgEK2PsL5vPMke81u1XaqqdG5
	53+2YcA4PxOGi7KqAbbTI7ThDzxl7ECpUK+tNjHySQ/vJGQl1kCOxTJ/KU+GtALsgt
X-Received: by 2002:a17:90b:3fc4:b0:38e:11ba:992c with SMTP id 98e67ed59e1d1-3958110c755mr10914058a91.12.1787155541199;
        Wed, 19 Aug 2026 09:05:41 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:4f::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17eb5sm3740911a91.3.2026.08.19.09.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 09:05:40 -0700 (PDT)
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
Subject: [PATCH net v3 3/3] net: stmmac: document oversized AF_XDP frame handling
Date: Wed, 19 Aug 2026 09:05:35 -0700
Message-ID: <20260819160535.1472459-4-sdf@fomichev.me>
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

stmmac drops AF_XDP zero-copy frames that exceed taprio's queueMaxSDU
after xsk_tx_peek_desc() has reserved their completion entries.

Completing a rejected descriptor is unsafe because AF_XDP completions are
ordered: xsk_tx_completed(pool, 1) would complete the oldest outstanding
descriptor, which may still be owned by hardware. Instead, leave the
completion pending so the ring eventually wedges and increment the drop
counter to expose the application error without risking hardware
misbehavior.

Document this intentional ring imbalance at the check.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 62de03e65a90..6a532747c039 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2713,6 +2713,10 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		if (priv->est && priv->est->enable &&
 		    priv->est->max_sdu[queue] &&
 		    xdp_desc.len > priv->est->max_sdu[queue]) {
+			/* Completions are ordered, so this descriptor cannot
+			 * be completed safely. Wedge the ring to expose the
+			 * application error instead.
+			 */
 			priv->xstats.max_sdu_txq_drop[queue]++;
 			continue;
 		}
-- 
2.53.0-Meta

