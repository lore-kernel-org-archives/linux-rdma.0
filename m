Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794508209;
	b=CxPfpMx0lAAxnP1wwCh+294ty/nIWG8I1iC6l8k1K7pbfiyq0fmF2OlhNh3SgSEQN5H9
	 wufTfRmoTBgA0QG18LjcXsoWzyG1uOLNcR/IveOyMepZE+E0qXBs8fueAuu8y1J7ATte6
	 nTHqWFFrnX9swbkJHlNw3Phc3GpWKjXRb7fshyvzOXs7RQgJLP5UmJ1BBMSvDYoJN4F7W
	 FfrB4jtAG+B5OMs0bafq/S6gs+2wEKnPzbkHIBoYUREWx4WYtTC/8HWw98akqege09/xX
	 prhOML8gxUcEwyAwGR2kUqXVLOeLfw3h58d4VjmWajYu6LJq/uR5dRbE3AdRo81f7oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794508209;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=8QjHjYTQcfKzzkMDSKlQFk8YX0rMADVNDVXY84yx8bc=;
	b=S6F1lvV2xLSeaKannhK8txQV4o/EsTnMGpVWx4C9gSzQi0nGo2/P/erce5llaLiJ71JC
	 MBL+cMbx0RBG1zgSEJn4IuCC0n3FwR2F7FMBrpcShNmW0rxJTOwzwPYgqDoYUvyAZAvG0
	 mrRwuLDua4tDThkSpWJr3o0mxEUT06q8xrky5yhEsXYUcjfwJQI2fIHaPE9mPOHU483ZN
	 gAQjiPYsFHRkiAMkX43MnAXn6V9Mtpi1ZXXH22u81dFQg99QkL6Bfx3YDFUvhYHDWZpBr
	 YrkCuBfnXxPpOWZCRTnoSGaQOJtASuX0hobdbv+DakdiPkinK0sYxlUWMYJ1KqCgj0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kNaW20lj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E678606A891;
	Thu, 12 Nov 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kNaW20lj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449C01F000C9;
	Thu, 12 Nov 2026 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794508209;
	bh=8QjHjYTQcfKzzkMDSKlQFk8YX0rMADVNDVXY84yx8bc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=kNaW20ljwApm5ZtaAnrz9ptI2yRCOws98KrcbDpyR2cRDAERRCN9uL9RToGlFWwKy
	 8z9T9QKpOyeNETmMauWg6ruRIFV2lGQq4IBhwmJMj2vaZohHepkauei1P71JiSzY/8
	 c2FZ6/ccTX4Y0VZ5et6Kv3M5F0+hu//c9XHv0b4YLswHfemsSxXajCWyNfI4/mG2Dt
	 NSNXz0aIHv+nL0kv4TdgOb+gDcIMYUh+5PR5xtpirhxkg+YRmC4bLR9g6q3XmuyZn0
	 868RTZOmmQP09KRQ4r6fLWS6ViCLx3VOffqn4PdWgZtUE0URAuxXhuRigM4vpjfnSI
	 dCjIEd5W3HAAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A3BA380AAFF;
	Thu, 12 Nov 2026 18:30:09 +0000 (UTC)
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
Subject: Re: [PATCH net RESEND] net/mlx5e: kTLS,
 Fix missing error unwind when enabling RX offload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179450820777.579048.1808368015625115725.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 18:30:07 +0000
References: <20261110101709.2589088-1-tariqt@nvidia.com>
In-Reply-To: <20261110101709.2589088-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 borisp@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, horms@kernel.org, witu@nvidia.com, luoxuanqiang@kylinos.cn

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Nov 2026 12:17:09 +0200 you wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
> ICOSQ"), the async ICOSQ is only created when an XDP program is attached
> or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
> the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
> the channels so that they get the queue, but it ignores the return value
> of mlx5e_safe_reopen_channels().
> 
> [...]

Here is the summary with links:
  - [net,RESEND] net/mlx5e: kTLS, Fix missing error unwind when enabling RX offload
    https://git.kernel.org/netdev/net/c/343672bad641

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


