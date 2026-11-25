Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795629636;
	b=CRlWEclXlZp5dS1vKTwhagR+apfyX3zCBJeR5IgJSzU3i98R0KjjkVKBQcjRGd+a5w/u
	 yzwr+GpmC6zgb1SpW/hF4Y1e5K4zfMVoLW8wxZsfZmRnUytC3e1nq5f1rQhOH35rqVDlm
	 22xmeIBHwP0QtBryOizXrtriCOMTXVCC3WMzWyrdJLLvbpiaUrKfNHH6bBPJD2n4DySke
	 ByK4Ud1uPrGBtqX7X5diSZ0EMaUL/2MLwgWVoSx6ZrTVbSzgjUY7in2BwBzv0tWPAGW2L
	 7VnmPCmAxMPNiwNecJ+gAaRWDnM2KqvjCE+0SEMzLh/1MK18cDpyqDiRIjE4cephkwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795629636;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3pm0NV4l/0E19QH1D7hyEXJVUZBwSAdff5s9WN+kmkw=;
	b=NnutreIV5qWyQYUFzNeG1atO8ohERY8tNq9CeYzXt+vmlvRKWTnCTiqmSSjXA1E5m5tA
	 LlXkA2+hpVJ+cO/H9eevh5YiVd8T1kWBvIXSYfsIAk2jj9+MQAx68P59kcfy5LjyQidHM
	 SiauR4oRjzGlEpMnWnS9y226MRe+smeYKyizjjsE8elr4Acwrm27Z/gTXkT4sXcmN5kFx
	 tO3bUmWk80hn4nTCzyilHkAjzGerItqi8Z8vj1NYaDGn/Leso/Ij32sk0hqLstUP2T8hc
	 Melf/LnzPRpzd+9y0ME+WcuTJ7SsEQeqyiCCeZKXw/JFZwr9LKG9fWn+Rvo9epwUu3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qBoKpS3Z;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A697606A681
	for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 18:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A697606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qBoKpS3Z
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cde827b7b95so1832327a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 25 Nov 2026 10:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1795629636; x=1796234436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3pm0NV4l/0E19QH1D7hyEXJVUZBwSAdff5s9WN+kmkw=;
        b=qBoKpS3ZZAB8952Iym+pb8+MiwHIZecNThqHFY21LgH06n26HX/kC9kPbvCPXaIFE/
         WCgnQ7QIM3sXxomeD/2k6pk/fBFqYC6wH1584SXgaEGeXKmNHUtJZ4rpwWYjAROfU2uf
         eTLLkE06V1Af6gyF4ZujBdukvmLgr0BdMh6ixf952Sjs4aMfxux7oVFBt6yOWb4ILTxT
         /Bs9r17IDrmKZ38nrhrkmjkvBqXWIrLT3YcUCbLa1nwpu9jZCSrv2nmsGiOaKg87SjkG
         i3wL1QXraLDm+Vf2MRO6y5sjJeU9KaMvVE/Ewnr0NaqPXFBMoraDCkFy53K8+WrWXNnn
         DH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795629636; x=1796234436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3pm0NV4l/0E19QH1D7hyEXJVUZBwSAdff5s9WN+kmkw=;
        b=tHYgL1EhCCELSqBrFe2IBcqULDvebQPhDWP9ZmRI990GYnocapMeVMep5168dC2GXN
         XB2/uitYRMfQJjmo0+XvjA1tAat3qzWtXORkLNb+EgYcUYmEObmF1LKgFL0u53qmLAex
         hGhm3QgKGw4sK6jkVhiM9IlkceOu/RoJXdIdAR3xRDTVkjhv3NWHNN5GXLYkgg8SV3ks
         bEQJIiKlBapcfbO9MKlY2eDN3vUktnHOfyUIDepmmKEEnwcmBgoiYTHoE/iImPXWmZXv
         D+s5noxLNikuccdQoZX6DseUMZsEbDUf3JBqTV/kR6OCZ93KnVj+pCLKn+iYuFQ6O9gV
         0qxw==
