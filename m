Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510009;
	b=2LqlyLxkz5XWaDiIxuivuGEZS5w2vp2thg0rNR89zTOXAMFIg9BYIneSVhXLgxSK2jWA
	 kMaEfQZfRhBgvNaW0trpbYfz2Rb2MpF3eorYH7hi1LahdsNsDsaqnW4FBrhg69ZckEcYX
	 LgvndctbTrsyE4+uIs0JXDO+ARwIhXt94xv7WFQFXffalSstfgxaLwQwA2ALKTuucw6HL
	 dE57T0fcJmnfo1FiNE0HB24BB1FtfccRBILY8HdLt1cG32NrOkd0R3OpZhQUEmrFTk12M
	 qrk0FUZWueuKp8HqD1mCi7st1mhNO7MNy/5qR/kNTinAW1UCs4fM1/HesuuyY4eDr8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510009;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=7YTH93u38oQ8QNw98PRHN1c5en4J1Tms4ZHbVUovza0=;
	b=GAHcghRQNXFDj2uGo/XvyT5wPCjoBc9TZgTN4RrIsWkWFxS6dklHEb91Wa1m/UqGthvo
	 Tw7bs1vc4N5piuA783TZFYOPCCFkfwH6raaxXaMDjL0IguiJ8gqLKeXKxRw7WVAEcGn5Y
	 PjQGeGx1ypRzxKCxcButi8IvO4Oxsy/xdWzmD6ruEqtVzovRZ3oJ86q72mUh3kdpCcF6C
	 gWLC17qOJE/KazsGEJsilNhnkVtNyinJ0HJQcTHHjFKXtGRNHGUgWum4H8/1Je3+0j263
	 isoOlP1xla94sOCZXE6SJQa1b1ccGC5/qtN7gD7ZCMpjvgDKFmJFcNBdILsB57odjSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXeoTvW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D1606A88F;
	Thu, 12 Nov 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXeoTvW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26D91F000C4;
	Thu, 12 Nov 2026 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510009;
	bh=7YTH93u38oQ8QNw98PRHN1c5en4J1Tms4ZHbVUovza0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=nXeoTvW8U87/8SqeAA08lThp6h9Z4f7VeoI5tOU6qvO1OO57XaYCNWm0fegl77DS9
	 pFrVWPLuMfNYwrMYLo7P4VrhoEiYtuN5CZWy8Qg3ucV0r1uNFWgzrrorxtpBw5ZwOs
	 FtwGGssacguLwpZfhPahNq0VKSflkjAtkTstiKAVICUhDO745KEoUe2li69RvZ6Ep6
	 GGcRf0qd1UvLXD0W6gSfEg07y3q9lOn6lB4TUcG3498jnEcY1rdV4zTzjU95DWjPee
	 GV7hSPaewv54nRk+8uBZ1MqJ0f1TPG/HLjhCVpWfUz2T+d9XxkZVfEujwu/XImHucs
	 3kSKn6E51rs3Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id E51053924A5F;
	Thu, 12 Nov 2026 19:00:08 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx5e: IPsec,
 don't match upper proto selectors in crypto offload TX
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179451000753.594620.15896228047491336264.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 19:00:07 +0000
References: <20261111081337.3129580-1-tariqt@nvidia.com>
In-Reply-To: <20261111081337.3129580-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 parri.andrea@gmail.com, borisp@nvidia.com, cratiu@nvidia.com, gal@nvidia.com,
 leon@kernel.org, leonro@nvidia.com, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, phaddad@nvidia.com,
 raeds@nvidia.com, saeedm@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 Nov 2026 10:13:37 +0200 you wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> The mentioned commit introduced support for upper protocol selectors
> (protocol & ports) to mlx5 IPsec offload. In crypto offload mode this
> causes offloaded TX SAs to stop matching traffic.
> 
> In tx_add_rule(), setup_fte_upper_proto_match() is called for all
> offload types and programs a match on the upper protocol (TCP/UDP) and
> ports. For crypto offload, setup_fte_esp() is then called and sets
> ip_protocol to ESP. The resulting rule requires both ESP as the IP
> protocol and TCP/UDP ports, which no packet can satisfy, so TX crypto
> offload silently stops working for such SAs.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: IPsec, don't match upper proto selectors in crypto offload TX
    https://git.kernel.org/netdev/net/c/5ed47bd79ceb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


