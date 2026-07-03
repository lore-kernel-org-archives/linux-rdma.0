Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415A2D5937;
	Fri,  3 Jul 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783097429; cv=none; b=YN7c3xOMSClO5s7t5lPBUYuIyCFoiPdX3Pm4gbVnvhzrGWHRcunTc1aw7egw9IO9CcvMxS6UoLEduMJlkD+61P1KVPNxy5CrZd33U1bGO0/zAyZYKmzPUXiTdCZqDFH3EphwzG/pQCixsNa66r7Vbf06YSCIJNKqCGd5bFfQX+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783097429; c=relaxed/simple;
	bh=RtRXNN/V0/X0eR9cUP2zfRsYDCjS2hjSq/47L8qXT0E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GtAmBCk3ZVvOPe9ujWTgTsWf0Hch+0usAqJeD54LQfZSW1neoUcju7mo9zxW/81U24v4hpprhj/fs0WowwNT0nznctu7TyORVNCoPsOBWY9ghfbmtl5GyGErI537w8jS7Xqe+m4xITS/Ngj1gneZl52SRQn9cgJPL1sHC0nhXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBiD/Bit; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBiD/Bit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9048A1F000E9;
	Fri,  3 Jul 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783097427;
	bh=WrF9vn0S3KoWGPkz3iUHZ+WnoOW53RPQRuaD93GH6vk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=mBiD/Bite7zNPhxE8kCnAS9CU9i4lU9tn8H+8A+IEc72CKcc6NtCXaGjM15hKFfNo
	 mp0FCyuxThyLYK0Ra7zmRLFmGBNTe4+IaMRndfi8VaCooeL+H/p6Bf0ysHl3Owvgay
	 srwX2MIXoabivUd8opyuHDyTm85p+nogZpv7y0PgQNFvxzjsbE44CKH44+FKslbQBA
	 pGMXxxwNbd0pToaIm5PLTz3hxeFgKWmf5sWRTKsSrMGAQy6VbUz41zZTi3VfRCYxOv
	 Qg+15oWgz9OaIcrunMWknbZV1bfmlQI6Qdox23ouW/3CUL6HQRvbrsTuiVcGVcfq0h
	 eSFT5OtzNom3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199B83939356;
	Fri,  3 Jul 2026 16:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2 0/3] net/mlx5: LAG bug fixes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178309740989.3239271.7935908979849887301.git-patchwork-notify@kernel.org>
Date: Fri, 03 Jul 2026 16:50:09 +0000
References: <20260630112917.698313-1-tariqt@nvidia.com>
In-Reply-To: <20260630112917.698313-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 edwards@nvidia.com, jacob.e.keller@intel.com, kees@kernel.org,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 msanalla@nvidia.com, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, rongweil@nvidia.com, saeedm@nvidia.com,
 shayd@nvidia.com, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 30 Jun 2026 14:29:14 +0300 you wrote:
> Hi,
> 
> Three bug fixes by Shay in the mlx5 LAG subsystem.
> 
> Patch 1 fixes an off-by-one in the error rollback path of
> mlx5_lag_create_single_fdb_filter(): the loop started from the
> failed index i, potentially operating on uninitialized state or
> double-tearing-down an entry that had already self-rolled-back.
> The rollback should start from i - 1.
> 
> [...]

Here is the summary with links:
  - [net,V2,1/3] net/mlx5: LAG, Fix off-by-one in single-FDB error rollback
    https://git.kernel.org/netdev/net/c/0f0e4ae6975c
  - [net,V2,2/3] net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
    https://git.kernel.org/netdev/net/c/d4b85f9a668b
  - [net,V2,3/3] net/mlx5e: TC, skip peer flow cleanup when LAG seq is unavailable
    https://git.kernel.org/netdev/net/c/7bed4af0ced8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


