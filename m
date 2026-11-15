Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739433;
	b=jY/JGSTf/D/B/req6SAdkGnl4K7FgNbGM0pIhh9hVBz1P6rYlM/y3ZUEELDRQ/MEOQVZ
	 bZVtuWaTUx284XBrvUyjGsxgGx65moiHROYrJKH39K7Rq+3W7oASN8HwaOLLvvlYCKQPn
	 iH+nRGETrUPgSolsioKC1jQj17Rp9pnf0ZeASjVIwb2hM5LckuQaXNO6wrftcfjqcZSKp
	 1ZfkBc/uvkVKdU5XXzzC8sVIOC3f+gYyYYc3ymriuvyp+er9zPOF8nIqYUiknm2TAgtlt
	 UQJ8JMBwd6P6nZeflUIUgy9+j67plGheAOX1hLZu34tu8wYK8XWL0rVul2l+HvnyPuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gR98zScnjm/gYsm/UQkLfN437d1nEwodIPcR62cdEAY=;
	b=v9xKcE4iWljo8ib8NwP+2yuvKgmdCI8mkSfw9AS3BGVaZ2hekDCQr14306LLAogvAQB9
	 +OD0AWY8pOfWBju2YVgIjSjytlD66zBbIt7cfeXj2CZ1PnC6JWNRRsIjpGz0ua8KbDvP0
	 BuQbHG58FeP7KtZthSYYCOHQQl5kr2iyHOZ1S0uJ3oPCCA/bHpD2Zfi58rKiLvwc+DIcM
	 fh2IG+095HBQy6of37aNRYi41TDK2/NiY16uoeTSVFWuwjSkn34hXn0tCMeV8v2ICvnO1
	 l6kal0DUDxmQKE2ODSloJ5elC4t6A5wOeIAZc/mfbfX0VTZTswrQdRp5hR/XeDDIXnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NdFqRhdu;
	arc=none smtp.remote-ip=74.125.229.4
Received: from mail-dy2-f4.google.com (mail-dy2-f4.google.com [74.125.229.4])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070F606A31F
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 10:43:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A070F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NdFqRhdu
Received: by mail-dy2-f4.google.com with SMTP id 5a478bee46e88-36e06480786so807151eec.1
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 02:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739432; x=1795344232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gR98zScnjm/gYsm/UQkLfN437d1nEwodIPcR62cdEAY=;
        b=NdFqRhduX6BNlveJdrkI0f+skJdQO3Mz4A/PGgmAI8KhFYI3nwjNGAbKhAjnkVlI10
         qQLpjIbrRLeM3/QUr2XaLU2q+w4mQFAuv5XghsgdnbxDm2DslEv3bWpH0A1UlO/kYsV5
         C67A6BXAPVkLd842HlisOcslrvlHgtwQcIadrW4RTgGrj6/096PT+Duwd8Z86ecU5IbP
         2Mdly9ye2KtyRiKV7UMw7vcbhymtI89GaK+KCWyMwHG0DbVlJ6uGW6NMBtzh7UFiPM99
         L1VlFEi9PiyAY/qXgcN7NTpRDvraJE6GFkETmov2MutAA5dy+AgQZ9vAOyAqzcHjfqtq
         7PVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739432; x=1795344232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gR98zScnjm/gYsm/UQkLfN437d1nEwodIPcR62cdEAY=;
        b=KaGpqduiGlAwrGhnx+sANcDk8cg9mMMJqWJzPA81HY3a9YMNmSWt/YVBreFmXOzBsx
         D2/gayJSMNe9Sw6jz2wFaQmB0lNTf8Fk19ksvgnpJ9Lnv5/+BCSBhH6EG8J7V1/9aqrY
         Fce846qLVOLsiOZm6qCGUxICN3r9rRQBJhtminpvr7ARZtybGAeWK8PawEYPSA+Ayxf/
         Fuqqese2sTst1eIN8so2LfwAH9eaAUxMjhz8gL1MabOBaPTdsYaWDfPVLg+Pk7SZ2sWF
         n0LyrEbJcoNbwJ2leEJ8XKx4UK8oYRoQG69pzIQk+TwOKVjYRTJWY8lhmSzJGLX2l/xM
         XNkA==
