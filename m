Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629629;
	b=pJ4hp6cs5gnO36aMswflyVNOEAPec5YKimngy8+mBhOjFw4T1nOZIG4l6bOw+/yAhKiN
	 fSJ+frqztGfOeBfgo+iEHzZ5lpQIXWi/EBhL2+qgrc/gBTUPINxie3gC3W7d/k7WFhj2E
	 dLBph60G2ej0ch0JwhhY5Sp4+IGgEkzPrRolq23P4qp6Xd1llOHYSsuSH1mAaLjwh+OtF
	 CYcFF+e4bg70E4fcb6S3Mse4b4c33lhBzSTKNEo9NPWw5sSND47SNKWBh/8LhSZmSKdmA
	 0OhydND/GlrCfZ3Y4y55SAhrASX7VJbwZyaKTROKaIuDHbqR8oYFTBJQXsbDnKWahSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKT68XtEZZ8Qs2Socjc73mf40QmJchDPGMQ2JHov2P4=;
	b=sfrJLUCwkch1jjT9Iy5s+qOoI1NiVQUeuvqy1lY8lRDABQCGGgOaRwTeIIaZBync+YZ6
	 8YDWK5dVQtsxG61hSQ4ImG+GGkh6hCpopuD32wczot6NtzsrVdYPJnP1JzP7NZV4Gtn3V
	 +3Eb6gQ87nl/G0Qj9ufuDwB5oVBUWRTpLqxCQpIR5BvJfw+rC1AuZOsN6J5yPSv7ckEuZ
	 1Q/dUYQmcZR7ETy0UIQHNgyrQCp3W5E2wk8JtRisdO38ILo//B7VXLTnzMGCorvAw59k0
	 jOKrNAYH1UX4FSVmjomsTtkK7a7f912SC8qZW3a7OfyoeYv5km8dz7EhABH1ZtwI4iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BRdggDeG;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3251606A337
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:00:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3251606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BRdggDeG
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso2485898a12.2
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795629628; x=1796234428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pKT68XtEZZ8Qs2Socjc73mf40QmJchDPGMQ2JHov2P4=;
        b=BRdggDeGyPI3UAIylfVeo6IPUlWp5GXsBc9dN7tVIt1+q+QcKd/tXzoK1yOhY4oXUM
         QZe8g21+sEL17dtTwJGcXqTyR7QoruWYRHw76cSONFuZe+4vei8242A3W/hQ9FaEDqdi
         s/50x7AmIe+h/CQZ7Yl6BOhoBzNfbphR2P3en6MEovWrnMtd/aPK7Kx97iVjtfhkqGhE
         abBAvgWOWgyw0xA8ukIa4zKDtpB1B6l+IBt/gSs9hSGV19uuAqkrtlXtbEvC8zwQSViM
         0JSEIAl+7OBl273nXhhkgWtMWSEdvCqky/27/enl4E+lIO2Zpzm2VCnck2+xBiExoMUx
         RaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629628; x=1796234428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pKT68XtEZZ8Qs2Socjc73mf40QmJchDPGMQ2JHov2P4=;
        b=W6iQolBgfdfVrTnvxZBS5uRVZs4onqwwTW4qY8Hn6+vco9NE4CK3ntgPgH1YeAbuTf
         jxVSiJH3My80ybbLw0kYJNrqkiAolsMj99XtfFBRzwPOqhasUOmc+0+gwcmQijwnxCTC
         zB7J9TfNxJu04mEk0AHZ490paKHQj0HmQE1lvGk8dbRd8PFRbq8STXCDvQ2kvkyIgMYI
         a5twRG7ScpD9N+IBMCo4pTRpAfPyPP5N3W0YzzAtFKrLGBgD1Vz/GSSNxMRnA6jn8CG7
         3bQtM0VI1p8hlIAikZkUfSDIvrRJUxnDvApan8vjwIB0bS3/u0LUVjKtpxqpZJPCSCUi
         GSCg==
X-Forwarded-Encrypted: i=1; AL+hErGUw0cl6RWg5LkgsTzc/im6E46AJRZsMxBbABLCHb2EtXObMyYFowjBi7OzYWq1F7Q6eEQDxOX/sVwP@vger.kernel.org
X-Gm-Message-State: APuU4Z99mqH73+IQlPpctsvT0ovLDegE1BK600Uzz03QyPVRYEUsH6N6
	esAl/IjVyOzlXjjVBAFvigHp1Ov05jUlK2uNG0eBTpdhvZIAZXbPPcBi5F3onqBvbQI=
X-Gm-Gg: AZFdTZdG4v6szSCMMe2dvWTbVJTACWgAx9cE+W1vGjz/0q0t1qP3DKsBfLwMYprddHW
	w3tsP7Pf18YLc34f5Mjrf6K9pQQXuJwmBG26zlTEWu4m1pjnPYxDM8vlrNJgRjR3VZR7PtGaANK
	mS13p7is+uUBKjw76p+W+I4XUhI2DAmx4KgJiM4q7EZ4GlB3iSZJ/340pW3cXREHM4ljyGZlRkv
	SmjKA4ILdb2wGX3/opLT7OPl0QpZ2xC4wh7QEyNQgKYBOt5+rBpjj+qZmxFOqOKl7D5w/as77/X
	UFBGCM7TeR6uy4QRuzGvTW3hhw8jb4koeNXWYYWPMa8tRIoIEkrVyBatkCFjheirnGGx7BN1hD1
	gcJSQU5MeTMkB7AQnZFHVr4QEDSRgA7MNbJPwKWbDbZS99+B8SvzvXgM6sWWtfZnmu31SeY2bZz
	ReFFnK4nhsH2fcX/+vCreuceS/lcj1pyf9E9+KJcEglt3BmNQrQV/u7dYFKazGJ6z4Atr2NrAEi
	g0yhEP3RXY88U+XYiKeZeo2V+nt7GubC4JFfOeKVeAB6buZZtBlKd5pySVyMoz4Ojyw3ZLL5NLS
	q3ndOrZ1c/CnT1sQad8+2OXt0wmZ
X-Received: by 2002:a17:90b:134e:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3b41c96764dmr18279550a91.49.1795629627796;
        Wed, 25 Nov 2026 10:00:27 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:45::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm31254202a91.16.2026.11.25.10.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:00:27 -0800 (PST)
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
Subject: [PATCH net-next v3 1/5] net/mlx4: factor VLAN parsing into mlx4_en_prep_vlan()
Date: Wed, 25 Nov 2026 10:00:14 -0800
Message-ID: <20261125180021.1804204-2-joe@dama.to>
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

Extract the code which converts an skb VLAN tag into WQE fields into a
small helper. This helper will be used by a follow-up series implementing
software USO, to avoid code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 33 ++++++++++++++--------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 9865ccd8d6e9..29eda78b9977 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -860,6 +860,26 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
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
@@ -901,19 +921,8 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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

