Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC8D403EBC
	for <linux-rdma@vger.kernel.org>; Wed,  3 Jun 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780471727; cv=none; b=ElI+vzquKx9hYdLeqs9nzq+QEPHdZkKA+q4svLINeAQXw+dBqFuoXE1onhqyrolgu7WfmR1qf9OVWeAZU3eX4XxqbFItHLODtRv9c9Qaike5yitnaPxbWYxyufEtlXi5QqFDOhof+yDeosYiqVtNvbNZBL4x1MfZAcuXldDutoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780471727; c=relaxed/simple;
	bh=vZOfIEcxw+Fy1HBH6hwkpuijf88E6fq/alp03avT+5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H4YFvg8F4X1ZSlO8dfB2bnKABZglCkcfbRrcERagKcV/i0NHSjxS+GrUpXWEdoetVWZkQL6AfKRI+Yjm3QLkVgFDOmJ1ckjcogbd+1SUkrPMgdeNG7QxbEEbH8MkwDVvKi2mQiP2M4dZ8yUhSpO9Y0uLXeZUzwCqx6kiPUSDX1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=btgvpoP/; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="btgvpoP/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780471722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGWYtXhrZv46AL1Ad6j8BtWNTA7mBnidxEXk+Mph1lY=;
	b=btgvpoP/52SIHLi2S3tYnry3XCFl3lxirO/81WgmLgvurS2xp8AUyrwtJIBWMGLmHisNo2
	HDns5Y8pmvKE5fthZXUkLfUhUZJAeE6zOSoWQRs06JJZWMVvOGfQC/92+yL2YLLfygQjcl
	8SJmaQ4DeIE0+b55OmxkDtxR5XsqBgk=
From: Fushuai Wang <fushuai.wang@linux.dev>
To: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shayd@nvidia.com,
	parav@nvidia.com,
	moshe@nvidia.com
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangfushuai@baidu.com
Subject: [PATCH 1/2] net/mlx5: Simplify cpumask operations in comp_irq_request_sf()
Date: Wed,  3 Jun 2026 15:26:56 +0800
Message-Id: <20260603072657.10868-2-fushuai.wang@linux.dev>
In-Reply-To: <20260603072657.10868-1-fushuai.wang@linux.dev>
References: <20260603072657.10868-1-fushuai.wang@linux.dev>
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
---
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

