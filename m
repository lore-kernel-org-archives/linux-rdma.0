Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793319803;
	b=GLVCv1Zc0b6F7JyZqnmLKR2IuF62zz4DQN7yla7sn0UodK7H5XWYrBCx0GyhnYsMzpn4
	 eRhINlwK+dmvJzdAZDYfu/GwQKt+zesJ/6M3b8Prd7rwBW3RD+ZnW+GsAS3fSrROzQ4kB
	 hD4NTnR8pt3OF2u8izHlcUfjl5FdGso82YvVOXnWpGOGMgqcXXLX07ca8+Ikket2u2eTM
	 QEpNN3mVKFHFWlSpoFVvTY7+uvu74xWtLJATDpDyeX9XKctCb710x4vTCKIfBPtX28z4r
	 RQrM+5Q3/aDFf+gzIpkbWwb+I3u7ilNQEaDww5Xq/AzFh3qSTP9j1PlrJqY9KDnSWng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793319803;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+NfimRk2GYnku3/wifGqwhcMFbQKhofA3PCyZ8KRFLg=;
	b=tC6q8+JGS+dIyovmJA+KOFQaEWkcrScA7hQlo+PCoR5FFyrZF15JtY5yTr66gd9qEsIR
	 pX81yS9zLlLZfGlpAjCBiPI1LBqlSsyP5ZzB9wttL4gPlpTz/D5tYDY4bVlJjTmTRno7m
	 2SlQgpRMj+UEL4Om519EAJTpOBcFbTwOtp+0LCbwHtLUVazkyheiOTRnWcXb6jYlhpcoN
	 2Zt0BWyVhEYBzPi44of2o59G+xt5iImqelprKQ1+SHdB7CaGeoLEb4hCYnxgarj8MuOCk
	 zrH7skvYC2b2yH8aQ/uGKJRyeJFnviCxMPYqyHnSwpZ5dmTOzVw2Xn0/CNieaWxN2ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ypsC157I;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F95C606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 00:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F95C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ypsC157I
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48e20edd106so124519f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 17:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793319801; x=1793924601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+NfimRk2GYnku3/wifGqwhcMFbQKhofA3PCyZ8KRFLg=;
        b=ypsC157I+v7buErUok30TBiMODRXmt0y64VItSaKUENFC534TAfGzo2OHFZgJmXpwc
         L9kRGPgyzBwdMo/O7Idj5K2oybXz418/96NL6mvw/0f02q4KmR0ACKymwGkg0VR1sK0l
         x0wzJBDeOvbt7evJA5Odgu1gFVbJRNHXAodaadMy/gMC9F5lm+HQCUcxIi2iCXYAbq8/
         k1WnX1L2j/7cClcqb9BTvinAQRSIx8wizdwUQkL5lXW+Rlu5PwBwLPae07RnC1v77LAt
         Td7bjzE/7MQ0RZzXwLBskmvr6E+VWZiCZxQfZVtlenHW992yTqB75FefpYt1zPMJa8T5
         4ZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793319801; x=1793924601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NfimRk2GYnku3/wifGqwhcMFbQKhofA3PCyZ8KRFLg=;
        b=iUVLUJjcyoVTgZus5QpEl5jgAhdV6rUOm3M/Ma6t8oxGkUDx9UOeBYAbCjLTwSQxjr
         f49umWaOv6eBeSEjdcmaTWkv/RmxsHu0aoBHpGljOGt45Bhs3ljhK7/Uc2sRTZjECoWP
         RsDg4zcG5CmKY1o/QWK8fteFoF+XTvKbz8P8QC0EJE7OHsIju2bHUbL/57dzjvq2F8YD
         K/35eoNt+RG3eixkyz0O+HKM931OCdzbW4yVsg3YbQJjUHLQsJq3akt0sKux8fi1DXOT
         41X0iso1gLbBhWkhDJgpEjuI2eIdQ/AwKBPKX5eoLglsfa/ArgyQMuzu3kFX/yrKEDrt
         YXsQ==
X-Forwarded-Encrypted: i=1; AKwUvBx3XDwkpCyGXNZZx0RP8YOppuqP/W8uh3CRG+zKOWJbhB1SkcSHKItkhlikbw5V8XTnSixV+h4dME8n@vger.kernel.org
X-Gm-Message-State: AFq9FYIlWW8vdvAGt2H+X7liAo/Qz5Mak8GRWCrA962Gd4vRCV/nxBJq
	TR66JiH44+hqamje/LM8KjoKRNaayfmHHbkbn29SbJKxwJ+TczQ4tumFClEYN2w7
