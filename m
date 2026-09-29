Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1C923EA83;
	Tue, 29 Sep 2026 00:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641286; cv=none; b=HqfSGjaFiE1lbFpFJcB/7w3N8zoetzg7JLcGVbU5P2YiiO/pZG54RZYsKhlVyXH4akd4ekoYQiAccFsKlBpRs0kSYMO/Abk0o0F8IyAPc2UGrjeayWGuDkizrJuZNIpoTPbXd8CBjqmc6NFiAFUSTSAKmPpwzOMCkcY6eAykCGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641286; c=relaxed/simple;
	bh=DKhFCEKhl1X7+xRAz3V5rr5PfVYofXi/eW6olyIRS6Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=I0K7yn83SE1ki9e/3Yq3XhAF3Ktxi71SKgZ/YVASX1YoQnEFYU8ZgxlGoNcrf0JWC21jI0rkXEtqtrJnuIWTLiH78ocKf4Xl13QRIBzi2oKHTCePLQVPiEUPikU4+6Zf4Dq56Px12mspM5mTjK/cxtByoedmdNJ1P6L7BGCbUe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBgtKR0l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBgtKR0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A711F000FF;
	Tue, 29 Sep 2026 00:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641283;
	bh=zQQvQv3q+e1IetBEA7huO6RsZ59E/pUsOM4PcqfIOyI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jBgtKR0loxmNSHr+Dm6lXZgMlre1AMQcgQx11Z7tZPE4gEJv2jzlDCotA2kqdGyzk
	 XjW4KrjDjmiEkkydPYK3AVGBzTlfh1jwzLDhRsBXBITriep7DOOAh7ghEIYnch/wGl
	 0yPre0Kkr3ZwtthfES7/SsStKPTBIoHfVht8YLbaDQjXpwImw5hnN+JXobSgVgKG4P
	 LFmJ2VY6bTh72i4qQJhblUBKXC9CbByH/XW+M23iFY07ucymee7bh0PTt3cU0x4ua3
	 9ayPovNh4A9eIWkE9S4yiVwI1Yn/H+TjJEsa58vnqsixq3q9ypa82u87HUO4bF8U/l
	 Z5r/LA9av2jwA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A213924FE4;
	Tue, 29 Sep 2026 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/13] net/mlx5: Preparations for nested E-switch
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179064120790.188287.14668641337564861331.git-patchwork-notify@kernel.org>
Date: Tue, 29 Sep 2026 00:20:07 +0000
References: <20260923103830.1183-1-tariqt@nvidia.com>
In-Reply-To: <20260923103830.1183-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 agoldberger@nvidia.com, cratiu@nvidia.com, gal@nvidia.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, ohartoov@nvidia.com, saeedm@nvidia.com, shayd@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Sep 2026 13:38:17 +0300 you wrote:
> Hi,
> 
> This series by Shay has two intertwined goals. The first is to remove
> the compile-time MLX5_MAX_PORTS sizing from the LAG and eswitch/TC
> datapaths so that structures scale with the actual number of ports/peers
> rather than a fixed maximum. The second is a set of small,
> self-contained fixes that prepare the eswitch and LAG code for a VF/SF
> acting as a nested e-switch manager - a mode new FW will allow, where a
> VF/SF has its own eswitch and the VFs/SFs can be grouped by MPESW.
> 
> [...]

Here is the summary with links:
  - [net-next,01/13] net/mlx5e: Assign a random MAC to any netdev with a zero MAC address
    https://git.kernel.org/netdev/net-next/c/cfda5de64053
  - [net-next,02/13] net/mlx5: E-switch, do not leave an unpaired devcom registered
    https://git.kernel.org/netdev/net-next/c/11dac22ca063
  - [net-next,03/13] net/mlx5: LAG, allocate v2p_map dynamically
    https://git.kernel.org/netdev/net-next/c/d9f3227f673b
  - [net-next,04/13] net/mlx5: LAG, allocate port-indexed scratch buffers dynamically
    https://git.kernel.org/netdev/net-next/c/4138820bddda
  - [net-next,05/13] net/mlx5: LAG, drop per-port scratch array in drop-rule setup
    https://git.kernel.org/netdev/net-next/c/fbc4f422c5b8
  - [net-next,06/13] net/mlx5: LAG, size debugfs buffers by port count
    https://git.kernel.org/netdev/net-next/c/6c244dd5ba6b
  - [net-next,07/13] net/mlx5e: TC, anchor peer-flow reverse index on the duplicated flow
    https://git.kernel.org/netdev/net-next/c/675956237b38
  - [net-next,08/13] net/mlx5e: TC, track peer flows in a vhca_id xarray
    https://git.kernel.org/netdev/net-next/c/9d608a40c2d4
  - [net-next,09/13] net/mlx5: E-switch, derive manager vport from device capability
    https://git.kernel.org/netdev/net-next/c/d451adde0203
  - [net-next,10/13] net/mlx5: LAG, don't print port mapping to debugfs in MPESW mode
    https://git.kernel.org/netdev/net-next/c/c51ea6db00e6
  - [net-next,11/13] net/mlx5: LAG, drop stale esw_shared_ingress_acl gate from shared FDB
    https://git.kernel.org/netdev/net-next/c/66b25da0cfed
  - [net-next,12/13] net/mlx5: E-switch, correct stale VF/PF wording in esw-allowed comments
    https://git.kernel.org/netdev/net-next/c/dd655b1e93c1
  - [net-next,13/13] net/mlx5: E-switch, disable host functions for a non PF e-switch manager
    https://git.kernel.org/netdev/net-next/c/a5bfbdfebd53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


