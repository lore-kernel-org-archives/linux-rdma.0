Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D59E3033F8;
	Tue, 29 Sep 2026 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790643085; cv=none; b=eY3c3x/Dy5nOLzyYizjVGwEF6OW0pUf94a+hxQX9OebbMXtXmOjynjuxbsEhGPEXa7bWG4f1nYi1zdK80s1jkTS70rREctm/QfwU/xprVaQRTstiXwlpCWPX2cBGpVgtm7PiyzHIxG+nqCF7+2YCZUJZ44is+BRscqxUu7r9C60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790643085; c=relaxed/simple;
	bh=9zLMEPG584Y7bh3D/qC3hXjpO2FGIYZOrrBno6vBT6Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FRSFpGz7id7pq8oyhuTYJB1XZnaCbmx58T4iE4EX3LaXWZWEIwra7LiTbLtj1XYV6yIy82bcqDYRDlsjH7soMQ0AvQD8QQZScLmVrVYDMIa11J6lWdVVCIIxMSXzVUalGZpymPVL2OANS5DYDybD5OevchPkdRSb/jHyb99Z/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0gS68Zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0gS68Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806701F000FF;
	Tue, 29 Sep 2026 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790643081;
	bh=H9mpT0HE9q8DiJPAQ5twcQri/K96Tv+PAKdnKVAxynM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=K0gS68ZgY384JnLb6tANPoaCKK0bRq+jA/Wnrzqu24OCvA5WB83xHpBxbu/tX74Cg
	 KgxOzUL0WF9VKm3EuVvlYvI2lzdMFg3j7VXw+EixbGQyN3ljTi0A0CxedViLYP4IQ0
	 VZOtY51pkYZP7fNolYgBBGqWfyAX4Ejk/rPeZ7bUUm2+Auk+46T8aSJ2TOSQLemSpd
	 QI/AI6AFGFb+ieXMEFFh7qsqBc+bhnykMjRPbDbRqY2zi7UPOvYFpZjQmBCb7kdLqL
	 a0mJe3oqCpvpNF4x2Fc9T681WY47m1mRydUDR7PSk8vadNfI6UdcTH1YsKkktMcbK4
	 CJbPb2TdC9YLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198A63924FE4;
	Tue, 29 Sep 2026 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/mlx5: Fix slab-out-of-bounds when handling
 team
 device events
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179064300590.197842.2925585054105917183.git-patchwork-notify@kernel.org>
Date: Tue, 29 Sep 2026 00:50:05 +0000
References: <20260924064244.94045-1-avirdi@redhat.com>
In-Reply-To: <20260924064244.94045-1-avirdi@redhat.com>
To: Anirudh Virdi <avirdi@redhat.com>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 shayd@nvidia.com, ohartoov@nvidia.com, maorg@nvidia.com,
 linux-rdma@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Sep 2026 12:12:44 +0530 you wrote:
> The mlx5_handle_changeupper_event() and mlx5_handle_changeinfodata_event()
> functions check for LAG masters (which includes both bonding and team
> devices) but only call bonding-specific APIs. When processing team device
> events, calling bond_slave_get_rcu() and bond_is_slave_inactive() on
> team_port structures causes KASAN to detect an out-of-bounds memory access
> since team_port is smaller than bond slave.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/mlx5: Fix slab-out-of-bounds when handling team device events
    https://git.kernel.org/netdev/net/c/04c824940d52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


