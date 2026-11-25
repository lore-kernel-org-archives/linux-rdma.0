Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629633;
	b=hZcu8EJUlmkJYrwrkvsMMy0wTnRUkWdQAtAWpiONgWD+W71uURhI4Np7KDA+RQ4GJqAN
	 kpXWfxyh+b37u8cENTUR6LtwTjmWLJ1RQw0mwb9oSNJpK1PBmH8To/NBtpC2n+qD2ZMsN
	 gWRSq6bykXq9DU4L/bICVPZibbWzWBo9nSZadaY5JD5aWd6nh6I1kJh0hibCVhU9la3sI
	 lMVoToSpx3vySeJ+nmOsxOSPuVxjC/p89jWkVOM9TLSuRk6R2TsRFBgI0iqgp4rb1BV/m
	 7+yCLCQKLCrXWfjBmlK0kKlqnpllftULMFFUU6idbwEVql8CPCqOgwNK1jFadqzX00g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629633;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04zPH8pKbZgStm3VZ5cSIvhJbVCbZaL1fubS+I8F7Z8=;
	b=TuJprR4iKSovPhqGYyDUFEWPGUWBus83k9CscuFQdW60N/gVRbxzZeVewxpEZbMAgSak
	 Q40tXk2XFxO3dmGNi3i7HK/arSL+yfocLL8xVEDfFGpaVxG3mio5sLF0KYrWLOnRGt+TV
	 8ALCpO3kOcyk8fI/IyCIEp1bAzh4Fxout8S+Sqr1k6DJRIurs7GsFvG6Ng+7rG8pPm0p3
	 vqymhLlWeyQogqOblGMYoWiBKKDvJM7YPVcDYqPkRnEje7UJcK+x7MVLiE4wq6ipeY7fm
	 oUpwFnRbBJhk6fM/e8UMbMbH4feRZ59SzNelP07et3nmFKlelzwOhFCCcPBcHOGdaUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hi9CsyCU;
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2623606A684
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2623606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hi9CsyCU
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cde827b7b95so1832266a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:00:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795629632; x=1796234432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=04zPH8pKbZgStm3VZ5cSIvhJbVCbZaL1fubS+I8F7Z8=;
        b=hi9CsyCUf/b/0VqLamSne6wspz7YbpnBm8Y1GiHDoxoAKD+Q+n68UBacSdCO/w40Lz
         QKAJPb7pNp57A4kkRCkKzFkyZ6DYXM06miTxqwk5MlAeNooOB9ZmH1D6lva6j3+XYsCI
         F1kWKTf/iOFRDShDnOINWpnaxlJh2ReLcgI7EqxyuR4W4cr/vzpIjibqysMZ04yz9Yw2
         SAPY0jcsa8SR0bJKRoNuvrUr/dSscDoCupnTwbuDO30RnopBYjgsmpSFdhYtsAEF7Y86
         lP8pxE/M9llm6kp9OOuA/TCba8nvEBxOZSSHQJSrmzxOGFhXSdC3tLsJGjW6nk5yS/KD
         NKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629632; x=1796234432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=04zPH8pKbZgStm3VZ5cSIvhJbVCbZaL1fubS+I8F7Z8=;
        b=otbEgu0CGAmA8nX34hW4uHyxjx4M1T7NMIhrtdPxNHssqC59PWoKGljt97FcGDve1/
         yr1O9vYlLmjmwE/bn+lokWRNU9yaCegHh4TKBqnHxzoQ7AyQIo4B1i/Hdt2OBeal6jtF
         cbLGqM9MX/Ui0I/UltzhXDnnYx6+R586K6YM3pa55Bc5M3UmY7Y3Gt/0rgDhT8dWMGIO
         Dsi8AR/aG0aGRUForrSpblDuMU/HcfBErMr5MipMN8d6JecMHrGT39Gixi1srJYMY9zK
         RrotEtUm2NnY3hPn55OUPEPYBKqPIi8GEvQn+WF4Px8mI9hj94q8Svh4Dkpn+IwXnCbK
         B7xQ==
X-Forwarded-Encrypted: i=1; AL+hErG6T6zvTmwbu5s8qCsEvFnPe2DkG9zbcl1N+cjHxVZasbAfMhGnoluRDp+uScjH8raBI5UarQwmJ2gk@vger.kernel.org
X-Gm-Message-State: APuU4Z8+8PFxjlAylj6ILNDUVgkqBxvtFelaVilMcCmuBlnJc/kHZ9yb
	RnT6cRVfkZsLEBAOPJdDiDU7h6NOIcB1cHFqQo7IBvWtRrVRjvIdTgTBQnf9GoLtiHw=
