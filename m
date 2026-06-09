Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7A91B4156;
	Tue,  9 Jun 2026 02:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780970415; cv=none; b=W6fN32E0hvsIZ+rQ3mgof+qavawLzJpwRxRRy1UQQUaUw3NmMYpvvMi0lqTdVQ6cWwjMuLI4zu2UA33EoHCr6IQKjAPEzum58fAiKPR4Jb8nMFPMNOC2gc864iE2aj+cXkxUCuvOOid/NcEB6tKc08OHuST2eMyapT3AxBSicKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780970415; c=relaxed/simple;
	bh=iUTbxRnznwH9gCWzMJlJQNrfNL1EJPjuleZHkYlThGA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bdDjgCvsWDqc27hHIFrcR+V0F1TwDDQUEI6H7e+bv9ngD9//eagtqbsqKgr3PVxjgHeVTstai/uNcPU93LyJZQngkQA0CfzvLIDEJdRQrs1yDwvbzhyEqzIE+Rr1sZE+Qw/b6q9SDKLpGtm1w00e6awn/a64XAiK8XQPBiIIbFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvHC4PmX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvHC4PmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19F71F00893;
	Tue,  9 Jun 2026 02:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780970414;
	bh=hkiZ1au4GyhFFSxzneWq8O/zxJkYSkfkORdEmjww73c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=LvHC4PmXexYzSjF5Dj1uWTF1Bcp2geQ8zoAcNaiptuiP3Zj1y2XQfIxuaNUvT9r+g
	 nV16jR4D6RJfNorooncjON4+PZ8p8uHx1UPuRf2cpYyY+5gPT6+i1qnbhAOkeYdY4/
	 /qmkERSWy4jKCRBpqx+Mv7MBdX6fKwC5cDkKAmoPkfXaD4wy1oM5KYMiPColBs0Qq0
	 0lt9XGS2HpheKLzwcBjdLeRc4jvfrvaYPGgdVHq3kFtxTfUGVzc2xDGiLk8VXmuUi6
	 jbi/R2t2Qf9mqAJP0H2rtNmaVG5alzPueyN/cOM/cl5N2ndxSWvQc39n/bz5NiQ9ik
	 NOKputsEAEU4Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D098B3822D43;
	Tue,  9 Jun 2026 02:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: Fix slab-out-of-bounds in
 mlx5_query_nic_vport_mac_list
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178097041239.1753037.13513019286051160726.git-patchwork-notify@kernel.org>
Date: Tue, 09 Jun 2026 02:00:12 +0000
References: <20260604135849.458060-1-tariqt@nvidia.com>
In-Reply-To: <20260604135849.458060-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, ogerlitz@mellanox.com,
 saeedm@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com,
 cjubran@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 4 Jun 2026 16:58:49 +0300 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> mlx5_query_nic_vport_mac_list() sizes its firmware command buffer using
> the PF's log_max_current_uc/mc_list capabilities. When querying a VF
> vport with a larger configured max (via devlink), the firmware response
> can overflow this buffer:
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list
    https://git.kernel.org/netdev/net/c/894e036a24a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


