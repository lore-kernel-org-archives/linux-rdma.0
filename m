Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59F64772B0;
	Thu, 23 Jul 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820661; cv=none; b=lWdy0n8ZganmNM+sb4qZNgO1aQQtGkvAeK4eQKiB/240QMlA1JEje3yOrvgA30u6q4Bolt1PI9RNWbkBomf3AnU4YtAjucsM2E0x/kM365IlhZDf/VgfFGWxLd/bUC6if46lk0T6TrQbRAJp5ueXWkCxvlkaguvUB6DdRCv6iG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820661; c=relaxed/simple;
	bh=zNWPol2Qz8LevKN/KHLTxnV4YdsqO3VTTiQ/gxycnC8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ad8rjyiErKIq1sIUwvFCf/WCLJ+bmiYZB61kWO50IY+eAIaBfHF2y+YO2+1jFRAXn2zVqltWMO0wsiwqAUfRyPt0QWSbMwtOUZnD5YkK8n4mOygiFtE8kKa0Jm4Z0joj17n2dFK2xSrP2W/0sOnTko47UJGecHkT27EadQl6bWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46F51F00A3D;
	Thu, 23 Jul 2026 15:30:57 +0000 (UTC)
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199753924454;
	Thu, 23 Jul 2026 15:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V2 0/2] net/mlx5e: Report zero bandwidth for non-ETS
 traffic
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178482061964.2321119.3970363391032813561.git-patchwork-notify@kernel.org>
Date: Thu, 23 Jul 2026 15:30:19 +0000
References: <20260717075125.1244877-1-tariqt@nvidia.com>
In-Reply-To: <20260717075125.1244877-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 alazar@nvidia.com, cjubran@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 pavan.chebbi@broadcom.com, saeedm@nvidia.com, gal@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Jul 2026 10:51:23 +0300 you wrote:
> Hi,
> 
> The IEEE 802.1Qaz standard restricts bandwidth allocation percentages
> to Enhanced Transmission Selection (ETS) traffic classes; STRICT,
> VENDOR, and CB Shaper TSA types carry no bandwidth semantics.  Two
> problems exist in the mlx5e DCBNL ETS implementation: the get path
> reports 100% bandwidth for all TCs regardless of TSA type due to a
> hardware limitation, introduced by commit 820c2c5e773d ("net/mlx5e:
> Read ETS settings directly from firmware"), and the set path does
> not reject the unsupported CB Shaper TSA, introduced by commit
> 08fb1dacdd76 ("net/mlx5e: Support DCBNL IEEE ETS").
> 
> [...]

Here is the summary with links:
  - [net,V2,1/2] net/mlx5e: Report zero bandwidth for non-ETS traffic classes
    https://git.kernel.org/netdev/net/c/ffb1873b2df1
  - [net,V2,2/2] net/mlx5e: Reject unsupported CB Shaper TSA in ETS validation
    https://git.kernel.org/netdev/net/c/9173e1d3c7c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


