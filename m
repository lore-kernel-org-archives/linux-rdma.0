Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339C43BCD17
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791296213; cv=none; b=A9lZzCBobN3XcROBMqbgGjKwygVEdOgg4UlbwfFttAVIojhvlsOO1Hwo2HVBIJBwr+6iSliM/0XQZHGNaoEhTPGkrBFsiaJc+wbx7zh1nyU4BbE7R2MHqHwtmCIaAMYTq5vfki4JNVPmfLMQ0dsHxLXjH6u1pghFEPmxLxMFLoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791296213; c=relaxed/simple;
	bh=02r4wGAOjM+0zaxUQkQ6LUoyUS4UyZaMWkhJRo0z8G4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Lnk9pojxScgj09Hyqz5VRYRt89CSP3a4LScF0PMqtf/rFTZ9WiDGMZEABqeU0pmEA6T2VUEQorxu7OD4T4rYYjTFnFwQdtcZ8dTIYSuSgfVbDOl0TlupSN8WEmR0Kf1FBqUD/LLJFSuM5fi3xVnQiztI71rQmGEv9qKz+3xdOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=U6dy56Q1; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="U6dy56Q1"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so468253a91.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 07:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1791296211; x=1791901011; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y7W/stljCR7Yo3LPNubWsyzPTC2BQ+EVRhVLuL/EFgc=;
        b=U6dy56Q1aBkmoRo7wfYzZ0NQnRj6ubXeTkf3XeFKhpT6R0y1K4nKAp3qRyxoiqIVrS
         uJecWmQUFigQuqogS5xFYQLSxuZjqr4Wh0FKQNkBTPXzEeXVcg5p9x7sqjcjd2uGilaJ
         LYU9D5lc8ACTO8mSWXVgpiR79bYImLLYBVvRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791296211; x=1791901011;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Y7W/stljCR7Yo3LPNubWsyzPTC2BQ+EVRhVLuL/EFgc=;
        b=n5nBkdIv2cf8cd8fH6iaiRRFiTg99pYHm/lzPC/N0PsN+JhRKEB8x5n6HSLaBaTiFO
         1UIlWsxgOr//7Qu7p7GkfSc/D9MYdJvxZ3a8ylmoVhcnx+JHyxRnBzcnSiQZR85SOtNB
         gMuIQnxNtVvSHi1/76GzotlzC2dWKu+MmMnc1fcC7y6SqKINknbyI/D9DRvklds5PpPL
         vSpewbLVN0aLOGA8Mu88DlcVwHB7EQ+jwRcSj5XpHVSdaV4Y5zHskhSVHDo6V47JQc4z
         IJ6wheaoFDp5b38mHWVKTU12wuwiNKYMQB2KdOVRS8K1QXssWkARsor8yvOZN4QK6tas
         uESg==
X-Forwarded-Encrypted: i=1; AKwUvBwHHwwi5QsfrDM7hbTRjZ1WzXRhywkYdItJG1fnk6ClnkQjHPA8IatTBR8klgtFlHfI8CfQbXJNfU03@vger.kernel.org
X-Gm-Message-State: AFq9FYKV+49uqoE8Rh9O3DblldAHjTbyKIkmUaz5CkX0J3C62I8ENQe8
	PlaeHQmtM4pE4o9sV5xXUBm9SK88vv5b33inseSaWtC8qHpdlY7Jn4s3Ef5vKFlyp9E=
X-Gm-Gg: AYBFou2w2k3ZXMC5Ok/ORRA4AZ7Ng6qSxgItXnjwmqihXTFuepm0LsM1Xa0fR5GdznQ
	WWO4anyaAjlbUVPzpNBEuAHBhVjXWeHKYOPAuGh7t88hFsCnipAcqN+SlCVOuGqIzk12OfV4PFy
	S4+W7/b3jv5oF3LfM78hguknedwgUn1hLZLtMUY1a2cwD2ZwgwJBX9SXBI7CDj7rr+6/8ZSDWvS
	d3sv/uRh2fWZv6tu2af8pd0kPsdFz1ZkLwTf9xT9TKX/rN/kTwrEux3nOaD6q8Zt9NADv9SmJVf
	S1eB0Po51vVvsTDNKJAzzWicN3Je3A3RM0W6F+NW1Yf3bodj41BSmxRMmThk+90oFvvImP8xxY/
	41a9zLObAidbFHAjina7N7plgGieQyG3JPDGDtJe4P4IDbCaUXPECYazzCuO4dkaeNmqTSxQQHR
	5WrAchdhWJAvrttHRgNOTGki+VAmuCWQHxzxlY7E63MaJG40tsSNgXZgu25mQRQ+FnvTHHjr8K6
	X0=
