Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A91E3DCD;
	Fri,  6 Feb 2026 02:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770346209; cv=none; b=Np0iBP5xCVmIjQ4pUGXHSL0R8rwBZV5IVF8yx9e9sHaWw7KDOrICJjLBpK1lhA8ZWwUvDAvKccYQG0d15rcspCYNfhR1uwWPnGh6uxVKRJR2tlHA8YxSMB+1O2i7pCwg+xX1FSU5woiUj/XDlDDYKSZD87OdRzpVHXtQcqYiKIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770346209; c=relaxed/simple;
	bh=RY/V4OENDXhQhj6d8j5wSyJo8Hi2YdIokwwYUY5c3WM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QrUbROp6JMacgnJgORIuSLjHZdZPfzj8EzkUKmF4Pk/B5eYNAwCBVGW//737p6EhcH5DMeIGvS0FW23B8W/21SV6PmF3T5FN+nfQ2f5mK1JJas03x8lqAWhYr76YgvwdBdA3gIs+bMXf/F19vx1OcuCelrRjJ70o5W4cF952Uq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFkUVksn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFkUVksn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2E3C4CEF7;
	Fri,  6 Feb 2026 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770346209;
	bh=RY/V4OENDXhQhj6d8j5wSyJo8Hi2YdIokwwYUY5c3WM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jFkUVksnLypSjiYfU37J3LCSA7MM8qm+stk0VCris7P0DNgigv+mDuxSXzFnw55QK
	 j2JzEhyzgonm8ZVhNhRd2YQtlAscnG7FLN3uzWDSGxiv5nnNEJGW6syBL8ATdYOdsG
	 dU2Go4YpvikfpM4wlwG06TTs94Ikeb7ZrV5V33VSsNdw77LcjOw8rA9Sg7ko3UEBao
	 ESXRB3JTXV0er7tvoKrI1qGdZPQgUqxwWKFp/4wJwBlkzMbJ4UH+1e0DrNsld1WRNU
	 lxO58Gkfm7lJdv74UNDU1Ts5QkNOIKRQPeE1EqGUd8R8LJurJ+Imq7Q9EvL9g8SQO6
	 APM4NFryblHXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B1723808200;
	Fri,  6 Feb 2026 02:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: Fix 1600G link mode enum naming
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177034620683.657894.2565367947070195735.git-patchwork-notify@kernel.org>
Date: Fri, 06 Feb 2026 02:50:06 +0000
References: <20260204194324.1723534-1-tariqt@nvidia.com>
In-Reply-To: <20260204194324.1723534-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, leon@kernel.org, jgg@ziepe.ca,
 saeedm@nvidia.com, mbloch@nvidia.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gal@nvidia.com,
 moshe@nvidia.com, ychemla@nvidia.com, dawid.osuchowski@linux.intel.com,
 shshitrit@nvidia.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Feb 2026 21:43:24 +0200 you wrote:
> From: Yael Chemla <ychemla@nvidia.com>
> 
> Rename TAUI/TBASE to GAUI/GBASE in 1600G link mode identifier and its
> usage in ethtool and link-info tables.
> 
> Reported-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
> Signed-off-by: Yael Chemla <ychemla@nvidia.com>
> Reviewed-by: Shahar Shitrit <shshitrit@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: Fix 1600G link mode enum naming
    https://git.kernel.org/netdev/net-next/c/215b53099b60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


