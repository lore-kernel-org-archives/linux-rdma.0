Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A9A31C576;
	Thu,  5 Feb 2026 05:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770269412; cv=none; b=OXag0/EIqqC4zGUoR/ubO4BhUUhI+3ZOxQfeWofBdW00gq+QktbpbGwplmJdDdnzcKPsw473mWhUgEZMHZfIjlRmlrvpJgUc9oZ7yzJDd9x0K8oTUVC/DTcMWTaaZlJC9s1/hKakwnvBRRRFQymYJrs6hMQ0BEhHEqq46lZzSTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770269412; c=relaxed/simple;
	bh=vHr7ZbbZfo7ZAuri5DqQAM2N6o4OzxTGcUMT4tYdpZA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=sFoaO/iT9Bf+qo24Nqe5xGaXyG/k5XylSL06ioV7tBMr8UlagpEz4QKO1QJZ+N9dMlHf1iJi1WZOYQxxM2HUAO/fc32D6JdjuKILDhc24oX2ykI6c1yGKqBJI4qdrC84IkPc98TkeVch58SMqmI49U0bMM7xW3Av9iZjHsF9pA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPYe3GG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPYe3GG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940D6C4CEF7;
	Thu,  5 Feb 2026 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770269411;
	bh=vHr7ZbbZfo7ZAuri5DqQAM2N6o4OzxTGcUMT4tYdpZA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KPYe3GG87lRSkcOMc/79b4qaUpO5qyV76k0L8GpXS5thpLp41RnahFYGiOTWttrOj
	 kTEVGqVY84pqwasdlidvSY85o9lJ7aCG3i3sEV0VeUgatOl/9HIGLz4nX2N9Y7swiV
	 4wg4NSmGMBKqlNYB54ZBl3r1hhEUTMuGYSOt2a/IRjr2b7sFIbWDEZJ6N+RBJAlMRB
	 7eiwkCYZj1j/pygoF5n8qywbIXfsIN63PyvfOeUkpK2NTn1NIGP9SdX8FPudzw7e3X
	 dk7pJdkOBIuGiMA9krmk0y/bIXwEBomSFXjY1A75+GxsS8Olgf0nVrv8/og7gx65jv
	 Gg2Euan4sMeBQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id C24BB3808200;
	Thu,  5 Feb 2026 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 0/2] net/mlx5e: RX datapath enhancements
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177026940958.174316.9801512398588540484.git-patchwork-notify@kernel.org>
Date: Thu, 05 Feb 2026 05:30:09 +0000
References: <20260203072130.1710255-1-tariqt@nvidia.com>
In-Reply-To: <20260203072130.1710255-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, gal@nvidia.com,
 dtatulea@nvidia.com, cratiu@nvidia.com, moshe@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 3 Feb 2026 09:21:28 +0200 you wrote:
> Hi,
> 
> This series by Dragos introduces multiple RX datapath enhancements to
> the mlx5e driver.
> 
> First patch adds SW handling for oversized packets in non-linear SKB
> mode.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,1/2] net/mlx5e: RX, Drop oversized packets in non-linear mode
    https://git.kernel.org/netdev/net-next/c/7ed7a576f20a
  - [net-next,V2,2/2] net/mlx5e: SHAMPO, Improve allocation recovery
    https://git.kernel.org/netdev/net-next/c/09e6960e8435

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


