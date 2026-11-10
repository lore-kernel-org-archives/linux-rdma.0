Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352404;
	b=nVyGPCsCqGMiFpJroMffIiAhZokNxlKiKr0H+SxCyAfdFdYOGGX/qDxN5grC/AJ8dvLG
	 8NP137HBT54MLu2Uq7JG4TAKbPL3j334kZTTqvaXldFCxcnic+OWXaHZJIiRkUH1YfOZz
	 JsCLnmKJExmBnTDSGtkM0o4BvFbO1ueM6oJj5KQrtM9Xn5AtI1cYNGWQnhQzQaug/XLEJ
	 9HYoI+Q4D65lLitVI29dQnjH0hD+1ZtCT0vbEXKiPXUm7yjwn7YLifx+NpTY/C1wh+FdN
	 oRK8DeYp0yALtdwxBd4YBTum3BGikADMqwHX4hpq7kZHNuXzF7dXCWjHu1E50LGihJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y2PJWsGT9DDXgdyqOWNZn4zZ/5815bxCRHtUykcsi0I=;
	b=MYzeyT3H/Js2Vn0JxASQiShno9wIP8g9VxM64ptaKUAzkoLU4uYi/GbEZfnArhKXa/3L
	 UPLAcpO5VthZfeKWyaBf2DUtQbaaCx575zRJmAyZlRQ85BdQR/UfisdlNO/a42Uws3xk0
	 C5+gVScnQ4noZNg7WTv2R80ygLA8PeSr3ARxr3aG4QP783H24AE3O97xmLJzxuKFCfcD1
	 GtFHyY5/IJP6d0aMVYdYoG1ROJi0cWuQxqmXR3bpjUGMWPAhv8WYg7bVp0EdVUjCbutmZ
	 9gu+ylZ5sk4DbzIY3L48yAn9ShtAcOXt0Klpkg+sZaqHZaRnPu/rACxgCaEG9+l6utw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="DQWHs/Y/";
	arc=none smtp.remote-ip=209.85.215.171
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79A606A334
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C79A606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DQWHs/Y/
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so1112892a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352403; x=1794957203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y2PJWsGT9DDXgdyqOWNZn4zZ/5815bxCRHtUykcsi0I=;
        b=DQWHs/Y/PxX1bY1e05b88CkK2bDdAN5JrwSGtg8GmFLeuA3BgFRMZU3R3JUh8zlLvg
         HErh6MpMjAOgl5cKp15bbsjM/8DwipYqYtH2+M9M2zQM+2aeKsSSmDZe5Vz/Q2cQQRMS
         QfKQgK/OCFPz1FNqzRusy3fVbbq6nCuTfkZf5w+RuAq4oCwnvAYnzMVwtggo3O3bdlFj
         P5F/yqBL3vL1y9lZG561H+nDFpGLL4F0WHMcos/ea2HORjLbG1QEonMAlVDdQNfuFgW1
         LIQMXMrrZMKItHydzE4sOsuKCoTtoDyCUVAmWFuIIfgWzl9unLZrimq6c7BocjtqbZQJ
         Gn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352403; x=1794957203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y2PJWsGT9DDXgdyqOWNZn4zZ/5815bxCRHtUykcsi0I=;
        b=zgDKYCpc0meCDkemgWgW6SVJbjiKOFcmXf274zwg/RAsaX/VASy4PR/bnp7t5Wqz41
         2Q27jWENqZpDRfet6IPrPMPin2MlSVUKWdY0VcdiA3WbDZdmNPurU/hKPTnj/J26sGIx
         l/Jb5vaFOI6KWQUCP0PyePV5o6fDzyLaTDGNbRHAV/nvFHNVtO2V/RHASDLewX9/gRog
         GoeuKqathGeUs6hNyooL5hOACeBKCwgfWLFiP1/8AjL1LRU6O01EYTrd6RwMVZEH82Ue
         APTlVZOtyEdn1yp3Lp2ewxZYcxY0msyq8F02AChnDHesxd/XsJ9FuFhCwCakxsPOkCPJ
         XBgA==
X-Forwarded-Encrypted: i=1; AL+hErGAqCjvXAJNZDnx0UOrhNOnMdib1QtNOUSU/mI5TCJQQOEJEWAveR68g9ckPM33NJiILM6mPNwWRO4Y@vger.kernel.org
X-Gm-Message-State: APuU4Z9gbrNEeK4gTPlhTK4mIFR6f0QteNlUHIq45AjcU9BBtR0X2HA0
	QFLPtAbUCttLOPTScuxZhODxWARaUKDkc4V+my4MoN6WWsAx8mloYF3nZBAXeQEBSwo=
X-Gm-Gg: AYBFou2NNIBsxMnAvCWRNnueyOmHgGYKzuwREsni2F9XfcK0s1tq53eylFtc1IgPHeG
	7uwcSPb7EW4j00KKfQooN3kHvwpgiehuKbMCZo3dhCkQvwWNKtpeXK1RdQ3Ga6fibYhF6iHucIi
	r7d+VxKyitQBg0q0yyd6nr0synyMStfRhC9G/4zDafROW4+Qf7o9nlht3sxq9NhDA2dzRDH1iRz
	ExpDv0rX7T9gnwjtcmfJMgt8+mNrcA+2tHglYG6eilmmEGnkg6ID1bgT2MdCd3Ki81DykGy3UBM
	f2tbXpelGjp/M45qSQtP6nDQ2xDgd3HeeobRMqSTQnro0tDcFT8rvJ6bWf/L9wqHnfk+T+D6bNR
	Bub6AMt2TIf3dZrE31jB4meljtKEAIcltiS3BtHm6xZsteOv1KqQemuzjG582Npv/9WISXOlJL0
	y6KX9MmcYale5hBYge3FLip4BnS6/PScDshlsZvN7xT1NKfoJg+aE8+22yVU1NjQbu4iysYo1vl
	+vJglnsg8f5U80MwoBD+5UI/rpD8LdNcTU5p3xan6kyOuCfwBjzr4mdMISnxuJFHx3hUqyndmdZ
	5r750faRq1+/aIXUMvmUkUqInAUtQSy3Tz0QknEJQW+CMklezdJxKw1etsJAWfk=
X-Received: by 2002:a17:90b:1e47:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b182fcd7b0mr392066a91.63.1794352402961;
        Tue, 10 Nov 2026 15:13:22 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:1::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b182de1dafsm323373a91.3.2026.11.10.15.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:22 -0800 (PST)
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
Subject: [PATCH net-next 3/5] net/mlx4: factor HW loopback DMAC into mlx4_en_set_loopback_dmac()
Date: Tue, 10 Nov 2026 15:12:57 -0800
Message-ID: <20261110231304.1859217-4-joe@dama.to>
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

Extract the code which copies the destination MAC into the WQE for
eSwitch loopback into a helper. This helper will be used by a follow-up
series implementing software USO, so USO packets between functions on
the same port are looped back too.

Signed-off-by: Joe Damato <joe@dama.to>
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
2.53.0-Meta

