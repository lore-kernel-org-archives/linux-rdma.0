Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0128B4FD
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 04:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792126760; cv=none; b=ClWMCx8YweH0c/vsEAoN85KdhH9ZtMiglOeyU7Wz9BEwPyJF9wAN0L1y9zPBMOGV9hhQ87aX5Cz6371jsZ6pU1GyrkzWw8HG/l1mPImylkPjoxzZ28F1acMKEy/Pwyp5RMaidM707m6bU7rGzRCgStyB8Co/dmykrjaPA086Otw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792126760; c=relaxed/simple;
	bh=M0d8jWOOzpsm8nvZV8h6SoAt6zX9ew6TrIRGfOMLwrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF9u2TmoAV1pCsqDdmGa3VtBMMDxiBwKyzmp5K8oFqStifStqT1BnI7i6igr1D8CfxU/rCEukUxspSWb/QoVPqyNbiq9cGEuWrWks/NtU8uuPf/PqHEeQ05NAaWpo7ZwWkNTymJe3eU8zn94HmeH3ShmjCHDdQjZ/iPp+pcYasU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dxjTNZgb; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxjTNZgb"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e55db58cfso218555485a.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792126757; x=1792731557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d1uiI9jtoPkEz2QcGrRrInkZN0NyUvlcm50FaYO6et8=;
        b=dxjTNZgbhqGnJHSx5ysS5/nuU1r38C2GYIjoSBFZ7U5Nj49R65xsUGBSIvd1YtwN6J
         yw9sX5Ju3Oc4P5YXFgYSmFXO3sXZU6rnFWvLEj1KHxjUWYcwRPjqSIyWNEqBDnrKbJZg
         rFpmhSI3YbEH2K07Oo1CbplBxJYNNlfjQkvxNrMFe2QocFlGkFYP/ZZZg1987uY5+9NS
         l3XhJ9UBP8bTWDUr9KnEIiQ1LMTJt3wqv7EXytNAhCBllBTNmSme5LuNiO2OHAsYZN+W
         l2Av854qrbEOM6ZRjJs2A7cBj6OBp2ZdNfzX8fu9vERg+kkHo4K93jpyj2v16zRSfKY0
         m++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792126757; x=1792731557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d1uiI9jtoPkEz2QcGrRrInkZN0NyUvlcm50FaYO6et8=;
        b=2qDIctfwLd0nNHuiNXGAjaoOR/viszySsOMQMOQerxsBcrr8KGqzbyoHH1aHBEVuCj
         f6Z4JWXoEgf4nsXzLdNfPZtu0yzGhlut7JcQ8GO3iQjW2eiAeKFJXFknCj0h1m83GaCM
         AmtXZWZzgZX9guMbuBQXFTwLGgS1hUZPwxUrvXidhOS4VcERQhVtYfycjmvGt0Tsuwjl
         H135ptCc6N0tKXwj1NX3V4gmPHT2W5Tpt5dQXqOSrepkl3BoAxWfLsJ4zB2sxhPGGR86
         Cy1SldbqYGvLPxLyhOyFH7Bayh2qH3bOyvr7lzFlNJPxrYwe/RmFQYHI2BxlImadTWoT
         zPiA==
X-Forwarded-Encrypted: i=1; AKwUvBy7uY1P0yWPu5JmtceZbx2ZAtjr+0C7kahgBJwQZGIukUYpfZV41xXIKXaOYUbM91c27+h9sIdwKdDb@vger.kernel.org
X-Gm-Message-State: AFq9FYKdhuHdDVU+VBSjp3WBmtTwPsv7m1JKwcNVMxebb9LtIXzYcE6v
	Jp91LrTJLMYtgPC2F2l3Lj99lGooIIPCzsiJ5ff17mXn/nJk9/Soq4BE
