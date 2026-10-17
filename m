Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E61348C6D;
	Sat, 17 Oct 2026 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792198210; cv=none; b=qCpRqvJhDk8moNZ02IAm3PNza6+3AlALyBHDMtk7Y4XoKlF3kes5l7vg835zhaRVpIxPUXl31iO+xHwsJ1LY41vOvpkvJXSEwxVoxju5aErWVSjVhYP6KGOyumfgpI3WagXss/MNugsfdPVbdFfmGav2Gtu73M4hQ8x7RQqOILI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792198210; c=relaxed/simple;
	bh=1qSj9AdeOvJHtZ3iji0ycVMezgLkw75O/fD7QSs8udo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=auh68p0PTEA67NvxkHfPCOTStsfNwixTTlPZ4z4JqEHTI9fU+Xlaj3EgQvSOQmTvtg4ngBaGMMeH9Srf56HjiS+mAEDW7Jij1nmssT1Zr7JGejwoI/B2Qdc+6S6vxQyAcMVM0nYIZhC7ZJ++LMQK21FVGql8QKFuE2HxBC5//LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hulqz7HY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hulqz7HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8229A1F000C4;
	Sat, 17 Oct 2026 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792198209;
	bh=9uOckY0UlP+Vue2nHG2jzq0onozdg0VelGYZKs/zUDs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Hulqz7HY9chl6B7AcIMC72lVQiTtFOCfySS4l14gQR/f9GdibVUlQTGxVIcWUxkEu
	 7wB/59Dn2chZMnDZ+sWWkqkvJjPZQ6MBB9PHLYC34HuW1FnCnhVzq37B6NqDN7iIvK
	 lqM5dC8tUJE59WvcfphUduMzFpRU46OrucTHWhDtulwJx1ylvYQACBsVWk2LH7NtX1
	 cAQ1zShuglhbFHhE+jIwjQVL/apJxzHlOfMpPaaLR5e5yJkXG+amSMdblW6NPPfboY
	 9rOA3IVgA1vtlbmoozs80CW+Elwus4hOIwFgsrnlWus1U4/5kybj6uqW1LMa155/dh
	 aFiymBwO9zUGA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7748E380CED8;
	Sat, 17 Oct 2026 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5: Remove max_external_SFs device
 resource
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179219820801.1034269.1188616668560907139.git-patchwork-notify@kernel.org>
Date: Sat, 17 Oct 2026 00:50:08 +0000
References: <20261011093828.784454-1-tariqt@nvidia.com>
In-Reply-To: <20261011093828.784454-1-tariqt@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cjubran@nvidia.com, cmi@nvidia.com, cratiu@nvidia.com, gal@nvidia.com,
 jiri@resnulli.us, corbet@lwn.net, kees@kernel.org, leon@kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, moshe@nvidia.com,
 ohartoov@nvidia.com, rdunlap@infradead.org, saeedm@nvidia.com,
 shayd@nvidia.com, skhan@linuxfoundation.org, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Oct 2026 12:38:28 +0300 you wrote:
> From: Or Har-Toov <ohartoov@nvidia.com>
> 
> The device-level max_external_SFs resource is redundant now that
> per-port max_SFs resources are registered on each PF port representor.
> Users can look up SF limits per-port directly via 'devlink port show'
> to correlate with controller number and pfnum.
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5: Remove max_external_SFs device resource
    https://git.kernel.org/netdev/net-next/c/001e9181ada8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


