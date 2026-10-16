Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60793AA1B0
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 04:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792126764; cv=none; b=oGU0SGjafRGLvluDnCigcpQoJWWmQlh5Q8+86nA4hMUiu73qeGYfyUkie+PgvttUkdmooQhjo61BF9xlvjThD0Jb05NFNEjFJy2aKCHQ719EtT2LROTTfA9dLCUrfu7JO+vS5jDuOoZS0N5OZvVHNzDi98TRpnlQTIzi0t6surQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792126764; c=relaxed/simple;
	bh=EDqH+UtMu9lLfpvEqam2Dre/TtwJRJkTG1q+T7HLHiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzPRtBKqRVH8cRIQATrXdX+Ig6xvn9ukdGoa2XopV1dxYeVAiVto5WMKqPKMqQTrpmIbXU1wD3kEBKR150KnARQbTrYjQzELzDqgWOivg3AMuT0Lj2E+qDlP2xUncX9YZ6VrlK+qOiFHKNcQ2v7DcuetdE1rrvjEmxZLRD51Gfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ITjleeO6; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITjleeO6"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91054f537ccso71483796d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792126762; x=1792731562; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YXMmAjVIKkIpvClePKCqZRvItWuOvpeYbF8NBgtQiLs=;
        b=ITjleeO6OJUB3L02RHa9imrSRZZ2I7Mz/mKxiDrEpcUDsWG50hExjpHwGN/NcxRbuH
         aDznMOQXxGe2XC2iKqm7mZKYh5NcPW0W0TWvPENhG7p5hJe34ufFbMbSP0Yo5gGQ5FMU
         eMmnpAaesoO8NhClZQjgOgxHkqpOaD1IaAXEYuGaAkIYvZfJGo3sBGMszrAFalk3vZ7R
         sxfXEc2BK8oJaDmpq2D0eUHjxa/bP/xfUONOIfoIUalsmzYCPAySXNJnhMlt1jUSqmpF
         qCfaQBppOAiZj6PbEVrx26HmBcD+keofu2ioR+p2jbbLcBKw7C7KVlpjGlirlpn1YSTe
         2LOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792126762; x=1792731562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YXMmAjVIKkIpvClePKCqZRvItWuOvpeYbF8NBgtQiLs=;
        b=xRIDu3hGsqeD2w7Lde1DvSDanEVwt1MIR8rn2MLGSQJLd00H2oiUd+cNIeWbw0ATaj
         Or4UWNDbRGyU6cbJcUsPqaI1HvxNmjkuqN/A24xtPS7rv4bv9ONKGbfk5b7v1SCy0w3+
         8NFGhYNTenXIOtHNqdhJoMV2aeyEVfR0qDoqORpZe+AyxaJoWqDjPYiZi6DRVzJQCVFu
         tK7dOjGIGvRIZejgV/G+1jkKPAt08GvXkvtomeBBkYVxwGrFOzgbHjSV9Vjz5Os0+SVs
         FGz1hIiAfcubnYYftaS6mOaEZdr1Hnn9cMQMILYMjZGhHgmHs2u3OGmzqe23i2mtvAMn
         SqUw==
X-Forwarded-Encrypted: i=1; AKwUvBxTVHO0mFNn7s8Euhy/KbpG0FZbnUqdSP0yvwc1ZSRuGqk+pdqQdb+AFV+dpK044a2q9JUDwsoDaaXY@vger.kernel.org
X-Gm-Message-State: AFq9FYLlyAyQ2VK1bcB9V1Uwj0ebnioAkXytDcrNGkv3nMjSEIMk3jqF
	i2+yPxIwGm3rzE42KFyL9Dy4Ftt+OE4kXFHtyzXnJvMtBvTp5Acd3+Rs
X-Gm-Gg: AYBFou2Cnmu8xFG/+mAI2vUQVqvzE0Y8bva3Hirf6MCGwfcWj48upJKTHluXpRwuIQP
	fnkaSPxCr05kdYQqiMI7UFKSbVj8QbK7NZJ5Unl6E3EoP2gxGu/2fkOPlaTGip8/C3eXjPBU2FR
	SZ5KHzJyLYH2x8eUZyFa9RWPbnFm6v4DKvfsKiRgcadTx/xOaNjKr/9lzoFg2CGbcYQ9lDxs7fR
	HEekWxFQs7jycbmHQZBTriHm/XESN1m0AwlnoyJ3Gb+32hU+5c21AXOHaBeAn78Xj2azCz8N/Jd
	n0zBylO62VdTj2bcbac/YBbDFhNND0fL4GNSpu2y6kmCXAgQZvaY1Cu9AJvUVTud+SsmhgkumJV
	634zVg+O1HCVRc9uTCvDevCJaHh+f58DjpBjczGCeGirk1Qu7G6pmzxDC/nmIAkMQrAwOBjPqS3
	2crS4NEsmeIyOqlZrRy/V+rtr7flJML4sRwtHXzI6POLZIum4B4szzurQTPbt8RmqLUF/q9yvgz
	2UrEhswdkFkkqV5vH8IIAO/5Wuu3IaR
X-Received: by 2002:a05:620a:198d:b0:93e:942f:b8ae with SMTP id af79cd13be357-93ebd1dfff5mr3416433185a.26.1792126761933;
        Thu, 15 Oct 2026 21:59:21 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a198372sm118038685a.27.2026.10.15.21.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:59:21 -0700 (PDT)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <oss.patchbox@gmail.com>
Subject: [PATCH net-next v1 3/4] net/mlx5: DR, Don't free the send ring CQ if destroying it fails
Date: Fri, 16 Oct 2026 00:57:48 -0400
Message-ID: <20261016045849.813696-9-oss.patchbox@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016045849.813696-6-oss.patchbox@gmail.com>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dr_destroy_cq() ignores the result of mlx5_core_destroy_cq() and frees
the CQ buffer, doorbell record and struct mlx5dr_cq anyway. If
DESTROY_CQ fails, the CQ may still exist in firmware and retain access
to its buffer and doorbell record. mlx5_core_destroy_cq() also returns
early in that case, without waiting for EQ handlers that may already
hold a reference to the CQ.

Keep the CQ and its buffer when DESTROY_CQ fails, as the regular mlx5_ib
CQ destroy path does. A device in internal error is not affected, since
the mlx5 core reports success for DESTROY_CQ in that state.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Assisted-by: LLM
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
---
This was found with a static analysis tool from ongoing, not yet
published research, and confirmed by code inspection. It has not been
reproduced on hardware.

 .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
index 79e3c29d1044e..8fc41adb4c756 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_send.c
@@ -1130,7 +1130,9 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 
 static void dr_destroy_cq(struct mlx5_core_dev *mdev, struct mlx5dr_cq *cq)
 {
-	mlx5_core_destroy_cq(mdev, &cq->mcq);
+	/* The device may still use an undestroyed CQ; keep it. */
+	if (mlx5_core_destroy_cq(mdev, &cq->mcq))
+		return;
 	mlx5_wq_destroy(&cq->wq_ctrl);
 	kfree(cq);
 }
-- 
2.43.0
