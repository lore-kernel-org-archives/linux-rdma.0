Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352399;
	b=aznqDGQBrJ3G+9gG6lT96KNgL0sjMcnI1shEdhYmUe/E71prqEFxFgkxbGkR0P44BxVa
	 GZ3XxZcTPjiPN2Ed2JLEwg2ZIRJIdEW+TY7UpCiEwvzNwz3lJFJRlYvVk5Zix1vNDYPCi
	 uXul4v3WBigHTFPHBKv/JX2arf1Y+VgBkEM1fABCbkbMQM8J3/klo0nhh1LVBozCR92ZU
	 VYzeBeGroM4SK72an6MSz3h4ZnLdSKMUS27rSIGG/yo9ZB6ZyR+DouToft+lixkBmxbbL
	 Fy3IwFStVe61EhY1/XzfVbLlN3yDALdGgaH6icgZWlxT7rfBvGjf3hfvSR8nQ/yRtUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WNPvGEKQXav9VSZ3J7/386PWbh2deprE17GmLSUj3BQ=;
	b=lDI4H+jOl68sU+eaxssKZm7m6gdjZ7zQmSghRVBNeYZREbcKajVEYE5+R2qEWXrc48Bs
	 dvnjH5POoVj9OVP76qRb5kJDcHsuMhzzTjuzOeNOL40EJm7p8jrRDegUYmCUhdD35mIs5
	 M+EdqJSpOE7RwMlrNNl6VojXZz44zs13io9gRvDxfhN2VcVCBtncAQraVj9R5xCsr/M7s
	 /EUOhzON/bFAd4rjDOR3s6fAq2kGU7A8eAuQOii4kpkR1TzpnqABOvDs61WXQKEKOh4fQ
	 SMckpPZRHfgw6abn5+7RYYz7TByy2Nvk3FB1QVqPMA+RNN4/GXBp/i8D9lwJd+fqsVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kSOtdwcf;
	arc=none smtp.remote-ip=209.85.210.182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8916F606A337
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8916F606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=kSOtdwcf
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so1621600b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352398; x=1794957198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WNPvGEKQXav9VSZ3J7/386PWbh2deprE17GmLSUj3BQ=;
        b=kSOtdwcflrPTYOJkmiuF1ig4Gx7po9JWw0+rkgtDjdQhuPJEj3dJCcsicLlHPeWxQV
         8HF5JC6ZMi7dBxkoETsI1t9vz/ghr2gsgZ8UVwXjHeAB2Y6KU5eaInzFaGs0/G/Y5eCW
         zF/SpM1eLZ/O+vx06KLGL2swCjxEl2MSban0MpTZaCQEhUqmtmxfsvldqcX4duHfxvVl
         HCjgawbylZyc/msT/UQG1mO6Ykc1SyGApMJBlfxR9EgtNzQnfhdGj0b5suSMITWCtQd0
         UOmg7cjMSdjr3MfKvwP2GKpia65QcXcPJ9h8iBs/2rk6ZAwFMkXs+EdntslcJPCl0WFw
         Y0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352398; x=1794957198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WNPvGEKQXav9VSZ3J7/386PWbh2deprE17GmLSUj3BQ=;
        b=l3tEfj5RTBm+k4n6L5rXeWM43lemX3U7ycKPl6DZlSsoNcJTFbacgI3wI8++EZph6L
         GE21VfhViofIBJ9f851zX5y1Ksc7w1SyWfWbw5a86xlBl/Al3PNWj3BxT4NJpP5mmyk7
         sxvMfkKyqnL/7zBtky4y3pFlqjXqgcxuYlIjMEYTbM6jK9VwI66PG5b0uKw0LA5gzhxQ
         KltFFlsTG0j9JGif8ZZ9KClxQDGC6qMpb22ObyMAh0ZadIfJ0p4rZCi8ueUFP3ftAyQq
         725ctB0x0HgBRSF+TQb4rAASaUwfxXBYK8t1T1RpzrEcNm5duH33Y08Mieo8BgzhJI8i
         j3QA==
X-Forwarded-Encrypted: i=1; AL+hErGpviA+dWTA6RTv6eiS1XTnpqMZFnj3GiIiEhqkwH3062d+UJJNMIT/3PDfSc6xc89sIagps7zfwjKg@vger.kernel.org
X-Gm-Message-State: APuU4Z8WBuh6ptXtTS/HveTxHBA6U7RzBep34ySlCfkfCbmIFMoWBAT7
	azuabQJfM0p7L6l3KR203wVEordAnNC+2VaSPOC6Kn7PhHnh6kgECKpRoT3G2Rv8s+g=
