Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220096;
	b=gxi7/00uuCLszdoy1tY1Q+mzGt9dQwx0uTATmUEyMhnKkPimvoWbxEnxfNl0h8gbqX1h
	 MVMykf/fVrptrTdopPQKh9csfjv9ehI/4bWIkmJ8PtlHYO/F1oNFwi90Jb9ydzxRvRb0z
	 gkeWxUNW5Lw4Cd/v2zRPgOeC+ksxCNEDoy2f7O7P6d1VY1+7hlhk42hrBXVdY2cyUDZqI
	 Qbadu8vl0AmD6v/EOk9sMo8Q3MMswGSStxJxhNyo6mbxkYK+mad3hmekattjxAvznCYHx
	 0OKDFfnrWTJAvdBeT0P6dDnQ1sTLASpVmSfu1CzNzLFYvm8WGS1Y4nXnKzLb4vQxm/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220096;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FHpCwmILGqqPyV1XeD0mfH97293hDloRW/sMB3Yx/KE=;
	b=K7M11CI/BbgRe2VbB1AuCzZhoyvtqe9RaZUiZkwfuGcC6VA8aSKwP66+fltUO7Bi381t
	 ATn2uvwSOWsWuYyXbjZBroR5q/6LfvEBBRtXjTKGq1pfjjYGGRmjMy9POj3Kc/qpNXqcm
	 C+uzIrHlK9PigeyGLDz0xNe25NicKATRoaYFfAEsJaGytNle3GWy14fE1dLT3+kwIn3AK
	 a6xPbXDa6tmMWS4CfkuWFVjn2lIb5bEnhi4NHYbT1TMVw5Y2IHjgmBJb8kCSL3pD36cS5
	 ByvzMEY6NgOtTNQhUEXZYJ7nxM0tfIHc8UhKY0KvfpxLjAj9XXIENxKMn7H4fMTPINQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wfJ3NaQY;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988E8606A68B
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 00:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 988E8606A68B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wfJ3NaQY
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49412eb1474so898072f8f.3
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795220088; x=1795824888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHpCwmILGqqPyV1XeD0mfH97293hDloRW/sMB3Yx/KE=;
        b=wfJ3NaQY6oy86fNQ3jqgi+Rx7AV8rcTxM/aw9mB69BxdU5TIXZI0qOvVwQ982BD78x
         U5RTlLCJB3Y9by3OaVxhaXxS5DB+Vo6GukLDUr3qnB25iwoTw/ciE8iugPPxvjzSDvlV
         Hd9cBK30dXzkSpG8HD/OV14Oqg+Ra5pwSTEY1ZcAX/s4exktQ5dY5uYUn9UgHnflglh5
         2i2Ud6nSTlCeFuC8EjU4mqzgoqH+kwe1AwyXtQsHGT+UxyNd1+Qgt3trw8Yuwb99m059
         UWHaH5nGUoAIpNOcB2d2/yZwgMFeNuV2mMdJecUJs/ySbwEGNu0j2rKu2c395IoTSRRw
         hI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795220088; x=1795824888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHpCwmILGqqPyV1XeD0mfH97293hDloRW/sMB3Yx/KE=;
        b=nbMuGMvFv8vwxJKdUVOpApnVWnK3fdL/OZGSulQP9ycEupuUUNOBet6Grw0MMwdD+o
         vUwaygePWSu9inHhdaOAr/bxgJHHS2I7BapgKloAGIl1JXsyjcJxq6R6gMjTkXEp4dQa
         YpeBmLdn3l06skNBqy9ihs+uR8yeMxBDJKJL7t8je+ixkE56o456kVbZK8a2O5RQ0MOt
         0tRiMkwlXR8SvIVilMSyFEbo3jchZIVkfLKGnvS9p1DzfSHLH7XTnnhJF0RwwZB+qENF
         tbtMi/Yp43GQ9//iuT+ZJ58L58jZpLdEqBWIokpjZqeVt5kpJJ7SpM2JJgyjQ3fElWAQ
         BODw==
X-Forwarded-Encrypted: i=1; AL+hErEXta6BeuolTu2vjHM8a7BTHHj1p9fuT4bA7107CsaXr1pTzzqJUkzuNvdJ6iOMh1d4wn9bbQlnwoav@vger.kernel.org
X-Gm-Message-State: APuU4Z/Q+blqiZsTPSOtPvaDCTlJHseoKdkqziblE6xEdtlhqVs+C+2V
	6SjNymb0JXr+NpkdsOUyx52puJ0KsmvOIIH4tjlxzRzyFeGCbA0dAmswhWQsF6Fv
