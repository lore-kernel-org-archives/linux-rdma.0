Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794883806;
	b=WaMsTWEkzwCRV/zYvq/v6SA9CdKmSXCM7ORH1JqkPNqcg/lgb9iIeqNhW4+sA0F1XOr/
	 6xsQM3bi3a8vMTf9/2shPP19jqChP/ER68HyD+JM+L/EdQGslupLo6ghnIXhYWeMuXneG
	 g33BGn8DGZnxjbw5G9dZx7z7ifahKOgXL6qvjH4syBebeUKdvFknBq9WDiJH8THB34Yrg
	 SjiZD3AA0tfTDopjYXmGVG/KJBviKMqGelHKTwN5mi25KA7Go6uErP7JMe522klek6HcA
	 ETEV3ildm70YveZPQcpxctROB0ItDSc9wFCrIvC67CGu2zjgo/wadsGBnc3noqBRdzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794883806;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=BL7jfL5RepDVHTpf571CMSvkP8AAhB1asrmNRQjeQpw=;
	b=Gz76EYJRTj78gO3WnqGbrUGtLMfMRyOPGF8kDRsRSjY9ptdhFcvzlci+hV+PrU6TEJPS
	 9suKnD5WqFBhsVH/1MqtSuTNLb5bkruThSmGfYes6zpiIG3HYDETFpn+KOPnACElJj8rn
	 G8xwQ/z5PBqOKfK/QHU0m4sU0KFWv7UuLCYsxRTJHQI5kYFprtPwHGnppmmQ4dCZOXWr2
	 MaSDxOwgg7crJmc6laBprbZuGKaJ5+suFxB7yV0ZWEJ4AtpL06QoSFHVl8pbhLuCdPele
	 3u/kytSrqIwjw7T9VESTJMdLv3FAwIbsM37To4Kbz6REFuOE9Nxj1JwcSA+0zGVsoZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKQL61tv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95CA606A31C;
	Tue, 17 Nov 2026 02:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DKQL61tv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E481F000C4;
	Tue, 17 Nov 2026 02:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794883806;
	bh=BL7jfL5RepDVHTpf571CMSvkP8AAhB1asrmNRQjeQpw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DKQL61tve8PT9P9rXUR2i9O4iq9u5aphdt2xxWVTKpGJWj6bIwjtJ6SuDijXsvTdA
	 XH10lPmrY+dhQk5tQUOqSwyzIPiVcMOoZ74PMGSiLKM0FwtxPztrqaNezJ5iGY3pvu
	 fcjbABlaeIa+rZIZqddY+Kax/rTsofLR/I8OZ9YhGEdAEpjyAXNQ+CdlWJrfV9gTHq
	 zRlOGPOSWmpW3ZA7h4IGHIyBayE2a4LFL4JtDiYh1sicGLPCc/uBOSgfut81tP72VL
	 rQXazmDB+i+DQM+mDoDPexFIhYIWHBr+4nRdnZa0NAbeOirQwN+XGFbv6DD2SqFF7z
	 TmHvJdKevj4Aw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773F8391B088;
	Tue, 17 Nov 2026 02:50:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: IFC,
 enlarge active_port field to support 8 port LAG
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179488380528.305876.11658073225104873930.git-patchwork-notify@kernel.org>
Date: Tue, 17 Nov 2026 02:50:05 +0000
References: <20261112182940.3655773-1-tariqt@nvidia.com>
In-Reply-To: <20261112182940.3655773-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Nov 2026 20:29:40 +0200 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> active_port is a bitmask with a bit per LAG port. The cited commit
> enabled 8 port LAG, but active_port remained 4 bits wide.
> 
> Enlarge active_port to 8 bits, as defined in the PRM.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: IFC, enlarge active_port field to support 8 port LAG
    https://git.kernel.org/netdev/net/c/a2239d5dbbda

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


