Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346808;
	b=Q9uTdF5Bws/WMqT4oZHxMiof51hzJ/skLUaghcHygd5aqcKug6kcOzDvSOdwXVUbDgaU
	 TE3JKFmeN3Od4ASbJ7ssPBNIyv04A42z64kTQ9m+oi5fiBEqxkjUWupjcQlT8PlZGvARq
	 LTFTO70n7NC3TgcrSjeQCkYlTK3yk087iF0UUX9uBp6v5lDp77OThqt3Ao3d5SXOFhjCO
	 wDoaK5SGtA7HRj1muGAYphiLGlC+uinwjL1XqQdLWFHCTchHy3Gx3CoSEEejIKyVubSq+
	 kUKNTxzVJluLqpAZ04BYQ8lwXq1ysHLxb5a6qTyygo+1TaH7Mr06+jbaLkr2vIF3Xmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346808;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=izWqIDu1MLZUfY7mHUtvRg3/UWowaZgxZTU46sEcixA=;
	b=Cyuf0yBC3wksH0JCP6GCHs4nMVjMPFwPGoFT08rtGVaHp8WwNeJ4bzSs1NQnOk8fg9gK
	 J21iHz/an/HludRhZseDgU+gz+4wP8awxMdfZmJFncnmZvWRUhJXc5lspE7LAcU4ScPXb
	 Znm2HWzQtoJPo5WzuT7epETMSsF1ayYf8HDdJrbzfCTssa8HzKWHoiNccWo5SCjd/VEWQ
	 Yjk6oRTd1aeOiIs9fAq3iCMK9Wk5duPBhdupSCXUM4d1QIc0GZpoA7RYDuU32+wMw8L4T
	 4iGNTkWEnfmIVbIRCIQD3pJEsGMHOhR8DSfUN44YhT0qyZk6CW2CeqKwT6w8f7GuIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ExuMp3AP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5EA606A31C;
	Tue, 10 Nov 2026 21:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ExuMp3AP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50941F008A4;
	Tue, 10 Nov 2026 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346807;
	bh=izWqIDu1MLZUfY7mHUtvRg3/UWowaZgxZTU46sEcixA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ExuMp3APC8DL6fpAH8LlnEHUAaZYSUf+6KLEGg4I9rPsDepuGBhcZKVf0kapCYMS5
	 RjFuPwfVv66TEjQpOm/HfDFmdbX5FD1WE0VqHCbU+OdPhS7jMPGQahg8z99KOTNsJg
	 039V8BOc5Spx7DLR/WHkiQ7XnknwLUC/G2I6N+vPGSC/DJBJzvGvIBGqQLaHkLwxbQ
	 HvyFwoErMl8DSqkVeDv15uhed32RknCiKupqgivhFt8I0Q+HcbqQRi8rSf+KA4xJfN
	 x5dv2AOH9l9JKfDwD2hgVO8xEMG/mnHyUBIhyi8sOgDvSn9fG+bEmWa/7bQtAJLvtd
	 dTttKEnxdhxeA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9B0EA39E8A40;
	Tue, 10 Nov 2026 21:40:07 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: E-switch,
 Restore host PF enable for ECPF that isn't E-switch manager
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179434680618.71955.12887058500414499208.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 21:40:06 +0000
References: <20261104184756.773910-1-tariqt@nvidia.com>
In-Reply-To: <20261104184756.773910-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, moshe@nvidia.com, parav@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Nov 2026 20:47:56 +0200 you wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> The cited commit breaks host PF enable_hca when the ECPF isn't E-switch
> manager. For example, when the link layer is infiniband, the ECPF isn't
> E-switch manager, so after the cited commit enable_hca is never issued
> for the host PF, it stays in initializing state and fails to probe.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: E-switch, Restore host PF enable for ECPF that isn't E-switch manager
    https://git.kernel.org/netdev/net/c/4777203cc9af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