X-Gm-Gg: AZFdTZe339Tg/EKm9vXvpBUUeYhZkW2fkUZSs9xS5/5LDJa34bbw+AxnmrcLZiYZWja
	Ku/4xnRnpIMIAjWbKXk6iuyu0U1iwdydyHwumDweqzQ3AArTqpo688V+Da56skoQy+tjXZlV8QV
	LnNO7ZuVYf7D33vQAqRVMCeqtXTOgmMQROaNyCOThIRH51C7FFhexQ8jdvLdg7Uy2jVq5/9Fv+W
	1MgxqN/heOwL7Fx6VTx/YcMxcWciHPMkQgs4ORFcmxW7XTEaYZTMGxGEiKy751bQgBpXTHlF47C
	zj21J/CUQ70yMRS5TiaUlLZzGNjRNKNbQH3qJ4Y5TSA28YPg84fQCX9ppfsM0Etj/vEy993SK5Q
	Li9sQ83ub39k3UaSJH6v4wwbCVGZVcBAy5E0SJm0d2cKOznaoYl5bBaL6aGccBtmdQv37njDoC3
	d894G7OdWFRT3vzMHiE7pnLiqExrGAuDzgnhqA9rjmRyMaJojhUyqBjoNAO4jDIvDW1umzxVpTf
	p69Jo0JB3Y3NgOREkVul+rBme09sKQ6rUg1Nrt2aLm2W+cdEOEbokVKCUY5CIei32el98vQwAVt
	cNuhuIfLImD3QUTjah9HysLUETuMre7FDqtB5oxNBTv7ZALO6sMPKGzCBbl40WB7TnCuA6R9Rx9
	15HLsnGHjlSYLM4t0UN2r8grHObC8leHI9KPR6kWtObT7ZZ15j09XmBdcYRw=
X-Received: by 2002:a05:6000:4812:b0:4a7:b8ab:df86 with SMTP id ffacd0b85a97d-4abb5db73bcmr8979385f8f.38.1795220087822;
        Fri, 20 Nov 2026 16:14:47 -0800 (PST)
Received: from qblck ([188.130.155.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4abbd84e661sm7138696f8f.18.2026.11.20.16.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 16:14:47 -0800 (PST)
From: Artemii Mashanov <ralerrdirsardx@gmail.com>
To: netdev@vger.kernel.org
Cc: Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net] net: mlx4_en: report the actual RX classification rule count
Date: Sat, 21 Nov 2026 03:14:14 +0300
Message-ID: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
X-Mailer: git-send-email 2.56.0
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

mlx4_en_get_rxnfc() treats the input rule_cnt as the number of
rules it needs to find for ETHTOOL_GRXCLSRLALL.

With room for four locations and only one rule installed, the
ioctl succeeds with rule_cnt still set to four and three extra
zero entries. When the buffer has too few slots, the ioctl
succeeds with an incomplete list.

Bound the scan by the rule table size, skip empty slots and
propagate unexpected lookup errors. Return -EMSGSIZE when the next
rule cannot fit and set rule_cnt to the number of copied locations
on success.

The source-extracted ASan/UBSan regression tests passed.

Fixes: 820672812f82 ("net/mlx4_en: Manage flow steering rules with ethtool")
Signed-off-by: Artemii Mashanov <ralerrdirsardx@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 4ba1947..463c1a4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1739,8 +1739,9 @@ static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
+	u32 count = 0;
 	int err = 0;
-	int i = 0, priority = 0;
+	int i;
 
 	if ((cmd->cmd == ETHTOOL_GRXCLSRLCNT ||
 	     cmd->cmd == ETHTOOL_GRXCLSRULE ||
@@ -1758,12 +1759,17 @@ static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		break;
 	case ETHTOOL_GRXCLSRLALL:
 		cmd->data = MAX_NUM_OF_FS_RULES;
-		while ((!err || err == -ENOENT) && priority < cmd->rule_cnt) {
+		for (i = 0; i < MAX_NUM_OF_FS_RULES; i++) {
 			err = mlx4_en_get_flow(dev, cmd, i);
-			if (!err)
-				rule_locs[priority++] = i;
-			i++;
+			if (err == -ENOENT)
+				continue;
+			if (err)
+				return err;
+			if (count == cmd->rule_cnt)
+				return -EMSGSIZE;
+			rule_locs[count++] = i;
 		}
+		cmd->rule_cnt = count;
 		err = 0;
 		break;
 	default:
-- 
2.56.0