X-Forwarded-Encrypted: i=1; AL+hErEzpjaJdJd2ghIdQPw9hGes76AJ3zSZu2aOPeXnGce4jLH1L6HPAlVvXAM+IDMYmniABIhqb4uiZg5q@vger.kernel.org
X-Gm-Message-State: APuU4Z+3fPUbYYtBlGxxkwL+mql7+H+ebke8I+uW1AfhYas46tjUwmBJ
	x90lU1YCnni1aKdPA+tCypffUQexcIgUsDXpJOi7sG9ZBfrAAgKRUrgv4/xavlksw2M=
X-Gm-Gg: AZFdTZd8TL9R2h8IxqVXXmwVqdFjVWsuOaBIJ38k3o5G50seU4OElE3+rcf50GbqDQE
	Aws2amdgj56Qmt1gVB89YAdLbvP2ZD+nr+VMObK9R30XbWtUAB1vYmlsuH/zGK6G9WmWciDCbto
	TrNU+wDU3KUa65TOQfhPnARf5BFPbEgVgvjW7tRc7Nc14GCRUHUC4f7HtfIfaXnctxLSmrZ0OQc
	MG/HMn01l8ltdxaHhry5tRrjeq9ezEEHgVggAxqGd9OapCsG1vQPZ9WiHjrH0qm02a2oEcWGdS/
	tiaLj8Eo+b6ciN8H9VrfhROwiRZ3fcL4N3MpqtU1P8vzoXG3Oxc3bQopF1xHuqVjANUFvAYvV8z
	0w489k7psr9Q+5TfLcff8xRa7y0yEgFmSVMbe/c4CF5mhGedO7539nnhuhwF0G1DHs+tk5LrVvp
	GBaEy6xV3OMAGEoKtfa5TaSfNJdt/GELSpSCLjcz20QYiBElGVNgRtr1m5w4ml8wOJxPAK0ThT6
	qmB5/H2geGLSk5rzWwU3Ebo9fX8EQ6w8cyBa+OecukrkO9GA3mJhxpK5lECROQrVJfx0o0Iad/k
	lPDMoyB7+nrovhiAVTRPL4T52vq4JYKOeZyzOklhDEsg
X-Received: by 2002:a05:6a20:6a04:b0:3fa:df2d:d3e2 with SMTP id adf61e73a8af0-4014c756bc9mr17912134637.16.1795629635828;
        Wed, 25 Nov 2026 10:00:35 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:4a::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e45756sm9446318b3a.27.2026.11.25.10.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:00:35 -0800 (PST)
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
Subject: [PATCH net-next v3 5/5] net/mlx4: flush pending doorbell when dropping a TX skb
Date: Wed, 25 Nov 2026 10:00:18 -0800
Message-ID: <20261125180021.1804204-6-joe@dama.to>
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

If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
that skb happens to be the last one in the batch, the doorbell for the
WQEs posted earlier in the batch isn't written.

The queue stays awake, though, so those WQEs are eventually announced to
the HW after the next TX, but that depends on traffic and could induce
latency.

Avoid all of that by writing the pending doorbell in the drop path and
clearing the flag.

Suggested-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Joe Damato <joe@dama.to>
---
v3:
  - Add mlx4_en_flush_pending_doorbell which clears the flag.
  - Call it from mlx4_en_xmit (Mark).
  - Dropped Daniel's Reviewed-by

 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 8a43c86f815c..8fd1850ba756 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -759,6 +759,14 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
 		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
 }
 
+static void mlx4_en_flush_pending_doorbell(struct mlx4_en_tx_ring *ring)
+{
+	if (ring->doorbell_pending) {
+		mlx4_en_xmit_doorbell(ring);
+		ring->doorbell_pending = false;
+	}
+}
+
 static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
 				  struct mlx4_en_tx_desc *tx_desc,
 				  union mlx4_wqe_qpn_vlan qpn_vlan,
@@ -1131,6 +1139,8 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 
 tx_drop_count:
 	ring->tx_dropped++;
+	/* an earlier skb in this batch may have deferred the doorbell */
+	mlx4_en_flush_pending_doorbell(ring);
 tx_drop:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
-- 
2.53.1-Meta