X-Gm-Gg: AZFdTZcHVMxH7ahyH9t342ZVEit+hFjwDLAKmW92lKJGcfA5FigFIjIXdoulv6P4cFs
	s2T+YHn3NolcMUfr+vKlBQJIL1lm3k4MnQ0YcLDIrsogyG3tRBelrzx+sVeBBAqYlU7yc/rdoeu
	GedLBOY/vw/MSxIyofk2r81ZUFluJAsaWy9RT1ahKuSmL4gBQSFOckjKm0DtYPbgI43fMgLFtZz
	4lNYFMAeRp3eRPtX1Gw+uvT7Y4/wD3AwQ2JG1F7pJdlvkIJxtU3+ngfE3qWYK8CxPmwq3uDClzE
	zKT6y8C8C2qES4jaPfzUUSSgzKiS5oMs4CFMYl9qaDGQRxfM++WtjKqLvYDI7Kg4IACh0G2r7R+
	ou8yCZudJQ3yDDvEAf+oV2+pWCkdNKdCihrHdLApnyKD5cIfEUozZoyu1Y1MNjFmLrZZM0XTYFj
	+U9rgMGnGD8cI7WWshxr6tUHEVxsfPHPP+vXBd74ZCer7nm+y9d8SD4QGu+euAXLmL13BNlUoqB
	qHVlLKYnN8piTGTDe2VzRq0F+EGnsdZ8ZZuJmSDQJ3R7pi3/8cpU9Oyi8obBl4qTsBUonFsj2yi
	CPQxMufMrjYSDQ2YIX2aD6P/keCJr9HwO9e0I80S/7w=
X-Received: by 2002:a17:90b:3b86:b0:3b3:fe22:2739 with SMTP id 98e67ed59e1d1-3b41c9c34b5mr17223800a91.54.1795629631705;
        Wed, 25 Nov 2026 10:00:31 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:54::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b792474sm13401830a91.3.2026.11.25.10.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:00:31 -0800 (PST)
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
	daniel.machon@microchip.com,
	mbloch@nvidia.com,
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v3 3/5] net/mlx4: factor HW loopback DMAC into mlx4_en_set_loopback_dmac()
Date: Wed, 25 Nov 2026 10:00:16 -0800
Message-ID: <20261125180021.1804204-4-joe@dama.to>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125180021.1804204-1-joe@dama.to>
References: <20261125180021.1804204-1-joe@dama.to>
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

Extract the code which copies the destination MAC into the WQE for
eSwitch loopback into a helper. This helper will be used by a follow-up
series implementing software USO, so USO packets between functions on
the same port are looped back too.

Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 1fb265a30a30..40dc4f6a7329 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -870,6 +870,23 @@ static __be32 mlx4_en_csum_flags(const struct sk_buff *skb)
 	return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM | MLX4_WQE_CTRL_TCP_UDP_CSUM);
 }
 
+static void mlx4_en_set_loopback_dmac(const struct mlx4_en_priv *priv,
+				      struct mlx4_en_tx_desc *tx_desc,
+				      const struct sk_buff *skb)
+{
+	struct ethhdr *ethh;
+
+	if (!(priv->flags & MLX4_EN_FLAG_ENABLE_HW_LOOPBACK))
+		return;
+
+	/* Copy dst mac address to wqe. This allows loopback in eSwitch,
+	 * so that VFs and PF can communicate with each other
+	 */
+	ethh = (struct ethhdr *)skb->data;
+	tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
+	tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
+}
+
 static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
 			      union mlx4_wqe_qpn_vlan *qpn_vlan)
 {
@@ -1007,16 +1024,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		ring->tx_csum++;
 	}
 
-	if (priv->flags & MLX4_EN_FLAG_ENABLE_HW_LOOPBACK) {
-		struct ethhdr *ethh;
-
-		/* Copy dst mac address to wqe. This allows loopback in eSwitch,
-		 * so that VFs and PF can communicate with each other
-		 */
-		ethh = (struct ethhdr *)skb->data;
-		tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
-		tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
-	}
+	mlx4_en_set_loopback_dmac(priv, tx_desc, skb);
 
 	/* Handle LSO (TSO) packets */
 	if (lso_header_size) {
-- 
2.53.1-Meta

