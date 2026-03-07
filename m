Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D632E62B4;
	Sat,  7 Mar 2026 01:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847015; cv=none; b=VldhKurvub+0E4ylMYCZckKChow/mRrzRYMAMWMWmdrCi2+kYZs8vRMNfKbC7ziC655nNeWJFeDdD/B/BRzsJ2KxdtBX6HbBUdTOWYaKTiPMEcvpwz3ZF7+CeZQq9aNz4+tnSNuXaRpU8tBDL17OTwOw3Zjvub3BUwHcDnMx4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847015; c=relaxed/simple;
	bh=lg7CqisZQMDNUf6ZmH/FDwRfH1YnMAiipPwyZc4TmKg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZTfahtslxUuibZX3zrnVqpnf3/91U3cSO9AJLEN4iMhd1EVLdaFxECOv8rolOqcM2UMdk5ckMYJIsRUMdVCvAQjN5OSLYgk+Va1Zqj2GeeKaAH83fyDuIVQ0vPNAQiuluPz9KjINCRgR32pk2Oj4dDOBYcx9/Fly4oPiFZE384E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuGX7Sg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuGX7Sg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8004C4CEF7;
	Sat,  7 Mar 2026 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772847015;
	bh=lg7CqisZQMDNUf6ZmH/FDwRfH1YnMAiipPwyZc4TmKg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KuGX7Sg7r7agwGGw//kBYskR5LI/PRIQgkBJb2ycdmJU0IckgkcphRPz4pHB8q2Aa
	 YRGFWVnsaLeeWZHaw5S+Jp5Ni+f6yQGNKruUaHTJKlbGVOTsa3wmyGF2aUuWIeJYR/
	 F81e/46LiXZlpN/lX1l0Fd1i9uuw2ibuPMmvEU+/FeZmtsBD01h4B4dACN8rusbzmZ
	 KykAIWJeP2VcVmtfaV9T2VU6unZ7dkgH2C8H6XTLtsN+p9xXU3rwb5RZThSk5TRnHv
	 5II1bTboklBHUZ6e8vbCWo2XK0mx9PpIHwpRyHa+S6ISzA3d2z28SrbYi7TSket1xN
	 z6+3NJvP1DhtA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDCC3808200;
	Sat,  7 Mar 2026 01:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] mlx5 misc fixes 2026-03-05
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177284701405.117391.4093352917138384077.git-patchwork-notify@kernel.org>
Date: Sat, 07 Mar 2026 01:30:14 +0000
References: <20260305142634.1813208-1-tariqt@nvidia.com>
In-Reply-To: <20260305142634.1813208-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, ast@kernel.org, daniel@iogearbox.net,
 hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com, moshe@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 5 Mar 2026 16:26:29 +0200 you wrote:
> Hi,
> 
> This patchset provides misc bug fixes from the team to the mlx5
> core and Eth drivers.
> 
> Thanks,
> Tariq.
> 
> [...]

Here is the summary with links:
  - [net,1/5] net/mlx5: Fix crash when moving to switchdev mode
    https://git.kernel.org/netdev/net/c/24b2795f9683
  - [net,2/5] net/mlx5: Fix peer miss rules host disabled checks
    https://git.kernel.org/netdev/net/c/76324e4041c0
  - [net,3/5] net/mlx5e: Fix DMA FIFO desync on error CQE SQ recovery
    https://git.kernel.org/netdev/net/c/1633111d6905
  - [net,4/5] net/mlx5e: RX, Fix XDP multi-buf frag counting for striding RQ
    https://git.kernel.org/netdev/net/c/db25c42c2e1f
  - [net,5/5] net/mlx5e: RX, Fix XDP multi-buf frag counting for legacy RQ
    https://git.kernel.org/netdev/net/c/a6413e6f6c9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


