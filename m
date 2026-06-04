Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C653F47B429
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 12:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780577891; cv=none; b=ckYKK0LKUusooqXUdfKoKE6s5lsZ8oien7v5fVlBP3uU192VyGEeDseAIFIymR5UwVrv0ad5vxuxVwPoJX8fD5mMWKmBFZQUPIU9abTLzUiENg3JwzVyL6YeOhGbPHW9dlz46/M2e4yMsJM/gsrEvyixfGnkAPIatSd10mkqoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780577891; c=relaxed/simple;
	bh=ITxfvDI8oavPccggeMNhMEmG800okNLoYQVxixVjF4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XOe9xPAj115K1rc8gV+sU5+4qY4i0DekjATy1pVN6Tz4peqlrR9j7u5IbmH8FIIjvu+Qlg0UcpOkScGAaswnDRSbfasl+pukwRFnypDRVpHxMLs4sLbNHArhLukutvaEP8wJgAToNkhXJtIhN+V04+rZQAmHdYZq/Ftf/CgPWpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dqAS6YXd; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dqAS6YXd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780577888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzdPHcgJjIO+zOaddsmfgLBr0nf2Cuw80ULqxQvRe3g=;
	b=dqAS6YXdZ2542+iQaGqWxws+YR0KFa0MAKoAaREnVvgF+V/AqBr3p/vCrXTmpcmS1CCcP9
	zAoAKdpZB3lwJVtJv/8PVcOjrASR2uuHhDFUOTSFvnMpLaVcrqHjqK9U75BMbM6pwX16hS
	wTFb4rbzmPz51e5iN0XrO2bawhMlSwk=
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
Subject: [PATCH v2 2/2] net/mlx5: Use effective affinity mask for IRQ selection
Date: Thu,  4 Jun 2026 20:57:05 +0800
Message-Id: <20260604125705.21241-3-fushuai.wang@linux.dev>
In-Reply-To: <20260604125705.21241-1-fushuai.wang@linux.dev>
References: <20260604125705.21241-1-fushuai.wang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Fushuai Wang <wangfushuai@baidu.com>

When an SF is created after a CPU has been taken offline, the IRQ pool may
contain IRQs with affinity masks that include the offline CPU. Since only
online CPUs should be considered for IRQ placement, cpumask_subset() check
would fail because the iter_mask contains offline CPUs that are not present
in req_mask, causing SF creation to fail.

Use irq_get_effective_affinity_mask() instead, which returns the IRQ's
actual effective affinity that already excludes offline CPUs.

Fixes: 061f5b23588a ("net/mlx5: SF, Use all available cpu for setting cpu affinity")
Suggested-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 994fe83da4be..c5d784cbc8e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -105,9 +105,12 @@ irq_pool_find_least_loaded(struct mlx5_irq_pool *pool, const struct cpumask *req
 
 	lockdep_assert_held(&pool->lock);
 	xa_for_each_range(&pool->irqs, index, iter, start, end) {
-		struct cpumask *iter_mask = mlx5_irq_get_affinity_mask(iter);
+		const struct cpumask *iter_mask;
 		int iter_refcount = mlx5_irq_read_locked(iter);
 
+		iter_mask = irq_get_effective_affinity_mask(mlx5_irq_get_irq(iter));
+		if (!iter_mask)
+			continue;
 		if (!cpumask_subset(iter_mask, req_mask))
 			/* skip IRQs with a mask which is not subset of req_mask */
 			continue;
-- 
2.36.1