X-Gm-Gg: AYBFou37Rvg7Hj8Q8SHGvsDln0yFyTxSYJDgqAUe8C6OE13F3VIgJJgzTDWgdxyr3qv
	9YuJWRxPQgG61cW1RstJfMPw1WsiLBXlLFMYyXf1e/9lXhP1vDM2AleYtwL48pC7KwQiIiHVEJb
	yP98FJo8sya0dG+xUKqA4eGpFMpGmsa5BtIAKni+bm5cbzn/JhJhH0HDd9Efc8pRBYwy77t/AGV
	6K9Chhnyt/J6jxv6KKLO/tqwa+OLDyq6ku5dqLj8INZsmj3K3ed9cfRqQDMzrw34V73sW1DHgHQ
	UPgAjoDXG+UUdX+8G/PWzrPIWE+4PtK3+rpXfsngVvSLIfLJa9k13KuaiBy8ZPiThJy4wg9GO48
	c3gJX0F4+DCb5uXi7obJ2M9XsLa5UiUrAA1ZN9F51CFn9Az73f7bayEwr8vz12L4caUCXSPSixv
	t56vbzTiiRhHSldUE6Fz+4jFJ9O/rXR+zb5UaSjF2vVm2aW6Fd5W6n5JUFfntoDuFNbSFcFS3uh
	S0G3dMpuKASBCsf15T4NA10N7Qb5t63PEwYw+iZj9Aw/80WFuDTyYhQKmf1b6W98AlrU/qwRg27
	IyAHD49FCmG/xK/pOY8fjkFIbRhoYlugy49PUJLnYGQDuPLjVsbtQkwDwnpubc6V9PMYE8FprJQ
	DF4hPzYAUgjHAz1NCPgGsUSvU6EMYYoTF95fqAR5EmpQZgH/9wmRRO4qooWsN
X-Received: by 2002:a05:6000:2211:b0:48e:6419:ddf2 with SMTP id ffacd0b85a97d-48e6e2e76bcmr1859407f8f.17.1793319800920;
        Thu, 29 Oct 2026 17:23:20 -0700 (PDT)
Received: from SD.cable.virginm.net (cpc117822-heme13-2-0-cust760.9-1.cable.virginm.net. [81.111.210.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b728ddsm69596f8f.9.2026.10.29.17.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 17:23:20 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Alex Vesker <valex@mellanox.com>,
	Erez Shitrit <erezsh@mellanox.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
Date: Fri, 30 Oct 2026 00:22:14 +0000
Message-ID: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
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

mlx5i_pkey_get_netdev() reads the QPN hash table without ht_lock,
while mlx5i_pkey_del_qpn() removes entries under that lock and then
frees them.

PKEY child interfaces share the parent's RX resources, so RX lookups
can overlap child removal and access a freed entry. A lookup for
another QPN in the same bucket can also be affected.

Hold ht_lock during lookup and save node->netdev before unlocking.

Fixes: 7e7f4780c340 ("net/mlx5e: IPoIB, Use hash-table to map between QPN to child netdev")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c   | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index 4120afd097c3..6c24ae8e7662 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -126,13 +126,17 @@ int mlx5i_pkey_del_qpn(struct net_device *netdev, u32 qpn)
 struct net_device *mlx5i_pkey_get_netdev(struct net_device *netdev, u32 qpn)
 {
 	struct mlx5i_priv *ipriv = netdev_priv(netdev);
+	struct mlx5i_pkey_qpn_ht *ht = ipriv->qpn_htbl;
+	struct net_device *result = NULL;
 	struct qpn_to_netdev *node;
 
-	node = mlx5i_find_qpn_to_netdev_node(ipriv->qpn_htbl->buckets, qpn);
-	if (!node)
-		return NULL;
+	spin_lock_bh(&ht->ht_lock);
+	node = mlx5i_find_qpn_to_netdev_node(ht->buckets, qpn);
+	if (node)
+		result = node->netdev;
+	spin_unlock_bh(&ht->ht_lock);
 
-	return node->netdev;
+	return result;
 }
 
 static int mlx5i_pkey_open(struct net_device *netdev);
-- 
2.43.0

