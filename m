Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC84854E6
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 13:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791207991; cv=none; b=WCXFZNCghFCzejjORLMcUd+YC3ZQMFXue2lxAyp8FkrLGZP/zropdZRc23X78k1Xz1vY6AJoxB+KbGuxWu9KKS5aJKAhLi4o2yG4QtzD1WrjwTcnYb6oJwt72mMjL2rBk1DKxFWgHXOqLo075hz6TAWlqkjwo7cJHFJzz9qsVD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791207991; c=relaxed/simple;
	bh=jK1xZfZ/ZAjbb1vwQsBgpSKswaKF6V+VUqJKzKbogOY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=S/mqmBzX+WytZ5Hsz1OpP3M9R2s2sZ2BvEbazVapv9kurAGrEzTcqxWuRLuwk4bTf5+YVW8Im0g/0pakgPSU4bEyZtIIgbrSSos66OiC/M4nNyGoOfHhO2gihjKyFM8IamJzSxiRGbdE1zCmDqKy/zAzA92x4YTKW8FrLfnAnbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=DDp+xs0R; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="DDp+xs0R"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a7d283e017so821571a91.3
        for <linux-rdma@vger.kernel.org>; Mon, 05 Oct 2026 06:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1791207986; x=1791812786; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cV4nIo3kAjiqJAr11D0A33XgzPLg22VQeLn4sDhwBQU=;
        b=DDp+xs0Rgq5lUOngPgfgVOd5bxf5QTjAmX5ouVAch38Tzfu8BHbBAIUTn6A6Dy2mZv
         9/0zPDDQvgJERK9EG7CcP+n06syhXrdMDXjhhIaIAAyjdLa5t0Qx7Nf3O1xJSaawpyD2
         C4GX8qzaqWnabQyWLcIPXkYGte4NbIB1NTC4E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791207986; x=1791812786;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=cV4nIo3kAjiqJAr11D0A33XgzPLg22VQeLn4sDhwBQU=;
        b=CDeQXX2ignHGu4e4hiz2/S2QZfaiJV4CtX5vopWg0XHxvh1JXz9eDxjFWv0oJUqdGc
         j5E/uo/kSmRwKrAtIwxYbAOzUrnDI4J+AnFilY9Dll2kqJmrPFBkEG+bMxH9KxaNv3xk
         b9XLjoVw5DuK6KkMpjjBlm/rbc3Vj91VAwgKmOX29zds06LJUNvKvXAApWTr6TohcFBS
         uyjvBd1ne3bHbGBP9Dp8ZxkaV3r0Q+knRd7WarBd61GTLwQjS/FhsYzw20KGCAprVCPM
         krQSq0rfNKGWoXYeL9XxRtecHWfBlO/4hvzlrNcXIaSH7WKq7a9YxifJyfpd4y1FwRi9
         gbQA==
X-Forwarded-Encrypted: i=1; AKwUvByJv/hQYHFxeYmTrnEUlqghvVvmXn281AjE1p/dK3Kxg20tcNhG4PXGL8y6ob3IrwPHif/ipcfyRtxJ@vger.kernel.org
X-Gm-Message-State: AFq9FYJPvm8eWBTsY9aZGuJDWSjETJew+H5JJSrbgVuXWP1Y1d2JViAJ
	Jc1AyufzfAufLCwLXetzcpLKwSoNIJrWXx9DCYPHjy8wQ7PKiNpxGJqggpwxjhNktt8=
X-Gm-Gg: AYBFou24EAjhgizkgPenFbPaxZFl+i6oz2e9sVNc4fe8x6ncIYVAWWmljHgAk5CIoOS
	8grpyRORIYM3FpNTOqYVcbdm6Rk/NWIG5gt0a07OR1CF8qRKoNkoZst+LNCAMPZNjfFs/caL/dg
	gYmVQivEb+0AxdT+sjBa5GHML7Si7Qfm3D9/EKANoMNTI4iNUQTkBPP9zMQTWxcKHKR7tve0Vm3
	pV32dRvP/AA08/m0f/YJF3iMQZCik0SQxzMkiDmgCBxiQFIMQrEyLRH58m/90lN7WjZ9AuHQlce
	dDPXZQi5iI/aLSAHjI/Wb231M1mKM3w4bfvLSD3d8pGxAMyB2H1+zK2j9R04M+xWzdA2C2DuNx/
	mXLDuaBFRjiNIWH6hhJ7ttLgA5YnkNAhNFSc3+DVwgxBIBShVT7oMpEkWelGKDh7UPO7xG9ZSmk
	3c+qeK/XgbJpvmiPqwnb9UK7ZLFF/gwgIvDZWwGLNQIyAxZul/EypXEbOkRrpkzSl/
X-Received: by 2002:a17:90b:3ec1:b0:3a0:4668:4cb0 with SMTP id 98e67ed59e1d1-3a787510226mr5872122a91.47.1791207986052;
        Mon, 05 Oct 2026 06:46:26 -0700 (PDT)
Received: from [172.19.0.2] ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d65d85csm11168162a91.4.2026.10.05.06.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 06:46:25 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
Date: Mon, 05 Oct 2026 13:46:15 +0000
Subject: [PATCH] net/mlx5: allocate dma pool structs on the pool's NUMA
 node
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr>
X-B4-Tracking: v=1; b=H4sIACaqw2oC/x2N0QrCMBAEf6XcsweXUBX8FfHhqKsepElIaimU/
 ruHbzMw7O7U0QydbsNODat1K9klnAaaPprfYHu6U5R4CSJnzlh4TpvDd1bWlMqkC7iWkriq9xG
 IojKG8Qrymdrwsu1/cX8cxw/U01I1cgAAAA==
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
or fill the pool, whiile the DMA pages they describe are allocated on
the pool's node.

The pool, page and bitmap are dereferenced on every block allocation
and free. Allocate them on the pool's NUMA node as well, so that all
of a pool's state lives on one node.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
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

