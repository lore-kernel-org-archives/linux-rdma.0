Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795304662;
	b=2Mfa0gJvGi8ZFJ6nBdOQ8EVaWPB4pfSty7/CV98fs930yhK6Spj/3l2N5uWb6wZWy2Uw
	 EoZejVjE5wGz+EGCNmnKmmTMuk0ZEw77nKhnTtB/OHu/uC0rKHpIi452M433X2gBXbTuO
	 BFcXG4mLIoAgzF5ZKPsrktK/9PcBUpouOr/M9QtMpR8TkJfv3UsFAAisYHZoEICN0sP3x
	 XptnZpz8CVzD88Ygvjnse6EiaxcOIf9goYbPm4rDA0gKFvkKsJSFXF7avRPoA0NOZovTx
	 VbdjHjkFIvck3hwZJ0m3rOsAB2k//Rr17NvT2dGQqY8Vh2zKOHleyJWVsU+gKSQr1Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795304662;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=eAH6oR/rt2izJh32uxloNKAo9wkoKxfTpTY+3FcUDAE=;
	b=TCXdCjVGxrLM9LJXwnzQQCwxSZ1oDOP2DAtBBBZZ6vhiT931bLU42mPUzqjutH+E3XrR
	 awwjNRL3Cxgg7zTBbFtDO2OPb5393MeuB1xYo57VywMsYjMwRXPIsgJkEazHt5hcUzwPG
	 GNj/sNMlW3h/2oZhJyAl4YJR8L+4rrlx0Tyka3izlH5AY/f4Fjh/7+44M1Q8rDQjcYvkk
	 DW+b7jC7IKqNRklW7PYtQjOJ1009O6F62bueHhJFVRgWFQGh7KYTSbRkbjARanDELAxeR
	 tvRe8OcGkSFHkUMnu6h9usfRlMFcIbHgZ39asTlrUMGvLl0rP2oSmY4ZKwan0onZrxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqRzFgAJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC5606A333;
	Sat, 21 Nov 2026 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aqRzFgAJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804491F000C6;
	Sat, 21 Nov 2026 23:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795304661;
	bh=eAH6oR/rt2izJh32uxloNKAo9wkoKxfTpTY+3FcUDAE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=aqRzFgAJ4mhAp9SxhH4cSj+hENUOExjeM6B4OuOPtJUiazYKI/Ou2n5NV9byVeX35
	 n+4JbtJchcIZmtajGqXr6QGETl5PFZRxcF6XDKQ83wNeCwvgylgtvw8wA7Cvt8qIBs
	 Ory9AfyWi/9DB+t2oS3FPr+8Rx0woD/ZqdCKSqKAsd6qYPLagnavrY6migTHovP9Ip
	 4YSq9d88nHlFwxIkqNM3lqPp2bSSKKEBBCp9FfkbRZxPGsGvmAyO0OWLKx0Ept2blJ
	 InyNO5mDApVQb2bxDCGJc4JrSZX4slp/UWMXIJPBVODmX4nry4WC/de7oviZHP71Oh
	 rTCOEB5e73yyA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 77426391B08F;
	Sat, 21 Nov 2026 23:44:21 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: E-Switch,
 skip vport change work for disabled vports
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179530466002.1212208.7295232184844541072.git-patchwork-notify@kernel.org>
Date: Sat, 21 Nov 2026 23:44:20 +0000
References: <20261118165155.1946097-1-tariqt@nvidia.com>
In-Reply-To: <20261118165155.1946097-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, parav@nvidia.com, roid@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, udar@nvidia.com, vuhuong@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 18:51:55 +0200 you wrote:
> From: Uri Dar <udar@nvidia.com>
> 
> A vport change work can still be pending when its vport is disabled.
> For an SF, the vport is then freed in FW and the work's query fails
> with syndrome 0x29d722. A disabled vport has nothing to sync, so skip
> the work.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: E-Switch, skip vport change work for disabled vports
    https://git.kernel.org/netdev/net/c/890f23ba87a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


