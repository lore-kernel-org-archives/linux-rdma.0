Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629631;
	b=RXDpOLYiuFXz/hmj2+K78HEyjMILAKySMLv2xwIxeZX9ZtkyotdWnoG2iE73tFlP748g
	 xDOidrtgLv3EdoBPVGTLyjmzuX/MWI/FqAJIRP9IxobIaSSpcTf38gXpDTwF3LY00CrHE
	 LaIu6qlq0cEco+sLyEo1EoU7DVpijOJ2wWTzxgSs7fHzJyj00xvkF89064YXX5SEJ05rA
	 TEGO2sG7Ev8AurrIzcpUxKA6IVNNTdh0UwHQVIVkMrpBs2xyTCeMopZkSs3D6ZOOt0KXZ
	 ETUIRVaBAeila3witJeGV4T7JZa63IHUGvZz9PEqrNWv/SV38SvFKc7V8xWUKh9hfPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629631;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybq08NfCGGRDLgIcrDYKd/XJOpQjXuujh7BORjeX0cc=;
	b=R8cbnPBJhNFk/0LRdLakbD9wjVjX4lS2YEu7/bSWkcTZPQSu5+TphLu2Hq4Np/kjy3XG
	 XYzAZJwVoeg6k4ZZa/shUr/3ctqW29uwBx5VMyy8sutD4hz7avZiW50u4T2sv6FF604ZC
	 6rnH/f4OyuqxPf1GngrTwzgmsnPwGftDBBV2Euswo42ABRDceWg+fWK6g26P4kFfWXtNU
	 O9FgvBqwx5A9FVA5ulfYjxVEcxhwuQDRAAxe/HmQ5F/kqsz/S/2k1NHebGdV2Sl1iextH
	 VKGUA4mTl7M9JIfAkpL5LCxojJ4Qs2IhySCPahu4cL0Sy4r3eVrj8bidQuUY2qgKWFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gq5yHQ9V;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799B6606A323
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 799B6606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gq5yHQ9V
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2f04244c3d0so49803415ad.3
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795629630; x=1796234430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ybq08NfCGGRDLgIcrDYKd/XJOpQjXuujh7BORjeX0cc=;
        b=gq5yHQ9VLcwYkwjr1vkTpEDyAlBQ4Sd3FCsFvzewZ+ebZZFnyePB8yPDif9oy3gME6
         ITa1WdI2UIk9dbCgxH0ruYuIf+nC9giMFawzjryr/7c5qDhxZkurJ8NGYfMNDMmGEoYV
         rl0E5COxhONIBIibPCroq2M1Lwdk0qQRPl4Mf1uYxEoeOcRwVZxyGODpxHmrtQdsKYnW
         FB1LazRC470fCGwZNUtXmV8rfPWeHW6sDHJ3Bg5K/bW7CtLSJZGTyHN8wM7D9rrJb1u8
         MMHKXygbp0655+fkMJPo42dk4PB8a99j0KRoM6au7Gcd8oDgG9NGAWijdbYFPS2N1KlH
         4xQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629630; x=1796234430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ybq08NfCGGRDLgIcrDYKd/XJOpQjXuujh7BORjeX0cc=;
        b=Fg3uUid1VJKMqIN8ajcxgFkgMEI9ZregMVdQsnTL728Vw8YjJS0QaL/npAkH0BA+Or
         8EGAqPy63WRriASx7DWIC6J0G0/Kq5+AmXwyQnD4y2SNJKWhgacNRDYWjC1GYIw8sq7L
         fsAoyXi3jsSfm+riQyL6b4bItjAhwT77qrw2fOk7Tvg1N2Mvj5XWY6gIEWBGwjloREi3
         tVKlyF0KBg7JJFJtzk4u4bXV5uBON+FvOj7I+BDIT6tWIEtclMp01cHMY/5MrEcy9YSX
         rW7N7ZRMsTKk30RP+Sdj34jJZWsyNlv9u3kK1XHkh80GcDBjI8KzGOUNIBLl7e3FZV6u
         XTzw==
