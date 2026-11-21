Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795221609;
	b=BMah5bNHHoZpTVJxb92g0vGRJXG19tpWf29/CQruui1SwWgrpJKpkcB2cwtnSeptthbD
	 wRfR0bbcdFH+KaGwemRMSyUhMZal7uE6qVx4qYBpOghy2BgmaRW7akPGcBc21NKK8VVt2
	 sHDA5PwqvNp6CSYy+livL21LPZuXhwkWIhdUKseHCtrPcWZyRWUzN5xByeyKPcSI4uzt9
	 2GAxL9TcOuY1zx8R0Ep/OhmYlYq/Eb7gp9ICNqZpcKkZl37eruxw4VdF3ip+RS3I9/0Yt
	 KixY5X1RXB77OdrCWnCzjqLqFMToo68KlB4HaaC3Eqo9EUqHeRrEBRvNC6e+mLm/RAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795221609;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=F0SnR5ogjRurN4enoGe12ZgjMu7/sT5ybH/hkV4/fio=;
	b=MHGzeRp5Y9gZKFqzHcz9msmIrRonkeDK4Yp+zRZQgSWmHMOrMDsxTZmijkpytlh5ssWh
	 MYPbAv4eMDAaM0mjdHQm/Ah/UGCEPA9dqFz5HyYugDpN30j0Y2chtAUyslecV0mlCoVQf
	 nTRObxzD+4jVizLcu7LaKEZ+JJTERBEofaAWzxSbLM1dI2J6Et5fR1YTY3f89QLtzkIZQ
	 8dU54lut2Uz5+MdgOrNe24nM45Ns7XFJvrVLkiWq6FMpl6T18hqqRcAzfpZdX+uF/CPqB
	 7Eu+7/0fLLFG3KN1xTYyQaeXKyr6mcaPzvnkvdB1n28mLp6euQYqUeREQULBZYqlcPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmQAehc5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEDA606A6B0;
	Sat, 21 Nov 2026 00:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmQAehc5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE2B1F000C0;
	Sat, 21 Nov 2026 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795221608;
	bh=F0SnR5ogjRurN4enoGe12ZgjMu7/sT5ybH/hkV4/fio=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=UmQAehc5aharjI2x2sJrQGEMto8RQ2eHL9zGMZ1aHU9roxdKfhk53eIYG/pVvr4l6
	 M/nw5qd1KQFT03adf67lMicpMDl8O91x15W9/f3oRRsZP5Ffl3hC96u3bcquNVIdsr
	 +/2pTXDGwgtW04br4X4DpZKPR86vxYNL7rQDPkHwFrg1rb0zTMe004M0RxQNwye9eY
	 NOifinfyCMAa/Sku0gbt7PkIuxUc3IFC+IUFi5D/G0Pzmy1HWPC9FrMGllQcmkEjCi
	 66Cg4yFluiLtE8EkxBDmX/PrpRXAZtr63o43wR1avfGilIGVyY4QDf15GgiflLb5EI
	 VkugKmh7jgTuw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B43EC380AA4D;
	Sat, 21 Nov 2026 00:40:08 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: Release FIB event work flows before
 dropping
 RTNL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179522160728.860209.2078425140293366542.git-patchwork-notify@kernel.org>
Date: Sat, 21 Nov 2026 00:40:07 +0000
References: <20261118143653.1915247-1-tariqt@nvidia.com>
In-Reply-To: <20261118143653.1915247-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 dlinkin@nvidia.com, fmancera@suse.de, gal@nvidia.com, idosch@nvidia.com,
 jianbol@nvidia.com, kuniyu@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 razor@blackwall.org, roid@nvidia.com, saeedm@nvidia.com, vladbu@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 16:36:53 +0200 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> The FIB event work, neigh update work and the neigh stats work all use
> flow->tmp_list to hold the encap flows they work on, while RTNL is what
> keeps them from using it at the same time.
> 
> mlx5e_tc_fib_event_work() drops RTNL before it is done with its list.
> A neigh work can then take the same flows while the FIB work is still
> walking them, and the two overwrite each other's list.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: Release FIB event work flows before dropping RTNL
    https://git.kernel.org/netdev/net/c/bfccb4e44e47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


