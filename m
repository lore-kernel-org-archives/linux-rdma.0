Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B788740801E;
	Wed, 14 Oct 2026 21:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792014007; cv=none; b=mm+IhKNoyjP9iC90qvF70Fosxqait3CWQokOBtv7iFujuC4qWWDjXGZoMqxg33ZH9ReuYE56l3X+A6d/L8nzj4AbXtX1n/qCyGwXzVLOifFs3igI/RLBrxJclnJlr6APl4WxYAP7MJ4MbfKsgf06CP2CdyycaEO9k+sSC9ORps0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792014007; c=relaxed/simple;
	bh=h+9Ctl4ivyuuCrvWdiFJ1KOVVH68xlr7C+eEtCx2Zvc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=J3n9zqfOVhs4P8rV+sVBPl05MQW9dZOOmOkYSe5wx26MHWjWuY4rZDBOJ2Uf3rhQP/z+YuhkB2nHdrUaWBQIUkmea07rdc1hoK6ZX2ak7B4JZo5FoutVOP+8XyWtB+q10UNoznde4mAgHm1sq/mSkoEi1BBT8YukPE+Z/XqaWJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEqnW0jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEqnW0jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A0B1F000C4;
	Wed, 14 Oct 2026 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792014006;
	bh=MHXeb0vXLdnW9/JmwDK3OUmF9m3u5QpIN6VrE7BO30U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=WEqnW0jD3CDKzk3yyPkIENurtJb9u8+7v8LlYYTkhdBRxr/2gkDUhAEBBqQp4E8xu
	 +HIh91vYH+zfKfHaws/cpNrK+ULUVi+CXOf6V70q+aUVIeOkeazLh8pE8xC709ibUv
	 cpj2owkVVgbfK4ieN2QHTb6cd3QVZbtFH5rdtYzhs7alrXvnca8nzOG4DaO4JPnpG4
	 WX/hVErhC4xFhZJubFngDYKhq5HPuh9qq6WF9Hblj07ScGv7oAqBCmFAhE5uSlTDs7
	 DIV/qH5FkBcB8VSt/voFn7ykplx/lDaOIEjfp+dnnmzwIXaNLEpXvI81B5YuARnZPS
	 m8KyBhCCSBrug==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A4313803318;
	Wed, 14 Oct 2026 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: use skb_share_check() in loopback
 selftest hooks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179201400467.3009952.9047387445003414493.git-patchwork-notify@kernel.org>
Date: Wed, 14 Oct 2026 21:40:04 +0000
References: 
 <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
In-Reply-To: 
 <20261007-nb-net-selftest-shared-net-v1-0-458369bfa1ba@tipi-net.de>
To: Nicolai Buchwitz <nb@tipi-net.de>
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, o.rempel@pengutronix.de,
 maxime.chevallier@bootlin.com, andrew+netdev@lunn.ch,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 Jose.Abreu@synopsys.com, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org, dtatulea@nvidia.com, alazar@nvidia.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 07 Oct 2026 20:29:21 +0200 you wrote:
> The loopback selftest hooks can get a shared skb when another handler
> is bound to the device. Linearizing a non-linear frame then hits
> BUG_ON(skb_shared()) in pskb_expand_head().
> 
> Stumbled over this on RPi CM4 (bcmgenet, with jumbo series applied +
> WIP selftest patches) with a packet socket open at the same time as
> running ethtool -t.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: selftests: use skb_share_check() in the loopback receive hook
    https://git.kernel.org/netdev/net-next/c/fbd3a301b137
  - [net-next,2/3] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
    https://git.kernel.org/netdev/net-next/c/a7a89019bac0
  - [net-next,3/3] net/mlx5e: use skb_share_check() in the loopback selftest hook
    https://git.kernel.org/netdev/net-next/c/16fb7aa6955a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


