Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930844;
	b=cJF9gUFCt7L4GvqlW8Q2jzufdz3d1liAd8+rHFZIOX/HVmGNz8k0TtOwPycHCrmH+PhO
	 tSgnHnkD4SEFd8PEAWUVTTGnCpqU264sxYMh1n4fpe/zP/52aJQcttFjRoMaI3a4Hn9PJ
	 b6hZOJQE3lGlwqJ0JVIK4lgE2FiITIlLBzjgWskC5vwZ6eYWrSp+Zb4Ej9ve6AYrkZW++
	 nIo2jyNhScHeejyBnGMRNIR9UZKqVIfd+CidGvLko95TkoPRL/PewV9oS7QaDu9gtbaKL
	 2z0WUZBukreGc78oxkLKb5uuNm0XJg5Ih1GAJiHFgSAgmtQbtEhCWi/sxg29PTeg0Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExJa3HV19g0ZGUa4rSb4P4UswY9qSGxs+IdWz2us4KU=;
	b=KmEKp8ehizkF0hkZh6J0TMOlRkd6o9iwPE5etAqfQObZ14MG1e22kn1JP1hvKl450kUY
	 j83QW1gS5smfF7ulBggcI8bOnnlB/SzuyI0Xz8q5uDuglfPz1jgLm1uX87FK/qzIWEdqT
	 Y2c4+VLE2ovRPAr+VOdr7PKTmr2f0fO4USmSKpTqphOWetuJ4yITOOCyaYxN9oUcT8TKx
	 V9DVCjLH8b7qnShBSH7tFfsTYe6J0jpBCnhrjWhQa2yrOOO5jTA+Y8b5DE+N6HhydZLFP
	 oaWxll+kwOoc7Hcm9QeCLz7E8uPppJ1faER3nLyPMhYUoA9UWUHvrzNGZYSoKZdvo6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RZ7o7KUj;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AB606A336
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 15:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E94AB606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RZ7o7KUj
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so1854653b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794930843; x=1795535643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ExJa3HV19g0ZGUa4rSb4P4UswY9qSGxs+IdWz2us4KU=;
        b=RZ7o7KUjf0yZpJ26n1S6UQZJEgftOanDPlT8nMSKzF09QIbtPjcMxRV63WfoVWz6Sm
         4Va89bbhECf5i1H65fSRdPOcJ5HX3R1EGCtSHwddDziA6cpuaAJEFOyL06pwfP/AfZM8
         HFKoaT4IJDCvQ3zL1TDnIWLFPhTQNiiaH9iUAKonzlz12lSBawZRA5+iaSZWUg8znSz5
         7uiXJPtkWP+psEspwuR7f737YQ+jQDUOW+1WdJCequIqAx8kQc9zKQxmeBAyOXLK1NKQ
         VgOwaitK3jDrbpkQx+NN1NlVgA+kC+eX30uO7PfmdkdeSfSX3ypc82AKyZNO0miPFZjl
         10xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794930843; x=1795535643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ExJa3HV19g0ZGUa4rSb4P4UswY9qSGxs+IdWz2us4KU=;
        b=esKaDV63vGjOqH7AucTyhODIq4LBZKq7QNbSHM8t5nX1V+wPlL8czu2H//OOgbuSpK
         6cDEsqj2r1Ecd+E4/EdHM2hjwNxpx1c98USfla/Mi5N6NfolRELDpoM2aoP+WEZUPUgx
         un1kNkJf9UhqasC6q6f+tQeq7r40eXwDTHvPUMPdH6S01TAfatPjbERg+8NUnEFanPgt
         gRHPaPRyChDDsIMJvYRIM8P/hsA5y+aeCkHgpbJH1Wkpco44RI9CzH2PDBMHt8yN59F7
         mUi5iblaUijqrTGSF1v5tOzThzOMlcSKzGXuspcILD9ESfa/rcFQNkHp7Gq9ANurtMPf
         B7jQ==
X-Forwarded-Encrypted: i=1; AL+hErFnHlAwZeF3b16lPB13Xp1InVvWxPeSldaj6AJCalAaUZIISVlp895O4ncSYkkFCdLC8iuYfxRKoMZy@vger.kernel.org
X-Gm-Message-State: APuU4Z9l5erHdMzjxMy/L7act5L8UARAKp+/vEnCQM+kXq9OnBnwxJVW
	gOqaCSwaFyln/IPST+ID3Y2PTiIhr5YYUhznjlUMgxOFR9PdFptGuELAgrGGX1Sk8Mg=
X-Gm-Gg: AYBFou3oLgCCvoct26Wkua08tHmDUcUT78RtN3SV4FIK2gptvRMnZ8JnYPZ0JwUUVFz
	HelwIM3W9Bti8AmeOQ829npMdIaKiFAusVdqAagkHy1bZqBCHMXOvmVAcl6hZqePXHMf3UUf7ef
	0DHz7NVKQ5gkFPHMFvBdIxaE5IKe642CYuTfLTKJAVutefv1VRfTauNQAPjBqBS457eXsM3fh16
	kV33IIWT0bBcv+ua7VKFLhkiaIcwTwHqpPqH6RWRcu+xjX6LVNQ2zDYhgubQB8SEDBEqAZbUa4f
	t8uTF47DQJx8++SwPhh/15QLbCxPJ7lkxy9JCjzDCDg6DX8NKRBtGGYTs3Vxyw7arIWNnQ7EzKc
	U7MPlk0qUkEVoAiV/N7ildEY6a15476zqz5W+toCMAZhDjnh9HxTLnsKuSLV3J6pSwZhEX7Z1sF
	ypWDgFiXlCw6/L3aCP0YeufEOKf83dA/PUi2QbCtHxud8SCkz30wkTC6uBYln+YBS7QtNkYYcPL
	0yjyyvPlP/YnFIyWq0K7AyYxCuT+SDqvTutUjVijQg01E0VW/YzzlTCV1xxkzuclfK8AVIaYS/r
	JgJdd4N7soXU840VChh2/fFaWHsABmH783rsbLb3X2E=
X-Received: by 2002:a05:6a00:420c:b0:8b6:400d:7cc8 with SMTP id d2e1a72fcca58-8beb6298a6cmr11857476b3a.30.1794930843313;
        Tue, 17 Nov 2026 07:54:03 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:59::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8114sm5476595b3a.12.2026.11.17.07.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:54:02 -0800 (PST)
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
Subject: [PATCH net-next v2 1/5] net/mlx4: factor VLAN parsing into mlx4_en_prep_vlan()
Date: Tue, 17 Nov 2026 07:53:46 -0800
Message-ID: <20261117155353.2250540-2-joe@dama.to>
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

Extract the code which converts an skb VLAN tag into WQE fields into a
small helper. This helper will be used by a follow-up series implementing
software USO, to avoid code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
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
2.53.1-Meta