X-Gm-Gg: AYBFou3UeSB1s4LJQH7tCOkpsbY4C262Ml4/tGcKvYVlkAjPmCgIp+3UiAkGWTjg+ML
	ANo2iU3EeEORced+9moOhEjr7zg7b2mY7s4fZvOBq1B9T7xsV+2d4eo+1RTm8yN+lcUtI7wYzIY
	qOIxfeSSfUYed0RCMIQrqDeRUeCd9xkSy1295Vf3S1+YQaIkAML4FOntN4D6LEGaowUZSIkq3hu
	x83ooJfwPyfkWAyb5U7oDPvr1KROe8sdAts48tj+Jb7yclvsdedunKa8KlfiqwuxYd+y9lVPlDE
	DsXDkagcaeGStXWu7emIWi7yI/DnALteyWMpiLkv3/iWwb6UGt4jb4DfVucneoqWUL9/sZtUUKl
	knPg0t7dUuuaFrlxB+cAn5yAaX2FwNAUWXEreUbeEE0ZZCbK6IBMUFBNIcN8EFPKWk0SgvfnHrB
	VpE5mFpme1MjlFqmSWCwJyV/G8xcDJ35oG50hIY9AMKjaXa+AxJm9Ttbp0Adn53oi/Ur3Z5fBxH
	o3ncRFUMtbd8ZWc1b2Ob6B5GCuCZcji7x3BeKH4TjjzvYila2XTJf22W9Mx4MkW0q9JHgL+iSDf
	3/ioVH4uBS7NYp6dZbHezqU+q4wooT9WPiuGzMajHLg=
X-Received: by 2002:a05:6a20:914b:b0:3e2:5d7f:f630 with SMTP id adf61e73a8af0-3f2feedbe75mr719252637.54.1794352397968;
        Tue, 10 Nov 2026 15:13:17 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:56::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d7cf07dsm1173961a12.28.2026.11.10.15.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:17 -0800 (PST)
From: Joe Damato <joe@dama.to>
To: netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com,
	horms@kernel.org,
	linux-kernel@vger.kernel.org,
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 1/5] net/mlx4: factor VLAN parsing into mlx4_en_prep_vlan()
Date: Tue, 10 Nov 2026 15:12:55 -0800
Message-ID: <20261110231304.1859217-2-joe@dama.to>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110231304.1859217-1-joe@dama.to>
References: <20261110231304.1859217-1-joe@dama.to>
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

Extract the code which converts an skb VLAN tag into WQE fields into a
small helper. This helper will be used by a follow-up series implementing
software USO, to avoid code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 33 ++++++++++++++--------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c5d564e5a581..00210dbae1c3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -861,6 +861,26 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
 	return false;
 }
 
+static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
+			      union mlx4_wqe_qpn_vlan *qpn_vlan)
+{
+	u16 vlan_proto;
+
+	if (!skb_vlan_tag_present(skb))
+		return false;
+
+	qpn_vlan->vlan_tag = cpu_to_be16(skb_vlan_tag_get(skb));
+	vlan_proto = be16_to_cpu(skb->vlan_proto);
+	if (vlan_proto == ETH_P_8021AD)
+		qpn_vlan->ins_vlan = MLX4_WQE_CTRL_INS_SVLAN;
+	else if (vlan_proto == ETH_P_8021Q)
+		qpn_vlan->ins_vlan = MLX4_WQE_CTRL_INS_CVLAN;
+	else
+		qpn_vlan->ins_vlan = 0;
+
+	return true;
+}
+
 netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
@@ -902,19 +922,8 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	nr_txbb = desc_size >> LOG_TXBB_SIZE;
 
 	bf_ok = ring->bf_enabled;
-	if (skb_vlan_tag_present(skb)) {
-		u16 vlan_proto;
-
-		qpn_vlan.vlan_tag = cpu_to_be16(skb_vlan_tag_get(skb));
-		vlan_proto = be16_to_cpu(skb->vlan_proto);
-		if (vlan_proto == ETH_P_8021AD)
-			qpn_vlan.ins_vlan = MLX4_WQE_CTRL_INS_SVLAN;
-		else if (vlan_proto == ETH_P_8021Q)
-			qpn_vlan.ins_vlan = MLX4_WQE_CTRL_INS_CVLAN;
-		else
-			qpn_vlan.ins_vlan = 0;
+	if (mlx4_en_prep_vlan(skb, &qpn_vlan))
 		bf_ok = false;
-	}
 
 	netdev_txq_bql_enqueue_prefetchw(ring->tx_queue);
 
-- 
2.53.0-Meta

