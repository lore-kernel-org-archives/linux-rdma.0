Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794508211;
	b=rmXDwQOEX3Z1S9CZPfplpkFooHHOE1pFbo/1Pd0laTCWzO5d230+lxMqN3kglWkeOLVo
	 FPHX6dsE6BrNDmcMxJRn8fmX8wGWF4EYDVCNz9AQl16P2GX6Ds8rx0Qkb+KvXybTUhOAc
	 hzTyJE2dd9G6gTcwU5XIhnt3oqZzazS+nQX9L/gmJBpa9UcwIMLhDvLkQnaFSJFKys99M
	 NitLQ7w/nBAzJc4/ZDKNSqXo/H7++j36n+VQOYDgGNCcGcYOAPDAjzvNIu/Bn7wWxoCXu
	 BPaMN5jssLaSY0uDS3tX0MvvhwHPyxXTBj4MOW+X0ckw6fjFwNbuhRtyRSNV5onx+5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794508211;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=wd6J/nnALVPLNUeKM+jfvQK7F8e3sxbXAIqC+Q/itMM=;
	b=Pz6a2o/ZpY8yiNL47zjL7PZ9Hdy4YsrO4+dRBto7EF7P8vrc8DLIKXPqE+NrATllzWMh
	 +2Vrl4fknBxcpllwV5YP+69E5rgSzr6Tomr/1fQwwn82bUv8rM3P9Pi1sFPxE4dkrcQhj
	 j9UAowL0yrShS3ambKkMD+PlviTYF7MNwUK5navrgOwzTvIpvbaBSK/rtG70Tz+0uCuAU
	 a+P8sL0XsSQioYLQ8VxzQPo/9R+T2I+Lq34HafTAtqpSq1Ht5fmhmYSIAOlvsVJmCaWWe
	 OpvF0RTlb2JIGBGQm7G5HgorbfzKNll2Wi2KC7KuaF1CHjpwwjiVHdhrkBXPem6kmQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tryemhy1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE263606A338;
	Thu, 12 Nov 2026 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tryemhy1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEA31F000C6;
	Thu, 12 Nov 2026 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794508210;
	bh=wd6J/nnALVPLNUeKM+jfvQK7F8e3sxbXAIqC+Q/itMM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Tryemhy12hlC9r0fi+NM5EF8EngTMkynnkzmlaOcHy7DY7exzdjZ1blxA51Pctv/6
	 pQdcFJnrLeqfFxO75yyIK3DrDADMu0fCobOi4YfXekFdp/IE+NJjrJCllaSmfUVfUv
	 Ue4cRQiS96mMIokYORI99Cen+aFdt0N09+A4XqxAlLYjfiS+QYhKYFeM+qslEpmcz9
	 f8yI/owTV8i9XjUny8U6r3TucAl/dP35rhEFuq7AqINJoOn3NdWe4VkAs2UJI0AQot
	 wUrp5YL1OnLD1aIN1JpQcAKtb+SmgjZEhYkyXOL6KlGBTHBSBk9PY1vaGXA1V32Kos
	 YAMaPHml4en4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B43CE380AAFF;
	Thu, 12 Nov 2026 18:30:10 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: Lag,
 Return error when enabling MPESW without LAG support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179450820928.579048.16141706419996009861.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 18:30:09 +0000
References: <20261110114350.2639891-1-tariqt@nvidia.com>
In-Reply-To: <20261110114350.2639891-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 maord@nvidia.com, mbloch@nvidia.com, moshe@nvidia.com, ohartoov@nvidia.com,
 roid@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com, udar@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Nov 2026 13:43:50 +0200 you wrote:
> From: Uri Dar <udar@nvidia.com>
> 
> When firmware reports a function as not LAG capable (lag_master=0 or
> num_lag_ports < 2), mlx5_lag_add_mdev() creates no LAG object for it.
> Enabling multiport E-Switch on such a device returns 0 from
> mlx5_lag_mpesw_queue_work(), so
> "devlink dev param set ... esw_multiport value true" reports success
> although nothing was enabled, and a following "devlink dev param show"
> still reports false.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Lag, Return error when enabling MPESW without LAG support
    https://git.kernel.org/netdev/net/c/a532a7049ba2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


