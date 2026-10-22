Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792630206;
	b=C7pnWh5KA+fTUhJReWcbjPEhqFlZTkyj44C7HkNl74PfujPFBKOMqqaj3/tiyC/vNey2
	 FFzYWyWD3GIbL/hKuwubnYyiQhr7dw70vKdCj22T5z5Oeugc1fr78zRYre1yWbn1v5/3b
	 qTrtR9eSFhzA2hKkQSCkTuLbhhPzATP5yVRH1kLPXfE1vKR/ndIeeblPTv7Q0XomkuXS/
	 G5Z9J0ZUqp4VNrCIEksgQZ9lfX/dA02VOa9J1I9NpOAycmKF7xSU1vpjWgTn923C67uCn
	 tRjJ8z/mob8/01EEtDw6A7OZjWasIC8fm5qQsj+Zm8iLX+7BSfpmDkVL9RLiZ6fZL6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792630206;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=tPIulb5aO07nDBTsaR3BgvvSevctw9HTVGRwm+45BBI=;
	b=S2CgTtjARhcOhOtvfG72XDpsfB5uZFLnkPvzR4yejM+NKYE1Edo8mm1PLVceFH8KpzH+
	 JY6GMOqMOOu4eU3wWwlsGea/H6xVFrqvKA+DkOKqRajQ0bW5jwjz4qLLyMo+F3hfGuzIE
	 4/0PAVpKhpGO1fL+TnYxM+dqNtTdXcW8Dy23pGFKs5fM7BiYndPF/eeAwU+LqfFb8IBkw
	 ahn3atwCaoXqj673bxG6A4w2LxV14zVxZMIKKLJ47/7YksIsdhKHON2HNT+1hcG3QsIWa
	 XH/AYBlFNP92qT3GMP1tSwY4Octl2eJRxZg+T39RCoZxHvwGFMTXWGbWvSOnmYewS8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6jhDnSb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76446606A319;
	Thu, 22 Oct 2026 00:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y6jhDnSb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449C31F000C1;
	Thu, 22 Oct 2026 00:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792630206;
	bh=tPIulb5aO07nDBTsaR3BgvvSevctw9HTVGRwm+45BBI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Y6jhDnSbd58nzbJx+oMOkkI7/T/fH9b2uyehRG3iqcvaz30T/mNthQ2fHA4okQI1A
	 VSQrfSXB5X3QRAtC6MYexTLr1wjW3UPC0rCIv4Cl3DUVt44pgIRy7jNpjeLM/mc2zD
	 gp2h/xK6ewbfCLMIb1Nb/H0ge67z++6TcY4Uf+ow7vL55VPM9y1xQL+6/yQYzgJsW+
	 TVUctpTaZiH1kbQXz35oSmg8uE+fQSXT44dDlmTpqusICgmTueYtaNyAhv4pQAxpOX
	 f3vXANexMtUF7mbvRutm+6gn0DYF0MuiUYjDpbrmdzSMZ2t8jUtZ+FkGH2Tb5N/7TD
	 WLEAWkrPTRtMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A48D380A963;
	Thu, 22 Oct 2026 00:50:06 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Stop asserting for RTNL when closing
 channels
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179263020503.1386998.12592459643971579447.git-patchwork-notify@kernel.org>
Date: Thu, 22 Oct 2026 00:50:05 +0000
References: <20261020153659.3440902-1-tariqt@nvidia.com>
In-Reply-To: <20261020153659.3440902-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cratiu@nvidia.com, dtatulea@nvidia.com, gal@nvidia.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 mbloch@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Oct 2026 18:36:59 +0300 you wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> mlx5e_close_channels() has an ASSERT_RTNL() from the time when RTNL was
> required for closing channels.
> But the driver has been switched to using the netdev lock a while back,
> and this fired from a flow which was forgotten during the conversion:
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Stop asserting for RTNL when closing channels
    https://git.kernel.org/netdev/net/c/e0a958ddfc89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


