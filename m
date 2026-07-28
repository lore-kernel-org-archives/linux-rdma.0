Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C769283142;
	Tue, 28 Jul 2026 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785202249; cv=none; b=DPZBt1LdA1CUeZNZzsdL3smor1p8KDz4gVP8FZCN3DJGP7zfaM8mQWLVhtnadupLnESnYlxJa68eggn8OSqvPTreKjZIhyQbHuhyquVAbnipGy3GIrjSikUEsHgdeaTjLDy1xU/fqlJi49KKuFQ9Q5gAdoF4T78zVjNLp5zUGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785202249; c=relaxed/simple;
	bh=GsSwk8gLfgqMhrJ4pQbYQe0Jk3831A/IyhXKnNEpYw4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=j3jWcynXy7wL7XwxaHrhA5hdNBcDqb3D3bEWgpKFGqDNoUqozk1X2rpX2wB8gX+WITMUM4pZ3PqHr4UKjoIeUgasjUktD3HojsD8Kxk9rxB4qjHburEFQpHox/hA3fIpvqh1YoShJ8NOWd/tF95eMFmT16EoWeDltraKLh7M0Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkf0ljlt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkf0ljlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD37A1F000E9;
	Tue, 28 Jul 2026 01:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785202247;
	bh=mjzvzo8zQF6cVCoi0/oCkEXvvlWs6xdMYzaSwEHT7eA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=gkf0ljltKS56q1tKo3NuTT0+rZJ1VxPkQyNUgW1DKhXj5q2vRhM3DnDK0wTVK6cNv
	 HZrqKpfk8SHZZcU3LVkje+iIz+KndFPahTLXUgpV015rTobrK9N5SUHnelmJw5vJhj
	 rCLeavwmg+5PBGznw5ggOPWCsRGV9Vhf+wCO/oBJEbnPvdAgLYt12iL9xwg+n9xriP
	 SIYs7/KiX7uIY7LYyAEJX/PFMOUP0jRgsLMXlX02L+SRVpcxRAit8lOCuZjYN+daBq
	 oDmn/T65vG4ASgvrTcCtVfkdqqaUP3d38t5R/faUDeSza2MO1LbZz2z0/nq8h303jm
	 v26qTXzlZjbPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19707380CEDA;
	Tue, 28 Jul 2026 01:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Remove _once from PCI heuristic debug
 print
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178520221263.1492617.6163508154592529107.git-patchwork-notify@kernel.org>
Date: Tue, 28 Jul 2026 01:30:12 +0000
References: <20260723081743.1868357-1-tariqt@nvidia.com>
In-Reply-To: <20260723081743.1868357-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel.zahka@gmail.com, dtatulea@nvidia.com, gal@nvidia.com,
 jacob.e.keller@intel.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, nathan@kernel.org,
 raeds@nvidia.com, rrameshbabu@nvidia.com, saeedm@nvidia.com, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jul 2026 11:17:43 +0300 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> The _once rate-limiting in slow_pci_heuristic() is unnecessary because
> this function only runs during probe.
> 
> Worse, it interacts poorly with dynamic debug: if the first probe
> happens before dynamic debug is enabled for this callsite, the _once
> flag is permanently consumed and the message becomes unreachable without
> reloading the module.
> Additionally, only the first probed device values were printable in case
> of multiple devices.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Remove _once from PCI heuristic debug print
    https://git.kernel.org/netdev/net-next/c/e4213520e976

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


