Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279297;
	b=zmM75R+8tqPpPKU1YuJCudaj/uZEZyuNalTM28iu1PQVACA5Kyerk96fqXXILiqUNB3j
	 Ie/fVOdQ6i3nVIB0okz5dq0ud+LdkMw25rO2L/9HrCr5Y5AZINej8d0zH2WBpdatkOWux
	 RQqAaXkMufPbsEG4xWkk9jF3+Ryi33b9+MJm9BRWAU2fR+PdSblynOtjV7g4j1euwPtNi
	 MFLN0raKYeBn0H5E4z9c3pbBotI/vGRvdBCySQPtF0lGIxYhsvJoMH1FdTEh+tLHuYfma
	 0/+slozpP2V68Uv50zaBcOJCvfnz2A1kIaStai2nwoD9N8MLGClz5eJJ4f2DW3MzMtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279297;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=220IttDuUK2+qmE+iRwEDRnwj9/vtgmDl7HUfJ3Mg7U=;
	b=IeQRKN8W6KBOeSnXNKUQBZJR/WNUg4rNeTRRGd2w0UX8od0cBbBMYGg2LTTNq9wGnlqd
	 BERqw8QwjbmwUgqo3J7pFzUaEwZmuvil7FVJkN2d1uehTLdMTGun5xRcDV0geVEVwAgPL
	 LTh2D4+SmbA0p+Q0Sb1HLIVNc4n6vNOYD1YASQJJSMWjS9E/qjkAEQiUQFlhrTYIKP2aL
	 KfaP4yxc5b0tWlTHOj183/yJV2fzxQmUJhTxLs0xMBsB9csndPQYP9oqCJ4seIkIonDUY
	 3rmeT0zWAFnBaKyzRFz10oCM9S9/42ouH0QLu0c15dsYRKEhWxMUYAum1CmPKNJS0Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iP6T/Oeu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF7060A2619;
	Tue, 10 Nov 2026 02:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iP6T/Oeu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2611F0089F;
	Tue, 10 Nov 2026 02:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279297;
	bh=220IttDuUK2+qmE+iRwEDRnwj9/vtgmDl7HUfJ3Mg7U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iP6T/Oeu3NeSaN5uH9Rk2agn2vNR1efLa1Z4y4cHVv1N6nV1uDKDo0EBBfZtp4u86
	 BGIew7PX90RQyQBVyVMxQKKzYZPvhoTb3QkbCeY01brgQgmqe82C63qLavWxkf305Y
	 gUcfRQiWsKQSNowNOx6f9g3/YgaDGjqF9Dvc178ID1CGWqSCJs83nzJRqxC3vkG2c9
	 o2k/Tnty27XDl0aaaY70QWNO5aZY3mJKOGKadwQUlktmr2neRF81hJT8y6tezX4Ikl
	 ssZnrzP+GlcYoRLgiwsNX+T+Qcn1ogXbp5YYpTbflVawIALqnPvTa1do71v8ydVymL
	 C1zpgvX3wP+VQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 20F2C391AFCB;
	Tue, 10 Nov 2026 02:54:57 +0000 (UTC)
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
 free steering resources on LAG destroy failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179427929567.3612825.14562641689410614120.git-patchwork-notify@kernel.org>
Date: Tue, 10 Nov 2026 02:54:55 +0000
References: <20261104183947.772195-1-tariqt@nvidia.com>
In-Reply-To: <20261104183947.772195-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 maorg@nvidia.com, mbloch@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Nov 2026 20:39:47 +0200 you wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> When firmware fails to destroy LAG, driver returns before releasing the
> steering resources, leaking the associated software objects.
> 
> The bond is no longer eligible for offload, and the driver cannot
> prevent its teardown. Release the steering resources even if LAG
> destruction fails. Preserve the error logging and return the original
> error after cleanup.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Lag, free steering resources on LAG destroy failure
    https://git.kernel.org/netdev/net/c/deceb70d1303

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


