Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619435;
	b=CrEZKeijHLArV6nvLm4p2Y/UHZv178IxWpW3NaMAPL2RaWdb7KIo8VdUZm/r/DGRhPdK
	 iSBw3f4fkwB25Cj09zPZlk1IkSe8h9VPube7gXlUAlW5oLibrcohAqgchCKvW0hF70oqN
	 CwQWxZTl6lISGpge2FyBJdhW+9T/AkfEI3t6CToO6qudW/A8Ankccaqm7WJLb6DqcchZY
	 KH5+agsqjXSges0e+49iyNBhQ/47KcKte8XEizgyx71xLFR6GOQ8g26q3CE8D8Gk3vzii
	 RDaAyONetJ6iWnGG3gQRHpq3zn14tZsYV0fnKyiJGn3Xgu9joUnb4bhHhIW0coiNbXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619435;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=llv31cCB0qW307sqInFshDFY3rFrRfABQYRSbjvxbig=;
	b=KrvduTJZ1OxX9cQNinXyoYFWgroh+rgiEtXX+2PoQXKLAEJ90cAdSrWsTA9EyY/jvO0N
	 phFsmA6h3mWtwqJ39qsl4vmv4T+r5UIfa5ghwEfbUOoSzxTpvAF8mfmgpi8+REYfwKbB+
	 NtSvVROoniCWPpCXvNy0wlxJ1th5EAF7a/Or8pHBuxB8SpfYNwnnHVpxFV4JqXTwbzyYR
	 rWaomFo57VGJWbONRFKfZqno7y0Xpgs+SYFY98O0ODzl6KPB91cUH9ceR/n9vSvjorguR
	 ws+bYORiHQbsVRBL0GDOzGVJPKfSsD61Ub15hn/Q0CzYj7+yRWJlhHIk9S3NjBaKe/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHhNlO01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B1606A695;
	Wed, 25 Nov 2026 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lHhNlO01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C91F000E1;
	Wed, 25 Nov 2026 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619435;
	bh=llv31cCB0qW307sqInFshDFY3rFrRfABQYRSbjvxbig=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lHhNlO01p5zd8k0VE4L8ab0FjRMu3csmbUJLoVvCZFQ3wECEQYDciuxLvtQzJJuB7
	 bLEmwbWbB0RqJspnI8fuKXvvFOGQvL9xfp0G3WDaUHZzldQnWp/qCut2pUQD1/SCif
	 qd9GGsX82pP4BcYpdSIG90eBeeETn0DNO9Ajh7GTgriA97p9PlsT8/6rcPxPM6jdg8
	 SJM/DJ/OdScs3C2noE5psZC+gf1KBzsjrwPNYjVDD+iemVHKCxbmB4jJzqOoFPMRW0
	 dqW22l1FLcp81IzHbVyoOu36E32aYUig57emfziNKyH3BqkZpKjxy3tSXwrXdz7Exi
	 +HVCzGIebHoYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7729E3808209;
	Wed, 25 Nov 2026 15:10:35 +0000 (UTC)
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
Subject: Re: [PATCH net-next 0/2] net/mlx5e: Fix mlx5e counters documentation
 errors
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179561943401.592665.4261692466901114316.git-patchwork-notify@kernel.org>
Date: Wed, 25 Nov 2026 15:10:34 +0000
References: <20261120083050.2540739-1-tariqt@nvidia.com>
In-Reply-To: <20261120083050.2540739-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 corbet@lwn.net, leon@kernel.org, linux-doc@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, noren@nvidia.com,
 rrameshbabu@nvidia.com, rdunlap@infradead.org, saeedm@nvidia.com,
 skhan@linuxfoundation.org, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Nov 2026 10:30:46 +0200 you wrote:
> Hi,
> 
> This series by Gal fixes errors in the mlx5e counters documentation.
> 
> Commit 8ce3b586faa4 ("net/mlx5: Add counter information to mlx5 driver
> documentation") added descriptions for counters that do not exist, and
> referenced one counter by a wrong name.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/mlx5e: Remove documentation of nonexistent counters
    https://git.kernel.org/netdev/net-next/c/79dbc8001fab
  - [net-next,2/2] net/mlx5e: Fix incorrect name of rx_symbol_err_phy counter in documentation
    https://git.kernel.org/netdev/net-next/c/356f4400c1fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