X-Forwarded-Encrypted: i=1; AL+hErFYkGnRfbW68GL3zVD71SaK0/AU0Le18+Aa2T2S2qyejRfa3dzR6i6txkS7T2HM77Cbyix+BWGaEVBY@vger.kernel.org
X-Gm-Message-State: APuU4Z9hMUAVCJrYJTlICeq8fHp30IPX5g2BKzrcUKvu8BM9EhdURrXP
	LQOTA4h/zmsNwiQVlLPgS14dQemxXpybJKwfSHgmQa+DYOXDi/mmP4Rp
X-Gm-Gg: AYBFou0V9fL1OilS2Q8PiikZ11xYIQ3LeVIjBriB3lp1pTmxGoeYWuEqmCpdJB4xdLO
	xwRLbu/Vz9oO9YDvd+kROdM/BKA1VHiAIxFOwegd7+hjvC14tO8ZJ9yKudRNSu7cmnESLlmMIXk
	VpO//OqiqpPCSTLk3NynPFJ/cHuayZQKucS1xIBsmwFwaVovo4fTcwECEQos9WeHNYRRcISd60L
	gbR4Do0p8aby1sl92LQFpfvxhmlElCAVyF6Lb4IzwLPPGQXVCzlX5xJEjyWzIyAp+v67ayxTLj2
	Lo+vZm6HnRg+Q08SgZ0poERoVaFJ1bultJjHcniMVE9eyRmzZ44CTMMHwlXIi+IVyMPwqXUItO2
	eut2Mj1Nv2qDPb1kR0ZzpdxccCOksqT/PRbS9dfdJjGsMgYe90UWedS8UhV79CCtWGJS6TiLvIA
	s4lblGWINz83cv6tmiMPARG8M4f6ncLlmeJJbkHNA3ZWb0E2u2jedmn5SFYP/98kqS7JBp4eDmx
	5LsElKUYP2W8XhzhCggsPeYZDqRsOlbIOIiwnLH3dK8Xl6LcVykvzzYXcQHO3Ru9FFTEyWkZkze
	gD3Av3rysJ4ni4Cndp14PJK7By2pNH+W/2ZHremushDNMV6UOuR3vwApGLOkp5dqhZjnEB7ihMv
	dy+xzdATB09OIy3c+cV9D5oJ9nNHfbTEzW/TfcA==
X-Received: by 2002:a05:7022:92a:b0:192:74cf:1db2 with SMTP id a92af1059eb24-1b5030e9a6emr10510136c88.11.1794739431638;
        Sun, 15 Nov 2026 02:43:51 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50313d8f5sm32935341c88.3.2026.11.15.02.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:43:51 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	maorg@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] RDMA/mlx5: Check the DM type before mapping a MEMIC operation
Date: Sun, 15 Nov 2026 10:43:42 +0000
Message-ID: <20261115104342.56112-1-dennylin0707@gmail.com>
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

MLX5_IB_METHOD_DM_MAP_OP_ADDR accepts a handle to any DM object and
converts it with to_memic() without checking the DM type. The handle can
refer to a SW ICM object, which is a struct mlx5_ib_dm_icm and is
smaller than struct mlx5_ib_dm_memic.

The handler then uses the ops_xa_lock, ops and ref members, which are
all located past the end of the mlx5_ib_dm_icm allocation, so it locks
and modifies memory that belongs to other slab objects.

Return -EOPNOTSUPP for DM objects that are not MEMIC, as
MLX5_IB_METHOD_DM_QUERY already does.

Fixes: cea85fa5dbc2 ("RDMA/mlx5: Add support in MEMIC operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 drivers/infiniband/hw/mlx5/dm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 7a6fe4fea3e2..16e42fd6c802 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -213,6 +213,9 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
 	int err;
 	u8 op;
 
+	if (dm->base.type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
+		return -EOPNOTSUPP;
+
 	err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);
 	if (err)
 		return err;
-- 
2.43.0
