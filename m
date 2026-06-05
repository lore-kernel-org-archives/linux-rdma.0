Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A643B4EA5
	for <linux-rdma@vger.kernel.org>; Fri,  5 Jun 2026 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780654711; cv=none; b=IgRPK8AsEEJFg+tKb7cI40gXkd4W3GWoF7D7P/gO+l+fs85WlNunV4t8OPE7jGRBM3Ho6QyEGa//ySAD1hh6nk2fk7cshkkBVN/Pbl+20M5kXijGmMKoGLo54TdC7+PWshCEdDq6X6LAelLVJ8cIJDthkytHT2btzb7904lJEpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780654711; c=relaxed/simple;
	bh=jjdWfOnThU2wytboyunR4pJP7lOU5zWdOMU2w/3M1jA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=imRUyK+2Qs6ipvhCrSvdAdrBQKTjXiHMNSWX67l06ZRLeJMN6gK3gQ+mBzxSgwTXu+xUdWj6y6l3F/7Inh1yNQWW93O//82CmiP1SnbhaEGGUVqUX35WY9VmVHjpltiQDV0D5/Q7jopA026MaUhI/GicoWNuW5/JnaAkh3qyN+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xNOCudal; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xNOCudal"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780654707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5G0mmIRv2/fBe3+vKgORqaUvFxz1BT8vIoZuho07iY4=;
	b=xNOCudalN5icmD0ZB1v3QbUiNyZOnW+Iv6JJ8Ol7wROYmua9xqUG67FJbz2GPNhOCINSJZ
	H3wsa6bENAmQoIlhxAGqg50YNMJmINTiJuNegTPDhRsI1lz7xmfhrSl39D5R4yHUGgAsuF
	tT4u19wj2Qhwbwe0khw8sNktQ35Jl0I=
From: Fushuai Wang <fushuai.wang@linux.dev>
To: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: shayd@nvidia.com,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangfushuai@baidu.com
Subject: [PATCH net-next v3] net/mlx5: Simplify cpumask operations in comp_irq_request_sf()
Date: Fri,  5 Jun 2026 18:17:56 +0800
Message-Id: <20260605101756.91275-1-fushuai.wang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Fushuai Wang <wangfushuai@baidu.com>

Combine cpumask_copy() and cpumask_andnot() into a single
cpumask_andnot() since the function can take cpu_online_mask
directly as the source.

Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
---
v2->v3: Separate the patchset to two patches, no changes on this patch
v1->v2: No changes on this patch

previous discussion:
https://lore.kernel.org/all/20260603072657.10868-1-fushuai.wang@linux.dev/T/#u
https://lore.kernel.org/all/20260604125705.21241-1-fushuai.wang@linux.dev/T/#u

 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 22a637111aa2..d11ec263d53c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -886,8 +886,7 @@ static int comp_irq_request_sf(struct mlx5_core_dev *dev, u16 vecidx)
 		return -ENOMEM;
 
 	af_desc->is_managed = false;
-	cpumask_copy(&af_desc->mask, cpu_online_mask);
-	cpumask_andnot(&af_desc->mask, &af_desc->mask, &table->used_cpus);
+	cpumask_andnot(&af_desc->mask, cpu_online_mask, &table->used_cpus);
 	irq = mlx5_irq_affinity_request(dev, pool, af_desc);
 	if (IS_ERR(irq)) {
 		kvfree(af_desc);
-- 
2.36.1

