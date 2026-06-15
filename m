Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2366C3AB294;
	Mon, 15 Jun 2026 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781549442; cv=none; b=OWdpzolzDY+75jrF15s6PVZyaXSgAXZaPXdflG+HxjT45rQJ9rszLiP7rUnyTJBUFiO3JzocqdPwUJJBe3RZqXaFidlO3klqYDZsyC047PjGpNZ9VtzwDLeQnhphbkF/JkJ3ZY1GB9bqFeOss5IUTXptsU1W984QNEpxysmGhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781549442; c=relaxed/simple;
	bh=Ug8ZP4OBqA1oZ3Dvhxb0xU8a/MfhAew0XbEcGtLPvko=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rE44WHvnueLJVfVFrIYt9YtMVlQAigF108oy/fSo27NHRisjHP3pq20N/VTvVeKyE8Gx/udPFobEqi3m1Hjn10WTSZBrjqzmxNtBY13RXiJkb6jnVViJHbUOrCNVMX6eHAcj3tSL0fJT4yT5P5Cebzsq/8f9SOeFZvWt8xCE14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHhWr0QO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHhWr0QO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0514F1F000E9;
	Mon, 15 Jun 2026 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781549441;
	bh=LNHX3r/9VU1VGfFBkQvGX1PcR0n8q+2QC9RgeUF7Abw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=QHhWr0QOYrBoCfPEVcAb4PDmk7x1qzyOYV42z+8dCUKxjodT0A59rT55mmduYBKCF
	 r79oD9jPiXt9A1fGX7EpmVLLN1GVz7cLk2YxV5gGZK0Seh1diEKAm64brZNm+mRC2/
	 SBrGroDHerbRInjvqj8LGgpCSuwKaac+7fdbLf6X41YY5C4P8aAVhO1xqzGB4NS9tM
	 0RAgTglbOMMtGUB0ymCBlY9FAfqVmgHYNo37yfK2+sK53rbgQ/jdobhAP+B7pRckm+
	 GDE5Be6ulSH3UfruJfPgBShZV+rOqtUA+5aShlIA+OHUHI46ZoGJ6f4Ub7wDCj641X
	 nWDphQpwwfx8Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A263839A06;
	Mon, 15 Jun 2026 18:50:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 00/15] net/mlx5: Add switchdev mode support
 for
 Socket Direct single netdev, part 2/2
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178154943614.246883.11702954511746985272.git-patchwork-notify@kernel.org>
Date: Mon, 15 Jun 2026 18:50:36 +0000
References: <20260612113904.537595-1-tariqt@nvidia.com>
In-Reply-To: <20260612113904.537595-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, shayd@nvidia.com, ohartoov@nvidia.com,
 edwards@nvidia.com, msanalla@nvidia.com, horms@kernel.org,
 gbayer@linux.ibm.com, kees@kernel.org, moshe@nvidia.com, parav@nvidia.com,
 phaddad@nvidia.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, gal@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 12 Jun 2026 14:38:49 +0300 you wrote:
> Hi,
> 
> This is part 2. Find part 1 here:
> https://lore.kernel.org/all/20260531113954.395443-1-tariqt@nvidia.com/
> 
> This series enables Socket Direct single netdev to operate in switchdev
> mode with shared FDB. SD single netdev combines multiple PCI functions
> behind a single netdev interface. To support switchdev offloads, these
> functions must participate in virtual LAG (shared FDB).
> 
> [...]

Here is the summary with links:
  - [net-next,V3,01/15] net/mlx5: E-Switch, skip uplink IB rep load for SD secondary devices
    https://git.kernel.org/netdev/net-next/c/597baeb467d8
  - [net-next,V3,02/15] net/mlx5: devcom, expose locked variant of send_event
    https://git.kernel.org/netdev/net-next/c/95e26588c84b
  - [net-next,V3,03/15] net/mlx5: devcom, add DEVCOM_CANT_FAIL for non-rollback events
    https://git.kernel.org/netdev/net-next/c/d5e77e4d3023
  - [net-next,V3,04/15] net/mlx5: SD, make primary/secondary role determination more robust
    https://git.kernel.org/netdev/net-next/c/4b918a198389
  - [net-next,V3,05/15] net/mlx5: SD, add L2 table silent mode query support
    https://git.kernel.org/netdev/net-next/c/13158554a302
  - [net-next,V3,06/15] net/mlx5: SD, expend vport metadata for SD secondary devices
    https://git.kernel.org/netdev/net-next/c/a1bfe9f1da83
  - [net-next,V3,07/15] net/mlx5: SD, support switchdev mode transition with shared FDB
    https://git.kernel.org/netdev/net-next/c/2a3fb8b2f450
  - [net-next,V3,08/15] net/mlx5: E-Switch, notify SD on eswitch disable
    https://git.kernel.org/netdev/net-next/c/232de72bdea2
  - [net-next,V3,09/15] net/mlx5: LAG, store demux resources per master lag_func
    https://git.kernel.org/netdev/net-next/c/eaaf1ff178a0
  - [net-next,V3,10/15] net/mlx5: LAG, disable both regular and SD LAG on lag_disable_change
    https://git.kernel.org/netdev/net-next/c/ebd629e70045
  - [net-next,V3,11/15] net/mlx5: LAG, introduce software vport LAG implementation
    https://git.kernel.org/netdev/net-next/c/98d56915eef5
  - [net-next,V3,12/15] net/mlx5: LAG, add MPESW over SD LAG support
    https://git.kernel.org/netdev/net-next/c/de464720489c
  - [net-next,V3,13/15] net/mlx5: E-Switch, Tie rep load/unload to SD LAG state
    https://git.kernel.org/netdev/net-next/c/68c2dd59a6c7
  - [net-next,V3,14/15] net/mlx5: SD, defer vport metadata init until SD is ready
    https://git.kernel.org/netdev/net-next/c/e3a02f3ecb13
  - [net-next,V3,15/15] net/mlx5: SD, enable SD over ECPF and allow switchdev transition
    https://git.kernel.org/netdev/net-next/c/7bcfb19465fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