X-Received: by 2002:a17:90a:f94e:b0:3a4:c18c:b8a5 with SMTP id 98e67ed59e1d1-3a8737d4695mr910988a91.58.1791296210623;
        Tue, 06 Oct 2026 07:16:50 -0700 (PDT)
Received: from [172.19.0.2] ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853889388sm5969035a91.2.2026.10.06.07.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 07:16:50 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
Date: Tue, 06 Oct 2026 14:16:45 +0000
Subject: [PATCH net-next v2] net/mlx5: allocate DMA pool structs on the
 pool's NUMA node
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
X-B4-Tracking: v=1; b=H4sIAMwCxWoC/42NTQ6CMBCFr0Jm7ZC21D9W3sOwGHGQxtKSthAM4
 e5WTuDuvbyfb4XIwXCEulgh8Gyi8S4bdSig7cm9GM0ze1BCnaQQR3SccLBLFtNASNb6lhLj6L3
 FkXJfMStBQkt9Zsg3Y+DOLDviDr+14yVBk5PexOTDZ2fPcs//x8wSJQrZaXWprpV66Ft0U0lt+
 Q7QbNv2BT4d5Z/aAAAA
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.13.0

The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
node hint, so they land on the node of whichever CPU happens to create
or fill the pool, while the DMA pages they describe are allocated on
the pool's node.

The pool, page and bitmap are dereferenced on every block allocation
and free. Allocate them on the pool's NUMA node as well, so that all
of a pool's state lives on one node.

These allocations happen on the control path, so the performance gain
is expected to be small; the change is mainly for consistency.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
Changes in v2:
- fix typo and specify the structs are allocated on the control path
- add a prefix net-next to the subject
- Link to v1: https://lore.kernel.org/r/20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index a92cf545bdaf..dcd281c4691d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -110,7 +110,7 @@ static struct mlx5_dma_pool *mlx5_dma_pool_create(struct mlx5_core_dev *dev,
 {
 	struct mlx5_dma_pool *pool;
 
-	pool = kzalloc_obj(*pool);
+	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, node);
 	if (!pool)
 		return NULL;
 
@@ -127,19 +127,20 @@ mlx5_dma_pool_page_alloc(struct mlx5_dma_pool *pool)
 {
 	int blocks_per_page = BIT(PAGE_SHIFT - pool->block_shift);
 	struct mlx5_dma_pool_page *page;
+	int node = pool->node;
 
-	page = kzalloc_obj(*page);
+	page = kzalloc_node(sizeof(*page), GFP_KERNEL, node);
 	if (!page)
 		goto err_out;
 
 	page->pool = pool;
-	page->bitmap = bitmap_zalloc(blocks_per_page, GFP_KERNEL);
+	page->bitmap = bitmap_zalloc_node(blocks_per_page, GFP_KERNEL, node);
 	if (!page->bitmap)
 		goto err_free_page;
 
 	bitmap_fill(page->bitmap, blocks_per_page);
 	page->buf = mlx5_dma_zalloc_coherent_node(pool->dev, PAGE_SIZE,
-						  &page->dma, pool->node);
+						  &page->dma, node);
 	if (!page->buf)
 		goto err_free_bitmap;
 
@@ -278,7 +279,7 @@ mlx5_frag_buf_node_pools_create(struct mlx5_core_dev *dev, int node)
 {
 	struct mlx5_frag_buf_node_pools *node_pools;
 
-	node_pools = kzalloc_obj(*node_pools);
+	node_pools = kzalloc_node(sizeof(*node_pools), GFP_KERNEL, node);
 	if (!node_pools)
 		return NULL;
 

---
base-commit: 8b4e7209c842d8cb9516f1f5ef0a88aa2d8831a6
change-id: 20261005-net-mlx5-numa-allocate-pool-page-2ee20a04147e

Best regards,
-- 
Seongjun Hong

