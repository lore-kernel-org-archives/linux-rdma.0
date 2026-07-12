Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D0C306776;
	Sun, 12 Jul 2026 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783845587; cv=none; b=Q4BCZOuNyKipGQelc1Ph/5R4lOIf/OigxeGwt4brC1q/TGAlqIS3MicZTBJYZ+yi+tk6JL0TqXuQjU7SWJepuBNIqrnKU10dyLTaavZALng+HtrGKMJ8v53GzhlZqlHcV0v9CGaz4LpFovgIsrmFebdfN74qe3eu/nkh+mSIjP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783845587; c=relaxed/simple;
	bh=6W3zIn+lS76s4GpcDPoUALiBczHTC48X7W6Vg14t4EQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gak4wgDDPPV/ayHUUm+y4SyM3tnsnj0kdB8WGFi+wGOPVV97/21WkArwwwjjDb8TLagpSBxjhi5xHpifN+M610dkJ1wy4InTSdTD3x76fXkvocWSbzMZnKMWZuyK28YZXuSCgEwqVlqyPa0WY5sMiDGKdEJK51QQI0tdFMSgogM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D401A1F000E9;
	Sun, 12 Jul 2026 08:39:45 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
In-Reply-To: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
References: <20260709-unload-rcu-v1-0-fccd27211e5a@nvidia.com>
Subject: Re: [PATCH rdma-rc 0/3] RDMA: Prevent RCU callbacks from outliving
 modules
Message-Id: <178384558365.1548560.9935891895895303799.b4-ty@nvidia.com>
Date: Sun, 12 Jul 2026 04:39:43 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 09 Jul 2026 12:06:46 +0300, Leon Romanovsky wrote:
> ib_core, mlx5_ib, and ib_ipoib use call_rcu() with callbacks implemented by
> their modules. Stopping callback producers does not drain callbacks already
> queued. If module unload completes first, RCU can later invoke code that has
> been unloaded. synchronize_rcu() and SRCU waits do not wait for queued
> callbacks.
> 
> IPoIB reclamation completions are signaled from inside the callbacks, so
> they can wake teardown before a callback returns. Initialization unwind
> also needs protection because registration can attach existing devices and
> undo their setup on failure.
> 
> [...]

Applied, thanks!

[1/3] RDMA/core: Wait for RCU callbacks before unloading ib_core
      https://git.kernel.org/rdma/rdma/c/7d75592114d166
[2/3] RDMA/mlx5: Drain RCU callbacks during module teardown
      https://git.kernel.org/rdma/rdma/c/e37cdd75f8d61c
[3/3] RDMA/ipoib: Drain RCU callbacks during module teardown
      https://git.kernel.org/rdma/rdma/c/31b7c700670830

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>

