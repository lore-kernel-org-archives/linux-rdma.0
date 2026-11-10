Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352401;
	b=B5tR9FStBl5cOofIoxQ1wXnG3+Mx8Wba8sRQQwzIpdXc6RbVLCwvcjMbYLuP6ouZCXAk
	 uS4gaMiRMoyGIG0ovD8IC+ilTsL5CFR62G3W73Ak9eL0aaN0Ug+MVJGYflF15ykoHVurt
	 456PkLgfrP6mfVQsHCVllitxUypwbKTNot8ebXtPDSmyOKaiG6F6sIJwxH2fDsFI8mram
	 YNkei48u/znCvhEmeX8bi06JWhgWOHU+e7+roHnGwvwtB9mV9N0W4KfpxDy0/JiIc59p7
	 TA0dHK/pBibnZSsmPy4e+urIYZko5WEZuHLtRGEvHuBvKeNFe3KKH3bdY71yMEKa4dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ud8T4mdbdPPGU2+VlHIdj3ZjRdWxPiYqyHT55Q4BDnc=;
	b=a4eIp48MptEUsuZRBL15XQXNwTBscCi3oS3LettlMxB+6OrN5fjZU08oYgOPI+rmqr4S
	 wl/gXxRD7JOPQc1hQlNF1p3F0+fmmB/O3EERv0wogcEy/Qgz+g1YJlnd0E3DwtsSwlWax
	 fAYnsaKEBm7+71WC5zqxkHCU4wt0TAMkEzqGHAxzzPIRuU24aKLWYOF1995NNH6gGWB8h
	 QUksqpEacC08vHcNfctwzqZ0L5fw2TSCcyOuB8QOzQxyOOwtD+ZW2dFJOENiBybsGllzM
	 9llcbc5k3OZGwHYZ0AaBhh0syfFC8iR1ltcvQ9KvVivS9ei8EqZFK2kXw86h1KIHKKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=snTVJ7Ds;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86444606A326
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86444606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=snTVJ7Ds
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a070781f63so1196217b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352401; x=1794957201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ud8T4mdbdPPGU2+VlHIdj3ZjRdWxPiYqyHT55Q4BDnc=;
        b=snTVJ7DsTTatcwZgyt0NTW6EYGJKr6B64WkjFf5RVm4yiATGep3mDPMkX4RnEjXD3n
         Pu5ALpzpm0Q21OSzW53ixtUWFrMWbUXIacAgn2+PFY/5l7c8COUYVdp5V90yzMCWbijf
         D9aM4ULn6F29luQmYN2YvCKj9vrsEZsI4VDDbNcrS5A2St5QZcxDsuSBEtF1acgSqQSx
         5NaSPyLDICGXkWsglr9BAzD/QFvRTFEIejqqnr4nMbOGn/2Ptccua0QyGMJGFK0e1xAL
         1KOfCfpUoOmj9XKSx+OEhk44Vysw2FD4+BmCso+9DL0fXM6k4GdYPNOtC8EqfUreGZie
         PfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352401; x=1794957201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ud8T4mdbdPPGU2+VlHIdj3ZjRdWxPiYqyHT55Q4BDnc=;
        b=IhYcbTLUlHTwZ7fMyucJ2BqyuOUYVN38ECSLJROlwR2UwXQcs3yTRdSN6VDcObH9dX
         5perbbY8QPVtwNflDn9mEKPq/1ttGg49qVKhp4Kb/8q1jKXLDOWdSOgHdMdDB8/nIWnC
         m9DP2gBuDx+RLXXA1cW3+3nfMApcABciedy3xzXH+B248kDrjBOIsCdQT6i6O7Dd37gA
         CWO3WB2I3pp13tek/Hj3LyoQQuOmVvRh/Qu5dvIKn0UkBRT5WNcyfa5bk6QbxzbAD7UK
         R6yZPPDMmqu+lUq2evh8nA4pk3uz/pt6wDZFkWQhcFtRZxyWz/4McYlhof2cSXcTcwOg
         dIUA==
X-Forwarded-Encrypted: i=1; AL+hErF/3XnEJfxVJmM/hmFrW8fpXV630zTFsu0lR9ShV6um7Ororp1w9FsIOc5edTq0wRFbOfWkT2QpQjNZ@vger.kernel.org
X-Gm-Message-State: APuU4Z8kXE1fMOaRb5N8mayDCovmJcV8d0CfReTyYV/MggDBkew9TWUm
	OQVbfDUvKxtymIYTIJzM3IcfA7o1IM1U67KMwSOEYslm7gXJ0z850TP5CzGKbnkXY4I=
X-Gm-Gg: AYBFou1i+hp56KOnGG4D0IgqhsaPjedq2Ln3KwZc9mgaH03tzyC5fIYn06zef65QsLc
	sjqortliOeobWrCVR6Xfco1zTImcNKqJno6BMCOu6K+ZvxT0Th9uTDAWS2TJR0YaDUhE/uWJS6m
	mK2qi4JuK6QiolGfRozktQCo4/TR7dYEpw49SuP6DEBYLeZ+jM3TLH2yF6gGATna3KuipoEsdE3
	/ixkNi3wir/xbd6YQ3cBMOm9OSENCQBioD3d5HdL0zMd1BLU7XBn+aiZqwOnxV56wQ3GCGoLTal
	Bkz3GPfFm7H2tLpqn5MAclXVWa6p+bEr74Cnpma0O4HhfVNDOFB8q5wzpwYCFOaEWQRFuWTZl/y
	z+POkNkdV5gtWiawZCv3cuHg6LL1+E/M2g/VwYUKgKBd//cya7JepG9Velm65xLKv/D7byS0saS
	fhysuqcWXfxpMKTOTX27JJIc8BQpNqykHx1yDpouH9j+7tw0TOaIHHwwrqobPqZPNAeOBhFN+3r
	6x72TC478LUbrW2S6fdlXzLFf1IzrUpqxA+EaJ34om3vUNj78W93kL81E7gbgNm2XT7plfzNYKh
	ZSTxFbj5LAOnnUvI6R85QWDLJKavZXEjYyF5tAZxS1w=
X-Received: by 2002:a05:6300:4090:b0:3eb:ace1:4b4a with SMTP id adf61e73a8af0-3f2feedf19dmr618205637.71.1794352400889;
        Tue, 10 Nov 2026 15:13:20 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:40::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa1b27cdsm1353357b3a.19.2026.11.10.15.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:13:19 -0800 (PST)
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
Subject: [PATCH net-next 2/5] net/mlx4: factor csum flags into mlx4_en_csum_flags()
Date: Tue, 10 Nov 2026 15:12:56 -0800
Message-ID: <20261110231304.1859217-3-joe@dama.to>
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

Extract the code which converts skb csum fields to WQE fields into a
helper. This helper will be used by a follow-up series implementing
software USO, to reduce code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 00210dbae1c3..f6059b533eac 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -861,6 +861,16 @@ static bool mlx4_en_build_dma_wqe(struct mlx4_en_priv *priv,
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
@@ -891,12 +901,12 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -991,12 +1001,10 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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
2.53.0-Meta

