Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8B449363C
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791817404; cv=none; b=mlPIJIlhxRsTOFpZgb3G+UYhLDzOCqW4ebE3vzbfqqAZWhEIVyErl/6k9YrtmNBGrN73HhWwT5Ucr1JHyM+SaakVipOA+1B6mPcZhg2ktYbowKTElr+xJUbwhgjS9ImsGIRImDDGZH5ScJAWTYLj0fVBbiqkUJkkXVhBbjpDdlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791817404; c=relaxed/simple;
	bh=nELPaAPua+7IB/hVRm1psNXCa3I0bCk6bvAmBHNyxhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g7LBD5fIrhBL9CEsw5vak9gFtMa0N7ackfOXFsV0NSjXCqDodGhI8MVl7ibfeqegu6NxdWsoEOKGULUb2azEwGsOXDDD3e9k8Sf7cwt4CJ/KZO+WbcfeDqMa9eKBunWJAuuyGKnRWq5saZH6DhxMR0Tf/GE7srQcB+fkJD8f/Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZW6HFnSb; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZW6HFnSb"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a8adb68d8bso1308492a91.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 08:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791817402; x=1792422202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pO408NIMRZiYBttvqoEalFxO06TzS1++JIbffjzp+Ek=;
        b=ZW6HFnSbKJnHprmJRR/iYiQtR2zqPxd9rj7JotXfJO3Gv+igcV8qv5tR0xmRD2eBOi
         8FsMlGuWdMS5YuwkLmOoH5E8O7kYgqLmpwhF/L/JDSj6jFgzrpsKH6AaSWTCv8th+VJC
         iMyBSuYgc08NWVwMIfTecCREh9nNqdU0uRE1AIlmDgB/khVBIl7XFHve/pSoVr0KQOES
         s8+dWAqKfQXf6cU72VVbN0GvADIhYSCb12OtGkjrBFQui91DOU3fwEurkV45DVeZxheT
         5R2E6RT4RdeMJYdswVd8xJ+WB5Jj2AnX3TXltXUCysK+pn48y7xRC/hJULxhTsKiCqhR
         +8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791817402; x=1792422202;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pO408NIMRZiYBttvqoEalFxO06TzS1++JIbffjzp+Ek=;
        b=drOE2uKxhyXLfNOAQxcyUknMp2D6PiB6CHQxG8MgkcfKLjfsIp4/X5T9J1gfOl72jb
         Kzffx80oAElgrzuIPV1dAdkmaCkJXW+j6Gjd+RO1Iwzoei1M8w0FhAnb6sw83Fl6LJM1
         nEjR3UKoDuhmbA16qO0CvEjZWe4rae341BkVjhupYtX1uSI6Yjs+B3rAcTBU0lzRvQ8I
         MD+NqaVhrnAL/o52uSDYEa96pA++bBfkyUISv63xvZD4IL6gX9xBGgZdQyLoSmgKyOME
         qpaTR/BG0MtTVuYIvnOqXcbDac82g5vcrjcTnR6JLnWxKPYmI2jh3iUUSEmlStwd/Z9w
         o69g==
X-Gm-Message-State: AFq9FYIzgFOZ33W7DaE4Nm8MAYo/SuB9LyXPb5DeKjaE1/Yt/Mkg7Csh
	Pr6Y268z0kaD/hht0LUxhJJZ+GT8DFZNy4SUshWqQYGvTtBaxUO9DFhY
X-Gm-Gg: AYBFou1sVGnaqGzf7mxSqIkeM4U5wDXDhXhi9PQlj7Gaadxn8EmVwjTJDgcGMwHSIo9
	7f4PVHRlozUFhbTKAuMi/LkmSWsuGsdyigJK3zxtEzQJTLQm7zTAkvbnql2F70Kemrr7OCLA/tU
	eu1oUU6CjWkyTf6FPIrQySdP8HoEMnaxu51iEeuQuvRZP23f51C2ct607ycs4P7gNNNmnxeUtr8
	NvAGAx5hK/DsiM6XBpC4aWDLM/y9esYK97snUzbKEiKPtCQA8l7tA/2OtW/SuctJr2MXQ5SSYTZ
	j8UKx1FDzHEJawXKO2q/IhcRkXMdymNx3wpy3+tWc0heKDHzNL3NcPRvb2mvojfq/oNaf+19Jr/
	A5hpGOpv1gVBhjcIDYGwK9Kb81Oto2nGWVqFqdEQM++p5AQ6CSsx1V4wMLJVoHoaAIIdWU6+8ow
	VS4HRhisqD+2dFMiM05vV7Ra4d80gxdnim9Xhx7pBaeHojQmlDEUgct/of7kilALYFV35zzMMtp
	b2Ab5qpYGjZlPG1UBo6iCM4
X-Received: by 2002:a17:90b:3145:b0:392:ca3b:370a with SMTP id 98e67ed59e1d1-3ab3a33db2bmr8277610a91.2.1791817402228;
        Mon, 12 Oct 2026 08:03:22 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab393efd88sm10110088a91.3.2026.10.12.08.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 08:03:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5: Remove redundant memset after kvzalloc
Date: Tue, 13 Oct 2026 00:03:10 +0900
Message-ID: <20261012150311.555104-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvzalloc() returns zeroed memory, so the memset after the allocation in
mlx5e_post_meter_create_mtu_table() and macsec_fs_tx_create() is
redundant.

So remove the memset.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c    | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index d03376d7bb31..fcbd464c5539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -310,7 +310,6 @@ mlx5e_post_meter_create_mtu_table(struct mlx5e_priv *priv,
 	}
 
 	/* create miss group */
-	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
 	fg = mlx5_create_flow_group(table->ft, flow_group_in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
index efc5167493c1..12af812a1e19 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
@@ -476,7 +476,6 @@ static int macsec_fs_tx_create(struct mlx5_macsec_fs *macsec_fs)
 	tx_tables->ft_check = flow_table;
 
 	/* Tx check table Default miss group/rule */
-	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_table->max_fte - 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_table->max_fte - 1);
 	flow_group = mlx5_create_flow_group(tx_tables->ft_check, flow_group_in);

base-commit: d8674294aefef02266c4d47ad10131f1bffbe534
-- 
2.43.0

