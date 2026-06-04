Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB447261C;
	Thu,  4 Jun 2026 01:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780535688; cv=none; b=NtzEDyuupPG9zR/d3LPjC7fApKw4G/bzFTVKnFgBKXFuGbav3xQzlPI7lyRRt6Rz0Vpnd35WpqtE4fvECEPb3pa56Etu0wQByvKHwNo+QLtcZSt2IefhBUeFIOaSyE3PWgdlf3N/kneBZWKwEM6RS1maNTtRrFV0qFj6c8fec6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780535688; c=relaxed/simple;
	bh=H92A5F3Y4PPwZrikNlD0rPmhbJ71THMxDtNMzOKAPjM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jJOKvvzMjOfEQKW7jOlJm1QF7jdnWAjCS6QrNnkOYmPXUp887SI4cxwB2OtCsT0HNEOX26gdBA9JR0qnbqLcFbzBAnvOgtc5qTc9xnGbdvPjbtxOfre7uMS2uPEWYd7M8vy8G7SFTMcEiplXCorZt/790tRjPF788jevPqyV6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYS/K6FX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYS/K6FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F71F00893;
	Thu,  4 Jun 2026 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780535687;
	bh=kQm3UOnV22+XowSsIiRdNkGTe1tnxdkGrpnta/e2VwQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DYS/K6FXRmdGtD98dEiwVzdD8RkQnA+qgD0+MU7ZXTouQ45Aypb1YQ4nf3drsYgnQ
	 tHYHq21Y9WQDTfAJ8YrKgkpcKwwqUpWt+vH3CwzzSEWkxFWDHBa7PK2rBgY7Doms2x
	 vjqUS2AtfMj44BwKA0DGkfg9nDjbv3Bx+sr8PSLQx8HVlL3abdA9x/Dv/Z6Z5dSv+N
	 VnoIb9horDy3UFtSjS05Z4rjgWUK/LUyxt79/WE//8bAEWxX/nqdIuwwelPbXadFYP
	 msFRq8JJsuHdBkspXnFxO5bpJDmvinwyIH4Nr19+VkcqifolBB4LoJzQUZy/ARrTkx
	 32xphJbqf8rJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56AD039308DD;
	Thu,  4 Jun 2026 01:14:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 00/13] net/mlx5: Add switchdev mode support
 for
 Socket Direct single netdev, part 1/2
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178053568788.2042071.16264807430423613256.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jun 2026 01:14:47 +0000
References: <20260531113954.395443-1-tariqt@nvidia.com>
In-Reply-To: <20260531113954.395443-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, noren@nvidia.com, ychemla@nvidia.com,
 shayd@nvidia.com, ohartoov@nvidia.com, edwards@nvidia.com, horms@kernel.org,
 msanalla@nvidia.com, parav@nvidia.com, kees@kernel.org, phaddad@nvidia.com,
 moshe@nvidia.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, gal@nvidia.com, jacob.e.keller@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 31 May 2026 14:39:40 +0300 you wrote:
> Hi,
> 
> This series enables Socket Direct single netdev to operate in switchdev
> mode with shared FDB. See detailed feature description by Shay below.
> 
> Regards,
> Tariq
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/13] net/mlx5: LAG, factor out shared FDB code into dedicated file
    https://git.kernel.org/netdev/net-next/c/cf6c4c0508a9
  - [net-next,V2,02/13] net/mlx5: E-Switch, align disable sequence with switchdev-to-legacy transition
    https://git.kernel.org/netdev/net-next/c/b48b6308dfae
  - [net-next,V2,03/13] net/mlx5: E-Switch, move devcom init from TC to eswitch layer
    https://git.kernel.org/netdev/net-next/c/2b1ba02c379f
  - [net-next,V2,04/13] net/mlx5: LAG, replace peer count check with direct peer lookup
    https://git.kernel.org/netdev/net-next/c/2ca494dad967
  - [net-next,V2,05/13] net/mlx5: LAG, prepare for SD device integration
    https://git.kernel.org/netdev/net-next/c/14a47f55c8de
  - [net-next,V2,06/13] net/mlx5: LAG, extend shared FDB API with group_id filter
    https://git.kernel.org/netdev/net-next/c/3cbce590b7f2
  - [net-next,V2,07/13] net/mlx5: SD, introduce Socket Direct LAG
    https://git.kernel.org/netdev/net-next/c/3c103110835d
  - [net-next,V2,08/13] net/mlx5: LAG, block RoCE and VF LAG for SD devices
    https://git.kernel.org/netdev/net-next/c/8b9fffb6d38b
  - [net-next,V2,09/13] net/mlx5: LAG, block multipath LAG for SD devices
    https://git.kernel.org/netdev/net-next/c/c3933a7a7f64
  - [net-next,V2,10/13] net/mlx5: SD, keep netdev resources on same PF in switchdev mode
    https://git.kernel.org/netdev/net-next/c/8698ddb07f87
  - [net-next,V2,11/13] net/mlx5e: TC, track peer flow slots with bitmap
    https://git.kernel.org/netdev/net-next/c/786b1d7486b0
  - [net-next,V2,12/13] net/mlx5e: TC, enable steering for SD LAG
    https://git.kernel.org/netdev/net-next/c/9f062b931daa
  - [net-next,V2,13/13] net/mlx5e: Verify unique vhca_id count instead of range
    https://git.kernel.org/netdev/net-next/c/0b1c4495aa00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


