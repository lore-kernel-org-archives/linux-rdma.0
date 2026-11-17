Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794930848;
	b=YbsXW2bcFZS0EOE//TzQWrckRO0KQzGVGdqnTjJwmROVi9ozbxZxpjrcJeWwYy+tBisN
	 PkKq0sl4wSDihMC8eQOaXMWIPOa+jn/GXtlNWt5fL47JFIyhB7vigwuI1Z8q5+ZHejlQj
	 7FV82cGTk4aAS6GLM+t5zO/eFrleWHN/xKqD86hHZdZOqw5XGYxHe2MLkZwhTfdLNaGf3
	 eKVS1gOe3TZ++QOIe2nie8fHrjpuKQlNaB8RYlynKs+a/MHlUwdZH0h4HZ4OchwQJwlLs
	 YshMnpADL5MJOj+3UJ309XNeGfLIlyFciPCWQczOmpAv+NGyhc8keTxWawu4XQpw+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794930848;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T2YU1tH+CNIU0dqfT1pwQhaFGOXLajMVIubV/u5Dc70=;
	b=ho+PpiDl82LjqPFmmgJfkz9TRE9hQxQdao/lVV7nnnR/YOxqKJbG3H0AJkXqa1+wB5n8
	 8fbB1OehYjTqqsuquAxLxukKWENxcM3PavI4T8xriw7iFOGSH/DPftooEHkuQNRuGQh7f
	 W4QefFvNy95eQxGK5A8JoHtnNn7P+EER7yWnXuR8nWk8jbBk4P44x4fOLAPw0hcDlfAQN
	 YF3hlqBOsNzICCG79DrkpFNCnjEqvo1MwalI6YIkxIC2dsg8vys0SWzhu0/DyqrQUNah5
	 PUt/RNHOWlMmtU1q0WxbNPRXjZJx5rgcl5ejx0mtaGTRlIgz5IFKVL2Gt3fK3Dz1Fww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NRWBHVqx;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB03C606A331
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 15:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB03C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=NRWBHVqx
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e987a2ba0cso30219195ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794930847; x=1795535647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T2YU1tH+CNIU0dqfT1pwQhaFGOXLajMVIubV/u5Dc70=;
        b=NRWBHVqxDtrZjDj810zSeDDkUYy70Fy2OixwQJx4w288utTEJ2lhTiDKh07xvr/vYH
         yLV+zf1kh5q1IU3c4fIARPakpLRFUzh2iQd3rORcU6P5ve41M64GrOuSBFnlvh3IFEps
         6gFDQtoVKzUGsm8jlQNb09VLw/T4v9qt2f/ZLa0sUFXnOtpTmoNrenLOep2ZDmF9rDqG
         lcZXqAjsuHWujLYdr9AeOIesJONIaXGLf4i7BPnL/bxAb0liHoWrPGM2CzH/41uqUF1j
         FO7xelRfvhlmqllATZKtUfxmq+/cLf3FGwj+8rvO2cv4UKUYzKPLRFzqvP3JZYZCL8MJ
         wu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794930847; x=1795535647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T2YU1tH+CNIU0dqfT1pwQhaFGOXLajMVIubV/u5Dc70=;
        b=iwt8FbdaOUWEA3x56tgU7nOMB4HX4SBH4ULysP7/85TGmJcVZvZMAoWDsbVMPISZtV
         dH4e+ei/rUWl7V9q5oCCQaQeNy+zw22WYeTahdIb3/84kzhEBbm0k2aMCt7ta2VktXN7
         bimCKVqPClBcC9Uiq8htYY/fBCsoPQGjYr0Ha3BakWmzY5Inn7RlTL3ORT165bYr8LZh
         98wnfgu1nOeOBwrJx5YWf3VIGgyVkm8hDWGNL75HrRWaq0bRfE+10YqYCN0UrDYm+frO
         noym15PyEMK66aVbT2d9DKtf9FMu5bvsz5zGg41skJqTDQkq4XfPyGeuv9H7/VC6JLUu
         nviQ==
X-Forwarded-Encrypted: i=1; AL+hErEAS1pSzXfqLUHmeg2wP0CxMRTQ1p83JOEKAN46nmUNVLmfVypxDuHeUVFy1ZZAzGkl6BfJfiwLt61X@vger.kernel.org
X-Gm-Message-State: APuU4Z/n8uo9Kvk6rGsdpI9AaYb547ApjmW1QHRBdd0oswrmbfcEC9eD
	cqzAknQlq266lMw1kDvdnxVZ9dVm0y26SlXsD3sLcPxKCn13SNoYNeO0PM0DWn6FxGc=
X-Gm-Gg: AZFdTZdSZHT8SJnSbeXZPwGq0IaE4Iz/JJ9b3la03XzWtesO7ToAU7C+h4uYFkv4ivR
	h/adrsX4EoWeY/fEdq6kWYbyB1illHMnzFJPSIY5nl5S+RHhaNwIAtpwbApkHJdeqVcqHW0tWAH
	dzFwTJG8X/ktoKdFcrhNzL4BJ9sFPb6OQ3ws6DrqiP2RiphmmOjk1VpU7cHOIs1Xge2tOb8s3Ic
	sf1C9c10JnihoWJhQIUUvkZRDG4rkOswDXmbyhS4uk+RwSalZ2G4Cd0o4qcvmdPgP46y2bwazE/
	0anoyY0VKocZXNFAJwAd3OlYfOR3EaeBM97I5FT69gl0uAUG/lBkqmIFz/+hc7NUjxUXN89th1C
	Ao15CQD2DNLzO1aQjIjBO8dEkqgtmQMLULNCYTCA9RjD0nCVFMsVLeco1wGyG/HPMadYViOK5bu
	hDmz5QyCQVVOyNrmmUebeiXLXCG4Ul+j7GdXcLm7iMLmWoTC+rk+CjPFQMeICxafZfYXK3p60qK
	+2qIZkWlUKfvbaHBpRMXWplBrPsplcSZk3Cdlyn9gSL2yWL+ahaa1DWCaz9+4SfhDz6LDl+h9fI
	qqEZunqFPikb2W2gx3C+W7uZYkqX9beItz0DkG6DCg==
X-Received: by 2002:a17:902:c406:b0:2e9:3f41:4212 with SMTP id d9443c01a7336-2ee0da7af82mr132965015ad.13.1794930847005;
        Tue, 17 Nov 2026 07:54:07 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a54576sm18946785ad.40.2026.11.17.07.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:54:06 -0800 (PST)
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
Subject: [PATCH net-next v2 2/5] net/mlx4: factor csum flags into mlx4_en_csum_flags()
Date: Tue, 17 Nov 2026 07:53:47 -0800
Message-ID: <20261117155353.2250540-3-joe@dama.to>
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

Extract the code which converts skb csum fields to WQE fields into a
helper. This helper will be used by a follow-up series implementing
software USO, to reduce code duplication.

Signed-off-by: Joe Damato <joe@dama.to>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
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
2.53.1-Meta

