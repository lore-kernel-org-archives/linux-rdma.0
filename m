Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D863E317B;
	Thu,  9 Jul 2026 09:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588031; cv=none; b=YDTR5KiK3JvdT28BisMqaOJOAwsVG01/jKSVLosJjB9PXfpVi10IXyTG4UWLqGyX/kjx30V78WXG9n7MvR9WP0aaD4FWxV5flEES7TBPSi5wSTo4eobH4n3thINzacsQ/yZbGepFTNrHKHy4jxv+Gbs2EWuiXCg/cI2NVLDMjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588031; c=relaxed/simple;
	bh=hjVEz5BlncyGAFoUfNZgxqqdRkYkFLytvRCg+vPzHi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JHuNXwApk5gBWAZUUuBrgVw2Z5kIRIpkBykxcXuRypgNFmUPPgoTwHmLoBwcq7OZiTSCE6ZkFlc8EAnoB8fHNrWv8is/iL//x9PO6is+OKC6HZPPYWymaE6cIhDnfDWv51g8EC3xdnxUeI5okq/GIAvhyBWgh9bwkxPPxzq+/yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsz8ONpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsz8ONpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CF61F000E9;
	Thu,  9 Jul 2026 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588026;
	bh=jidoqdeZHZw4TpWtPyn9fssGkEWIzNrMJvRkmLNC0ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsz8ONpSqkrplwEmkt7z8iENBhwyjJEjCTMBgxIeSmDuC0vCb5cvudHnzRnWruIic
	 BnzxNYevMY/Tx1S1UWNJ8WSElklDNeyg21pC2niG3XE8otQGJsIJt3kTzkQq2a5zK/
	 QgvYQJ8c+OBW170FVSVWNOw78GA1EwTM/lj5Dw0Dp0BfHv3IVXYz4CwvcLYlXFUo1g
	 RIAitqnbZC9OfjXqonIo33Mxcakzjg9xP6ls0+b/VUBG36NsmJ5v8CApoKhRUa2Z9R
	 n8Sw4EhHtYuaSimwYeuMw4nOxNXpWOXMPtvPXSM7RvIsQBgGJGgd4o3Qpz2M4qxYRo
	 feZ57lABckU+Q==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH rdma-rc 1/3] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Thu,  9 Jul 2026 12:06:47 +0300
Message-ID: <20260709-unload-rcu-v1-1-fccd27211e5a@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
References: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

put_gid_ndev() is queued with call_rcu() and implemented in ib_core.
Stopping the workqueues does not drain callbacks already queued, so RCU
could invoke it after the module code has been unloaded.

synchronize_rcu() does not wait for callbacks. Wait for them after all
producers have stopped.

Fixes: 943bd984b108 ("RDMA/core: Allow detaching gid attribute netdevice for RoCE")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b8193e077a74..d954eda63134 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3150,6 +3150,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }

-- 
2.54.0

