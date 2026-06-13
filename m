Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49914AD20;
	Sat, 13 Jun 2026 01:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781315411; cv=none; b=TAxciderQl/uwiExcbTNZZwKf5Unt/kGAHKWB40Q08p5GOWg/dVWMGprDNTVHMxh330OoSERV6bcuqRy+c1m/ae/0ZSHrDs3xPHwSgGLwPb1wLeonNoSx3mIc1XGz4Vtu68hgLgRbUosCAg4QrjX982BentSJ0/saP+KdpGen+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781315411; c=relaxed/simple;
	bh=Yr6S8fIgmX6vxEnD0wUnAAB0in2o/6zYLTND/bgmMnA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qtgIxJoTOODSFpMNdui/M7FnFzmd8ujEu0MMxfjldCcRt6PFbOw5u73GuWn5/p9rzoIzphLhfuZOI1uocEQBjO91PcdTAT6eLE5aHelX6dvgtw2l+SrOVkas2yt0Ipzs+5xDGKAmriu3QHrqUkWspcIvSB0e+Ds8Mc+OdINa4RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1tZq+35; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1tZq+35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6F11F000E9;
	Sat, 13 Jun 2026 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781315410;
	bh=jv21HSBAOpuW2iqSfNFVJWMIhwVLUAEqSkvvh5Xsn6Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=W1tZq+35Lb8/oV5V+jzTzzjhLxyaOI2qoCMADrDF916YiSZp/03HSPwKNuIAMP4p4
	 LHpkxW1SCNJ4/uN1neGlkGEeHFaV6BP1XX3EUyum9mEDMgYVnCU5XcMZtJCAJfN+1f
	 BwXu4q2oOs+zzbH33iEORclvO/Bzy926wqO2DujfgNL/7ul+VcjgvNbWfgmbEb0t1n
	 k4X+/kde7nFgDvsMfGwvgnKxRO2OxXWtMHDHMzJLbg9z78WMVZV+NYIYMXCbe/Kmzl
	 k5FBwZ1aZXJr7aPUtTPhIQ6lI4WITIQouuOZqgYfp8jm3yixYVX1KngL1LC/BDmLZq
	 dJbaA9/YADYMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1991C39E9607;
	Sat, 13 Jun 2026 01:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: Check max_macs devlink param value against
 max
 capability
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178131540664.1328827.1311821066255309586.git-patchwork-notify@kernel.org>
Date: Sat, 13 Jun 2026 01:50:06 +0000
References: <20260611135230.534513-1-tariqt@nvidia.com>
In-Reply-To: <20260611135230.534513-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, moshe@nvidia.com, shayd@nvidia.com,
 parav@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com, dtatulea@nvidia.com,
 ychemla@nvidia.com, cjubran@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Jun 2026 16:52:30 +0300 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> The max_macs devlink param is checked against the FW max value only at
> param register time (driver load) and inside the validate callback
> (devlink param set). The stored DRIVERINIT value persists across FW
> resets and devlink reloads without any further checks against the max.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5: Check max_macs devlink param value against max capability
    https://git.kernel.org/netdev/net/c/d7b0413b3571

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


