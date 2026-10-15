Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA75C4A7CA7;
	Thu, 15 Oct 2026 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058408; cv=none; b=sreWhWLBc2kGGGdSwNSqKKZm1xvbeuLYWcfB0rshorypNC0zSmG/52HNnzaaFwR5GDi7yZQnmkdE/9cQbnLG1VPlcS/JYMe7ChPU2lF90wkbuSkN8INyZsHj6VDMRq7FMe2ZmEjtEshFLvQunwmxK9yTBOV8ePck2STHGcT3ZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058408; c=relaxed/simple;
	bh=FRIOZyO0iAK4GL6hXO5EDHKcOhtImob5hsUVrqOj52k=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GTRewn5KnkkExotdqS8iwuIL0ZO4zYazJMJhU5FPsFvrAY9embq3JJzi6rgsLkf+lStt6po64L+HOFTy7qvW9YtTMpYyP4Nh2AjbP+Ph167pMctzQYVAxDC2+tAHoQj6nRILNPJSVRRD5JDYaEuQIZVVPpOczCKl05ZWtlgl7+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQ3w9+Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQ3w9+Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B81F000C4;
	Thu, 15 Oct 2026 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792058406;
	bh=O5PSGyP3wGupPJqSfNsCyMmvW0tTQlkg6s/LDbfJd2c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=GQ3w9+VcIs5b1BwjJ1iCh59EFJZlT0Z5PHEzdgENPyH4tgCRwe8aKk6grqhZli7Lo
	 CcciMX5a+qnhK62KG/9CskMBZKJOfb8eukj0pCsw1wMa01nmO3zN5j/LzcvzlT95qS
	 KOM6KGgak7wWZEjarbyk5CrJctWIScqEhN8ezxZpLYkalA4R0RsHCUIvzTxCWjEg+a
	 alVURb81EPgGOvOhMGiQaKIxYVBoqsezrMRzLtU8YNGj7eb7leIPjPkgwP4kWqaKXl
	 m0GBH1Bu8Gc+Ww5ujG4KQkbHX9wTPhe3SDgeOgehtyAGM+FpZs2jGLLoGC+U6p5BEh
	 eW13N9HwDKekA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B44C4392EA50;
	Thu, 15 Oct 2026 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/mlx5: less memory per offloaded tc rule
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179205840526.3325132.4078585050271061230.git-patchwork-notify@kernel.org>
Date: Thu, 15 Oct 2026 10:00:05 +0000
References: <20261009052103.3621855-1-acassen@corp.free.fr>
In-Reply-To: <20261009052103.3621855-1-acassen@corp.free.fr>
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, moshe@nvidia.com, kliteyn@nvidia.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  9 Oct 2026 07:20:59 +0200 you wrote:
> Two mlx5 allocations hold more memory than an offloaded tc rule needs.
> A NIC flow keeps a 4 KB allocation for parse attributes that nothing
> reads after offload. An FTE under hardware steering keeps the 1 KB
> action array it was built in while a rule rarely needs more than three
> entries.
> 
> Freeing the first after offload saves 4 KB per NIC flow. Shrinking the
> second saves about 1 KB per FTE under hardware steering.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/mlx5e: TC, free NIC flow parse attributes after offload
    https://git.kernel.org/netdev/net-next/c/dd0425c502fc
  - [net-next,2/2] net/mlx5: HWS, shrink FTE action array to fit
    https://git.kernel.org/netdev/net-next/c/3636705910f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


