Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930851;
	b=u6n1nyNbm+2EjrIS67t5VR7e/o7YVyTIAR3B6HPtyrvvqZvDZo01e+DQao4jdvoPF7ca
	 zuzDJ8n5XMZ6vrhATyb4jhp5uw0S6aDWFzmB8Pw7Fa6FZMnU2BrJ8vZ4wyJI0L/L7xlvj
	 EvZvzKo5FPT25z6339H/pi1iaBtyivh2WCkELYjOuspvQeqd/2tPweJTH0tf8aMZULDKw
	 Nd7bGU2097g48cLi0xiXHN6Bmj+24ecQBc8mEtwpi/vtH7jk8rN77GPvp7+sNpXv8NMYr
	 1idJpl1/YXTtfpCHlj5DmccynUmfTvdBPTrxcdXBu2rSVPfzDoRt3ZxBGs7Roj95LzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930851;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AGrjC0rSP1b8Paro9DQQb1SL5gZ8d3d+SCH/LzYuvzQ=;
	b=RmjhnthOKl53wS9ESbOtcmqOXRdGfvKA8/EVf4/jGGKdsLPk+tG65CU91cQJ+QpEFxZN
	 4uS02tJsL8rdpI8dJbXb+x0/BxzzfpScKy7rZ4ZHIR4t2ugUB3WHp+GBU7RQwgxESN7b3
	 ZUVTXPZSJRG6ScbwMgmpTuxRTuG5rTgf/Fgu+Z67kJ9g9Vx/3EnEaQ8pjDKJ7MWDq0gPJ
	 RrZfy3fcA5dBPSsyPikbZ1YriL+In1m6kS4ovxa0A5t8/XvwUWi4nhV3MOQpBg1Rmdh3k
	 HWDc9vVGX2zdXpySOpqPsjfvbmFcFVnjVeWOgQkiej4e4WT8kcJ1QTtc7Qt/57hfFhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DfAihYYr;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB023606A891
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 15:54:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB023606A891
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DfAihYYr
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdb2893531bso10058a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794930850; x=1795535650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AGrjC0rSP1b8Paro9DQQb1SL5gZ8d3d+SCH/LzYuvzQ=;
        b=DfAihYYr1Hx/FqwMJ++uuMbrUTmpfc6KPCxYCi5wOzpVdspIXPzcsosvZhU0XxEMIw
         B6vrhiqXTMvQJGlj6nOouEJ/kGGHkeA5MQlWJgcfkEuYmjzzU1uWP5+bY0IV3UeS47Oe
         vWgkcTtP/nZv6teke8OAAhraDps/KlgCFXg3qdQ6S+Zj8RIc12tfM7MKwg3BjeiDInsW
         18kYOWONHh4XfPq1KLoueRY+UjKz3S8Z9En81+9Ah95ePbG8OTZCC4ZkwQZlwsz4YLbS
         9a3mkMmXCAyrR3ieqEQ+A5K3hf5DHfRoOuEOf9bzYOQupWXTtEu9u1m0hT1cnkuiIHol
         Tnig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794930850; x=1795535650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AGrjC0rSP1b8Paro9DQQb1SL5gZ8d3d+SCH/LzYuvzQ=;
        b=JKH4lFkkW8b52rX6JXUarBBba4vgYvQ9Q7Y9Kvld22HxNG/PVgiAJiyO7CXNCVhg82
         l8154J71HGGQRvw40tFmnPEZ0gLpJzH4GnlYNwAjR4ASn9Sf1sizBY/bN8PnLsGILPdp
         igMyxeI0/YjBhaGHlgFV0FZhWbwPidOqwAi1VRWoiOipdEDLSfJJRVLA7FyEKReKy8Hi
         lxjm2K7048EkPCJOOoUCftRLK+Lvb+tz1kMhymsf2MkO5MreUcPcrhKRSArDkNLriKvL
         WudrIqlHiUwvV3Uq/zKAmfcqp2ZwZzlDP+k4CP2ATStNz0Y0pLD1/Fh4Cn/3oKVNEHd3
         MY7A==
X-Forwarded-Encrypted: i=1; AL+hErGPr/Ke+UsoM904b8JY1KNfY1x9JlTiXVc/v7xDxnJGi2/T4eg5BKJ0Exu0CUoOm89rZ1o1s0UGd5dI@vger.kernel.org
X-Gm-Message-State: APuU4Z/CQ2A2R23sX30Ag/8onKjWgrbuU05qXrU6Hpx2kSovEyB2wf6S
	gBDFW43KCbaIcWiUw1v6Rb0Mn2ES1Q7Ow3wOXr5V43roIBiMgA0AZWXCI9Y3Iun5Xiw=
X-Gm-Gg: AZFdTZej3H5PyLzc0lGb+nzbpY5tJ1sYzQeZsqIFtZ6rlZl2DbMOvC9z5viAryoZpfu
	CylEzQG452Lu8jey6bUZZIXSjcs08hnmhp6QEzwveb5eZpvSpl4djhsZZ3UMVN/aFArllaN4nYH
	yNjLZALw0+2QqG3FFps7tuLZUQlOSVYzOiddAP7ZTgUTmmxsZl4us2ZapKqT2P7Y4ndQbbXiPYe
	H0/DpCcQ0hkNiMiKn5+jXNFT6bcxDDr71S4bb4mu0ysctnMBO8MfDxQSXFOF3ELbyB3+oL2yt8t
	fIXIRLocScwoprKAxWQFDSUGFDZ8tJ/0OX0/1/OwbiuyJvcwl9p68lIrqr/cnFhLuxBkwHK8J29
	ZsFrg3PQOI59jfukoTjNG/l2Sd1SuYR5ys3fj6FamCP7o+jlhXCNUDKlXvNRmPa6br2eX+VoBtZ
	CkHCq799H1uc5UO/LNPTvrR710AYIWTyDvygMfTyc9xo2ihKbQzgaQHul1hm2xBq7bTAfGjI0g+
	7pIXqQTqiPTQzjt7Z5mC/yOoK9gAVIZnSPB1feaZNztnRCdr/Ns4TOKEovOCR69BJCb6EZtzfc0
	qyMW/1q5Bighi5N1kk9YhzbAIPdimE/n83PCqSmxBIsB
X-Received: by 2002:a17:90b:3c4e:b0:3ab:afca:1d79 with SMTP id 98e67ed59e1d1-3b1b0b6672bmr13618434a91.21.1794930849960;
        Tue, 17 Nov 2026 07:54:09 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:72::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abd063e8sm4624009a91.8.2026.11.17.07.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:54:09 -0800 (PST)
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
	Joe Damato <joe@dama.to>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net/mlx4: factor HW loopback DMAC into mlx4_en_set_loopback_dmac()
Date: Tue, 17 Nov 2026 07:53:48 -0800
Message-ID: <20261117155353.2250540-4-joe@dama.to>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261117155353.2250540-1-joe@dama.to>
References: <20261117155353.2250540-1-joe@dama.to>
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
index f6059b533eac..97f27e005810 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -871,6 +871,23 @@ static __be32 mlx4_en_csum_flags(const struct sk_buff *skb)
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
@@ -1008,16 +1025,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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

