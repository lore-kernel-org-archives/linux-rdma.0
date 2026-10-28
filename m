Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793176825;
	b=KCLsl0NcBhphirpyYmCmB3BtUgeiqVIGnBRGii+rnQ8WcKVte7tKo/1OtWzjCoMnYHHn
	 jz+/sRBk/PgamQ4EKMWBF+C2tWFQd3u1BPNdcXNi/CfEQCN+bTRrK3L/R3Y0vJFgnFCQ1
	 f0K1dkX/lbE4M6LNgJsBrfj8U5OZw9Im0VZOWzrSijqA5LNqaOJ0lSSAWbvZUQhHO9WcR
	 JKDjCTL1ouqG5Vl4EuF2UKetd90nLcyujcjolawfgP+67yjHt3AgX6np1RI9hbgXjvhkn
	 BHtkrnxNTZeYzO4B3ddqhKHFw4VccW9A+0wa470umj75/V8kBUmndaXFx8QHjhHfeHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793176825;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=AQoKLK0VTNZUfDnVaHGdTm31mvIvHVHIkcGezc3xE3I=;
	b=KdNuP6gk298jnrqPiIruxxYYbbe7NKCnQsUK2kOBso/siFgYa1/+KXWASAf3rpk3AeaO
	 9PPm2nNs0BL7O7qwIbnnDZGxJ1K2LNihzRdqtQqG+CuYHY/NJJMtBCbTlbSKw9w3xeMO6
	 n//ud7yv8Unplz8xSVlS0Uk4MFvpzreglIka6U/hYktzo6MxFBTGDjlLEpoLPh72r7s8o
	 3Jm78EUP2moMkBCHFqDO5lbhaiKXXrdu3JQamDtS2TMXaKAxYBkG/ukHqtik0x+jIrue2
	 l4yd6OcBSi6sQsppNlTQ6bBQgA+Nl3AukQbfq0TLtv25texnWEOK3wqTKYIph06kmOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O/mS1o0O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07CD606A31D;
	Wed, 28 Oct 2026 08:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O/mS1o0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2DA1F01825;
	Wed, 28 Oct 2026 08:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793176824;
	bh=AQoKLK0VTNZUfDnVaHGdTm31mvIvHVHIkcGezc3xE3I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=O/mS1o0OMLuqq2iHL5XTiGaYdBwIg6NNhVM1OhnR8QlS9kMCswIwqX19qjNddYyKC
	 sifigods4UT59KvpQQGs3SdfuPs2lSPxcqAGXyVT3XgOcbOTBwA1z1IBvituTWy34I
	 vN6QhoAZNLNIAji2rBKbIByTb9NBKyiZ6ZPLFLPUhNq0TkINsCLq2gyexagUqHH3UV
	 zQjPDHpr/CmayWp89AmQkBS6qwxkdnlcHWbZH7iIClz+YgMdw1y7TsTkGrCMZTvGDx
	 cCYdgd3sM+/7MhpGUhjhQP8Gfly6yYyfqRCmh/5sOFyeIQNBKY2xlSt7ZS2iuNgOvU
	 HkjsIsimMbTXg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 815D93AA9F78;
	Wed, 28 Oct 2026 08:40:24 +0000 (UTC)
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
Subject: Re: [PATCH net] net/mlx4: always create the eth and ib auxiliary
 devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179317682332.583220.822272904304785815.git-patchwork-notify@kernel.org>
Date: Wed, 28 Oct 2026 08:40:23 +0000
References: <20261020164239.3808903-1-pdmorrow@gmail.com>
In-Reply-To: <20261020164239.3808903-1-pdmorrow@gmail.com>
To: Peter Morrow <pdmorrow@gmail.com>
Cc: tariqt@nvidia.com, leon@kernel.org, petr.pavlu@suse.com,
 yishaih@nvidia.com, kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, regressions@lists.linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>:

On Tue, 20 Oct 2026 17:42:39 +0100 you wrote:
> Since commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
> auxiliary bus"), mlx4_core creates the "ib" auxiliary device only for
> an IB port or a device that advertises IBoE. Before it, each mlx4
> interface was offered every device and decided in its own add callback.
> mlx4_ib_add() accepted Ethernet ports without IBoE and registered them
> for raw packet QPs only.
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4: always create the eth and ib auxiliary devices
    https://git.kernel.org/netdev/net/c/557d80138618

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


