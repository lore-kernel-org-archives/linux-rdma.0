Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510008;
	b=pGb3MiYydKoIcq7mCVEz867scMK9C6QKr59cxVI+MY+bkE+bON9ejySvjF6z2pfFgGtA
	 ICxN+J/e80G93xYN6TZNpS++r1vs1MMmC4FwTul8ujJ5zvV6mAtXkgd++WVJzMMSRFCsh
	 K0kywiLMBwkCIN9cm8Ll3d02fJLNRwcUZuySRWRrjkP/1oRn4mgzJFldO3nl1MKlW9ZMS
	 RG++yL9iEWfBLB0LMyy5MRuQyXK/Z459EbnxNisRSmbxV2derQY0JaGsahbddjJqz6mNk
	 0mhGg5nzwYRh5ZeRNKa9zLiLfzj+cXnYVEqmJKS1FYwQUZVQAAbfsV8oOUy6LaG7QJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510008;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=1F2ta5jBLuNV395CAKcN7BEwN99fCZGw4zMuD1xJ8K8=;
	b=YTT8jZh3PgLskJJk90PBLdBzeMmn+x2DZcQiF3qBDIa9/R//5uFjvxv0eeAT5ezkIwmC
	 JkRjV4b6Xj77oJvkpEXzov2GnPC96UBnk0YcewszUM/hSSNuluwwKOGfPvL+M9oSqo0sX
	 Tf/rhvn//FtGK+smYmZmzodheIWmVPuP+cJGqjBiubmhIMOyCbZMnTa2KSPopjA4K+fuH
	 xJM9UgobeDn3fPyfj16RCHRTBR5JjImoAacCzs+0nNiIu2AAxj+umLDuiY/r4UmqIyPZm
	 0KDuh/U+USRf+AdxyiaPWbvP5zCS6OtgxO94vZOiIGli0AsF2EFBWsg6gm8NmxEQ3wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JwJAWNEt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDF1606A88C;
	Thu, 12 Nov 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JwJAWNEt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862CD1F000C4;
	Thu, 12 Nov 2026 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510007;
	bh=1F2ta5jBLuNV395CAKcN7BEwN99fCZGw4zMuD1xJ8K8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=JwJAWNEtkhQ+oSMCnMG44GXfiCQWiyp5xLE79P4lWytqk12mjUKlUaPjCp70cx+o3
	 nR7j9bQ2eaFdJ7YrwsXc2OBRbv3WsRZcpLWT0zacTgcNgA8+pCFM2AHg7heBhzjr+9
	 aHz42cJ+vtr4EaGSuEw9jdeDmoEJFqiU4np79Dh3H07ccmrYfqFX952TOt35/b62+a
	 EOUEPpqVq4U/2nW2fjf/t0ezokK/++oKONLc4fL/ajWz4vplXZGCrjq95d/uG+Ybr4
	 8YpOl19R1OLGwTCxHA/5PHMIHYEkD2EpPNhOuQBsx7bYOsh/jpCGfC01vHprDw46V8
	 CN5c3+eDPDPXQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 778AB3924A5F;
	Thu, 12 Nov 2026 19:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2] net/mlx5e: Fix false WARN_ON_ONCE in flow steering
 cleanup on RX init failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179451000631.594620.9453588813056592176.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 19:00:06 +0000
References: <20261111082142.3131746-1-tariqt@nvidia.com>
In-Reply-To: <20261111082142.3131746-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, ayal@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, saeedm@nvidia.com, shshitrit@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Nov 2026 10:21:42 +0200 you wrote:
> From: Alexei Lazar <alazar@nvidia.com>
> 
> mlx5e_attach_netdev() sets rx_mode_active before calling init_rx(), so
> any init_rx() failure after mlx5e_create_flow_steering() has succeeded
> makes mlx5e_destroy_flow_steering() trip
> WARN_ON_ONCE(fs->rx_mode_active) in mlx5e_del_vlan_rules().
> 
> [...]

Here is the summary with links:
  - [net,V2] net/mlx5e: Fix false WARN_ON_ONCE in flow steering cleanup on RX init failure
    https://git.kernel.org/netdev/net/c/3962ded998c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


