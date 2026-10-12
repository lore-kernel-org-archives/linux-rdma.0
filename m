Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B7C493657;
	Mon, 12 Oct 2026 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816606; cv=none; b=m6q9LPlXv8CpodEVYgILCTkJRhrbnu0gSZ+YuFsdvtD/6ZwM6q/XIyqjhrUEBMivLzXt1NoZVWQtsNUa8uh9TQI22Xqalqfoj/aGF368kuat/Cxm3rm6EnWl2UB+sNgXjZ3z0LY9JhcWgc4y6/0m+/izmYfn52+nHsUd8AUdXBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816606; c=relaxed/simple;
	bh=rnapNuSROl7ZSIniW2dU35eramnfFZ+Am2idUYK06HA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Kdb6DCCSTz2eU4zr43vYnyUeoXXfMsPaiZ8Qq7Afyoiy84v7gktAiWWEHMX7B6jCTgWxCqbREpIC/pnix3aVhgYPfwnZXIxDsiT3swQwJyhNSscPOcxxzBJ0rwZE2o7BedO9atM6HYnbB1wD4r6aSTdiATNVXUm3Gc7Ppa/WZrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFQ/xx79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFQ/xx79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F4D1F0089C;
	Mon, 12 Oct 2026 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816605;
	bh=zw3oM9Psv0fJEvjd8IvDiH4wKsxJ+0hVmCMiGEw+n7o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=UFQ/xx79MN9/RJf2AusS26Gkn/YMl6C/W1WX7IlEKPXgnmf1wwWs5Uf/tYdD93ZXu
	 KJ13LFoCfpI26z1cDs2fg9wH7L5O13U7XXP1/BIsKkUoUDeQEvC4UURKlL5e9NpL63
	 yPxqE49yv1dyO1KCacE7bzJQw2cOGts96zkT3DKTJ/+yODmuLNuJcRBvFCE0Cj8pr7
	 Ykwd7pZ96jNZyIJ3AAK5n/+YQiIVlZaq8WYlwJESaq09ScwyFMYzQkvzOpfWKmNV7r
	 feWvIeKoxhy0eLrYK62FjUERn2pCFRWK+aBKSeIhGwwT1Tve2NdiVr0iPUKHhPQkrr
	 NL2d9WhLUeAYw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773523924A4E;
	Mon, 12 Oct 2026 14:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/mlx5: allocate DMA pool structs on the
 pool's NUMA node
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179181660403.3469238.58273282558779725.git-patchwork-notify@kernel.org>
Date: Mon, 12 Oct 2026 14:50:04 +0000
References: 
 <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
In-Reply-To: 
 <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
To: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 06 Oct 2026 14:16:45 +0000 you wrote:
> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, while the DMA pages they describe are allocated on
> the pool's node.
> 
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/mlx5: allocate DMA pool structs on the pool's NUMA node
    https://git.kernel.org/netdev/net-next/c/29f144016f03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


