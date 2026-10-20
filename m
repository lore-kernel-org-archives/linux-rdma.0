Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502406;
	b=MK2GKYNbHHxdfSE3r1bppKPb+UWWIGevexlpjy7FlfYgtTwJIVvcbV1l+1DKxIn1mKA0
	 qkJR80Wd2w1RUhdhnTM4SVqpNEqrlWE4sZQBgeIhFhb8WomASZotNs6VYgvZ99OZG8cLJ
	 V1Phk1FbrGOhbX8MHu0xslIYAcq8mobGMbTGGpeEl6i2pUCubJz4miFLiWBz7QYijIfda
	 +6bCsL81t8twrdy7wf3JpoaDkk2jfFx8BOwgWlzWL+AMv55SpVlNbgFi9VNgk3+UALD+t
	 +DRPOnxCamg/P8c4/7YwJtltRerWhFhQozfeoE0xziTFxVmmNZCo84TZI6mWRvCHRYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502406;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=//l75mDkUGX/oYCveaouVsCzegcFG2T6MkUG/0+hS48=;
	b=RuzYtAVVqCVJOihENnc5NIl1QPoOi1uyuOG6KeYc8NQ7LMJW0NAADmmT4/f+1kHTHDDr
	 dMNqbcC3+2Cv7JGCLDQZsBHhRJaUetLd1yZ2rubuEmmARs4kFkEdiPWrnZRCvlo7hrnwe
	 lvK4YaWj82cn6Re5K3+JUKkXUbIfwuZsjSjqq6/w2AWDWovqKuhVWuscyWhSKQXtnbaVY
	 icQu1ugK1qw1YR+fZLENg6+d7yULumqMgHbVbsPF0vA1+hmzDWQ3wmA4Tze6ojdODHLim
	 JLFc93zNLwkUgjIfyVYLdsmIvmFdAlaC3+jSrCVe93lP9iZPZbuULYm8cgTrCob304g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgYUh57J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403D3606A319;
	Tue, 20 Oct 2026 13:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lgYUh57J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7F51F000C6;
	Tue, 20 Oct 2026 13:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502405;
	bh=//l75mDkUGX/oYCveaouVsCzegcFG2T6MkUG/0+hS48=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lgYUh57JuaKuD5gRSGEzJKqeo4LWW6FufjozqIRigsKoxHbHs/zHhH002zlJR2aHh
	 0s13AtucPcvCfabVv8jwj5hBa54R4pzQei+VVTOa4NH00TreAi0Z6rWq5Hn4EvLHMR
	 Af63L4TmiJhTNcJ7GE5wcIJCODwI5UPg1DCnu/ZNpomPBb9hcEgSgyriJ1QoBitVaW
	 YxslTW0Fsb+Mb1qWP8Yc+1Co0i3AL1CFRJ7zTsB/CS6HvxIqoe8+FVSxAcsAidNZN1
	 lVhw61Dj3JXJX+KVzWzAUaN2tBr/ady9A/AL1rCBXYAdPGeg+CrCqpN4Na1A4etu3g
	 CsoyKUoPIvRDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B43C83808209;
	Tue, 20 Oct 2026 13:20:05 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5: DPLL,
 fix fractional frequency offset scaling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179250240453.3733082.6292944364676588556.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 13:20:04 +0000
References: <20261015074035.1092340-1-tariqt@nvidia.com>
In-Reply-To: <20261015074035.1092340-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 arkadiusz.kubalewski@intel.com, cjubran@nvidia.com, gal@nvidia.com,
 jiri@nvidia.com, jiri@resnulli.us, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 saeedm@nvidia.com, vadim.fedorenko@linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 15 Oct 2026 10:40:35 +0300 you wrote:
> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The frequency_diff is reported by firmware in parts-per-trillion, which
> is exactly what the DPLL core now expects from the ffo_get callback.
> 
> Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
> switched the callback contract to ppt but assumed frequency_diff was in
> ppm and scaled it by 1000000 to "convert" it. Since the value was
> already ppt, this makes both exported attributes wrong.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: DPLL, fix fractional frequency offset scaling
    https://git.kernel.org/netdev/net/c/0edb8222b852

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