X-Gm-Gg: AYBFou2viE6FXkyTqpUwrYg7DA/gQnYD5XcnYp7U73Tvb8zS9hfn2U5zLXGeYX7W/y3
	rXsZvuHIErfu7QvTunTlVrRqBq6lzZ7jIRXj4filHRWOZClCjWZbm3tIWpCdajhzqr7hbJRGFIx
	yLIkuv+Tz1qcp6HXtNd269eY9E3FZetVj+0uirLF/l1ktvLs+N0Gb3tZ7nOZUxYY7Io9A8oRR5Q
	dU1KH5oUXWk/10XsUNRZ9eoKIR0wTyqwLKvPeDBMNEB9rn1BdCzPoQRoWhIv4i2Iu/apquHAA73
	bfYioOuFZtuRMS40FDRCJFOQrBTvUW732C+UKJPldQN0Ik6uLOAUvFpnOZVk6bZL/d7vnro1/qZ
	wHytEn5aGnNDiS7VILTEKWV7iusWVIqoXPLOIhh5xS8GG8ncqM+W2vyCOan3+TkmM/F0kvi41kW
	RsGvFERisoymipbNF8vJk3PrUMJjVQR4FJIQ7bSjakebz/DKGIbJpYKVZXRlP06bjT+NR0cnm9k
	9Ayl3+OMkOO+FSf5eGWTw==
X-Received: by 2002:a05:620a:45a1:b0:93e:96e0:25b8 with SMTP id af79cd13be357-93ebd208ef6mr3435592585a.42.1792126757290;
        Thu, 15 Oct 2026 21:59:17 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a198372sm118038685a.27.2026.10.15.21.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:59:16 -0700 (PDT)
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
Subject: [PATCH net-next v1 1/4] net/mlx5: Don't free the ASO CQ if destroying it fails
Date: Fri, 16 Oct 2026 00:57:46 -0400
Message-ID: <20261016045849.813696-7-oss.patchbox@gmail.com>
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

mlx5_aso_destroy_cq() ignores the result of mlx5_core_destroy_cq() and
frees the CQ buffer and doorbell record anyway, and its callers then
free the struct mlx5_aso that embeds the CQ. If DESTROY_CQ fails, the
CQ may still exist in firmware and retain access to its buffer and
doorbell record. mlx5_core_destroy_cq() also returns early in that case,
without waiting for EQ handlers that may already hold a reference to
the CQ.

Return the error from mlx5_aso_destroy_cq() and keep both the buffer
and the struct mlx5_aso when it fails, as the regular mlx5_ib CQ destroy
path does. A device in internal error is not affected, since the mlx5
core reports success for DESTROY_CQ in that state.

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Assisted-by: LLM
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
---
This was found with a static analysis tool from ongoing, not yet
published research, and confirmed by code inspection. It has not been
reproduced on hardware.

 .../net/ethernet/mellanox/mlx5/core/lib/aso.c  | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 614cd57a40d74..6a9d31d539e9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -112,10 +112,14 @@ static int create_aso_cq(struct mlx5_aso_cq *cq, void *cqc_data)
 	return err;
 }
 
-static void mlx5_aso_destroy_cq(struct mlx5_aso_cq *cq)
+static int mlx5_aso_destroy_cq(struct mlx5_aso_cq *cq)
 {
-	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
-	mlx5_wq_destroy(&cq->wq_ctrl);
+	int err = mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
+
+	/* The device may still access an undestroyed CQ's buffer; keep it. */
+	if (!err)
+		mlx5_wq_destroy(&cq->wq_ctrl);
+	return err;
 }
 
 static int mlx5_aso_create_cq(struct mlx5_core_dev *mdev, int numa_node,
@@ -326,7 +330,9 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
 	return aso;
 
 err_sq:
-	mlx5_aso_destroy_cq(&aso->cq);
+	/* An undestroyed CQ may still be in use; keep the ASO that holds it. */
+	if (mlx5_aso_destroy_cq(&aso->cq))
+		return ERR_PTR(err);
 err_cq:
 	kfree(aso);
 	return ERR_PTR(err);
@@ -335,7 +341,9 @@ struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
 void mlx5_aso_destroy(struct mlx5_aso *aso)
 {
 	mlx5_aso_destroy_sq(aso);
-	mlx5_aso_destroy_cq(&aso->cq);
+	/* An undestroyed CQ may still be in use; keep the ASO that holds it. */
+	if (mlx5_aso_destroy_cq(&aso->cq))
+		return;
 	kfree(aso);
 }
 
-- 
2.43.0