X-Forwarded-Encrypted: i=1; AL+hErEu7tWwYbWLt8bPIW3phfLVsg9qsqNxOzuupi7vUAoG2DISTpYsz4VWysQYCV2t9l/tFLJC23EBJqvw@vger.kernel.org
X-Gm-Message-State: APuU4Z9RulM6G++iazVt9D9fsdt+xZM3/wHWwF++fdbyXMDj5ag5VFbU
	JMFOItITNUPPfLRLWMBkGdV69N7zWIIIOWmNcCsB/R8eX7dqmHorf0w0vgWXNguSEUY=
X-Gm-Gg: AZFdTZeWy4sLM7UhOr2v3gUXk5NQZMJ0SWxfRG17FP49DVaS/5vaMGB3RVnV82ZIsuc
	M9oqrH5HH474XZdKES9D0OW5p85E+cAJp6s6fW/51QYjGj9fyimyA0nK8wsJc8dae1JUNJNoOfg
	f1KQ1A+z6ABO7koN4BERSZ7g5sd/5Eimx340mLWsTWPwGJDVAujF+7sJTP4x7Uz84Tsph6Ubzl5
	7KS9gfXt+hRitHKhBhOW8sJMIQTJcFyJS/HmfBovwYG1mF9w46lQr/xmJUbGyvOb4z0NuRZeSlS
	9gPYL7WKG5KSav1MYdsonQYxX7riKh7WvVsXxP5Xy7Kw4XgRHekMdyZMpc4ktgcIBs8Fzp4E9K/
	OPjB1V+rcwkaD13T2PPxIa/cq/8wPetTMfpE/ZdbR8Ffrtr+2C+MC1W3WhPR/rBFbeb177G0nZF
	SedT0bvW9g5qSAxLLOm06CNOSZG9wAZUp/+u8gsfVM35IbWeLmQF92MKcMi5jVd6W44JPsF9+ry
	QTwX9UuJ2P8vJ/JlmETnfKEbM8cfEeDJ41tmV3gY/9rsW4wRLaijTGuuZLSQOLC0vTI+TM3bxGl
	2jMQuqzNo5ci3Lihs6im+RCQXQ4YH0toH+6Ufo8nxQs=
X-Received: by 2002:a17:902:da83:b0:2ef:e5b9:5841 with SMTP id d9443c01a7336-2f050c1d8cemr175723835ad.35.1795629629861;
        Wed, 25 Nov 2026 10:00:29 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:57::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1215e2sm91189495ad.63.2026.11.25.10.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:00:29 -0800 (PST)
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
Subject: [PATCH net-next v3 2/5] net/mlx4: factor csum flags into mlx4_en_csum_flags()
Date: Wed, 25 Nov 2026 10:00:15 -0800
Message-ID: <20261125180021.1804204-3-joe@dama.to>
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

Extract the code which converts skb csum fields to WQE fields into a
helper. This helper will be used by a follow-up series implementing
software USO, to reduce code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 29eda78b9977..1fb265a30a30 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -860,6 +860,16 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
 	return false;
 }
 
+static __be32 mlx4_en_csum_flags(const struct sk_buff *skb)
+{
+	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL))
+		return 0;
+	if (skb->encapsulation)
+		return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
+
+	return cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM | MLX4_WQE_CTRL_TCP_UDP_CSUM);
+}
+
 static bool mlx4_en_prep_vlan(const struct sk_buff *skb,
 			      union mlx4_wqe_qpn_vlan *qpn_vlan)
 {
@@ -890,12 +900,12 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mlx4_wqe_data_seg *data;
 	struct mlx4_en_tx_info *tx_info;
 	u32 __maybe_unused ring_cons;
+	__be32 op_own, csum_flags;
 	int tx_ind;
 	int nr_txbb;
 	int desc_size;
 	int real_size;
 	u32 index, bf_index;
-	__be32 op_own;
 	int lso_header_size;
 	void *fragptr = NULL;
 	bool bounce = false;
@@ -990,12 +1000,10 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Prepare ctrl segment apart opcode+ownership, which depends on
 	 * whether LSO is used */
 	tx_desc->ctrl.srcrb_flags = priv->ctrl_flags;
-	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		if (!skb->encapsulation)
-			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
-								 MLX4_WQE_CTRL_TCP_UDP_CSUM);
-		else
-			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
+
+	csum_flags = mlx4_en_csum_flags(skb);
+	if (csum_flags) {
+		tx_desc->ctrl.srcrb_flags |= csum_flags;
 		ring->tx_csum++;
 	}
 
-- 
2.53.1-Meta

