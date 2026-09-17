Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3814E06E7
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 11:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646194; cv=none; b=qsg58wEeyEvAoxN8WVhktA2lXzNljHtPJE1Jkzi+Cqry1EmLOxiAnCAGWUs85/KVMNGOJMAS6fqDB27wVnPxGBzb22BjfH/mLVUJqgHmKRtYyeovky2oBvIUg3y06ivCC21RZTJiow3TKNngGVvXVZkBpPFwXfHfq0bsaEdazc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646194; c=relaxed/simple;
	bh=vblgVjmKLjnqZGvPgkCntjtx/0R17wWvdDbLZshFLYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a4NFG4b644Wd48QMnlxQamX+jrsc+ICHpLz+HQMgutqqYxHm+OoaFG9GkIssorFd4ipcZlKYvHDQb3QGIzbKaG8u66CpxyVlYBxDUBDQ7iYPsk+PdSWZuJG0LdVhbubnI+uQEpKxd2Ey5vMVfN9zR5nd7DpiHOifRHd/NKJ05wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSXS0aWi; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSXS0aWi"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6b885ef8so4226945e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 04:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789646169; x=1790250969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sfSAIiiQdgel4feb27tEimyHftJdnHXovDfE5MDcETc=;
        b=YSXS0aWib9djmCbcYduOElRmbUr2+dvSU9vfgRCkf3c058OJK7T6dm4s37P9KufrXp
         Js/sOP5MAPmuCpjRJgqSLmC1LVmsaWyfLufBKXoui9uH4qVL3s58k6/Fs4YRPt8hns+e
         R4CEJ+BnuXW4TguU1oXGN/x5moUmGpezGd51ZK8rGKlfYxYZhj2vXjvruVzIK0dwMBHz
         ZtNgIhdAdZl3A7peeMIIkivZUbKPShnkHfl0molCteJQ1hux6XAjDcCEcgl1cRZoBxsK
         A54Jaqxh0kI09z/xSRXXVH37qvARQS9EoyVadTGK0fZt6xkHDRnKACGd0toWrkAKf0pi
         60Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789646169; x=1790250969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sfSAIiiQdgel4feb27tEimyHftJdnHXovDfE5MDcETc=;
        b=tCbcayq9D40hZFKDkJ6fAxp+K4e1HD84IY/sQqdUy/fP0wCZehqBJCrAov6DW4Kb7l
         bUwgeWjBTdrOTdCwazKqyspXQr0Is6EJS66CAY8WEhAhXBvvhozXr/CZY26nAWhMuYUm
         a+djNH6OC7jYFYsUsW0H4MpTC9Acp6G7F4+dpRLlKjyGzvXbko4AL2Jwm3SlvaUAEWhT
         l6TZ+6Q203TCK1eypuNpsOXjCKyDUJCIE5rODBDAYi6LnCsGsJhjslcHTv+RMUVFj5TJ
         cNOJtzX+jWwXebeSd8EP8y0ZnB0M52nrqFrdTwSNd8XkgShOGZcQnmimfKSqIITP1Z2y
         rVMA==
X-Forwarded-Encrypted: i=1; AKwUvBzc+Smbmw2ruQISdvY5fWyxOVS4ufwB0iCUiPWslqJPLosUIvgJAgHvgh4GtRWBXRkBHhlFwpBObU77@vger.kernel.org
X-Gm-Message-State: AFuF++n54qICwfRobrrZK7cy3iPn7kFShkRpx15dzMW+EGdNDk4cDvJ0
	+M0xQMRL9biL/HLzieMeiTHaNAJjYVskm2QK+Qdd3IA5cKbZyfMKCRff
X-Gm-Gg: AYBFou10NhRm29kYHKxbzeRXa5FBwyuQQtrfvSu8vq8wncuSIp8TNHLfLbeiaDhzuWf
	qsZQr1zw9u9G5nw0e3tKfFhnzNeypLA+1IM5dSgUPn5vzWU1TIVkGGTO5TcNH9chLOpxQsPsycu
	wyQGlMuwtm1X9nHZB/yHCanUSmQRKDQeXfpTYTYaEJB8V0PkByP/LuKPU/03Z3UHgJELoLuZl1y
	9LOf4Ov7DWEnoRKVAphyw7DBQ8PfOO9W8jPXJ0u2enN3gNIkMIV6F8buVxxSkLBQX3vMNfF3Bbv
	Z34j7rxdBA36XbywYWQIwzfzD3JPIZUX1jK/PTnnbCX4A/aHIduniJcNPsC0zyHTUvRHM2OdqK0
	1g4Fi5wTnt4BceeHJCJjTetaF5Yyu65SlRqIH8VvpXxmQK0qZPVqWk1kFgb1SdbuGfbAJmpmnoY
	4xFLstrc/prV9F5MAAONxlHpQ5ummS+0iOOlsDriVn3+/3PZ5nvc+fhhPskokmvUkjnljB5ozkH
	09i4Kg/oNRnNh1vNONidhhWiSWuf5xdONWp9DnmLH+JTGQt
X-Received: by 2002:a05:600c:8b35:b0:49e:6861:50f7 with SMTP id 5b1f17b1804b1-49eac4626c0mr70270685e9.5.1789646169088;
        Thu, 17 Sep 2026 04:56:09 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1ce79csm79913185e9.0.2026.09.17.04.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 04:56:08 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Boris Pismenny <borisp@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrea Parri <parri.andrea@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] net/mlx5e: fix swapped IPv6 IPsec policy masks
Date: Thu, 17 Sep 2026 13:55:42 +0200
Message-ID: <20260917115542.177675-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IPv6 XFRM policies may use different source and destination prefix
lengths. mlx5e_ipsec_policy_mask() builds the corresponding masks
independently, but setup_fte_addr6() installs each mask in the opposite
address field.

When the prefix lengths differ, this makes the source match use the
destination prefix and the destination match use the source prefix. The
resulting hardware rule can both miss traffic covered by the policy and
match traffic outside it.

Install each mask in its corresponding match field.

Fixes: ca7992f52c2c ("net/mlx5e: Properly match IPsec subnet addresses")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 329608c59313b..8ffa8068e90ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1564,14 +1564,14 @@ static void setup_fte_addr6(struct mlx5_flow_spec *spec,
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), dmask, 16);
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), smask, 16);
 	}
 
 	if (!addr6_all_zero(daddr)) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), smask, 16);
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), dmask, 16);
 	}
 }
 
-- 
2.53.0

